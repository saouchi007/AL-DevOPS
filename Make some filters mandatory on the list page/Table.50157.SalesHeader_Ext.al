/// <summary>
/// TableExtension SalesHeader_Ext (ID 50157) extends Record Sales Header.
/// </summary>
tableextension 50157 SalesHeader_Ext extends "Sales Header"
{
    fields
    {
        field(50157; UserName; Code[50])
        {
            Caption = 'User Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(User."User Name" where("User Security ID" = field(SystemCreatedBy)));
        }
    }
}