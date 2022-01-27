/// <summary>
/// TableExtension User Setup Ext (ID 52182429) extends Record User Setup.
/// </summary>
tableextension 52182429 "User Setup Ext" extends "User Setup"
{
    fields
    {
        field(50000; "Company Business Unit"; Code[10])
        {
        }
        field(50001; "RH et Paie"; Boolean)
        {
        }
    }

    var
        myInt: Integer;
}