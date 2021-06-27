codeunit 82440 "MICA Flow Extract Upd. SRD/ETA"
{
    TableNo = "MICA Flow Entry";

    trigger OnRun()
    var
        MICAFlowBufferETASRD: Record "MICA Flow Buffer ETA SRD";
        MICAFlowInformation: Record "MICA Flow Information";
        BufferImpMICAImportSRDETAXML: Codeunit "MICA Import SRD/ETA XML";
        InStream: InStream;
        FlowEntryNoIsNotInStatusErr: Label 'Flow Entry No. %1 is not in status %2.';
        EmptyBlobLbl: Label 'Empty Blob : import aborted.';
        ImportStartedLbl: Label 'Data import started.';
        ImportAbortedLbl: Label 'Data import aborted during the process.';
        AbortedAfterLbl: Label 'Process aborted after %1 record(s).';
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

        Clear(BufferImpMICAImportSRDETAXML);
        BufferImpMICAImportSRDETAXML.SetInstrSource(InStream);
        BufferImpMICAImportSRDETAXML.SetFlowEntry(Rec);
        Commit();
        if not BufferImpMICAImportSRDETAXML.Run() then
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, ImportAbortedLbl, StrSubstNo(AbortedAfterLbl, GetLastErrorText()))
        else begin
            BufferImpMICAImportSRDETAXML.GetBuffer(MICAFlowBufferETASRD);
            Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ImportFinishedLbl, BufferImpMICAImportSRDETAXML.GetRecordCount()), '');
            Rec.Validate("Receive Status", Rec."Receive Status"::Loaded);
            Rec.Validate("Buffer Count", BufferImpMICAImportSRDETAXML.GetRecordCount());
        end;
        MICAFlowInformation.Update('', '');
    end;

}