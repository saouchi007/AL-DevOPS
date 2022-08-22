/// <summary>
/// PageExtension ISA_ServiceOrder (ID 50305) extends Record Service Order.
/// </summary>
pageextension 50305 ISA_ServiceOrder extends "Service Order"
{
    layout
    {
        addfirst(factboxes)
        {
            systempart(Links; Links)
            {
                ApplicationArea = All;
                Visible = true;
            }
            systempart(Outlook; Outlook)
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
    }

}