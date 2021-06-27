codeunit 81262 "MICA Flow Process AL to PO"
{
    TableNo = "MICA Flow Entry";

    var
        MICAFlow: Record "MICA Flow";
        MICAFlowEntry: record "MICA Flow Entry";
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFlowSetup: record "MICA Flow Setup";
        MICAFlowBufferALtoPO: Record "MICA Flow Buffer AL to PO";
        DefaultLocation: Record Location;
        PurchaseHeader: record "Purchase Header";
        MICAFlowRecord: Record "MICA Flow Record";
        Location: Record Location;
        Item: Record Item;
        ReleasePurchaseDocument: codeunit "Release Purchase Document";
        HeaderCount: Integer;
        LineCount: Integer;
        BufferCount: Integer;
        LineNo: Integer;
        PurchOrderNo: Code[20];
        CheckAllBufferLines: Boolean;
        LocationToCode: Code[20];
        DefaultLocationCode: Code[20];
        DoNotAddYear: Boolean;
        ProcessStartedLbl: Label 'Process started.';
        ProcessFinishedLbl: Label 'Process terminated : %1 buffer record(s) processed';
        ProcessFinished2Lbl: Label '%1 order(s) created / %2 line(s) created.';
        ProcessAbortedLbl: Label 'Process aborted : %1 error(s) found.';
        IncorrectValueLbl: Label 'Incorrect Value : Field %1 value %2.';
        BufferCountLbl: Label '%1 buffer record(s) to process.';
        DefaultLocationCodeErr: Label 'PIT Location %1 not found.';
        DrpLocationToCodeNotSetupErr: label '%1 is not setup on location list for Ship-to %2.';
        PITLocationParamLbl: Label 'PIT', Locked = true;
        DoNotAddYearLbl: Label 'DONTADDYEAR', Locked = true;

    trigger OnRun()
    begin
        MICAFlowEntry.Get(Rec."Entry No.");

        MICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Information, ProcessStartedLbl, ''));
        MICAFlow.Get(Rec."Flow Code");
        MICAFlowBufferALtoPO.Reset();
        MICAFlowBufferALtoPO.SetRange("Flow Code", Rec."Flow Code");
        MICAFlowBufferALtoPO.SetRange("Flow Entry No.", Rec."Entry No.");
        MICAFlowBufferALtoPO.SetRange("Skip Line", false);
        BufferCount := MICAFlowBufferALtoPO.Count();
        MICAFlowInformation."Description 2" := StrSubstNo(BufferCountLbl, BufferCount);
        LocationToCode := '';

        If MICAFlowBufferALtoPO.FindSet() then
            repeat
                // Technical fields
                if not EvaluateRawDateTimeToDateTime(MICAFlowBufferALtoPO."Creation Date Time", MICAFlowBufferALtoPO."Creation Date Time Raw") then
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferALtoPO."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferALtoPO.FieldCaption("Creation Date Time"), MICAFlowBufferALtoPO."Creation Date Time Raw"), '');
                // Message Fields
                if not EvaluateRawDateTimeToDateTime(MICAFlowBufferALtoPO."Document Date Time", MICAFlowBufferALtoPO."Document Date Time Raw") then
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferALtoPO."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferALtoPO.FieldCaption("Document Date Time"), MICAFlowBufferALtoPO."Document Date Time Raw"), '');
                if not EvaluateRawDateTimeToDateTime(MICAFlowBufferALtoPO."Order Date Time", MICAFlowBufferALtoPO."Order Date Time Raw") then
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferALtoPO."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferALtoPO.FieldCaption("Order Date Time"), MICAFlowBufferALtoPO."Order Date Time Raw"), '');
                if not EvaluateRawDateToDate(MICAFlowBufferALtoPO."Requested Receipt Date", MICAFlowBufferALtoPO."Requested Receipt Date Raw") then
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferALtoPO."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferALtoPO.FieldCaption("Requested Receipt Date"), MICAFlowBufferALtoPO."Requested Receipt Date Raw"), '');
                if not EvaluateRawIntToInt(MICAFlowBufferALtoPO.Quantity, MICAFlowBufferALtoPO."Quantity Raw") then
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferALtoPO."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferALtoPO.FieldCaption(Quantity), MICAFlowBufferALtoPO."Quantity Raw"), '');
                // Check if setup on location allow to retrieve Location-To-Code
                Location.SetRange("MICA DRP OUT Location Code", MICAFlowBufferALtoPO.Location);
                Location.SetFilter("MICA PIT Location Code", '<>%1', '');
                if Location.FindFirst() then
                    LocationToCode := Location.Code
                else
                    MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(DrpLocationToCodeNotSetupErr, Location.FieldCaption("MICA DRP OUT Location Code"), MICAFlowBufferALtoPO.Location), '');
                MICAFlowBufferALtoPO.Modify();
            until MICAFlowBufferALtoPO.Next() = 0;

        DefaultLocationCode := CopyStr(MICAFlowSetup.GetFlowTextParam(Rec."Flow Code", PITLocationParamLbl), 1, 20);
        if DefaultLocationCode = '' then
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(DefaultLocationCodeErr, '<empty>)'), '');
        if not DefaultLocation.Get(DefaultLocationCode) then
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(DefaultLocationCodeErr, DefaultLocationCode), '');

        Rec.CalcFields("Error Count");
        if not MICAFlow."Allow Partial Processing" and (Rec."Error Count" > 0) then begin // Aborts process if any error
            MICAFlowInformation.Update('', '');
            Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ProcessAbortedLbl, Rec."Error Count"), '');
            exit;
        end;
        DoNotAddYear := MICAFlowSetup.Get(Rec."Flow Code", DoNotAddYearLbl);

        // Check Buffer values before processing
        CheckAllBufferLines := (MICAFlowSetup.GetFlowIntParam(Rec."Flow Code", 'CHECKBUFFER') = 1);
        if CheckAllBufferLines then
            CheckBuffer();

        Rec.CalcFields("Error Count");
        if Rec."Error Count" = 0 then begin
            // Process Buffer if no error
            MICAFlowBufferALtoPO.Reset();
            MICAFlowBufferALtoPO.SetCurrentKey("Document Reference", "AL Line Number");
            MICAFlowBufferALtoPO.SetAutoCalcFields("Error Count");
            MICAFlowBufferALtoPO.SetRange("Flow Code", Rec."Flow Code");
            MICAFlowBufferALtoPO.SetRange("Flow Entry No.", Rec."Entry No.");
            MICAFlowBufferALtoPO.SetRange("Skip Line", false);
            if MICAFlowBufferALtoPO.FindSet() then
                repeat
                    ProcessBuffer();
                until MICAFlowBufferALtoPO.Next() = 0;

            Clear(ReleasePurchaseDocument);
            ReleasePurchaseDocument.PerformManualRelease(PurchaseHeader);

            Rec.AddInformation(MICAFlowInformation."Info Type"::information,
                StrSubstNo(ProcessFinishedLbl, BufferCount),
                StrSubstNo(ProcessFinished2Lbl, HeaderCount, LineCount));
        end;
        MICAFlowInformation.Update('', '');
        Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ProcessAbortedLbl, Rec."Error Count"), '');
    end;

    local procedure EvaluateRawDateTimeToDateTime(var OutValue: DateTime; RawDateTime: Text): Boolean
    var
        EvaluatedDay: Integer;
        EvaluatedMonth: integer;
        EvaluatedYear: Integer;
        EvaluatedTime: Time;
    begin
        if not Evaluate(EvaluatedDay, CopyStr(RawDateTime, 9, 2)) then
            exit(false);
        if not Evaluate(EvaluatedMonth, CopyStr(RawDateTime, 6, 2)) then
            exit(false);
        if not Evaluate(EvaluatedYear, CopyStr(RawDateTime, 1, 4)) then
            exit(false);
        if not Evaluate(EvaluatedTime, CopyStr(RawDateTime, 12, 8)) then
            exit(false);
        OutValue := CreateDateTime(DMY2Date(EvaluatedDay, EvaluatedMonth, EvaluatedYear), EvaluatedTime);
        Exit(true);
    end;

    local procedure CheckBuffer()
    var
        Vendor: Record Vendor;
        VendorCurrencyTested: Boolean;
        NoPurchPriceforItemLbl: Label 'No purchase price for item %1, vendor %2 and currency ''%3'' according order date %4.';
        ItemDoesNotExistsErr: label '%1 %2 does not exists.';
        ItemIsBlockedErr: label '%1 %2 is blocked.';
        CurrencyError: Text;
    begin
        // Check Buffer values before processing
        VendorCurrencyTested := false;
        MICAFlowBufferALtoPO.Reset();
        MICAFlowBufferALtoPO.SetCurrentKey("Document Reference", "AL Line Number");
        MICAFlowBufferALtoPO.SetAutoCalcFields("Error Count");
        MICAFlowBufferALtoPO.SetRange("Flow Code", MICAFlowEntry."Flow Code");
        MICAFlowBufferALtoPO.SetRange("Flow Entry No.", MICAFlowEntry."Entry No.");
        MICAFlowBufferALtoPO.SetRange("Skip Line", false);
        if MICAFlowBufferALtoPO.FindSet() then
            repeat
                // Check Header Data only on first record
                if not VendorCurrencyTested then begin
                    if ((MICAFlowBufferALtoPO."Pay-To" <> '') and (MICAFlowBufferALtoPO."Pay-To" <> MICAFlowBufferALtoPO."Buy-From Vendor")) then
                        Vendor.Get(MICAFlowBufferALtoPO."Pay-To")
                    else
                        Vendor.Get(MICAFlowBufferALtoPO."Buy-From Vendor");
                    if Vendor."Currency Code" = '' then
                        MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferALtoPO."Entry No.", StrSubstNo(IncorrectValueLbl, Vendor.FieldCaption("Currency Code"), ''), '');
                    CurrencyError := CheckPurchaseOrderCurrencyRate(Vendor."Currency Code", DT2Date(MICAFlowBufferALtoPO."Creation Date Time"));
                    if CurrencyError <> '' then
                        MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferALtoPO."Entry No.", CurrencyError, '');
                    VendorCurrencyTested := true;
                end;
                // Check If Item exist or is blocked
                if not Item.Get(MICAFlowBufferALtoPO.CAD) then
                    MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferALtoPO."Entry No.", StrSubstNo(ItemDoesNotExistsErr, Item.TableCaption(), MICAFlowBufferALtoPO.CAD), '')
                else begin
                    if Item.Blocked then
                        MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferALtoPO."Entry No.", StrSubstNo(ItemIsBlockedErr, Item.TableCaption(), Item."No."), '');
                    // Check Line Data on each record
                    if not FindPurchPrice(Vendor) then
                        MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error,
                                                 MICAFlowBufferALtoPO."Entry No.",
                                                 StrSubstNo(NoPurchPriceforItemLbl, MICAFlowBufferALtoPO.CAD, Vendor."No.", Vendor."Currency Code", DT2Date(MICAFlowBufferALtoPO."Order Date Time")), '');
                end;
            until MICAFlowBufferALtoPO.Next() = 0;
    end;

    local procedure FindPurchPrice(FromVendor: record Vendor): boolean
    var
        FromPurchasePrice: record "Purchase Price";
    begin
        WITH FromPurchasePrice do begin
            Item.get(MICAFlowBufferALtoPO.CAD);
            SetRange("Item No.", MICAFlowBufferALtoPO.CAD);
            SetRange("Vendor No.", FromVendor."No.");
            SetFilter("Ending Date", '%1|>=%2', 0D, DT2Date(MICAFlowBufferALtoPO."Order Date Time"));
            SetRange("Starting Date", 0D, DT2Date(MICAFlowBufferALtoPO."Order Date Time"));
            SetFilter("Currency Code", '%1|%2', FromVendor."Currency Code", '');
            SetFilter("Unit of Measure Code", '%1|%2', Item."Purch. Unit of Measure", '');
            SetFilter("Direct Unit Cost", '<>%1', 0);
            exit(FindFirst());
        end;
    end;

    local procedure ProcessBuffer()
    var
        PurchaseLine: record "Purchase Line";
    begin
        if PurchOrderNo = '' then
            CreatePurchOrder()
        else
            if PurchOrderNo <> GetPurchaseOrderNo() then begin
                Clear(ReleasePurchaseDocument);
                ReleasePurchaseDocument.PerformManualRelease(PurchaseHeader);
                CreatePurchOrder();
            end;
        with PurchaseLine do begin
            LineNo += 10000;
            init();
            Validate("Document Type", PurchaseHeader."Document Type");
            Validate("Document No.", PurchaseHeader."No.");
            Validate("Line No.", LineNo);
            insert(true);
            Validate(Type, Type::Item);
            Validate("No.", MICAFlowBufferALtoPO.CAD);
            Validate(Quantity, MICAFlowBufferALtoPO.Quantity);
            Validate(PurchaseLine."Qty. to Receive", 0);
            Validate("MICA AL No.", PurchaseHeader."MICA AL No.");
            Validate("MICA AL Line No.", MICAFlowBufferALtoPO."AL Line Number");
            Validate("MICA Location-To Code", PurchaseHeader."MICA Location-To Code");
            Validate("MICA DC14", PurchaseHeader."MICA DC14");
            Validate("MICA Record ID", PurchaseHeader.RecordId());
            if DefaultLocationCode <> '' then
                Validate("Location Code", DefaultLocationCode);
            Validate("MICA Ship From Vendor", MICAFlowBufferALtoPO."Ship From Vendor");
            Modify(true);
            LineCount += 1;
            MICAFlowRecord.UpdateReceiveRecord(MICAFlowEntry."Entry No.", RecordId(), 4); //" ",Created,Received,Loaded,Processed,PostProcessed;
        end;
    end;

    local procedure CreatePurchOrder()
    begin
        PurchOrderNo := GetPurchaseOrderNo();
        PurchaseHeader.Init();
        PurchaseHeader.Validate("Document Type", PurchaseHeader."Document Type"::Order);
        PurchaseHeader.Validate("No.", PurchOrderNo);
        PurchaseHeader.Insert(true);
        PurchaseHeader.SetHideValidationDialog(true);
        PurchaseHeader.Validate("Buy-from Vendor No.", MICAFlowBufferALtoPO."Buy-From Vendor");
        PurchaseHeader.Validate("Document Date", DT2Date(MICAFlowBufferALtoPO."Creation Date Time"));
        PurchaseHeader.Validate("Order Date", DT2Date(MICAFlowBufferALtoPO."Order Date Time"));
        PurchaseHeader.Validate("Vendor Order No.", MICAFlowBufferALtoPO."Vendor Order Number");
        PurchaseHeader.Validate("Shipment Method Code", MICAFlowBufferALtoPO."Shipment Method Code");
        PurchaseHeader.Validate("Pay-to Vendor No.", MICAFlowBufferALtoPO."Pay-To");
        PurchaseHeader.Validate("MICA AL No.", CopyStr(MICAFlowBufferALtoPO."Document Reference", 1, 9));
        PurchaseHeader.Validate("MICA Purch. Doc. Creation DT", MICAFlowBufferALtoPO."Document Date Time");
        PurchaseHeader.Validate("MICA Location-To Code", LocationToCode);
        PurchaseHeader.Validate("Expected Receipt Date", MICAFlowBufferALtoPO."Requested Receipt Date");
        PurchaseHeader.Validate("MICA DC14", MICAFlowBufferALtoPO."MICA DC14");
        PurchaseHeader.Validate("MICA Ship From Vendor", MICAFlowBufferALtoPO."Ship From Vendor");
        PurchaseHeader.Validate("MICA Record ID", PurchaseHeader.RecordId());
        PurchaseHeader.Validate("MICA Shipment Instructions", copystr(MICAFlowBufferALtoPO."Shipment Instructions", 1, maxstrlen(PurchaseHeader."MICA Shipment Instructions")));
        if DefaultLocationCode <> '' then
            PurchaseHeader.Validate("Location Code", DefaultLocationCode);
        PurchaseHeader.Modify(true);
        HeaderCount += 1;
        MICAFlowRecord.UpdateReceiveRecord(MICAFlowEntry."Entry No.", PurchaseHeader.RecordId(), 4); //" ",Created,Received,Loaded,Processed,PostProcessed;
    end;

    local procedure GetPurchaseOrderNo(): Code[20]
    var
        MyPurchOrderNo: Text;
        Year: Integer;
        MyPurchOrderNoLbl: Label '%1_%2', Comment = '%1%2', Locked = true;
    begin
        if DoNotAddYear then
            exit(CopyStr(MICAFlowBufferALtoPO."Document Reference", 1, 20));
        Year := Date2DMY(DT2Date(MICAFlowBufferALtoPO."Creation Date Time"), 3);
        MyPurchOrderNo := StrSubstNo(MyPurchOrderNoLbl, CopyStr(MICAFlowBufferALtoPO."Document Reference", 1, 17), CopyStr(format(Year), 3));
        exit(CopyStr(MyPurchOrderNo, 1, 20));
    end;

    local procedure EvaluateRawDateToDate(var OutValue: Date; RawDate: Text): Boolean
    var
        XmlDate: Text;
    begin
        XmlDate := CopyStr(RawDate, 1, 4) + '-' +
                    CopyStr(RawDate, 6, 2) + '-' +
                    CopyStr(RawDate, 9, 2);
        Exit(Evaluate(OutValue, XmlDate, 9));
    end;

    local procedure EvaluateRawIntToInt(var OutValue: Integer; RawInt: Text): Boolean
    begin
        Exit(Evaluate(OutValue, RawInt));
    end;

    procedure CheckPurchaseOrderCurrencyRate(CurrencyCode: Code[20]; DocumentDate: date): text
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        NoCurrencyFoundLbl: Label 'Exchange rate missing for currency %1 and date %2.';
    begin

        CurrencyExchangeRate.Reset();
        CurrencyExchangeRate.Setrange("Currency Code", CurrencyCode);
        CurrencyExchangeRate.Setrange("Starting Date", DocumentDate);
        if CurrencyExchangeRate.IsEmpty() then
            exit(StrSubstNo(NoCurrencyFoundLbl, CurrencyCode, DocumentDate));

    end;
}