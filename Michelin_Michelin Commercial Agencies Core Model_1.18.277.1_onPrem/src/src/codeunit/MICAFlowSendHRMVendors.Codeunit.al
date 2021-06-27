codeunit 81160 "MICA Flow Send HRM Vendors"
{
    //REP-HERMES: Purchase Data Exports (Vendors) 
    TableNo = "MICA Flow";

    trigger OnRun()
    var
        //Flow: Record "MICA Flow";
        MICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowInformation: Record "MICA Flow Information";
        TempBlob: Codeunit "Temp Blob";
        MICAHRMVendorsExport: XmlPort "MICA HRM Vendors Export";
        ExportedRecordCount: Integer;
        SetDestOutStream: OutStream;
        StartMsg: Label 'Start Preparing Data';
        DataPrepLbl: Label 'Data Preparation Executed';
        ExportedRecordCountLbl: Label '%1 Records Exported';
        ErrorFoundLbl: Label '%1 not updated to %2 (%3 errors found)';
        ExportFailLbl: Label 'Export Failed (%1)';
        OutStream: OutStream;
        InStream: InStream;
    begin
        If not MICAFlowEntry.Get(Rec.CreateFlowEntry()) then begin
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, 'Unable to create Flow Entry', '');
            exit;
        end;

        MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StartMsg, ''));

        MICAHRMVendorsExport.SetFlowEntry(MICAFlowEntry."Entry No.");
        TempBlob.CreateOutStream(SetDestOutStream);
        MICAHRMVendorsExport.SetDestination(SetDestOutStream);

        if not MICAHRMVendorsExport.Export() then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(ExportFailLbl, GetLastErrorText()), '');
            exit;
        end;

        MICAFlowEntry.Description := CopyStr(MICAHRMVendorsExport.GetFileName(), 1, 100);
        ExportedRecordCount := MICAHRMVendorsExport.GetRecordCount();

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