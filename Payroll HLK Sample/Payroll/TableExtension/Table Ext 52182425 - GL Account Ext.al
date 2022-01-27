/// <summary>
/// TableExtension GL Account Ext (ID 52182425) extends Record G/L Account.
/// </summary>
tableextension 52182425 "GL Account Ext" extends "G/L Account"
{
    fields
    {
        field(50004; "Detail By Employee"; Boolean)
        {
            Caption = 'Comptabiliser par salarié';
        }
    }

    var
        myInt: Integer;
}