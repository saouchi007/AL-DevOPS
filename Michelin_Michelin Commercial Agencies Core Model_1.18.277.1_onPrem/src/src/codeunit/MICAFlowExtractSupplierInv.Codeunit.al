codeunit 82020 "MICA Flow Extract Supplier Inv"
{
    //INTGIS001 – Supplier Invoice Integration
    TableNo = "MICA Flow Entry";

    trigger OnRun()
    var
        MICAFlowInformation: Record "MICA Flow Information";
        BufferImpMICASupplierInvDataImport: Codeunit "MICA Supplier Inv. Data Import";
        InStream: InStream;
        FlowEntryNoIsNotInStatusErr: Label 'Flow Entry No. %1 is not in status %2.';
        EmptyBlobLbl: Label 'Empty Blob : import aborted.';
        ImportStartedLbl: Label 'Data import started.';
        ImportAbortedLbl: Label 'Data import aborted during the process: %1';
        AbortedAfterLbl: Label 'Process aborted after %1 record(s). Error : %2.';
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

        BufferImpMICASupplierInvDataImport.SetSource(InStream);
        BufferImpMICASupplierInvDataImport.SetFlowEntry(Rec);
        Commit();
        if not BufferImpMICASupplierInvDataImport.Run() then
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(ImportAbortedLbl, GetLastErrorText()), StrSubstNo(AbortedAfterLbl, BufferImpMICASupplierInvDataImport.GetRecordCount(), GetLastErrorText()))
        else begin
            Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ImportFinishedLbl, BufferImpMICASupplierInvDataImport.GetRecordCount()), '');
            Rec.Validate("Receive Status", Rec."Receive Status"::Loaded);
            Rec.Validate("Buffer Count", BufferImpMICASupplierInvDataImport.GetRecordCount());
        end;
        MICAFlowInformation.Update('', '');
    end;

}