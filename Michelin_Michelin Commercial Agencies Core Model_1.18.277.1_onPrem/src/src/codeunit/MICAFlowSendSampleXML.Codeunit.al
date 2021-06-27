codeunit 80872 "MICA Flow Send Sample XML"
{
    TableNo = "MICA Flow";

    trigger OnRun()
    var
        MICAMyExampleTableXmlPort: XmlPort "MICA MyExampleTable XmlPort";
        DataPrepLbl: Label 'Data Preparation Executed';
        ExportedRecordCountLbl: Label '%1 Records Exported';
        ErrorFoundLbl: Label '%1 not updated to %2 (%3 errors found)';
        ExportFailLbl: Label 'Export Failed (%1)';
        ExportedRecordCount: Integer;
        OutStream: OutStream;
        InStream: InStream;
    begin
        If not MICAFlowEntry.Get(Rec.CreateFlowEntry()) then begin
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, 'Unable to create Flow Entry', '');
            exit;
        end;
        MICAFlowEntry.Description += '.xml';
        MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, 'Start Preparing Data', ''));
        TempBlob.CreateOutStream(OutStream);
        MICASampleData.Reset();
        MICASampleData.SetRange("MICA Send Last Flow Status", MICASampleData."MICA Send Last Flow Status"::" "); //Send only newly created data

        Clear(MICAMyExampleTableXmlPort);
        MICAMyExampleTableXmlPort.SetFlowEntry(MICAFlowEntry."Entry No.");
        MICAMyExampleTableXmlPort.SetTableView(MICASampleData);
        MICAMyExampleTableXmlPort.SetDestination(OutStream);
        if not MICAMyExampleTableXmlPort.Export() then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(ExportFailLbl, GetLastErrorText()), '');
            exit;
        end;
        ExportedRecordCount := MICAMyExampleTableXmlPort.GetRecordCount();

        // Update Blob with exported data
        clear(OutStream);
        clear(InStream);
        MICAFlowEntry.Blob.CreateOutStream(OutStream);
        TempBlob.CreateInStream(InStream);
        CopyStream(OutStream, InStream);
        MICAFlowEntry.Validate(Blob);
        MICAFlowEntry.Modify(true);

        MICAFlowEntry.CalcFields("Error Count");
        If ExportedRecordCount > 0 then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, DataPrepLbl, StrSubstNo(ExportedRecordCountLbl, ExportedRecordCount));
            MICAFlowEntry.PrepareToSend(); // update last send status on flow entries
        end else
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ErrorFoundLbl, MICAFlowEntry.FieldCaption("Send Status"), MICAFlowEntry."Send Status"::Prepared, MICAFlowEntry."Error Count"), '');

        MICAFlowInformation.Update('', '');
    end;

    var
        MICASampleData: Record "MICA Sample Data";
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFlowEntry: Record "MICA Flow Entry";
        TempBlob: Codeunit "Temp Blob";

}