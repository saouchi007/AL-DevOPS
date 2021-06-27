codeunit 82520 "MICA DeleteInvSalesOrderEvents"
{


    [EventSubscriber(ObjectType::Report, Report::"Delete Invoiced Sales Orders", 'OnBeforeDeleteSalesHeader', '', false, false)]
    local procedure OnBeforeDeleteSalesHeader(var SalesHeader: Record "Sales Header")
    begin
        //Need to get the record again from db because it has been changed by the 
        //UpdateSalesHeaderPrepaymentAmt function called in the OnAfterDeleteEvent of the sales line (Prepayment management)
        SalesHeader.Get(SalesHeader."Document Type", SalesHeader."No.");

    end;


}