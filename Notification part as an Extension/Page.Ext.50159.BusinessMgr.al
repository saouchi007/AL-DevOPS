/// <summary>
/// PageExtension ISA_BusinesManager (ID 50159) extends Record Business Manager Role Center.
/// </summary>
pageextension 50159 ISA_BusinesManager extends "Business Manager Role Center"
{
    layout
    {
        addafter(Control9)
        {
            part(MyNotification; 50158)
            {
                Visible = true;
                ApplicationArea = All;
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