table 80681 "MICA Reporting Buffer"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }

        field(2; "Ledger Entry No."; Integer)
        {
            Caption = 'Ledger Entry No.';
            DataClassification = CustomerContent;
        }

        field(3; "Consolidation Date"; Date)
        {
            Caption = 'Consolidation Date';
            DataClassification = CustomerContent;
        }

        field(4; "Company Code"; Code[3])
        {
            Caption = 'Company Code';
            DataClassification = CustomerContent;
        }

        field(5; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }

        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }

        field(7; Type; Option)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            OptionMembers = ,Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }

        field(8; "Group Account No."; Code[4])
        {
            Caption = 'Group Account No.';
            DataClassification = CustomerContent;
        }

        field(9; "Code"; Code[1])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }

        field(10; Interco; Code[20])
        {
            Caption = 'Intercompany';
            DataClassification = CustomerContent;
        }

        field(11; "Amount LCY"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }

        field(12; "Invoice Currency"; Code[10])
        {
            Caption = 'Invoice Currency';
            DataClassification = CustomerContent;
        }

        field(13; "Invoice Amount"; Decimal)
        {
            Caption = 'Invoice Amount';
            DataClassification = CustomerContent;
        }
        field(14; Section; Code[20])
        {
            Caption = 'Section';
            DataClassification = CustomerContent;
        }

        field(15; Structure; Code[20])
        {
            Caption = 'Structure';
            DataClassification = CustomerContent;
        }

        field(16; "Include Entry on the Reporting"; Boolean)
        {
            caption = 'Include Entry on the Reporting';
            DataClassification = CustomerContent;
        }
        field(17; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(18; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(19; "Cost Amount"; Decimal)
        {
            Caption = 'Cost Amount';
            DataClassification = CustomerContent;
        }
        field(20; CAI; Code[6])
        {
            Caption = 'CAI';
            DataClassification = CustomerContent;
        }
        field(21; "Supplier Code"; Code[3])
        {
            Caption = 'Supplier Code';
            DataClassification = CustomerContent;
        }
        field(22; "Sales Amount"; Decimal)
        {
            Caption = 'Sales Amount';
            DataClassification = CustomerContent;
        }
        field(100; Modified; Boolean)
        {
            Caption = 'Modified';
            DataClassification = CustomerContent;
        }
        field(81020; "Cust. Cr. Indicator"; Code[10])
        {
            Caption = 'Customer Credit Indicator';
            DataClassification = CustomerContent;
        }
        field(81021; "UserId"; Code[50])
        {
            caption = 'UserId';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Ledger Entry No.")
        {

        }
        key(Key3; "Group Account No.", Section, Structure, Interco, "Invoice Currency")
        {

        }
        key(Key4; "Supplier Code", CAI)
        {

        }
        Key(Key5; UserId)
        {

        }
    }
    procedure InitPeriod(NewPeriod: date)
    var
        IntYear: Code[4];
        IntMonth: code[2];
        PeriodLbl: Label '%1%2', Comment = '%1%2', Locked = true;
    begin
        EVALUATE(IntYear, FORMAT(Date2DMY(NewPeriod, 3)));
        EVALUATE(IntMonth, FORMAT(Date2DMY(NewPeriod, 2)));
        if StrLen(IntMonth) < 2 then
            IntMonth := COPYSTR(InsStr(IntMonth, '0', 1), 1, 2);
        Period := COPYSTR(STRSUBSTNO(PeriodLbl, IntYear, IntMonth), 1, 6);
    end;

    procedure InsertFluxBuffer(GLEntryNo: Integer)
    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        MICAReportingBuffer: Record "MICA Reporting Buffer";
        GLEntry: Record "G/L Entry";
        GLAccount: Record "G/L Account";
        DimensionSetEntry: record "Dimension Set Entry";
        Currency: record Currency;
        Dialog: Dialog;
        LastDocumentNo: Code[20];
        LastSourceNo: Code[20];
        CurrencyCode: Code[3];
        LastEntryNo: Integer;
        TotalRecs: Integer;
        CurrTotal: Integer;
        LastSourceType: Integer;
        CurrencyFactor: Decimal;
        EndingPeriod: date;
        GrpAccountMissing: Boolean;
        DialText01_Msg: label 'Phase #1############### \';
        DialText02_Msg: label 'Progress @2@@@@@@@@@@';
        DialText03_Msg: label 'Insert data to Flux 2 Buffer';
        TextGrpAccMissing_Msg: label 'Warning! Some group accounts are missing on local accounts. Please check them and add the corresponding group account.';
    begin
        LastDocumentNo := '';
        LastSourceNo := '';
        LastSourceType := 0;
        Dialog.OPEN(DialText01_Msg + DialText02_Msg);
        Dialog.UPDATE(1, DialText03_Msg);

        MICAFinancialReportingSetup.RESET();
        MICAFinancialReportingSetup.GET();
        MICAFinancialReportingSetup.TESTFIELD("Company Code");
        //FinancialReportingSetup.TESTFIELD("Adjustment Source Code");
        MICAFinancialReportingSetup.TESTFIELD("Intercompany Dimension");
        MICAFinancialReportingSetup.TESTFIELD("Section Dimension");
        //FinancialReportingSetup.TESTFIELD("LP/UOT Dimension");        
        //FinancialReportingSetup.TESTFIELD("CAI Code Dimension");

        GeneralLedgerSetup.RESET();
        GeneralLedgerSetup.GET();
        GeneralLedgerSetup.TESTFIELD("LCY Code");

        //IF VDESetup.GET THEN
        //    LocalCostCenterDim := VDESetup."Local Cost Center Dimension";

        IF GLEntryNo = 0 THEN begin
            StartingPeriod := 0D;
            EndingPeriod := 0D;
            CheckPeriodFormat(Period, StartingPeriod, EndingPeriod);
        end;

        MICAReportingBuffer.RESET();
        MICAReportingBuffer.LOCKTABLE();
        IF MICAReportingBuffer.FINDLAST() THEN
            LastEntryNo := MICAReportingBuffer."Entry No.";

        MICAReportingBuffer.SETCURRENTKEY("Ledger Entry No.");

        GLEntry.RESET();
        IF GLEntryNo = 0 THEN BEGIN
            GLEntry.SETCURRENTKEY("Posting Date");
            GLEntry.SETFILTER("Posting Date", '..%1', EndingPeriod);
        END ELSE
            GLEntry.SETRANGE("Entry No.", GLEntryNo);

        TotalRecs := GLEntry.COUNT();
        CurrTotal := 0;
        //IF FinancialReportingSetup."Exclude G/L Account No." <> '' THEN
        //    GLEntry.SETFILTER("G/L Account No.", FinancialReportingSetup."Exclude G/L Account No.");        
        IF GLEntry.FINDSET(FALSE, FALSE) THEN
            REPEAT
                MICAReportingBuffer.SETRANGE("Ledger Entry No.", GLEntry."Entry No.");
                IF (NOT MICAReportingBuffer.FINDFIRST()) OR (GLEntryNo <> 0) THEN BEGIN
                    LastEntryNo += 1;
                    MICAReportingBuffer.INIT();
                    MICAReportingBuffer."Entry No." := LastEntryNo;
                    MICAReportingBuffer."Ledger Entry No." := GLEntry."Entry No.";
                    MICAReportingBuffer."Consolidation Date" := CALCDATE('<CM>', GLEntry."Posting Date");
                    MICAReportingBuffer."Company Code" := CopyStr(MICAFinancialReportingSetup."Company Code", 1, 3);
                    MICAReportingBuffer."Document Date" := GLEntry."Posting Date";
                    MICAReportingBuffer."Document No." := GLEntry."Document No.";
                    MICAReportingBuffer.Type := GLEntry."Document Type".AsInteger();

                    GLAccount.GET(GLEntry."G/L Account No.");
                    MICAReportingBuffer."Group Account No." := COPYSTR(GLAccount."No. 2", 1, 4);
                    IF MICAReportingBuffer."Group Account No." = '' THEN
                        GrpAccountMissing := TRUE;

                    MICAReportingBuffer."G/L Account No." := GLEntry."G/L Account No.";
                    IF DimensionSetEntry.GET(GLEntry."Dimension Set ID", MICAFinancialReportingSetup."Intercompany Dimension") THEN BEGIN
                        //AND (NOT GLEntry."Diff. Inventory") AND (NOT GLEntry."Diff. Exch. Rates") THEN BEGIN
                        MICAReportingBuffer.Interco := DimensionSetEntry."Dimension Value Code";
                        MICAReportingBuffer.Code := '1';
                    END ELSE
                        MICAReportingBuffer.Code := '0';

                    IF (LastDocumentNo <> GLEntry."Document No.") OR (LastSourceType <> GLEntry."Source Type".AsInteger())
                      OR (LastSourceNo <> GLEntry."Source No.") THEN BEGIN
                        CurrencyCode := '';
                        CurrencyFactor := 1;
                        GetInvoiceCurrency(GLEntry, CurrencyCode, CurrencyFactor);
                        LastDocumentNo := GLEntry."Document No.";
                        LastSourceType := GLEntry."Source Type".AsInteger();
                        LastSourceNo := GLEntry."Source No.";
                    END;
                    MICAReportingBuffer."Amount LCY" := GLEntry.Amount;
                    IF CurrencyCode = '' THEN BEGIN
                        MICAReportingBuffer."Invoice Currency" := GeneralLedgerSetup."LCY Code";
                        MICAReportingBuffer."Invoice Amount" := GLEntry.Amount;
                    END ELSE BEGIN
                        Currency.GET(CurrencyCode);
                        MICAReportingBuffer."Invoice Currency" := CurrencyCode;
                        MICAReportingBuffer."Invoice Amount" := ROUND(GLEntry.Amount * CurrencyFactor, Currency."Amount Rounding Precision");
                    END;
                    IF DimensionSetEntry.GET(GLEntry."Dimension Set ID", MICAFinancialReportingSetup."Section Dimension") THEN
                        MICAReportingBuffer.Section := COPYSTR(DimensionSetEntry."Dimension Value Code", 1, 4);

                    //IF DimensionSetEntry.GET(GLEntry."Dimension Set ID", FinancialReportingSetup."LP/UOT Dimension") THEN
                    //    Flux2Buffer.Structure := DimensionSetEntry."Dimension Value Code";

                    //IF LocalCostCenterDim <> '' THEN BEGIN
                    //    IF DimensionSetEntry.GET(GLEntry."Dimension Set ID", LocalCostCenterDim) THEN
                    //        Flux2Buffer."Local Cost Center" := DimensionSetEntry."Dimension Value Code";
                    //END;

                    MICAReportingBuffer."Include Entry on the Reporting" := TRUE;
                    //AddMissingSectionStructure(Flux2Buffer);
                    IF GLEntryNo = 0 THEN
                        MICAReportingBuffer.INSERT()
                END;

                CurrTotal += 1;
                Dialog.UPDATE(2, ROUND(CurrTotal / TotalRecs * 10000, 1));
            UNTIL GLEntry.NEXT() = 0;

        IF GrpAccountMissing THEN
            MESSAGE(TextGrpAccMissing_Msg);

        Dialog.CLOSE();
    end;

    Procedure CheckPeriodFormat(PeriodCode: Code[6]; var StartingDate: Date; var EndingDate: date)
    var
        Err: Boolean;
        Year: Integer;
        Month: Integer;
        PeriodFormat_Err: Label 'The period format should be YYYYMM';
    begin
        Err := FALSE;
        Year := 0;
        Month := 0;

        IF STRLEN(PeriodCode) < 6 THEN
            Err := TRUE
        ELSE BEGIN
            IF NOT EVALUATE(Year, COPYSTR(PeriodCode, 1, 4)) THEN
                Err := TRUE;

            IF NOT EVALUATE(Month, COPYSTR(PeriodCode, 5, 2)) THEN
                Err := TRUE;
        END;

        IF Err THEN
            ERROR(PeriodFormat_Err);

        StartingDate := DMY2DATE(1, Month, Year);
        EndingDate := CALCDATE('<CM>', DMY2DATE(1, Month, Year));
    end;

    Local Procedure GetInvoiceCurrency(GLEntry: Record "G/L Entry"; var CurrencyCode: Code[3]; CurrencyFactor: Decimal)
    var
        FoundGLEntry: record "G/L Entry";
        VendorLedgerEntry: record "Vendor Ledger Entry";
        CustLedgerEntry: record "Cust. Ledger Entry";
    begin
        IF GLEntry."Source Type" IN [GLEntry."Source Type"::" ", GLEntry."Source Type"::"Bank Account"] THEN BEGIN
            FoundGLEntry.RESET();
            FoundGLEntry.SETRANGE("Document No.", GLEntry."Document No.");
            FoundGLEntry.SETRANGE("Posting Date", GLEntry."Posting Date");
            FoundGLEntry.SETFILTER("Source Type", '<>%1&<>%2', GLEntry."Source Type"::" ", GLEntry."Source Type"::"Bank Account");
            IF FoundGLEntry.COUNT() > 1 THEN
                FoundGLEntry.SETRANGE(Description, GLEntry.Description);
            IF FoundGLEntry.FINDFIRST() THEN
                GLEntry := FoundGLEntry;
        END;

        IF GLEntry."Source Type" <> GLEntry."Source Type"::" " THEN BEGIN
            IF GLEntry."Source Type" = GLEntry."Source Type"::Customer THEN BEGIN
                CustLedgerEntry.RESET();
                CustLedgerEntry.SETCURRENTKEY("Document No.");
                CustLedgerEntry.SETRANGE("Customer No.", GLEntry."Source No.");
                CustLedgerEntry.SETRANGE("Document No.", GLEntry."Document No.");
                CustLedgerEntry.SETRANGE("Posting Date", GLEntry."Posting Date");
                IF CustLedgerEntry.FINDFIRST() THEN BEGIN
                    CurrencyCode := CopyStr(CustLedgerEntry."Currency Code", 1, 3);
                    CurrencyFactor := CustLedgerEntry."Original Currency Factor";
                END;
            END ELSE BEGIN
                VendorLedgerEntry.RESET();
                VendorLedgerEntry.SETCURRENTKEY("Document No.");
                VendorLedgerEntry.SETRANGE("Vendor No.", GLEntry."Source No.");
                VendorLedgerEntry.SETRANGE("Document No.", GLEntry."Document No.");
                VendorLedgerEntry.SETRANGE("Posting Date", GLEntry."Posting Date");
                IF VendorLedgerEntry.FINDFIRST() THEN BEGIN
                    CurrencyCode := CopyStr(VendorLedgerEntry."Currency Code", 1, 3);
                    CurrencyFactor := VendorLedgerEntry."Original Currency Factor";
                END;
            END;
        END ELSE BEGIN
            CustLedgerEntry.RESET();
            CustLedgerEntry.SETCURRENTKEY("Document No.");
            CustLedgerEntry.SETRANGE("Document No.", GLEntry."Document No.");
            CustLedgerEntry.SETRANGE("Posting Date", GLEntry."Posting Date");
            IF CustLedgerEntry.FINDFIRST() THEN BEGIN
                CurrencyCode := CopyStr(CustLedgerEntry."Currency Code", 1, 3);
                CurrencyFactor := CustLedgerEntry."Original Currency Factor";
            END ELSE BEGIN
                VendorLedgerEntry.RESET();
                VendorLedgerEntry.SETCURRENTKEY("Document No.");
                VendorLedgerEntry.SETRANGE("Document No.", GLEntry."Document No.");
                VendorLedgerEntry.SETRANGE("Posting Date", GLEntry."Posting Date");
                IF VendorLedgerEntry.FINDFIRST() THEN BEGIN
                    CurrencyCode := CopyStr(VendorLedgerEntry."Currency Code", 1, 3);
                    CurrencyFactor := VendorLedgerEntry."Original Currency Factor";
                END;
            END;
        END;
    end;

    var
        Period: Code[6];
        StartingPeriod: Date;

}