tableextension 81170 "MICA Workflow" extends Workflow
{
    procedure ImportFromBlobSAAS(var TempBlob: Codeunit "Temp Blob")
    var
        ImportExportWorkflow: XMLport "Import / Export Workflow";
        InStream: InStream;
    begin
        TempBlob.CreateInStream(InStream);
        ImportExportWorkflow.SetSource(InStream);
        ImportExportWorkflow.InitWorkflow(Rec.Code);
        ImportExportWorkflow.SetTableView(Rec);
        ImportExportWorkflow.Import();
    end;
}