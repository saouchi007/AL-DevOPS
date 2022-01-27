/// <summary>
/// Page Treatment by Hourly Index Grid (ID 52182535).
/// </summary>
page 52182535 "Treatment by Hourly Index Grid"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Treatment by Hourly Index Grid',
                FRA = 'Grille des traitements par indices horaires';
    Editable = false;
    PageType = Card;
    SourceTable = "Treatment Hourly Index Grid";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("No."; "No.")
                {
                }
                field("Function"; "Function")
                {
                }
                field(CH; CH)
                {
                }
                field("Section 1"; "Section 1")
                {
                }
                field("Section 2"; "Section 2")
                {
                }
                field("Section 3"; "Section 3")
                {
                }
                field("Section 4"; "Section 4")
                {
                }
                field("Section 5"; "Section 5")
                {
                }
                field("Section 6"; "Section 6")
                {
                }
                field("Section 7"; "Section 7")
                {
                }
                field("Section 8"; "Section 8")
                {
                }
                field("Section 9"; "Section 9")
                {
                }
            }
        }
    }

    actions
    {
    }


}

