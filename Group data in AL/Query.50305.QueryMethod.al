/// <summary>
/// Query ISA_SalesLineQueryMethod (ID 50305).
/// </summary>
query 50305 ISA_SalesLineQueryMethod
{
    QueryType = Normal;
    Caption = 'Sales Line Query Group Method';
    OrderBy = descending(SelltoCustomerNo, Type, No);
    elements
    {
        dataitem(SalesLine; "Sales Line")
        {
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }
            column("Type"; "Type")
            {
            }
            column(No; "No.")
            {
            }
            column(Amount; Amount)
            {
                Method = Sum;
            }
        }
    }
    /// <summary>
    /// ISA_QueryGroupMethod.
    /// </summary>
    procedure ISA_QueryGroupMethod()
    var
        ISA_SalesLineQueryMethod: Query ISA_SalesLineQueryMethod;
        DicOfGroup: Dictionary of [Integer, Decimal];
        GroupNo: Integer;
    begin
        ISA_SalesLineQueryMethod.open;
        while ISA_SalesLineQueryMethod.Read() do begin
            GroupNo += 1;
            DicOfGroup.Add(GroupNo, ISA_SalesLineQueryMethod.Amount);
        end;
    end;
}