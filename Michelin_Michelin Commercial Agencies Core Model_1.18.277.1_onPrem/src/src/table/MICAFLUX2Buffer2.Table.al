table 80661 "MICA FLUX2 Buffer2"
{
    DataClassification = CustomerContent;
    LookupPageId = "MICA FLUX2 Buffer";
    DrillDownPageId = "MICA FLUX2 Buffer";
    fields
    {
        field(1; "Consolidation Date"; Date)
        {
            Caption = 'Consolidation Date';
            DataClassification = CustomerContent;
        }
        field(2; "Company Code"; Code[3])
        {
            Caption = 'Company Code';
            DataClassification = CustomerContent;
        }
        field(3; "Group Account No."; Code[4])
        {
            Caption = 'Group Account No.';
            DataClassification = CustomerContent;
        }
        field(4; Interco; Code[20])
        {
            Caption = 'Interco';
            CaptionClass = '1,2,3';
            DataClassification = CustomerContent;
        }
        field(5; Section; Code[20])
        {
            Caption = 'Section';
            CaptionClass = '1,1,1';
            DataClassification = CustomerContent;
        }
        field(6; Structure; Code[20])
        {
            Caption = 'Structure';
            CaptionClass = '1,1,2';
            DataClassification = CustomerContent;
        }
        field(7; "Invoice Currency"; Code[10])
        {
            Caption = 'Invoice Currency';
            DataClassification = CustomerContent;
        }
        field(8; "Amount LCY"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(9; "Invoice Amount"; Decimal)
        {
            Caption = 'Invoice Amount';
            DataClassification = CustomerContent;
        }
        field(10; "G/L Account"; Code[20])
        {
            Caption = 'G/L Account';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Group Account No.", Interco, Section, Structure, "Invoice Currency", "G/L Account")
        {
            Clustered = true;
        }
    }

    var
        Period: Code[6];

    procedure InitPeriod(NewPeriod: date)
    var
        IntYear: Code[4];
        IntMonth: code[2];
    begin
        EVALUATE(IntYear, FORMAT(Date2DMY(NewPeriod, 3)));
        EVALUATE(IntMonth, FORMAT(Date2DMY(NewPeriod, 2)));
        if StrLen(IntMonth) < 2 then
            IntMonth := COPYSTR(InsStr(IntMonth, '0', 1), 1, 2);
        Period := COPYSTR(STRSUBSTNO('%1%2', IntYear, IntMonth), 1, 6);
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

    procedure InsertFluxBuffer()
    var
        FinancialReportingSetup: Record "MICA Financial Reporting Setup";
        GLSetup: Record "General Ledger Setup";
        GLEntry: Record "G/L Entry";
        Flux2Buffer: Record "MICA FLUX2 Buffer2";
        GLAccount: Record "G/L Account";
        Flux2BufferQuery: Query "MICA FLUX2 Buffer";
        Dial: Dialog;
        StartingPeriod: Date;
        EndingPeriod: Date;
        AccountNo: Code[4];
        SectionCode: Code[6];
        CurrencyCode: Code[10];
        CurrentNo: Code[20];
        CurrentYear: Boolean;
        GrpAccountMissing: Boolean;
        DialText01_Msg: label 'Phase #1############### \';
        DialText02_Msg: label 'Progress @2@@@@@@@@@@';
        DialText03_Msg: label 'Inserting data to %1';
        DialText04_Msg: label 'Summing up data from %1';
        TextGrpAccMissing_Msg: label 'Warning! Some group accounts are missing on local accounts. Please check them and add the corresponding group account.';
    begin
        CurrentNo := '';

        Dial.OPEN(DialText01_Msg + DialText02_Msg);
        Dial.UPDATE(1, StrSubstNo(DialText04_Msg, GLEntry.TableCaption()));

        FinancialReportingSetup.GET();
        FinancialReportingSetup.TESTFIELD("Company Code");
        FinancialReportingSetup.TESTFIELD("Intercompany Dimension");

        GLSetup.GET();
        GLSetup.TESTFIELD("LCY Code");
        CheckPeriodFormat(Period, StartingPeriod, EndingPeriod);

        Flux2Buffer.RESET();
        Flux2Buffer.DeleteAll();

        Flux2BufferQuery.SetRange(PostingDate, 0D, EndingPeriod);
        Flux2BufferQuery.Open();
        while Flux2BufferQuery.Read() do begin
            CurrentYear := Date2DMY(Flux2BufferQuery.GLEntryPostingDate, 3) = Date2DMY(EndingPeriod, 3);

            if CurrentNo <> Flux2BufferQuery.GLAccountNo then begin
                GLAccount.Get(Flux2BufferQuery.GLAccountNo);
                CurrentNo := GLAccount."No.";
            end;

            Dial.UPDATE(1, StrSubstNo(DialText03_Msg, Flux2Buffer.TableCaption()));
            AccountNo := CopyStr(Flux2BufferQuery.AccountNo, 1, 4);
            SectionCode := CopyStr(Flux2BufferQuery.SectionCode, 1, 6);
            CurrencyCode := Flux2BufferQuery.CurrencyCode;
            IF CurrencyCode = '' then
                CurrencyCode := GLSetup."LCY Code";

            if Flux2Buffer.Get(AccountNo,
                               Flux2BufferQuery.IntercoValueCode,
                               SectionCode,
                               Flux2BufferQuery.StructureCode,
                               CurrencyCode,
                               GLAccount."No.")
            then begin
                if GLAccount."MICA F2 Incl. Year Amt. Only" then begin
                    if CurrentYear then
                        Flux2BufferModify(Flux2Buffer, Flux2BufferQuery);
                end else
                    Flux2BufferModify(Flux2Buffer, Flux2BufferQuery);
            end else
                if GLAccount."MICA F2 Incl. Year Amt. Only" then begin
                    if CurrentYear then
                        Flux2BufferInsert(Flux2Buffer, Flux2BufferQuery, AccountNo, SectionCode, CurrencyCode, CopyStr(FinancialReportingSetup."Company Code", 1, 3), EndingPeriod);
                end else
                    Flux2BufferInsert(Flux2Buffer, Flux2BufferQuery, AccountNo, SectionCode, CurrencyCode, CopyStr(FinancialReportingSetup."Company Code", 1, 3), EndingPeriod);
            IF AccountNo = '' then
                GrpAccountMissing := true;
        end;

        IF GrpAccountMissing THEN
            MESSAGE(TextGrpAccMissing_Msg);

        Dial.CLOSE();
    end;

    local procedure Flux2BufferInsert(var Flux2Buffer: Record "MICA FLUX2 Buffer2"; Flux2BufferQuery: Query "MICA FLUX2 Buffer"; AccountNo: Code[4]; SectionCode: Code[6]; CurrencyCode: Code[10]; CompanyCode: Code[3]; EndingPeriod: Date)
    begin
        Flux2Buffer.Init();
        Flux2Buffer."Consolidation Date" := CalcDate('<CM>', EndingPeriod);
        Flux2Buffer."Company Code" := CompanyCode;
        Flux2Buffer."Group Account No." := AccountNo;
        Flux2Buffer.Interco := Flux2BufferQuery.IntercoValueCode;
        Flux2Buffer.Section := SectionCode;
        Flux2Buffer.Structure := Flux2BufferQuery.StructureCode;
        Flux2Buffer."Invoice Currency" := CurrencyCode;
        Flux2Buffer."Amount LCY" := Flux2BufferQuery.SumAmountLCY;
        Flux2Buffer."Invoice Amount" := Flux2BufferQuery.SumAmountFCY;
        Flux2Buffer."G/L Account" := Flux2BufferQuery.GLAccountNo;
        Flux2Buffer.Insert();
    end;

    local procedure Flux2BufferModify(var Flux2Buffer: Record "MICA FLUX2 Buffer2"; Flux2BufferQuery: Query "MICA FLUX2 Buffer")
    begin
        Flux2Buffer."Amount LCY" += Flux2BufferQuery.SumAmountLCY;
        Flux2Buffer."Invoice Amount" += Flux2BufferQuery.SumAmountFCY;
        Flux2Buffer.Modify();
    end;
}