codeunit 80280 "MICA Shipping1TimeManagement"
{
    /*[EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Shipping Advice', false, false)]
    local procedure MyProcedure(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if (Rec."Shipping Advice" = Rec."Shipping Advice"::Complete) and (xRec."Shipping Advice" <> xRec."Shipping Advice"::Complete) then begin
            Rec.TestField(Status, Rec.Status::Released);
        end;
    end;*/

    procedure Shipping1Time(FromSalesHeader: Record "Sales Header"; var ToSalesLine: Record "Sales Line")
    var
        // SalesLine: Record "Sales Line";
        LastPlannedDeliveryDate: Date;
        LastShipmentDate: Date;
        LastPlannedShipmentDate: Date;
        LastPromisedDeliveryDate: Date;
        LastLocationCode: Code[10];
    begin
        // SalesLine.SetRange("Document Type", FromSalesHeader."Document Type");
        // SalesLine.SetRange("Document No.", FromSalesHeader."No.");
        // SalesLine.SetRange(Type, SalesLine.Type::Item);
        ToSalesLine.SetRange(Reserve, ToSalesLine.Reserve::Always);
        //SalesLine.CurrentKey("Planned Delivery Date");
        //SalesLine.Ascending(false);
        //if SalesLine.FindFirst() then begin
        ToSalesLine.SetRange("Planned Delivery Date");
        LastPlannedDeliveryDate := 0D;
        LastLocationCode := '';
        ToSalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        if ToSalesLine.FindSet(false, false) then begin
            repeat
                if (LastLocationCode <> '') and (LastLocationCode <> ToSalesLine."Location Code") then
                    Error(CompleteDeliveryNotPossibleErr);
                if ToSalesLine."Planned Delivery Date" > LastPlannedDeliveryDate then begin
                    LastPlannedDeliveryDate := ToSalesLine."Planned Delivery Date";
                    LastPlannedShipmentDate := ToSalesLine."Planned Shipment Date";
                    LastShipmentDate := ToSalesLine."Shipment Date";
                    LastPromisedDeliveryDate := ToSalesLine."Promised Delivery Date";
                    LastLocationCode := ToSalesLine."Location Code";
                end;
            until ToSalesLine.Next() = 0;
            if Confirm(ApplyShipmentDatetoAllLinesqst, false, LastPlannedShipmentDate) then
                // SalesLine.ModifyAll("Planned Delivery Date", LastPlannedDeliveryDate);
                // SalesLine.ModifyAll("Planned Shipment Date", LastPlannedShipmentDate);
                // SalesLine.ModifyAll("Shipment Date", LastShipmentDate);
                // SalesLine.ModifyAll("Promised Delivery Date", LastPromisedDeliveryDate);
                if ToSalesLine.FindSet(true, false) then
                    repeat
                        ToSalesLine."Planned Delivery Date" := LastPlannedDeliveryDate;
                        ToSalesLine."Planned Shipment Date" := LastPlannedShipmentDate;
                        ToSalesLine."Shipment Date" := LastShipmentDate;
                        ToSalesLine."Promised Delivery Date" := LastPromisedDeliveryDate;
                        ToSalesLine.Modify(false);
                    until ToSalesLine.Next() = 0;
        end;

    end;

    var
        CompleteDeliveryNotPossibleErr: Label 'Complete delivery is not possible for this order. Shipping Advice should be changed to Partial before order is Released.';
        ApplyShipmentDatetoAllLinesQst: Label 'Shipping advice value is Complete. Do you want to apply shipment date: %1 to all lines?';
}