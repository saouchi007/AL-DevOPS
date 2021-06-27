codeunit 81620 "MICA Whse. Shipment BSC to 3PL"
{
    //3PL-009: Whse. Shipment BSC to 3PL
    //Page "Order Processor Role Center" have added menu item: Sales Order Lines

    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        Code();
    end;

    procedure Code()
    var
        SalesHeader: Record "Sales Header";
        TransferHeader: Record "Transfer Header";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange(Status, SalesHeader.Status::Released);
        if SalesHeader.FindSet() then
            repeat
                SalesHeader.CalcFields("Completely Shipped");
                if not SalesHeader."Completely Shipped" then
                    ProcessSalesHeader(SalesHeader);
            until SalesHeader.Next() = 0;

        TransferHeader.SetRange(Status, TransferHeader.Status::Released);
        if TransferHeader.FindSet() then
            repeat
                TransferHeader.CalcFields("Completely Shipped");
                if not TransferHeader."Completely Shipped" then
                    ProcessTransferHeader(TransferHeader);
            until TransferHeader.Next() = 0;
    end;

    local procedure ProcessSalesHeader(SalesHeader: Record "Sales Header")
    var
        MICAGetSourceDocOutbound: Codeunit "MICA Get Source Doc. Outbound";
    begin
        MICAGetSourceDocOutbound.CreateFromSalesOrderHideDialog(SalesHeader);
    end;

    local procedure ProcessTransferHeader(TransferHeader: Record "Transfer Header")
    var
        MICAGetSourceDocOutbound: Codeunit "MICA Get Source Doc. Outbound";
    begin
        MICAGetSourceDocOutbound.CreateFromOutbndTransferOrderHideDialog(TransferHeader);
    end;

}