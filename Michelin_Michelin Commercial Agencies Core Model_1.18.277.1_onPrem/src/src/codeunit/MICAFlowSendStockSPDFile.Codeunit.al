codeunit 82340 "MICA Flow Send Stock SPD File"
{
    TableNo = "MICA Flow";

    trigger OnRun()
    var
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFlowEntry: Record "MICA Flow Entry";
        TempBlob: Codeunit "Temp Blob";
        MICAExportStockSPD: XmlPort "MICA Export Stock SPD";
        SetDestOutStream: OutStream;
        OutStream: OutStream;
        InStream: InStream;
        ExportedRecordCount: Integer;
        StartMsg: Label 'Start preparing data';
        DataPrepLbl: Label 'Data Preparation executed.';
        ExportedRecordCountLbl: Label '%1 Records Exported';
        ErrorFoundLbl: Label '%1 not updated to %2 (%3 errors found)';
        ExportFailLbl: Label 'Export Failed (%1)';
    begin
        if not MICAFlowEntry.Get(Rec.CreateFlowEntry()) then begin
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, 'Unable to create Flow entry', '');
            exit;
        end;

        MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StartMsg, ''));

        TempBlob.CreateOutStream(SetDestOutStream);
        MICAExportStockSPD.SetDestination(SetDestOutStream);
        MICAExportStockSPD.SetFlowEntry(MICAFlowEntry."Entry No.");
        MICAExportStockSPD.CheckAndRetrieveParameters();
        if not MICAExportStockSPD.Export() then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(ExportFailLbl, GetLastErrorText()), '');
            exit;
        end;


        ExportedRecordCount := MICAExportStockSPD.GetRecordCount();
        MICAFlowEntry.Description := CopyStr(MICAExportStockSPD.GetFileName(), 1, MaxStrLen(MICAFlowEntry.Description));

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
            MICAFlowEntry.PrepareToSend();
        end else
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ErrorFoundLbl, MICAFlowEntry.FieldCaption("Send Status"), MICAFlowEntry."Send Status"::Prepared, MICAFlowEntry."Error Count"), '');

        MICAFlowInformation.Update('', '');
    end;


}