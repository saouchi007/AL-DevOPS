codeunit 82941 "MICA Combine Shipment Mgt"
{
    [EventSubscriber(ObjectType::Table, DATABASE::"Sales Shipment Line", 'OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine', '', false, false)]
    local procedure SetOrderNoOnTextLine(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line")
    begin
        if SalesShptLine."Order No." <> '' then
            SalesLine.Description += ' ' + StrSubstNo(Text000Lbl, SalesShptLine."Order No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvLineInsert', '', false, false)]
    local procedure SetWhseInformationOnSalesInvline(SalesLine: Record "Sales Line"; var SalesInvLine: Record "Sales Invoice Line")
    var
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        SalesShipmentLine: Record "Sales Shipment Line";
    begin
        if (SalesLine."Shipment No." <> '') and (SalesLine."Shipment Line No." <> 0) then
            if SalesShipmentLine.Get(SalesLine."Shipment No.", SalesLine."Shipment Line No.") then begin
                PostedWhseShipmentLine.SetCurrentKey("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                PostedWhseShipmentLine.SetRange("Source Type", Database::"Sales Line");
                PostedWhseShipmentLine.SetRange("Source Subtype", PostedWhseShipmentLine."Source Subtype"::"1");
                PostedWhseShipmentLine.SetRange("Source No.", SalesShipmentLine."Order No.");
                PostedWhseShipmentLine.SetRange("Source Line No.", SalesShipmentLine."Order Line No.");
                PostedWhseShipmentLine.SetRange("Posted Source Document", PostedWhseShipmentLine."Posted Source Document"::"Posted Shipment");
                PostedWhseShipmentLine.SetRange("Posted Source No.", SalesShipmentLine."Document No.");
                if PostedWhseShipmentLine.FindFirst() then begin
                    SalesInvLine."MICA Whse Ship. No." := PostedWhseShipmentLine."Whse. Shipment No.";
                    SalesInvLine."MICA Whse Ship. Line No." := PostedWhseShipmentLine."Whse Shipment Line No.";
                end;
            end;
    end;


    var
        Text000Lbl: Label 'Order No. %1:';

}