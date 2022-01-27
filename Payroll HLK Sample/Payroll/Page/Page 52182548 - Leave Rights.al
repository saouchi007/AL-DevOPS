/// <summary>
/// Page Leave Rights (ID 52182548).
/// </summary>
page 52182548 "Leave Rights"
{
    // version HALRHPAIE

    CaptionML = ENU = 'Leave Rights',
                FRA = 'Droits au congé';
    // Editable = false;
    PageType = Card;
    SourceTable = "Leave Right";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Leave Period Code"; "Leave Period Code")
                {
                }
                field("Employee No."; "Employee No.")
                {
                }
                field("No. of Days"; "No. of Days")
                {
                }
                field("No. of Consumed Days"; "No. of Consumed Days")
                {
                }
                field(Difference; Difference)
                {
                }
                field("Employment Date"; "Employment Date")
                {
                    Visible = false;
                }
                field("Termination Date"; "Termination Date")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }


}

