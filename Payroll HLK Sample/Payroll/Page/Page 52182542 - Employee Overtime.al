/// <summary>
/// Page Employee Overtime (ID 52182542).
/// </summary>
page 52182542 "Employee Overtime"
{
    // version HALRHPAIE.6.1.01

    // HALKORB - HALRHPAIE - F.HAOUS - Avril 2010
    // 01 : Cloisonnement par direction

    CaptionML = ENU = 'Employee Overtimes',
                FRA = 'Heures supp. salarié';
    Editable = true;
    PageType = List;
    SourceTable = "Employee Overtime";

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
                field("Overtime Date"; "Overtime Date")
                {
                }
                field("Cause of Overtime Code"; "Cause of Overtime Code")
                {
                }
                field(Description; Description)
                {
                }
                field(Category; Category)
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
                field("Employee Structure Code"; "Employee Structure Code")
                {
                }
                field("Employee Structure Description"; "Employee Structure Description")
                {
                }
                field(Date; Date)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Contract")
            {
                CaptionML = ENU = '&Contract',
                            FRA = '&Fonction';
                Image = Job;
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST(1), // Count(11)
                                  "Table Line No." = FIELD("Entry No.");
                }
            }
        }
    }

    trigger OnOpenPage();
    begin

        //---01---
        IF NOT ParamUtilisateur.GET(USERID) THEN
            ERROR(Text01);
        IF ParamUtilisateur."Company Business Unit" <> '' THEN BEGIN
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
        Text01: Label 'Utilisateur %1 non configuré !';
        Text02: Label 'Unité non paramétrée pour l''utilisateur %1 !';

}

