/// <summary>
/// Page Congé salariés mutés (ID 52182504).
/// </summary>
page 52182504 "Congé salariés mutés"
{
    // version HALRHPAIE.6.2.00

    PageType = Card;
    SourceTable = "Payroll Archive Header";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Payroll Code"; "Payroll Code")
                {

                    trigger OnValidate();
                    begin
                        IF COPYSTR("Payroll Code", 1, 2) <> 'CA' THEN
                            ERROR('Seules les paies de congés sont autorisées.');
                    end;
                }
                field("No."; "No.")
                {

                    trigger OnValidate();
                    begin
                        NoOnAfterValidate;
                    end;
                }
                field("Last Name"; "Last Name")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Leave Indemnity No."; "Leave Indemnity No.")
                {
                }
                field("Leave Indemnity Amount"; "Leave Indemnity Amount")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        FILTERGROUP(2);
        SETFILTER("Payroll Code", 'CA' + '*');
        FILTERGROUP(0);
    end;

    var
        Text01: Label 'Utilisateur %1 non configuré !';
        Text02: Label 'Direction non paramétrée pour l''utilisateur %1 !';
        Direction: Record "Company Business Unit";
        ParamUtilisateur: Record 91;
        Salarie: Record 5200;

    local procedure NoOnAfterValidate();
    begin
        IF COPYSTR("Payroll Code", 1, 2) = 'CA' THEN BEGIN
            Salarie.GET("No.");
            "First Name" := Salarie."First Name";
            "Last Name" := Salarie."Last Name";
            //MODIFY;
        END;
    end;
}

