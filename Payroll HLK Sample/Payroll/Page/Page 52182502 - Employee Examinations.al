/// <summary>
/// Page Employee Examinations (ID 52182502).
/// </summary>
page 52182502 "Employee Examinations"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employee Examinations',
                FRA = 'Visites médicales du salariés';
    Editable = false;
    PageType = Card;
    SourceTable = "Employee Medical Examination";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field("Examination Date"; "Examination Date")
                {
                }
                field(Type; Type)
                {
                }
                field(Doctor; Doctor)
                {
                }
                field("Structure code"; "Structure code")
                {
                }
                field("Structure description"; "Structure description")
                {
                }
                field(Comptage; Comptage)
                {
                }
                field("Groupe statistique"; "Groupe statistique")
                {
                }
                field(Result; Result)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Examination")
            {
                CaptionML = ENU = '&Examination',
                            FRA = '&Visite';
                Image = ViewRegisteredOrder;
                action("Co&ments")
                {
                    CaptionML = ENU = 'Co&ments',
                                FRA = 'Co&mmentaires';
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST(1), // Const(19)
                                  "Table Line No." = FIELD("Entry No.");
                }
            }
        }
    }


}

