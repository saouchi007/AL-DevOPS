/// <summary>
/// Page Employee Recoveries (ID 52182493).
/// </summary>
page 52182493 "Employee Recoveries"
{
    // version HALRHPAIE.6.1.01

    // HALKORB - CGMP cloisonnement par direction - F.HAOUS - Mars 2010
    // 01 : Cloisonnement par direction

    CaptionML = ENU = 'Employee Recoveries',
                FRA = 'Récupérations salarié';
    Editable = false;
    PageType = Card;
    SourceTable = "Employee Recovery";

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
                field("From Date"; "From Date")
                {
                }
                field("To Date"; "To Date")
                {
                }
                field("Cause of Recovery Code"; "Cause of Recovery Code")
                {
                }
                field(Description; Description)
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
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
    }

    trigger OnOpenPage();
    begin

        //---01---
        IF NOT ParamUtilisateur.GET(USERID) THEN
            ERROR(Text01);
        IF ParamUtilisateur."Company Business Unit" <> '' THEN BEGIN
            Direction.GET(ParamUtilisateur."Company Business Unit");
            IF ParamUtilisateur."Company Business Unit" = '' THEN
                ERROR(Text02);
            FILTERGROUP(2);
            SETRANGE("Company Business Unit Code", ParamUtilisateur."Company Business Unit");
            FILTERGROUP(0);
        END;
        //+++01+++
    end;

    var
        ParamUtilisateur: Record 91;
        Direction: Record "Company Business Unit";
        Text01: Label 'Utilisateur %1 non configuré !';
        Text02: Label 'Direction non paramétrée pour l''utilisateur %1 !';

}

