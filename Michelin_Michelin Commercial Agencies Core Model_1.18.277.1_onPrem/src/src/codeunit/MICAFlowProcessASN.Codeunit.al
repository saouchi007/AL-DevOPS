codeunit 81980 "MICA Flow Process ASN"
{
    TableNo = "MICA Flow Entry";

    trigger OnRun()
    var
        MICAFlow: Record "MICA Flow";
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFlowRecord: Record "MICA Flow Record";
        PurchaseHeader: Record "Purchase Header"; // Order   
        MICAFlowBufferASN: Record "MICA Flow Buffer ASN";
        ToCodeLocation: record Location;
        PurchaseLine: Record "Purchase Line";
        UserSetupManagement: Codeunit "User Setup Management";
        SetupRecordID: RecordId;
        dateTimePart: DateTime;
        UpdateCount: Integer;
        BufferCount: Integer;
        CurrencyError: Text;
        ProcessStartedLbl: Label 'Process started.';
        ProcessFinishedLbl: Label 'Process terminated : %1 record(s) processed / %2';
        ProcessAbortedLbl: Label 'Process aborted : %1 error(s) found.';
        MissingValueLbl: Label 'Missing value : Field %1.';
        IncorrectValueLbl: Label 'Incorrect Value : Field %1 value %2.';
        ValueNotSetLbl: label 'Value %1 not set in %2 %3.';
        BufferCountLbl: Label '%1 buffer record(s) to process.';
        UpdateErrorLbl: Label 'Error while updating record %1.';
        PurchaseOrderNotExistLbl: label 'Purchase order %1 does not exist.';
        ASNIntegratedLbl: Label 'The ASN number %1 is already integrated.';
        EntryNoLbl: Label 'Entry no. %1';
        PostingDateErr: Label 'Posting date %1 is not allowed for user %2.';
        BlockedItemErr: Label 'Item %1 is blocked';
        QtyToReceiveIsGreaterErr: Label 'For %1 %2 %3 %4 Qty. to Receive %5 from ASN message is greater then Quantity %6 in the Purchase Line for AL No. %7, AL Line No.: %8.';
        BufferASNLbl: Label '%1%2', Comment = '%1%2', Locked = true;

    begin
        MICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Information, ProcessStartedLbl, ''));
        MICAFlow.get(Rec."Flow Code");

        MICAFlowBufferASN.Reset();
        MICAFlowBufferASN.SetRange("Flow Code", Rec."Flow Code");
        MICAFlowBufferASN.SetRange("Flow Entry No.", Rec."Entry No.");
        MICAFlowBufferASN.SetRange("Skip Line", false);
        MICAFlowInformation."Description 2" := StrSubstNo(BufferCountLbl, MICAFlowBufferASN.Count());
        if MICAFlowBufferASN.FindSet() then begin
            if ASNIntegrated(CopyStr(MICAFlowBufferASN."Doc. ID", 1, 35)) then
                Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferASN."Entry No.", StrSubstNo(ASNIntegratedLbl, MICAFlowBufferASN."Doc. ID"), '');
            PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
            PurchaseHeader.SetFilter("MICA AL No.", StrSubstNo(BufferASNLbl, CopyStr(MICAFlowBufferASN."AL No. Raw", 1, 9), '*'));
            if PurchaseHeader.FindFirst() then
                if ToCodeLocation.get(PurchaseHeader."MICA Location-To Code") then
                    if format(ToCodeLocation."Inbound Whse. Handling Time") = '' then
                        Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferASN."Entry No.", StrSubstNo(ValueNotSetLbl, ToCodeLocation.FieldCaption("Inbound Whse. Handling Time"), ToCodeLocation.TableCaption(), ToCodeLocation.Code), '');
            repeat
                if not UserSetupManagement.IsPostingDateValidWithSetup(WorkDate(), SetupRecordID) then
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferASN."Entry No.", StrSubstNo(PostingDateErr, WorkDate(), UserId()), '');

                if MICAFlowBufferASN."AL No. Raw" = '' then
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferASN."Entry No.", StrSubstNo(MissingValueLbl, MICAFlowBufferASN.FieldCaption("AL No.")), '');
                ExtractALNo(MICAFlowBufferASN);

                PurchaseHeader.SetFilter("MICA AL No.", StrSubstNo(BufferASNLbl, CopyStr(MICAFlowBufferASN."AL No. Raw", 1, 9), '*'));
                if not PurchaseHeader.FindFirst() then
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferASN."Entry No.", StrSubstNo(PurchaseOrderNotExistLbl, MICAFlowBufferASN."AL No."), StrSubstNo(EntryNoLbl, MICAFlowBufferASN."Entry No."));

                if not Evaluate(MICAFlowBufferASN."Actual Ship DateTime", MICAFlowBufferASN."Actual Ship DateTime Raw", 9) then
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferASN."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferASN.FieldCaption("Actual Ship DateTime"), MICAFlowBufferASN."Actual Ship DateTime Raw"), '');

                if not Evaluate(MICAFlowBufferASN."Tech. Creation DateTime", MICAFlowBufferASN."Tech. Creation DateTime Raw", 9) then
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferASN."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferASN.FieldCaption("Tech. Creation DateTime"), MICAFlowBufferASN."Tech. Creation DateTime Raw"), '')
                else
                    MICAFlowBufferASN."Date Time Creation" := MICAFlowBufferASN."Tech. Creation DateTime";

                if not Evaluate(MICAFlowBufferASN."Quantity", MICAFlowBufferASN."Quantity Raw") then
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferASN."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferASN.FieldCaption("Quantity"), MICAFlowBufferASN."Quantity Raw"), '');

                if not Evaluate(dateTimePart, MICAFlowBufferASN."ETA Raw", 9) then
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferASN."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferASN.FieldCaption(ETA), MICAFlowBufferASN."ETA Raw"), '')
                else
                    if evaluate(dateTimePart, MICAFlowBufferASN."ETA Raw", 9) then
                        MICAFlowBufferASN.ETA := DT2Date(dateTimePart);

                if not Evaluate(MICAFlowBufferASN."ASN Line Number", MICAFlowBufferASN."ASN Line Number Raw") then
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferASN."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferASN.FieldCaption("ASN Line Number"), MICAFlowBufferASN."ASN Line Number Raw"), '');

                if IsCAIBlocked(MICAFlowBufferASN.CAI) then
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferASN."Entry No.", StrSubstNo(BlockedItemErr, MICAFlowBufferASN.CAI), '');

                if CurrencyExchangeRateDoesntExist(MICAFlowBufferASN."AL No. Raw", MICAFlowBufferASN."Tech. Creation DateTime", CurrencyError) then
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferASN."Entry No.", CurrencyError, '');

                if MICAFlowBufferASN."Container ID Raw" <> '' then
                    MICAFlowBufferASN."Container ID" := DelChr(MICAFlowBufferASN."Container ID Raw");

                if NewQtyToReceiveIsNotValid(MICAFlowBufferASN, PurchaseLine) then
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferASN."Entry No.", StrSubstNo(QtyToReceiveIsGreaterErr, PurchaseLine."Document Type",
                                                                                                                            PurchaseLine."Document No.",
                                                                                                                            PurchaseLine.FieldCaption("Line No."),
                                                                                                                            PurchaseLine."Line No.",
                                                                                                                            MICAFlowBufferASN.Quantity,
                                                                                                                            PurchaseLine.Quantity,
                                                                                                                            PurchaseLine."MICA AL No.",
                                                                                                                            PurchaseLine."MICA AL Line No."), '');

                MICAFlowBufferASN.Modify();
            until MICAFlowBufferASN.Next() = 0;
        end;
        Rec.CalcFields("Error Count");
        if not MICAFlow."Allow Partial Processing" then
            if Rec."Error Count" > 0 then begin
                MICAFlowInformation.Update('', '');
                Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ProcessAbortedLbl, Rec."Error Count"), '');
                exit;
            end;

        if CheckIfItemBlockedInPurchaseOrder(Rec, MICAFlowInformation, MICAFlow) then
            exit;

        MICAFlowBufferASN.Reset();
        MICAFlowBufferASN.SetAutoCalcFields("Error Count");
        MICAFlowBufferASN.SetRange("Flow Code", Rec."Flow Code");
        MICAFlowBufferASN.SetRange("Flow Entry No.", Rec."Entry No.");
        MICAFlowBufferASN.SetRange("Skip Line", false);
        if MICAFlowBufferASN.FindSet() then
            repeat
                if MICAFlowBufferASN."Error Count" = 0 then begin
                    UpdateAllPurchaseLinesResetQtyToReceive(MICAFlowBufferASN);
                    BufferCount += 1;
                    Commit();
                    if Codeunit.Run(Codeunit::"MICA Flow Upd. Purch. Ord.", MICAFlowBufferASN) then
                        UpdateCount += 1
                    else begin
                        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
                        PurchaseHeader.SetFilter("MICA AL No.", StrSubstNo(BufferASNLbl, CopyStr(MICAFlowBufferASN."AL No.", 1, 9), '*'));
                        if PurchaseHeader.FindFirst() then begin
                            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, PurchaseHeader.RecordId(), StrSubstNo(UpdateErrorLbl, format(PurchaseHeader.RecordId())), GetLastErrorText());
                            MICAFlowRecord.UpdateReceiveRecord(Rec."Entry No.", PurchaseHeader.RecordId(), Rec."Receive Status"::Loaded);
                        end else
                            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferASN."Entry No.", StrSubstNo(UpdateErrorLbl, MICAFlowBufferASN."AL No."), GetLastErrorText());
                    end;
                end;

            until MICAFlowBufferASN.Next() = 0;

        Rec.AddInformation(MICAFlowInformation."Info Type"::information, StrSubstNo(ProcessFinishedLbl, format(UpdateCount), Format(BufferCount)), '');
        MICAFlowInformation.Update('', '');
    end;

    local procedure ASNIntegrated(ASNNumber: Text[35]): Boolean
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        PurchRcptHeader.SetCurrentKey("MICA ASN No.");
        PurchRcptHeader.SetRange("MICA ASN No.", ASNNumber);
        exit(not PurchRcptHeader.IsEmpty());
    end;

    local procedure UpdateAllPurchaseLinesResetQtyToReceive(MICAFlowBufferASN: Record "MICA Flow Buffer ASN")
    var
        PurchaseLine: Record "Purchase Line";
        PurchaseLine1Lbl: Label '%1%2', Comment = '%1%2', Locked = true;
    begin
        if MICAFlowBufferASN."AL No." = '' then
            exit;

        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetFilter("MICA AL No.", StrSubstNo(PurchaseLine1Lbl, CopyStr(MICAFlowBufferASN."AL No.", 1, 9), '*'));
        PurchaseLine.SetRange("MICA ASN No.", '');
        PurchaseLine.SetRange("MICA ASN Line No.", 0);
        PurchaseLine.SetFilter("Qty. to Receive", '>%1', 0);
        if PurchaseLine.FindSet() then
            repeat
                PurchaseLine.Validate("Qty. to Receive", 0);
                PurchaseLine.Modify(true);
            until PurchaseLine.Next() = 0;
    end;

    local procedure ExtractALNo(var MICAFlowBufferASN: Record "MICA Flow Buffer ASN")
    var
        underscorePosition: Integer;
    begin
        if MICAFlowBufferASN."AL No. Raw" = '' then
            exit;

        underscorePosition := StrPos(MICAFlowBufferASN."AL No. Raw", '_');
        if underscorePosition = 0 then
            MICAFlowBufferASN."AL No." := CopyStr(MICAFlowBufferASN."AL No. Raw", 1, 9)
        else
            MICAFlowBufferASN."AL No." := CopyStr((CopyStr(MICAFlowBufferASN."AL No. Raw", 1, underscorePosition - 1)), 1, MaxStrLen(MICAFlowBufferASN."AL No."));
    end;

    local procedure IsCAIBlocked(NewItemNo: Code[20]): Boolean
    var
        Item: Record Item;
        ItemLbl: Label '%1%2', Comment = '%1%2', Locked = true;
    begin
        Item.SetFilter("No.", StrSubstNo(ItemLbl, CopyStr(NewItemNo, 1, 6), '*'));
        Item.SetRange(Blocked, false);
        exit(Item.IsEmpty());
    end;

    local procedure CheckIfItemBlockedInPurchaseOrder(NewMICAFlowEntry: Record "MICA Flow Entry"; NewMICAFlowInformation: Record "MICA Flow Information"; NewMICAFlow: Record "MICA Flow"): Boolean
    var
        PurchaseLine: Record "Purchase Line";
        MICAFlowBufferASN: Record "MICA Flow Buffer ASN";
        BlockedItemPurchaseOrderErr: Label 'Item %1 is blocked. Purchase Order No: %2, Line No: %3.';
        ProcessAbortedLbl: Label 'Process aborted : %1 error(s) found.';
    begin
        MICAFlowBufferASN.SetRange("Flow Code", NewMICAFlowEntry."Flow Code");
        MICAFlowBufferASN.SetRange("Flow Entry No.", NewMICAFlowEntry."Entry No.");
        MICAFlowBufferASN.SetRange("Skip Line", false);
        MICAFlowBufferASN.SetFilter(Quantity, '>%1', 0);
        if MICAFlowBufferASN.Count() = 0 then
            exit(false);
        if MICAFlowBufferASN.FindSet() then
            repeat
                if FindPurchaseLine(PurchaseLine, MICAFlowBufferASN) then
                    NewMICAFlowEntry.AddInformation(NewMICAFlowInformation."Info Type"::Error, MICAFlowBufferASN."Entry No.", StrSubstNo(BlockedItemPurchaseOrderErr, PurchaseLine."No.", PurchaseLine."Document No.", PurchaseLine."Line No."), '');
            until MICAFlowBufferASN.Next() = 0;

        NewMICAFlowEntry.CalcFields("Error Count");
        if not NewMICAFlow."Allow Partial Processing" then
            if NewMICAFlowEntry."Error Count" > 0 then begin
                NewMICAFlowInformation.Update('', '');
                NewMICAFlowEntry.AddInformation(NewMICAFlowInformation."Info Type"::Information, StrSubstNo(ProcessAbortedLbl, NewMICAFlowEntry."Error Count"), '');
                exit(true);
            end;
    end;

    local procedure FindPurchaseLine(var PurchaseLine: Record "Purchase Line"; NewMICAFlowBufferASN: Record "MICA Flow Buffer ASN"): Boolean
    var
        PurchaseLine2Lbl: Label '%1%2', Comment = '%1%2', Locked = true;
    begin
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetFilter("MICA AL No.", StrSubstNo(PurchaseLine2Lbl, CopyStr(NewMICAFlowBufferASN."AL No.", 1, 9), '*'));
        PurchaseLine.SetRange("MICA AL Line No.", NewMICAFlowBufferASN."AL Line No.");
        PurchaseLine.SetFilter("No.", StrSubstNo(PurchaseLine2Lbl, CopyStr(NewMICAFlowBufferASN.CAI, 1, 6), '*'));
        if PurchaseLine.FindFirst() then
            exit(IsItemBlocked(PurchaseLine."No."));
    end;

    local procedure IsItemBlocked(NewItemNo: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        if not Item.Get(NewItemNo) then
            Item.Init();
        exit(Item.Blocked);
    end;

    local procedure CurrencyExchangeRateDoesntExist(NewALNoRaw: Text[50]; NewDocumentDate: DateTime; var CurrencyError: Text): Boolean
    var
        PurchaseHeader: Record "Purchase Header";
        MICAFlowProcessALtoPO: codeunit "MICA Flow Process AL to PO";
        PurchaseHeaderLbl: Label '%1%2', Comment = '%1%2', Locked = true;
    begin
        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
        PurchaseHeader.SetFilter("MICA AL No.", StrSubstNo(PurchaseHeaderLbl, CopyStr(NewALNoRaw, 1, 9), '*'));
        PurchaseHeader.SetFilter("Currency Code", '<>%1', '');
        if PurchaseHeader.FindFirst() then begin
            CurrencyError := MICAFlowProcessALtoPO.CheckPurchaseOrderCurrencyRate(PurchaseHeader."Currency Code", DT2Date(NewDocumentDate));
            if CurrencyError <> '' then
                exit(true);
        end;
    end;

    local procedure NewQtyToReceiveIsNotValid(NewMICAFlowBufferASN: Record "MICA Flow Buffer ASN"; var PurchaseLine: Record "Purchase Line"): Boolean
    var
        PurchaseLine3Lbl: Label '%1%2', Comment = '%1%2', Locked = true;
    begin
        PurchaseLine.Reset();
        PurchaseLine.SetCurrentKey("Document Type", Type, "Prod. Order No.", "Prod. Order Line No.", "Routing No.", "Operation No.");
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetFilter("MICA AL No.", StrSubstNo(PurchaseLine3Lbl, CopyStr(NewMICAFlowBufferASN."AL No.", 1, 9), '*'));
        PurchaseLine.SetRange("MICA AL Line No.", NewMICAFlowBufferASN."AL Line No.");
        PurchaseLine.SetFilter("Outstanding Qty. (Base)", '<>%1', 0);
        PurchaseLine.SetFilter("Qty. Received (Base)", '%1', 0);
        if PurchaseLine.FindFirst() then
            exit(NewMICAFlowBufferASN.Quantity > PurchaseLine.Quantity);
    end;
}