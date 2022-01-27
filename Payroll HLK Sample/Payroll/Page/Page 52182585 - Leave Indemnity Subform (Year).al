/// <summary>
/// Page Leave Indemnity Subform (Year) (ID 52182585).
/// </summary>
page 52182585 "Leave Indemnity Subform (Year)"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Leave Indemnity Subform',
                FRA = 'Sous-formulaire indemnité de congé';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Leave Right By Years";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Leave Period Code"; "Leave Period Code")
                {
                    Caption = 'Période de congé';
                }
                field("Remaining Amount"; "Remaining Amount")
                {
                    Caption = 'Indemnité de congé';
                }
                field("Remaining Days"; "Remaining Days")
                {
                    Caption = 'Droits à congé';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin


        SETFILTER("Remaining Days", '>0');
    end;

    var
        Paie: Record Payroll;
        PeriodeConge: Record "Leave Period";
        Direction: Record "Company Business Unit";
        Text01: Label 'Période congé courante non paramétrée pour la direction %1 !';

}

