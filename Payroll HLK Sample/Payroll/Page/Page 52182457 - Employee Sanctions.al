/// <summary>
/// Page Employee Sanctions (ID 5521824571422).
/// </summary>
page 52182457 "Employee Sanctions"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employee Sanctions',
                FRA = 'Sanctions salariés';
    DataCaptionFields = "Employee No.";
    DelayedInsert = true;
    Editable = false;
    PageType = Card;
    PopulateAllFields = true;
    SourceTable = "Employee Sanction";
    SourceTableView = SORTING("Employee No.", "Sanction Date");

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field("Sanction Code"; "Sanction Code")
                {
                }
                field("Sanction Date"; "Sanction Date")
                {
                }
                field("Misconduct Code"; "Misconduct Code")
                {
                }
                field("Misconduct Description"; "Misconduct Description")
                {
                }
                field("Sanction Description"; "Sanction Description")
                {
                }
                field("Minutes No."; "Minutes No.")
                {
                }
                field("Minutes Date"; "Minutes Date")
                {
                }
                field("Decision No."; "Decision No.")
                {
                }
                field("Decision Date"; "Decision Date")
                {
                }
                field("From Date"; "From Date")
                {
                }
                field("To Date"; "To Date")
                {
                }
                field(Number; Number)
                {
                    Caption = 'Nombre de Jours';
                }
                field(Degré; Degré)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Misconduct")
            {
                CaptionML = ENU = '&Misconduct',
                            FRA = '&Faute';
                Image = FaultDefault;
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST(1), // Const(Emplo advance)
                                  "Table Line No." = FIELD("Entry No.");
                }
            }
        }
    }


}

