codeunit 81860 "MICA Cust. Printing Mgt"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Format Address", 'OnBeforeSalesInvBillTo', '', false, false)]
    local procedure OnBeforeSalesInvBillTo(var AddrArray: array[8] of Text[100]; var SalesInvHeader: Record "Sales Invoice Header"; var Handled: Boolean);
    var
        SellToCustomer: Record Customer;
        FormatAddress: Codeunit "Format Address";
    begin
        if not SellToCustomer.Get(SalesInvHeader."Sell-to Customer No.") then
            exit;
        if not SellToCustomer."MICA Print Sell-to Address" then
            exit;
        if SalesInvHeader."Bill-to Customer No." = SalesInvHeader."Sell-to Customer No." then
            exit;

        FormatAddress.FormatAddr(
                  AddrArray, SalesInvHeader."Sell-to Customer Name", SalesInvHeader."Sell-to Customer Name 2", SalesInvHeader."Sell-to Contact", SalesInvHeader."Sell-to Address", SalesInvHeader."Sell-to Address 2",
                  SalesInvHeader."Sell-to City", SalesInvHeader."Sell-to Post Code", SalesInvHeader."Sell-to County", SalesInvHeader."Sell-to Country/Region Code");
        Handled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Format Address", 'OnBeforeSalesCrMemoBillTo', '', false, false)]
    local procedure OnBeforeSalesCrMemoBillTo(var AddrArray: array[8] of Text[100]; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var Handled: Boolean);
    var
        SellToCustomer: Record Customer;
        FormatAddress: Codeunit "Format Address";
    begin
        if not SellToCustomer.Get(SalesCrMemoHeader."Sell-to Customer No.") then
            exit;
        if not SellToCustomer."MICA Print Sell-to Address" then
            exit;
        if SalesCrMemoHeader."Bill-to Customer No." = SalesCrMemoHeader."Sell-to Customer No." then
            exit;

        FormatAddress.FormatAddr(
                  AddrArray, SalesCrMemoHeader."Sell-to Customer Name", SalesCrMemoHeader."Sell-to Customer Name 2", SalesCrMemoHeader."Sell-to Contact", SalesCrMemoHeader."Sell-to Address", SalesCrMemoHeader."Sell-to Address 2",
                  SalesCrMemoHeader."Sell-to City", SalesCrMemoHeader."Sell-to Post Code", SalesCrMemoHeader."Sell-to County", SalesCrMemoHeader."Sell-to Country/Region Code");
        Handled := true;
    end;


}