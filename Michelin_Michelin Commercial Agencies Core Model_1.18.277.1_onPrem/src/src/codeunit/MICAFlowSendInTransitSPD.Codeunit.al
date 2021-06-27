codeunit 82360 "MICA Flow Send InTransit SPD"
{
    TableNo = "MICA Flow";

    trigger OnRun()
    var
        MICAFlowInformation: Record "MICA Flow Information";

        MICAFlowEntry: Record "MICA Flow Entry";
        TempBlob: Codeunit "Temp Blob";
        MICAExportInTransitSPD: XmlPort "MICA Export InTransit SPD";
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
        MICAExportInTransitSPD.SetDestination(SetDestOutStream);
        MICAExportInTransitSPD.SetFlowEntry(MICAFlowEntry."Entry No.");
        MICAExportInTransitSPD.CheckAndRetrieveParameters();
        if not MICAExportInTransitSPD.Export() then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(ExportFailLbl, GetLastErrorText()), '');
            exit;
        end;


        ExportedRecordCount := MICAExportInTransitSPD.GetRecordCount();
        MICAFlowEntry.Description := CopyStr(MICAExportInTransitSPD.GetFileName(), 1, MaxStrLen(MICAFlowEntry.Description));

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

    [EventSubscriber(ObjectType::Table, Database::"Transfer line", 'OnBeforeInsertEvent', '', true, true)]
    local procedure T5741OnBeforeInsert(var Rec: Record "Transfer Line"; RunTrigger: Boolean)
    var
        TransferLine: Record "Transfer Line";
    begin
        if (not RunTrigger) or (Rec."Derived From Line No." <> 0) then
            exit;

        TransferLine.SetRange("Document No.", Rec."Document No.");
        if TransferLine.FindSet(false) then begin
            Rec."MICA Shipment Line Num" := TransferLine."MICA Shipment Line Num";
            repeat
                if TransferLine."MICA Shipment Line Num" > Rec."MICA Shipment Line Num" then
                    Rec."MICA Shipment Line Num" := TransferLine."MICA Shipment Line Num";
            until TransferLine.Next() = 0;
            Rec."MICA Shipment Line Num" += 1;
        end else
            Rec."MICA Shipment Line Num" := 1;
    end;

}