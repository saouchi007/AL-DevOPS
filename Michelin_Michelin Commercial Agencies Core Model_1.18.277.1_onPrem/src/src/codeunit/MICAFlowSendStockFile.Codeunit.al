codeunit 81320 "MICA Flow Send Stock File"
{
    TableNo = "MICA Flow";

    trigger OnRun()
    var
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFlowEntry: Record "MICA Flow Entry";
        TempBlob: Codeunit "Temp Blob";
        ExpMICAStockFileforMIMS: XmlPort "MICA Stock File for MIMS";
        ExportedRecordCount: Integer;
        SetDestOutStream: OutStream;
        StartMsg: Label 'Start preparing data';
        DataPrepLbl: Label 'Data Preparation executed.';
        ExportedRecordCountLbl: Label '%1 Records Exported';
        ExportFailLbl: Label 'Export Failed (%1)';
        ErrorFoundLbl: Label '%1 not updated to %2 (%3 errors found)';
        OutStream: OutStream;
        InStream: InStream;
    begin
        if not MICAFlowEntry.Get(Rec.CreateFlowEntry()) then begin
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, 'Unable to create Flow entry', '');
            exit;
        end;

        MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StartMsg, ''));

        TempBlob.CreateOutStream(SetDestOutStream);
        ExpMICAStockFileforMIMS.SetDestination(SetDestOutStream);
        ExpMICAStockFileforMIMS.SetFlowEntry(MICAFlowEntry."Entry No.");

        if not ExpMICAStockFileforMIMS.Export() then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(ExportFailLbl, GetLastErrorText()), '');
            exit;
        end;

        ExportedRecordCount := ExpMICAStockFileforMIMS.GetRecordCount();
        MICAFlowEntry.Description := CopyStr(ExpMICAStockFileforMIMS.GetFileName(), 1, 100);

        clear(OutStream);
        clear(InStream);
        MICAFlowEntry.Blob.CreateOutStream(OutStream);
        TempBlob.CreateInStream(InStream);
        CopyStream(OutStream, InStream);
        MICAFlowEntry.Validate(Blob);
        MICAFlowEntry.Modify(true);

        MICAFlowEntry.CalcFields("Error Count");
        If MICAFlowEntry."Error Count" = 0 then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, DataPrepLbl, StrSubstNo(ExportedRecordCountLbl, ExportedRecordCount));
            MICAFlowEntry.PrepareToSend(); // update last send status on flow entries
        end else
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ErrorFoundLbl, MICAFlowEntry.FieldCaption("Send Status"), MICAFlowEntry."Send Status"::Prepared, MICAFlowEntry."Error Count"), '');

        MICAFlowInformation.Update('', '');
    end;
}