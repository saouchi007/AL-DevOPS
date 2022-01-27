/// <summary>
/// Page Employee Accidents (ID 52182499).
/// </summary>
page 52182499 "Employee Accidents"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employee Accidents',
                FRA = 'Accident de travail salarié';
    Editable = false;
    PageType = Card;
    SourceTable = "Employee Accident";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field("Accident Date"; "Accident Date")
                {
                }
                field("Cause of Accident Code"; "Cause of Accident Code")
                {
                }
                field(Description; Description)
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field(Comment; Comment)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Accident")
            {
                CaptionML = ENU = '&Accident',
                            FRA = '&Accident';
                Image = DeleteAllBreakpoints;
                action("Co&ments")
                {
                    CaptionML = ENU = 'Co&ments',
                                FRA = 'Co&mmentaires';
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST(1), // Count(18)
                                  "Table Line No." = FIELD("Entry No.");
                }
            }
        }
    }


}

