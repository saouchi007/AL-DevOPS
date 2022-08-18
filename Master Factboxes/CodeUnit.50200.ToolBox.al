/// <summary>
/// Codeunit ISA_ToolBox (ID 50200).
/// </summary>
codeunit 50200 ISA_ToolBox
{
    /// <summary>
    /// ISA_FindLastInvoicedPrice.
    /// </summary>
    /// <param name="BilltoCustomerNo">Code[20].</param>
    /// <param name="ItemNo">Code[20].</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure ISA_FindLastInvoicedPrice(BilltoCustomerNo: Code[20]; ItemNo: Code[20]): Decimal
    var
        SalesInvLine: Record "Sales Invoice Line";
    begin
        SalesInvLine.SetRange("Bill-to Customer No.", BilltoCustomerNo);
        salesInvLine.SetRange("No.", ItemNo);

        if salesInvLine.FindLast() then
            exit(salesInvLine."Unit Price");
    end;
}