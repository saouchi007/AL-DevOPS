/// <summary>
/// PageExtension ISA_OrderProcessor_Ext (ID 50178) extends Record Order Processor Role Center.
/// </summary>
pageextension 50178 ISA_OrderProcessor_Ext extends "Order Processor Role Center"
{
    layout
    {
        addafter(Control1907692008)
        {
            part(Notes; 50177)
            {
                Visible = true;
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
