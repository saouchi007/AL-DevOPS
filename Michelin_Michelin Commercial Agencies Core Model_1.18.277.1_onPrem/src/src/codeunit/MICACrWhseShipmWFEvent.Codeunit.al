codeunit 81080 "MICA Cr Whse Shipm WF Event"
{
    trigger OnRun()
    begin

    end;

    procedure WarehouseShipmentCreationCode(): code[128]
    begin
        exit(CopyStr(UpperCase('WarehouseShipmentCreationCode'), 1, 128));
    End;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure c1520OnAddWorkflowEventsToLibrary()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(WarehouseShipmentCreationCode(), Database::"Warehouse Shipment Header", 'Warehouse Shipment is released', 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Shipment Release", 'OnAfterRelease', '', false, false)]
    local procedure c7310OnAfterRelease(VAR WarehouseShipmentHeader: Record "Warehouse Shipment Header"; VAR WarehouseShipmentLine: Record "Warehouse Shipment Line")
    var
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        WorkflowManagement.HandleEvent(WarehouseShipmentCreationCode(), WarehouseShipmentHeader);
    end;

    [EventSubscriber(ObjectType::Report, Report::"Notification Email", 'OnSetReportFieldPlaceholders', '', false, false)]
    local procedure r1320OnSetReportFieldPlaceholders(RecRef: RecordRef; VAR Field1Label: Text; VAR Field1Value: Text; VAR Field2Label: Text; VAR Field2Value: Text)
    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        Customer: Record Customer;
        TotalQty: Decimal;
        Field1Lbl: Label 'Total Quantity';

    begin
        IF RecRef.Number() = Database::"Warehouse Shipment Header" then begin
            TotalQty := 0;
            RecRef.SetTable(WarehouseShipmentHeader);
            WarehouseShipmentLine.SetRange(WarehouseShipmentLine."No.", WarehouseShipmentHeader."No.");
            IF WarehouseShipmentLine.FindSet() then
                repeat
                    TotalQty += WarehouseShipmentLine.Quantity;
                until WarehouseShipmentLine.Next() = 0;

            Field1Label := Field1Lbl;
            Field1Value := Format(TotalQty);

            Customer.Get(WarehouseShipmentLine."Destination No.");
            Field2Label := FORMAT(WarehouseShipmentLine."Destination Type", 0, '<text>');
            Field2Value := Customer.Name + '(#' + Customer."No." + ')';
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Notification Management", 'OnGetDocumentTypeAndNumber', '', false, false)]
    local procedure c1510OnGetDocumentTypeAndNumber(VAR RecRef: RecordRef; VAR DocumentType: Text; VAR DocumentNo: Text; VAR IsHandled: Boolean)
    var
        FieldRef: FieldRef;
    begin
        IF RecRef.Number() = Database::"Warehouse Shipment Header" THEN begin
            FieldRef := RecRef.Field(1);
            DocumentType := RecRef.Caption();
            DocumentNo := Format(FieldRef.Value());
            IsHandled := true;
        END;
    end;
}
