codeunit 81150 "MICA Flow Send HRM Purch. Inv."
{
    //REP-HERMES-002: Purchase Data Exports (AP-Invoices) 
    TableNo = "MICA Flow";
    Permissions = tabledata 122 = rm;
    trigger OnRun()
    var
        MICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowInformation: Record "MICA Flow Information";
        TempBlob: Codeunit "Temp Blob";
        MICAHRMPPurchInvoiceexp: XmlPort "MICA HRM P.Purch.Invoice exp.";
        ExportedRecordCount: Integer;
        SetDestOutStream: OutStream;
        //FileName: Text[22];

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

        Clear(MICAHRMPPurchInvoiceexp);

        MICAHRMPPurchInvoiceexp.SetFlowEntry(MICAFlowEntry."Entry No.");
        TempBlob.CreateOutStream(SetDestOutStream);
        MICAHRMPPurchInvoiceexp.SetDestination(SetDestOutStream);
        if not MICAHRMPPurchInvoiceexp.Export() then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(ExportFailLbl, GetLastErrorText()), '');
            exit;
        end;

        MICAFlowEntry.Description := CopyStr(MICAHRMPPurchInvoiceexp.GetFilename(), 1, 100);

        clear(OutStream);
        clear(InStream);
        MICAFlowEntry.Blob.CreateOutStream(OutStream);
        TempBlob.CreateInStream(InStream);
        CopyStream(OutStream, InStream);
        MICAFlowEntry.Validate(Blob);
        MICAFlowEntry.Modify(true);

        ExportedRecordCount := MICAHRMPPurchInvoiceexp.GetRecordCount();
        MICAFlowEntry.CalcFields("Error Count");
        If ExportedRecordCount > 0 then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, DataPrepLbl, StrSubstNo(ExportedRecordCountLbl, ExportedRecordCount));
            MICAFlowEntry.PrepareToSend(); // update last send status on flow entries
        end else
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ErrorFoundLbl, MICAFlowEntry.FieldCaption("Send Status"), MICAFlowEntry."Send Status"::Prepared, MICAFlowEntry."Error Count"), '');

        MICAFlowInformation.Update('', '');
    end;
}