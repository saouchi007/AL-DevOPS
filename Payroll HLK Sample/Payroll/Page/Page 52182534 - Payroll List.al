/// <summary>
/// Page Payroll List (ID 52182534).
/// </summary>
page 52182534 "Payroll List"
{
    // version HALRHPAIE.6.1.02

    // HALKORB - CGMP cloisonnement par direction - F.HAOUS - Novembre 2009
    // Rajout du champ "Company Business Unit"

    CaptionML = ENU = 'Payroll List',
                FRA = 'Liste des paies';
    PageType = Card;
    SourceTable = Payroll;

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field(Code; Code)
                {
                }
                field("Company Business Unit Code"; "Company Business Unit Code")
                {
                }
                field(Description; Description)
                {
                }
                field("Regular Payroll"; "Regular Payroll")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field(Closed; Closed)
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
        //---01---
        IF NOT ParamUtilisateur.GET(USERID) THEN
            ERROR(Text01);
        IF ParamUtilisateur."Company Business Unit" <> '' THEN BEGIN
            FILTERGROUP(2);
            SETRANGE("Company Business Unit Code", ParamUtilisateur."Company Business Unit");
            FILTERGROUP(0);
        END;
        //+++01+++
    end;

    var
        ParamUtilisateur: Record 91;
        Text01: Label 'Utilisateur %1 non configuré !';
}

