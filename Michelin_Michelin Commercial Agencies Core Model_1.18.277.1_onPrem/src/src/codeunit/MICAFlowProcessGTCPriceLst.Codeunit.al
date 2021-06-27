codeunit 80940 "MICA Flow Process GTCPriceLst"
{
    TableNo = "MICA Flow Entry";

    var
        MICAFlowInformation: Record "MICA Flow Information";
        GeneralLedgerSetup: Record "General Ledger Setup";
        StartProcessingMsg: Label 'Start processing data';
        MissingValueErr: Label 'Missing value';
        IncorrectFormatErr: Label 'Incorrect format for value %1';
        HeaderErr: Label 'Header record not exist.';
        FooterErr: Label 'Footer record not exist.';
        LineCountErr: Label 'Line records count mismatch.';
        LineCountDetErr: Label 'Actual Line record count is %1. Stated in Footer line record count is %2.';
        ItemErr: Label 'Item not found.';
        NotProcessedDuePartialProcessingErr: Label 'Flow Entry not processed due to Partial Processing not allowed';
        IncorrectValueErr: Label '%1 not found.';
        RecordType2EmptyErr: Label 'No line with type 2 found.';
        ImportCompleteMsg: Label 'Import complete (%1 price(s) inserted, %2 price(s) updated; %3 identical price(s).';
        InsertPriceCount: integer;
        UpdatedPriceCount: integer;
        IdenticalPriceCount: integer;




    trigger onRun()
    var
        MICAFlow: Record "MICA Flow";
        MICAFlowBufferGTCPricelist2: Record "MICA Flow Buffer GTCPricelist2";
        OpeningMICAFlowInformation: Record "MICA Flow Information";
        RecordsProcessed: Integer;
        RecordsRejected: Integer;

    begin
        MICAFlow.Get(Rec."Flow Code");
        OpeningMICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StartProcessingMsg, ''));
        MICAFlowBufferGTCPricelist2.Reset();
        MICAFlowBufferGTCPricelist2.SetRange("Flow Entry No.", Rec."Entry No.");
        if MICAFlowBufferGTCPricelist2.FindSet(true) then
            repeat
                MICAFlowBufferGTCPricelist2.Error := false;

                case MICAFlowBufferGTCPricelist2."Bloc Type" of
                    '1':
                        AssignDateValue(Rec, MICAFlowBufferGTCPricelist2."Bloc Type", MICAFlowBufferGTCPricelist2."Header Raw File Date", MICAFlowBufferGTCPricelist2."Header File Date", MICAFlowBufferGTCPricelist2.Error, MICAFlowBufferGTCPricelist2.FieldCaption("Header Raw File Date"), MICAFlowBufferGTCPricelist2.FieldCaption("Header File Date"));
                    '2':
                        begin
                            AssignDateValue(Rec, MICAFlowBufferGTCPricelist2."Bloc Type", MICAFlowBufferGTCPricelist2."Line Raw Start Date", MICAFlowBufferGTCPricelist2."Line Start Date", MICAFlowBufferGTCPricelist2.Error, MICAFlowBufferGTCPricelist2.FieldCaption("Line Start Date"), MICAFlowBufferGTCPricelist2.FieldCaption("Line Raw Start Date"));
                            AssignDateValue(Rec, MICAFlowBufferGTCPricelist2."Bloc Type", MICAFlowBufferGTCPricelist2."Line Raw End Date", MICAFlowBufferGTCPricelist2."Line End Date", MICAFlowBufferGTCPricelist2.Error, MICAFlowBufferGTCPricelist2.FieldCaption("Line End Date"), MICAFlowBufferGTCPricelist2.FieldCaption("Line End Date"));

                            if MICAFlowBufferGTCPricelist2."Line Raw Transfer Price" = '' then begin
                                Rec.AddInformation(MICAFlowInformation."Info Type"::Error, CopyStr(MICAFlowBufferGTCPricelist2.FieldCaption("Line Raw Transfer Price"), 1, 250), MissingValueErr);
                                MICAFlowBufferGTCPricelist2.Error := true;
                            end else
                                if not GetLinePrice(MICAFlowBufferGTCPricelist2."Line Raw Transfer Price", MICAFlowBufferGTCPricelist2."Line Transfer Price") then begin
                                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, CopyStr(MICAFlowBufferGTCPricelist2.FieldCaption("Line Transfer Price"), 1, 250),
                                                        StrSubstNo(IncorrectFormatErr, MICAFlowBufferGTCPricelist2."Line Raw Transfer Price"));
                                    MICAFlowBufferGTCPricelist2.Error := true;
                                end;
                        end;
                    '9':
                        if MICAFlowBufferGTCPricelist2."Raw Record Counter" = '' then begin
                            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, CopyStr(MICAFlowBufferGTCPricelist2.FieldCaption("Raw Record Counter"), 1, 250), MissingValueErr);
                            MICAFlowBufferGTCPricelist2.Error := true;
                        end else
                            if not Evaluate(MICAFlowBufferGTCPricelist2."Record Counter", MICAFlowBufferGTCPricelist2."Raw Record Counter") then begin
                                Rec.AddInformation(MICAFlowInformation."Info Type"::Error, CopyStr(MICAFlowBufferGTCPricelist2.FieldCaption("Record Counter"), 1, 250),
                                                    StrSubstNo(IncorrectFormatErr, MICAFlowBufferGTCPricelist2."Raw Record Counter"));
                                MICAFlowBufferGTCPricelist2.Error := true;
                            end;
                end;
                MICAFlowBufferGTCPricelist2.Modify();
            until MICAFlowBufferGTCPricelist2.Next() = 0;

        Rec.CalcFields("Error Count");
        if not MICAFlow."Allow Partial Processing" then
            if Rec."Error Count" > 0 then begin // Aborts process if any error
                MICAFlowInformation.Update('', '');
                Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(NotProcessedDuePartialProcessingErr), '');
                exit;
            end;

        MICAFlowBufferGTCPricelist2.Reset();
        MICAFlowBufferGTCPricelist2.SetRange("Flow Entry No.", Rec."Entry No.");
        ProcessBuffer(Rec, MICAFlowBufferGTCPricelist2, RecordsProcessed, RecordsRejected);

        OpeningMICAFlowInformation.Update('', '');
        Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ImportCompleteMsg, InsertPriceCount, UpdatedPriceCount, IdenticalPriceCount), '');
    end;


    local procedure ProcessBuffer(MICAFlowEntry: Record "MICA Flow Entry"; MICAFlowBufferGTCPricelist2: Record "MICA Flow Buffer GTCPricelist2"; var RecordsProcessed: Integer; var RecordsRejected: Integer)
    var
        RecordType2Count: Integer;
        HeaderRecCount: integer;
    begin
        with MICAFlowBufferGTCPricelist2 do begin
            Reset();
            SetRange("Flow Entry No.", MICAFlowEntry."Entry No.");
            SetRange("Bloc Type", '1');
            if IsEmpty() then begin
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, HeaderErr, copystr(GetFilter("Bloc Type"), 1, 200));
                exit;
            end;

            Reset();
            SetRange("Flow Entry No.", MICAFlowEntry."Entry No.");
            SetRange("Bloc Type", '9');
            if not FindFirst() then Begin
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, FooterErr, CopyStr(GetFilter("Bloc Type"), 1, 200));
                exit;
            end;
            HeaderRecCount := MICAFlowBufferGTCPricelist2."Record Counter";

            Reset();
            SetRange("Flow Entry No.", MICAFlowEntry."Entry No.");
            SetRange("Bloc Type", '2');
            RecordType2Count := Count();
            if RecordType2Count = 0 then begin
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, RecordType2EmptyErr, MICAFlowBufferGTCPricelist2.getfilters());
                exit;
            end;
            if RecordType2Count <> HeaderRecCount then begin
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, LineCountErr, StrSubstNo(LineCountDetErr, RecordType2Count, MICAFlowEntry."Record Count"));
                exit;
            end;

            Findset();
            repeat
                if Error then
                    RecordsRejected += 1
                else
                    if ProcessRecord(MICAFlowEntry, MICAFlowBufferGTCPricelist2) then
                        RecordsProcessed += 1
                    else
                        RecordsRejected += 1;
            until Next() = 0;
        end;

    end;

    local procedure ProcessRecord(
        MICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowBufferGTCPricelist2: Record "MICA Flow Buffer GTCPricelist2"): Boolean
    var
        Item: Record Item;
    begin
        item.Reset();
        if MICAFlowBufferGTCPricelist2."Line Item Type" = 'PF' then
            Item.SetRange("No. 2", MICAFlowBufferGTCPricelist2."Line Item Code")
        else
            Item.SetRange("No.", MICAFlowBufferGTCPricelist2."Line Item Code");

        if not Item.FindSet(false) then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferGTCPricelist2."Entry No.", ItemErr, item.GetFilters());
            exit(false);
        end;

        repeat
            UpdatePrice(Item, MICAFlowBufferGTCPricelist2, MICAFlowEntry);
        until Item.Next() = 0;

        exit(true);
    end;

    local procedure UpdatePrice(
        Item: Record Item;
        var MICAFlowBufferGTCPricelist2: Record "MICA Flow Buffer GTCPricelist2";
        var MICAFlowEntry: Record "MICA Flow Entry")
    var
        PurchasePrice: Record "Purchase Price";
        Currency: Record Currency;
        Vendor: Record Vendor;
        MICAFlowRecord: Record "MICA Flow Record";
    begin

        GeneralLedgerSetup.Get();
        clear(Currency);
        if MICAFlowBufferGTCPricelist2."Line Currency Code" <> GeneralLedgerSetup."LCY Code" then begin
            Currency.Reset();
            Currency.setrange(Code, MICAFlowBufferGTCPricelist2."Line Currency Code");
            if not Currency.FindFirst() then begin
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(IncorrectValueErr, Currency.TableCaption()), Currency.GetFilters());
                exit;
            end;
        end;

        Clear(Vendor);
        Vendor.SetRange("MICA GTC Pricelist Code", MICAFlowBufferGTCPricelist2."Line Price List Code");
        if not Vendor.FindSet() then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(IncorrectValueErr, vendor.TableCaption()), vendor.GetFilters());
            exit;
        end;

        Repeat
            if PurchasePrice.Get(Item."No.", Vendor."No.", MICAFlowBufferGTCPricelist2."Line Start Date", Currency.Code, '', Item."Base Unit of Measure", 0) then begin

                if (PurchasePrice."Direct Unit Cost" <> MICAFlowBufferGTCPricelist2."Line Transfer Price")
                or (PurchasePrice."Ending Date" <> MICAFlowBufferGTCPricelist2."Line End Date") then begin
                    PurchasePrice."Direct Unit Cost" := MICAFlowBufferGTCPricelist2."Line Transfer Price";
                    PurchasePrice.Validate("Ending Date", MICAFlowBufferGTCPricelist2."Line End Date");
                    UpdatedPriceCount += 1;
                end else
                    IdenticalPriceCount += 1;
                PurchasePrice.Validate("MICA Rcv. Last Flow Entry No.", MICAFlowEntry."Entry No.");
                PurchasePrice.modify(true);

            end else begin
                PurchasePrice.Init();
                PurchasePrice.Validate("Item No.", Item."No.");
                PurchasePrice.Validate("Vendor No.", Vendor."No.");
                PurchasePrice.Validate("Starting Date", MICAFlowBufferGTCPricelist2."Line Start Date");
                PurchasePrice."Currency Code" := MICAFlowBufferGTCPricelist2."Line Currency Code";
                PurchasePrice."Unit of Measure Code" := Item."Base Unit of Measure";
                PurchasePrice."Direct Unit Cost" := MICAFlowBufferGTCPricelist2."Line Transfer Price";
                PurchasePrice.Validate("Ending Date", MICAFlowBufferGTCPricelist2."Line End Date");
                PurchasePrice.Validate("MICA Rcv. Last Flow Entry No.", MICAFlowEntry."Entry No.");
                PurchasePrice.Insert(true);
                InsertPriceCount += 1;

                CloseOldPurchPrice(PurchasePrice);

            end;

            MICAFlowBufferGTCPricelist2.Validate("Linked Record ID", PurchasePrice.RecordId());
            MICAFlowBufferGTCPricelist2.Modify();
            MICAFlowRecord.UpdateReceiveRecord(MICAFlowEntry."Entry No.", PurchasePrice.RecordId(), 2);

        Until Vendor.next() = 0;
    end;

    local procedure CloseOldPurchPrice(NewPurchasePrice: Record "Purchase Price")
    var
        OldPurchasePrice: Record "Purchase Price";
    begin
        OldPurchasePrice.SetRange("Item No.", NewPurchasePrice."Item No.");
        OldPurchasePrice.SetRange("Vendor No.", NewPurchasePrice."Vendor No.");
        OldPurchasePrice.SetFilter("Starting Date", '<%1', NewPurchasePrice."Starting Date");
        OldPurchasePrice.SetRange("Currency Code", NewPurchasePrice."Currency Code");
        OldPurchasePrice.SetRange("Unit of Measure Code", NewPurchasePrice."Unit of Measure Code");
        OldPurchasePrice.SetRange("Ending Date", 0D);
        if OldPurchasePrice.FindSet() then
            repeat
                OldPurchasePrice.Validate("Ending Date", NewPurchasePrice."Starting Date" - 1);
                OldPurchasePrice.Modify(true);
            until OldPurchasePrice.Next() = 0;

        OldPurchasePrice.SetFilter("Ending Date", '>=%1', NewPurchasePrice."Starting Date");
        if OldPurchasePrice.FindSet() then
            repeat
                OldPurchasePrice.Validate("Ending Date", NewPurchasePrice."Starting Date" - 1);
                OldPurchasePrice.Modify(true);
            until OldPurchasePrice.Next() = 0;

        OldPurchasePrice.SetFilter("Starting Date", '>%1', NewPurchasePrice."Starting Date");
        if NewPurchasePrice."Ending Date" <> 0D then
            OldPurchasePrice.SetFilter("Ending Date", '<> '''' & <=%1', NewPurchasePrice."Ending Date")
        else
            OldPurchasePrice.SetRange("Ending Date");
        if OldPurchasePrice.FindSet() then
            repeat
                OldPurchasePrice.Delete(true);
            until OldPurchasePrice.Next() = 0;

        OldPurchasePrice.SetFilter("Starting Date", '>%1 & <=%2', NewPurchasePrice."Starting Date", NewPurchasePrice."Ending Date");
        OldPurchasePrice.SetRange("Ending Date");
        if OldPurchasePrice.FindSet() then
            repeat
                OldPurchasePrice.Delete();
                OldPurchasePrice.Validate("Starting Date", NewPurchasePrice."Ending Date" + 1);
                OldPurchasePrice.Insert(true);
            until OldPurchasePrice.Next() = 0;


    end;

    local procedure AssignDateValue(MICAFlowEntry: Record "MICA Flow Entry"; BlocType: Text; "RawDate": Text; var DateToAssign: Date; var Error: boolean; RawFieldCaption: text; FieldCaption: text)
    begin
        if RawDate = '' then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, CopyStr(RawFieldCaption, 1, 250), MissingValueErr);
            Error := true;
        end else
            if not GetDate(BlocType, RawDate, DateToAssign) then begin
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, CopyStr(FieldCaption, 1, 250),
                                    StrSubstNo(IncorrectFormatErr, CopyStr(RawFieldCaption, 1, 200)));
                Error := true;
            end;
    end;


    [TryFunction]
    local procedure GetDate(BlocType: text; DateText: Text; var HdrDate: date)
    var
        day: Integer;
        month: Integer;
        year: Integer;
    begin
        case BlocType of
            '1':
                begin
                    Evaluate(day, CopyStr(DateText, 1, 2));
                    Evaluate(month, CopyStr(DateText, 3, 2));
                    Evaluate(year, CopyStr(DateText, 5, 4));
                    HdrDate := DMY2Date(day, month, year);

                end;
            '2':
                begin
                    Evaluate(year, CopyStr(DateText, 1, 4));
                    Evaluate(month, CopyStr(DateText, 6, 2));
                    Evaluate(day, CopyStr(DateText, 9, 2));
                    HdrDate := DMY2Date(day, month, year);

                end;
        end;
    end;

    [TryFunction]
    local procedure GetLinePrice(PriceText: Text; var LinePrice: Decimal)
    var
        Number: integer;
    begin
        PriceText := DelChr(PriceText, '<', '0');
        Evaluate(Number, PriceText);
        LinePrice := Number / 100;
    end;

}