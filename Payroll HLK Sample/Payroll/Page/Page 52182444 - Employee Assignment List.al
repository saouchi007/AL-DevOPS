/// <summary>
/// Page Employee Assignment List (ID 52182444).
/// </summary>
page 52182444 "Employee Assignment List" //Saisie des affectations salarié
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employee Assignment List',
                FRA = 'Liste d''affectations salarié';
    PageType = List;
    SourceTable = "Employee Assignment";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Structure No."; "Structure No.")
                {
                }
                field("Structure Description"; "Structure Description")
                {
                }
                field("Function Code"; "Function Code")
                {
                }
                field("Function Description"; "Function Description")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field(Class; Class)
                {
                }
                field(Section; Section)
                {
                }
                field(Level; Level)
                {
                }
                field(Indice; Indice)
                {
                }
                field("Decision No."; "Decision No.")
                {
                }
                field("Decision Date"; "Decision Date")
                {
                }
                field("Movement Code"; "Movement Code")
                {
                }
            }
        }
    }

    actions
    {
    }


}

