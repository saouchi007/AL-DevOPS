codeunit 81140 "MICA Flow Send HRM Purch. Ord."
{
    TableNo = "MICA Flow";

    trigger OnRun()
    var
        MICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowInformation: Record "MICA Flow Information";
        TempBlob: Codeunit "Temp Blob";
        MICAHRMPurchOrderexport: XmlPort "MICA HRM Purch.Order export";
        ExportFailLbl: Label 'Export Failed (%1)';
        StartMsg: Label 'Purchase Orders export started';
        DataPrepLbl: Label 'Data Preparation Executed';
        ExportedRecordCountLbl: Label '%1 Records Exported';
        ErrorFoundLbl: Label '%1 not updated to %2 (%3 errors found)';
        ExportedRecordCount: Integer;
        SetDestOutStream: OutStream;
        OutStream: OutStream;
        InStream: InStream;
    begin
        if not MICAFlowEntry.Get(Rec.CreateFlowEntry()) then begin
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, 'Unable to create Flow Entry', '');
            exit;
        end;
        MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StartMsg, ''));

        TempBlob.CreateOutStream(SetDestOutStream);
        Clear(MICAHRMPurchOrderexport);
        MICAHRMPurchOrderexport.SetFlowEntry(MICAFlowEntry."Entry No.");
        MICAHRMPurchOrderexport.SetDestination(SetDestOutStream);

        if not MICAHRMPurchOrderexport.Export() then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(ExportFailLbl, GetLastErrorText()), '');
            exit;
        end;

        ExportedRecordCount := MICAHRMPurchOrderexport.GetRecordCount();

        // Update Blob with exported data
        MICAFlowEntry.Description := CopyStr(MICAHRMPurchOrderexport.GetFileName(), 1, 100);

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
}