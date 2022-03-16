/// <summary>
/// PageExtension ISA_CustomerCard (ID 50165) extends Record Customer Card.
/// </summary>
pageextension 50165 ISA_CustomerCard extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {
            field(CustRank; CustRank)
            {
                Caption = 'Customer Rank';
                ApplicationArea = All;
            }
        }
    }


    var
        CustRank: Enum CustomerRank;
}