codeunit 80925 "MICA Flow Extract CFM Rates"
{
    TableNo = "MICA Flow Entry";

    var
        MICAFlowBufferCFMExchRates: Record "MICA Flow Buf. CFM Exch. Rates";
        BufferRecordCount: integer;
        ExchangeRateDateTxt: Text[8];


    trigger OnRun()
    var
        MICAFlowInformation: Record "MICA Flow Information";
        FlowEntryNoIsNotInStatusErr: Label 'Flow Entry No. %1 is not in status %2.', comment = '%1 = Flow Entry No. ; %2 = Status';
        EmptyBlobLbl: Label 'Empty Blob : import aborted.';
        ImportStartedLbl: Label 'Data import started.';
        ImportAbortedLbl: Label 'Data import aborted during the process.';
        AbortedAfterLbl: Label 'Process aborted after %1 record(s).', comment = '%1 = No. of records processed';
        ImportFinishedLbl: Label 'Data import finished: %1 record(s) buffered.', comment = '%1 = No. of records buffered';
    begin
        if Rec."Receive Status" <> Rec."Receive Status"::Received then begin
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(FlowEntryNoIsNotInStatusErr, Rec."Entry No.", Rec."Receive Status"::Received), '');
            exit;
        end;

        Rec.CalcFields(Blob);
        if Rec.Blob.Length() = 0 then begin
            MICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Error, EmptyBlobLbl, ''));
            exit;
        end;

        MICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Information, ImportStartedLbl, ''));

        if not ExtractFile(Rec) then
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, ImportAbortedLbl, StrSubstNo(AbortedAfterLbl, GetLastErrorText()))
        else begin
            Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ImportFinishedLbl, BufferRecordCount), '');
            Rec.Validate("Receive Status", Rec."Receive Status"::Loaded);
            Rec.Validate("Buffer Count", BufferRecordCount);
            Rec.Modify(true);
        end;
        MICAFlowInformation.Update('', '');
    end;

    local procedure ExtractFile(var FromMICAFlowEntry: record "MICA Flow Entry"): Boolean
    var
        QuantumInStream: InStream;
        FileLineText: Text;
        LineTypeCode: Code[2];
    begin
        FromMICAFlowEntry.Blob.CreateInStream(QuantumInStream);
        while not QuantumInStream.EOS do begin
            BufferRecordCount += 1;
            QuantumInStream.ReadText(FileLineText);
            LineTypeCode := CopyStr(FileLineText, 1, 2);
            MICAFlowBufferCFMExchRates.Init();
            MICAFlowBufferCFMExchRates.Validate("Flow Entry No.", FromMICAFlowEntry."Entry No.");
            MICAFlowBufferCFMExchRates.Validate("Bloc Type", LineTypeCode);
            case LineTypeCode of
                '90':
                    ExtractLineType90(FileLineText);

                '91':
                    ExtractLineType91(FileLineText);
            end;
            MICAFlowBufferCFMExchRates.Insert(true);
        end;
        exit(true);
    end;

    local procedure ExtractLineType90(FromFileLineText: Text)
    begin
        MICAFlowBufferCFMExchRates."Exchange Rate Date Raw" := CopyStr(FromFileLineText, 4, 8);
        ExchangeRateDateTxt := MICAFlowBufferCFMExchRates."Exchange Rate Date Raw";
        MICAFlowBufferCFMExchRates."Exchange Rate Receipt Date Raw" := CopyStr(FromFileLineText, 18, 8);
    end;

    local procedure ExtractLineType91(FromFileLineText: Text)
    begin
        MICAFlowBufferCFMExchRates.Validate("Base Currency Code Raw", CopyStr(FromFileLineText, 4, 3));
        MICAFlowBufferCFMExchRates.Validate("Country/Region Description", CopyStr(FromFileLineText, 8, 15));
        MICAFlowBufferCFMExchRates.Validate("Currency Code Raw", CopyStr(FromFileLineText, 24, 3));
        MICAFlowBufferCFMExchRates.Validate("Direct Cross Rate Raw", CopyStr(FromFileLineText, 28, 15));
        MICAFlowBufferCFMExchRates.Validate("Indirect Cross Rate Raw", CopyStr(FromFileLineText, 45, 15));
        MICAFlowBufferCFMExchRates.Validate(Unit, CopyStr(FromFileLineText, 60, 1));
        MICAFlowBufferCFMExchRates.Validate("Country/Region Code Raw", CopyStr(FromFileLineText, 65, 2));
        MICAFlowBufferCFMExchRates.Validate("Exchange Rate Date Raw", ExchangeRateDateTxt);
    end;
}
