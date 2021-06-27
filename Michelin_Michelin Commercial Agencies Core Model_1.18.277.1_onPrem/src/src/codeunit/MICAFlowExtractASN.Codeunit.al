codeunit 81720 "MICA Flow Extract ASN"
{
    TableNo = "MICA Flow Entry";

    trigger OnRun()
    var
        MICAFlowBufferASN: Record "MICA Flow Buffer ASN";
        MICAFlowInformation: Record "MICA Flow Information";
        MICAImportASNXMLData: Codeunit "MICA Import ASN XML Data";
        InStream: InStream;
        FlowEntryNoIsNotInStatusErr: Label 'Flow Entry No. %1 is not in status %2.';
        EmptyBlobLbl: Label 'Empty Blob : import aborted.';
        ImportStartedLbl: Label 'Data import started.';
        ImportAbortedLbl: Label 'Data import aborted during the process: %1';
        AbortedAfterLbl: Label 'Process aborted after %1 record(s).';
        ImportFinishedLbl: Label 'Data import finished: %1 record(s) buffered.';
    begin
        if Rec."Receive Status" <> Rec."Receive Status"::Received then begin
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(FlowEntryNoIsNotInStatusErr, Rec."Entry No.", Rec."Receive Status"::Received), '');
            exit;
        end;

        Rec.CalcFields(Blob);
        if not Rec.Blob.HasValue() then begin
            MICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Error, EmptyBlobLbl, ''));
            exit;
        end;

        MICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Information, ImportStartedLbl, ''));

        Rec.Blob.CreateInStream(InStream);

        MICAImportASNXMLData.SetSource(InStream);
        MICAImportASNXMLData.SetFlowEntry(Rec);
        Commit();
        if not MICAImportASNXMLData.Run() then
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error,
                 StrSubstNo(ImportAbortedLbl, GetLastErrorText()),
                 StrSubstNo(AbortedAfterLbl, MICAImportASNXMLData.GetRecordCount()))
        else begin
            MICAImportASNXMLData.GetBuffer(MICAFlowBufferASN);
            Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ImportFinishedLbl, MICAImportASNXMLData.GetRecordCount()), '');
            Rec.CalcFields("Error Count");
            if Rec."Error Count" = 0 then
                Rec.Validate("Receive Status", Rec."Receive Status"::Loaded);
            Rec.Validate("Buffer Count", MICAImportASNXMLData.GetRecordCount());
        end;

        MICAFlowInformation.Update('', '');
    end;
}