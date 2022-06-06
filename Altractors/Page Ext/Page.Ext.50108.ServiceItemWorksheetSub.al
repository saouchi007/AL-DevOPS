
/// <summary>
/// TableExtension ISA_Service (ID 50108) extends Record Service Line.
/// </summary>
pageextension 50108 ISA_SvcItemWksheetSub_Ext extends "Service Item Worksheet Subform"
{
    layout
    {
        addafter("Location Code")
        {
            field("Unit Cost"; Rec."Unit Cost")
            {
                Visible = true;
                ApplicationArea = all;
            }
        }
    }
}