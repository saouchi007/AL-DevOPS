codeunit 81210 "MICA Flow Extract ReceivedConf"
{
    TableNo = "MICA Flow Entry";

    trigger OnRun()
    var
        MICAFlowBuffReceivedConfirm2: Record "MICA FlowBuff ReceivedConfirm2";
        MICAFlowInformation: Record "MICA Flow Information";
        BufferImpMICAReceivedConfirmation: XmlPort "MICA Received Confirmation";
        InStream: InStream;
        FlowEntryNoIsNotInStatusErr: Label 'Flow Entry No. %1 is not in status %2.';
        EmptyBlobLbl: Label 'Empty Blob : import aborted.';
        ImportStartedLbl: Label 'Data import started.';
        ImportAbortedLbl: Label 'Data import aborted during the process.';
        AbortedAfterLbl: Label 'Process aborted after %1 record(s). %2';
        ImportFinishedLbl: Label 'Data import finished: %1 record(s) buffered.';
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

        Rec.Blob.CreateInStream(InStream);

        Clear(BufferImpMICAReceivedConfirmation);
        BufferImpMICAReceivedConfirmation.SetSource(InStream);
        BufferImpMICAReceivedConfirmation.SetFlowEntry(Rec);
        Commit();
        if not BufferImpMICAReceivedConfirmation.Import() then
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, ImportAbortedLbl, StrSubstNo(AbortedAfterLbl, BufferImpMICAReceivedConfirmation.GetRecordCount(), GetLastErrorText()))
        else begin
            BufferImpMICAReceivedConfirmation.GetBuffer(MICAFlowBuffReceivedConfirm2);
            Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ImportFinishedLbl, BufferImpMICAReceivedConfirmation.GetRecordCount()), '');
            Rec.Validate("Receive Status", Rec."Receive Status"::Loaded);
            Rec.Validate("Buffer Count", BufferImpMICAReceivedConfirmation.GetRecordCount());
        end;
        MICAFlowInformation.Update('', '');
    end;
}
