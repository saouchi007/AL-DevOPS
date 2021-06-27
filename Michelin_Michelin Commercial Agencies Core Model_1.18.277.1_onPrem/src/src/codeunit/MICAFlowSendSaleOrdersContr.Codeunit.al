codeunit 82380 "MICA Flow Send SaleOrdersContr"
{
    //FDM003 eFDM – Sales Order Interface Contract
    TableNo = "MICA Flow";

    trigger OnRun()
    var
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFlowEntry: Record "MICA Flow Entry";
        TempBlob: Codeunit "Temp Blob";
        MICAExportSalesOrderContr: XmlPort "MICA Export Sales Order Contr.";
        SetDestOutStream: OutStream;
        OutStream: OutStream;
        InStream: InStream;
        LastProcessedDateTime: DateTime;
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

        GetLastProcessedDateTime(LastProcessedDateTime, MICAFlowEntry."Entry No.", MICAFlowEntry."Flow Code");

        MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StartMsg, ''));

        TempBlob.CreateOutStream(SetDestOutStream);
        MICAExportSalesOrderContr.SetDestination(SetDestOutStream);
        MICAExportSalesOrderContr.SetFlowEntry(MICAFlowEntry."Entry No.");
        MICAExportSalesOrderContr.CheckAndRetrieveParameters();
        MICAExportSalesOrderContr.SetLastProcessedDateTime(LastProcessedDateTime);
        if not MICAExportSalesOrderContr.Export() then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(ExportFailLbl, GetLastErrorText()), '');
            exit;
        end;


        ExportedRecordCount := MICAExportSalesOrderContr.GetRecordCount();
        MICAFlowEntry.Description := CopyStr(MICAExportSalesOrderContr.GetFileName(), 1, MaxStrLen(MICAFlowEntry.Description));

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

    local procedure GetLastProcessedDateTime(var LastDateTime: DateTime; CurrFlowEntryNo: Integer; FlowCode: Code[20])
    var
        MICAFlowEntry: Record "MICA Flow Entry";
    begin
        MICAFlowEntry.SetAutoCalcFields("Error Count");
        MICAFlowEntry.SetRange("Flow Code", FlowCode);
        MICAFlowEntry.SetFilter("Entry No.", '<>%1', CurrFlowEntryNo);
        MICAFlowEntry.SetRange("Error Count", 0);
        if MICAFlowEntry.FindLast() then
            LastDateTime := MICAFlowEntry."Created Date Time";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure t37OnAfterInsertEvent(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    begin
        Rec."MICA Last Date Update Status" := CurrentDateTime();
    end;
}