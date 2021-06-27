codeunit 80960 "MICA 3PL Pick request (out)"
{   //INT-3PL-001: Pick request (out)

    var
        ReOpenDisabledErr: Label 'You cannot open %1 no. %2 because %3 is %4.';

    [EventSubscriber(ObjectType::Codeunit, 5750, 'OnAfterInitNewWhseShptLine', '', true, true)]
    LOCAL procedure C5750OnAfterInitNewWhseShptLine(VAR WhseShptLine: Record "Warehouse Shipment Line"; WhseShptHeader: Record "Warehouse Shipment Header"; SalesLine: Record "Sales Line")
    begin
        WhseShptLine."MICA 3PL Whse Shpt. Comment" := SalesLine."MICA 3PL Whse Shpt. Comment";
        WhseShptLine."MICA Transport Instruction" := SalesLine."MICA Transport Instruction";
    end;

    local procedure ValidClientType(): Boolean
    begin
        if CurrentClientType() in [ClientType::Background, ClientType::NAS, ClientType::OData, ClientType::SOAP, ClientType::ODataV4, ClientType::Api] then
            exit(false)
        else
            exit(true);
    end;

    [EventSubscriber(ObjectType::Page, 7335, 'OnModifyRecordEvent', '', true, true)]
    local procedure P7335OnModifyRecordEvent(VAR Rec: Record "Warehouse Shipment Header"; VAR xRec: Record "Warehouse Shipment Header"; VAR AllowModify: Boolean)
    begin
        if ValidClientType() then
            Rec.TESTFIELD(Status, Rec.Status::Open);
    end;

    [EventSubscriber(ObjectType::Page, 7336, 'OnModifyRecordEvent', '', true, true)]
    local procedure P7336OnModifyRecordEvent(VAR Rec: Record "Warehouse Shipment Line"; VAR xRec: Record "Warehouse Shipment Line"; VAR AllowModify: Boolean)
    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
    begin
        if ValidClientType() then begin
            WarehouseShipmentHeader.Get(Rec."No.");
            WarehouseShipmentHeader.TESTFIELD(Status, WarehouseShipmentHeader.Status::Open);
        end;
    end;

    [EventSubscriber(ObjectType::Page, 7336, 'OnInsertRecordEvent', '', true, true)]
    local procedure P7336OnInsertRecordEvent(VAR Rec: Record "Warehouse Shipment Line"; BelowxRec: Boolean; VAR xRec: Record "Warehouse Shipment Line"; VAR AllowInsert: Boolean)
    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
    begin
        if ValidClientType() then begin
            WarehouseShipmentHeader.Get(Rec."No.");
            WarehouseShipmentHeader.TESTFIELD(Status, WarehouseShipmentHeader.Status::Open);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 7310, 'OnBeforeReopen', '', true, true)]
    LOCAL procedure C7310OnBeforeReopen(VAR WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    var
        Location: Record Location;
        MICAFlowEntry: Record "MICA Flow Entry";
        MICASingleInstanceVariables: Codeunit "MICA SingleInstanceVariables";
        MICAFlowMgt: Codeunit "MICA Flow Mgt";
        InfoType: Option Information,Warning,Error;
        MICASendLastErrorCount: Integer;
        ErrorText: Text;
    begin
        if MICASingleInstanceVariables.Get_Skip3PLExportStatus(false) then
            exit;

        with WarehouseShipmentHeader do begin
            Location.Get("Location Code");
            if Location."MICA 3PL Integration" then begin
                MICAFlowMgt.GetFlowEntry("MICA Send Last Flow Entry No.", MICAFlowEntry);
                IF MICAFlowEntry."Send Status" = MICAFlowEntry."Send Status"::" " then
                    exit;

                MICASendLastErrorCount := MICAFlowMgt.CountFlowInformation(InfoType::Error, "MICA Send Last Flow Entry No.", "MICA Record ID");
                if MICASendLastErrorCount > 0 then
                    exit;
                if "MICA Send Ack. Received" then
                    exit;
                ErrorText := StrSubstNo(ReOpenDisabledErr, TableCaption(), "No.", MICAFlowEntry.FieldCaption("Send Status"), MICAFlowEntry."Send Status");
                Error(ErrorText);
            end;
        end;
    end;
}