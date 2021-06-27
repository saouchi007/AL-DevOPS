codeunit 80921 "MICA Flow Process MT940"
{  //Known issues: "Receive Status" not set to Processed

    TableNo = "MICA Flow Entry";

    var
        MICAFlowBufferMT9402: Record "MICA Flow Buffer MT940-2";
        MICAFlowInformation: Record "MICA Flow Information";
        GeneralLedgerSetup: Record "General Ledger Setup";
        Flow: Record "MICA Flow";
        DebitAmountParamTxt: Text;
        CheckStatementNoSeq: Boolean;
        StartMsg: label 'Start processing data';
        UnsupportedTypeErr: label 'Unsupported value type: %1.';
        IncorrectValueErr: label 'Incorrect value: %1';
        BankAccNotFoundErr: label 'Bank Acount not found.';
        MandatoryErr: Label 'You must specify %1';
        ProcessAbortedLbl: Label 'Process aborted : %1 error(s) found.';

    trigger onRun()
    var
        OpeningMICAFlowInformation: Record "MICA Flow Information";
        MICAFlow: Record "MICA Flow";
        BufferRecordRef: RecordRef;
        RecordsProcessed: Integer;
        RecordsRejected: Integer;
    begin
        GeneralLedgerSetup.Get();
        MICAFlow.Get(Rec."Flow Code");

        CheckFlowParam(Rec);

        with MICAFlowBufferMT9402 do begin
            OpeningMICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StartMsg, ''));
            SetRange("Flow Entry No.", Rec."Entry No.");
            if FindSet(true) then begin
                repeat
                    "Error" := false;
                    BufferRecordRef.GetTable(MICAFlowBufferMT9402);
                    HandleRawField(BufferRecordRef, fieldNo("Raw Closing Balance Date"), fieldNo("Closing Balance Date"), FieldNo("Error"), Rec, '', true, "Entry No.");
                    if "Header Entry No." = 0 then begin
                        HandleRawField(BufferRecordRef, fieldNo("Raw Open Balance Amount"), fieldNo("Open Balance Amount"), FieldNo("Error"), Rec, "Open Balance D/C", true, "Entry No.");
                        HandleRawField(BufferRecordRef, fieldNo("Raw Closing Balance Amount"), fieldNo("Closing Balance Amount"), FieldNo("Error"), Rec, "Closing Balance D/C", true, "Entry No.");
                    end else begin
                        HandleRawField(BufferRecordRef, fieldNo("Raw Line Entry Date"), fieldNo("Line Entry Date"), FieldNo("Error"), Rec, '', false, "Entry No.");
                        HandleRawField(BufferRecordRef, fieldNo("Raw Line Date"), fieldNo("Line Date"), FieldNo("Error"), Rec, '', true, "Entry No.");
                        HandleRawField(BufferRecordRef, fieldNo("Raw Line Amount"), fieldNo("Line Amount"), FieldNo("Error"), Rec, "Line Amount D/C", true, "Entry No.");
                    end;
                    BufferRecordRef.Modify();
                until Next() = 0;

                CalcFields("Error Count");
                if not MICAFlow."Allow Partial Processing" then
                    if "Error Count" > 0 then begin // Aborts process if any error
                        MICAFlowInformation.Update('', '');
                        Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ProcessAbortedLbl, "Error Count"), '');
                        exit;
                    end;

                ProcessBuffer(Rec, RecordsProcessed, RecordsRejected);
            end;
            //OverviewMessage(Rec, RecordsRead, RecordsProcessed, RecordsRejected, RunBegin);
            OpeningMICAFlowInformation.Update('', '');
        end;
    end;

    local procedure ProcessBuffer(MICAFlowEntry: Record "MICA Flow Entry"; var RecordsProcessed: Integer; var RecordsRejected: Integer)
    var
        LinesMICAFlowBufferMT9402: Record "MICA Flow Buffer MT940-2";
    begin
        with MICAFlowBufferMT9402 do begin
            SetRange("Header Entry No.", 0);
            FindFirst();
            repeat
                if "Error" or not ProcessRecord(MICAFlowEntry, MICAFlowBufferMT9402, RecordsProcessed, RecordsRejected) then begin
                    RecordsRejected += 1;
                    LinesMICAFlowBufferMT9402.SetCurrentKey("Flow Entry No.", "Header Entry No.");
                    LinesMICAFlowBufferMT9402.SetRange("Flow Entry No.", "Flow Entry No.");
                    LinesMICAFlowBufferMT9402.SetRange("Header Entry No.", "Entry No.");
                    RecordsRejected += LinesMICAFlowBufferMT9402.Count();
                end;
            until Next() = 0;
        end;
    end;

    local procedure ProcessRecord(MICAFlowEntry: Record "MICA Flow Entry"; var LocMICAFlowBufferMT9402: Record "MICA Flow Buffer MT940-2"; var RecordsProcessed: Integer; var RecordsRejected: Integer): Boolean
    var
        LinesMICAFlowBufferMT9402: Record "MICA Flow Buffer MT940-2";
        HeaderBankAccReconciliation: Record "Bank Acc. Reconciliation";
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        MICAFlowRecord: Record "MICA Flow Record";
        BankAccountNo: Code[20];
        LineNo: Integer;
        StatementNoSeqErr: Text[250];
    begin
        if not CheckStatementNoSequence(LocMICAFlowBufferMT9402."Statement No.", StatementNoSeqErr, MICAFlowEntry) then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, LocMICAFlowBufferMT9402."Entry No.", StatementNoSeqErr, '');
            exit(false);
        end;

        LinesMICAFlowBufferMT9402.SetRange("Flow Entry No.", LocMICAFlowBufferMT9402."Flow Entry No.");
        LinesMICAFlowBufferMT9402.SetRange("Header Entry No.", LocMICAFlowBufferMT9402."Entry No.");
        if LinesMICAFlowBufferMT9402.IsEmpty() then begin
            RecordsProcessed += 1;
            exit(true); //Transactions not exist. Header only exist in Statement.
        end;

        BankAccountNo := GetBankAccountCardWithBankAccountNo(MICAFlowEntry, true);

        if BankAccountNo = '' then
            exit(false);

        if not ValidateHeader(HeaderBankAccReconciliation, BankAccountNo, LocMICAFlowBufferMT9402) then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, LocMICAFlowBufferMT9402."Entry No.", CopyStr(GetLastErrorText(), 1, 250), CopyStr(GetLastErrorCode(), 1, 250));
            exit(false);
        end;
        HeaderBankAccReconciliation."MICA Statement Entry No." := MICAFlowEntry."Entry No.";
        HeaderBankAccReconciliation.Insert(true);
        RecordsProcessed += 1;

        LinesMICAFlowBufferMT9402.FindSet(false);
        repeat
            LineNo += 10000;
            if ValidateLine(BankAccReconciliationLine, HeaderBankAccReconciliation, LinesMICAFlowBufferMT9402, LineNo) then begin
                BankAccReconciliationLine.Insert(true);
                MICAFlowRecord.UpdateReceiveRecord(MICAFlowEntry."Entry No.", BankAccReconciliationLine.RecordId(), MICAFlowEntry."Receive Status"::Processed);
                RecordsProcessed += 1;
            end else begin
                RecordsRejected += 1;
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, LinesMICAFlowBufferMT9402."Entry No.", CopyStr(GetLastErrorText(), 1, 250), CopyStr(GetLastErrorCode(), 1, 250));
            end;
        until LinesMICAFlowBufferMT9402.Next() = 0;

        exit(true);
    end;

    local procedure GetBankAccountCardWithBankAccountNo(FromFlowEntry: Record "MICA Flow Entry"; SetError: Boolean): Code[20]
    var
        BankAccount: record "Bank Account";
    begin
        BankAccount.SetRange("Bank Account No.", MICAFlowBufferMT9402."Bank Account No.");
        if MICAFlowBufferMT9402."Currency Code" = GeneralLedgerSetup."LCY Code" then
            BankAccount.Setfilter("Currency Code", '%1', '')
        else
            BankAccount.SetRange("Currency Code", MICAFlowBufferMT9402."Currency Code");
        if not BankAccount.FindFirst() then begin
            if SetError then
                FromFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferMT9402."Entry No.", BankAccNotFoundErr, CopyStr(BankAccount.GetFilters(), 1, 250));
            exit('');
        end else
            exit(BankAccount."No.");
    end;

    [TryFunction]
    local procedure ValidateHeader(var HeaderBankAccReconciliation: Record "Bank Acc. Reconciliation"; BankNo: Code[20]; LocMICAFlowBufferMT9402: Record "MICA Flow Buffer MT940-2")
    begin
        HeaderBankAccReconciliation.Init();
        HeaderBankAccReconciliation.Validate("Statement Type", HeaderBankAccReconciliation."Statement Type"::"Bank Reconciliation");
        HeaderBankAccReconciliation."Statement No." := LocMICAFlowBufferMT9402."Statement No.";
        HeaderBankAccReconciliation.Validate("Bank Account No.", BankNo);
        HeaderBankAccReconciliation."Balance Last Statement" := LocMICAFlowBufferMT9402."Open Balance Amount";
        HeaderBankAccReconciliation.Validate("Statement Ending Balance", LocMICAFlowBufferMT9402."Closing Balance Amount");
        HeaderBankAccReconciliation.Validate("Statement Date", LocMICAFlowBufferMT9402."Closing Balance Date");
    end;

    [TryFunction]
    local procedure ValidateLine(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"; HeaderBankAccReconciliation: Record "Bank Acc. Reconciliation"; LinesMICAFlowBufferMT9402: Record "MICA Flow Buffer MT940-2"; LineNo: Integer)
    begin
        BankAccReconciliationLine.Init();
        BankAccReconciliationLine.Validate("Statement Type", HeaderBankAccReconciliation."Statement Type");
        BankAccReconciliationLine."Statement No." := HeaderBankAccReconciliation."Statement No.";
        BankAccReconciliationLine.Validate("Bank Account No.", HeaderBankAccReconciliation."Bank Account No.");
        BankAccReconciliationLine.Validate("Statement Line No.", LineNo);
        BankAccReconciliationLine.Validate("Transaction Date", LinesMICAFlowBufferMT9402."Line Date");
        BankAccReconciliationLine.Validate("Statement Amount", LinesMICAFlowBufferMT9402."Line Amount");

        BankAccReconciliationLine.Validate("Transaction Text", LinesMICAFlowBufferMT9402."Additional Transaction Info");
        BankAccReconciliationLine.Validate("Additional Transaction Info", CopyStr(LinesMICAFlowBufferMT9402."Transaction Text", 1, 100));
        BankAccReconciliationLine.Description := CopyStr(LinesMICAFlowBufferMT9402."Transaction Text", 1, MaxStrLen(BankAccReconciliationLine.Description));
        BankAccReconciliationLine."MICA Description 2" := LinesMICAFlowBufferMT9402."Additional Transaction Info";

        BankAccReconciliationLine.Validate("Value Date", LinesMICAFlowBufferMT9402."Line Entry Date");
    end;

    local procedure HandleRawField(var RecordRef: RecordRef; RawFieldNo: Integer; FieldNo: Integer; ErrorFieldNo: Integer; MICAFlowEntry: Record "MICA Flow Entry"; Sign: Code[2]; Mandatory: Boolean; FlowBufferEntryNo: Integer): Boolean
    var
        RecordField: Record Field;
        RawFieldRef: FieldRef;
        FieldRef: FieldRef;
        ErrorFieldRef: FieldRef;
        dt: Date;
        dec: Decimal;
        EvalError: Boolean;
    begin
        RecordField.Get(RecordRef.RecordId().TableNo(), RawFieldNo);
        RawFieldRef := RecordRef.Field(RecordField."No.");
        RecordField.Get(RecordRef.RecordId().TableNo(), FieldNo);
        FieldRef := RecordRef.Field(RecordField."No.");
        RecordField.Get(RecordRef.RecordId().TableNo(), ErrorFieldNo);
        ErrorFieldRef := RecordRef.Field(RecordField."No.");

        if format(RawFieldRef) = '' then begin
            if Mandatory then begin
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, FlowBufferEntryNo, StrSubstNo(MandatoryErr, CopyStr(RawFieldRef.Caption(), 1, 50)), '');
                ErrorFieldRef.Value(true);
            end
        end else begin
            case format(FieldRef.Type()) of
                'Decimal':
                    if GetAmount(RawFieldRef.Value(), dec) then
                        if CopyStr(Sign, 1, StrLen(DebitAmountParamTxt)) = DebitAmountParamTxt then
                            FieldRef.Value(dec * -1)
                        else
                            FieldRef.Value(dec)
                    else
                        EvalError := true;
                'Date':
                    if GetDate(RawFieldRef.Value(), dt) then
                        FieldRef.Value(dt)
                    else
                        EvalError := true;
                else
                    Error(UnsupportedTypeErr, format(FieldRef.Type()));
            end;
            if EvalError then begin
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, FlowBufferEntryNo, CopyStr(FieldRef.Caption(), 1, 250),
                                    StrSubstNo(IncorrectValueErr, RawFieldRef.Value()));
                ErrorFieldRef.Value(true);
            end;
        end;
        exit(EvalError);
    end;

    [TryFunction]
    local procedure GetDate(txt: Text; var dt: Date)
    var
        Day: Integer;
        Month: Integer;
        Year: Integer;
    begin
        //YYMMDD
        Evaluate(Year, CopyStr(txt, 1, 2));
        Year += 2000;
        Evaluate(Month, CopyStr(txt, 3, 2));
        Evaluate(Day, CopyStr(txt, 5, 2));
        dt := DMY2Date(Day, Month, Year);
    end;

    [TryFunction]
    local procedure GetAmount(txt: Text; var dec: Decimal)
    var
        DecSeparator: Text;
    begin
        //100,15
        DecSeparator := CopyStr(Format(1.2), 2, 1);
        txt := ConvertStr(txt, ',', DecSeparator);
        Evaluate(Dec, txt);
    end;

    local procedure CheckFlowParam(FromMICAFlowEntry: record "MICA Flow Entry")
    var
        MICAFlowSetup: record "MICA Flow Setup";
        ErrorMICAFlowInformation: record "MICA Flow Information";
        FlowParamMissingErr: Label 'For %1 %2, %3 ''%4'' is missing.', comment = '%1 = Flow table caption ; %2 = Flow code ; %3 = Flow setup table caption ; %4 = Flow setup param code';
    begin
        DebitAmountParamTxt := CopyStr(MICAFlowSetup.GetFlowTextParam(Flow.Code, 'DEBITAMTPARAMCODE'), 1, 20);
        if DebitAmountParamTxt = '' then
            FromMICAFlowEntry.AddInformation(ErrorMICAFlowInformation."Info Type"::Error, StrSubstNo(FlowParamMissingErr, Flow.TableCaption(), Flow.Code, MICAFlowSetup.TableCaption(), 'DEBITAMTPARAMCODE'), '');
        CheckStatementNoSeq := MICAFlowSetup.GetFlowIntParam(Flow.Code, 'CHECKSTATEMENTSEQ') = 1;
    end;

    local procedure CheckStatementNoSequence(NewStatementNo: code[20]; var ToStatementNoSeqErr: Text[250]; FromFlowEntry: record "MICA Flow Entry"): Boolean
    var
        BankAccReconciliation: Record "Bank Acc. Reconciliation";
        PostedPaymentReconHdr: Record "Posted Payment Recon. Hdr";
        BankAccountNo: code[20];
        StatementNoSequenceErr: label '%1 %2: latest %3 %4 was %5. New one is %6 you cannot process this MT 940 file.', comment = '%1 = Bank Account No. Field Caption ; %2 = Bank Account No. ; %3 = Table caption ; %4 = Field caption ; %5 = latest statement no. ; %6 = new statement no.';
    begin
        if not CheckStatementNoSeq then
            exit(true);


        BankAccountNo := GetBankAccountCardWithBankAccountNo(FromFlowEntry, false);

        BankAccReconciliation.SetFilter("Statement No.", '%1..', NewStatementNo);
        BankAccReconciliation.SetRange("Bank Account No.", BankAccountNo);
        if BankAccReconciliation.FindFirst() then begin
            ToStatementNoSeqErr := CopyStr(StrSubstNo(StatementNoSequenceErr, MICAFlowBufferMT9402.FieldCaption("Bank Account No."), MICAFlowBufferMT9402."Bank Account No.", BankAccReconciliation.TableCaption(), BankAccReconciliation.FieldCaption("Statement No."), BankAccReconciliation."Statement No.", NewStatementNo), 1, 250);
            exit(false);
        end;

        PostedPaymentReconHdr.SetFilter("Statement No.", '%1..', NewStatementNo);
        PostedPaymentReconHdr.SetRange("Bank Account No.", BankAccountNo);
        if PostedPaymentReconHdr.FindFirst() then begin
            ToStatementNoSeqErr := CopyStr(StrSubstNo(StatementNoSequenceErr, MICAFlowBufferMT9402.FieldCaption("Bank Account No."), MICAFlowBufferMT9402."Bank Account No.", PostedPaymentReconHdr.TableCaption(), PostedPaymentReconHdr.FieldCaption("Statement No."), PostedPaymentReconHdr."Statement No.", NewStatementNo), 1, 250);
            exit(false);
        end;

        exit(true);
    end;
}