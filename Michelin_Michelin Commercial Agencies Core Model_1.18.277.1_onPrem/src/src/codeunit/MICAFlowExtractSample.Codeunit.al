codeunit 80879 "MICA Flow Extract Sample"
{
    TableNo = "MICA Flow Entry";

    trigger OnRun()
    var
        MICAFlowInformation: Record "MICA Flow Information";
        BufferImpMICASampleDataImport: XmlPort "MICA Sample Data Import";
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

        clear(BufferImpMICASampleDataImport);
        BufferImpMICASampleDataImport.SetSource(InStream);
        BufferImpMICASampleDataImport.SetFlowEntry(Rec);
        Commit();
        if not BufferImpMICASampleDataImport.Import() then
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, ImportAbortedLbl, StrSubstNo(AbortedAfterLbl, BufferImpMICASampleDataImport.GetRecordCount()))
        else begin
            Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ImportFinishedLbl, BufferImpMICASampleDataImport.GetRecordCount()), '');
            Rec.Validate("Receive Status", Rec."Receive Status"::Loaded);
            Rec.Validate("Buffer Count", BufferImpMICASampleDataImport.GetRecordCount());
        end;
        MICAFlowInformation.Update('', '');
    end;
}