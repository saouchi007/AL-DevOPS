/// <summary>
/// Page Overtime Registration (ID 52182543).
/// </summary>
page 52182543 "Overtime Registration"
{
    // version HALRHPAIE.6.1.01

    // HALKORB - HALRHPAIE - F.HAOUS - Avril 2010
    // 01 : Cloisonnement par unité

    AutoSplitKey = true;
    CaptionML = ENU = 'Overtime Registration',
                FRA = 'Saisie des heures supp.';
    DelayedInsert = true;
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
                field("Employee Structure Code"; "Employee Structure Code")
                {
                }
                field("Employee Structure Description"; "Employee Structure Description")
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
            group("&Overtime")
            {
                CaptionML = ENU = '&Overtime',
                            FRA = '&Heure supp.';
                Image = ServiceHours;
                action("Co&ments")
                {
                    CaptionML = ENU = 'Co&ments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST(1), //Const(9)
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
            SETRANGE(Status, Status::Active);
            FILTERGROUP(0);
        END;
        //+++01+++
    end;

    var
        ParamUtilisateur: Record 91;
        Text01: Label 'Utilisateur %1 non configuré !';
        Text02: Label 'Unité non paramétrée pour l''utilisateur %1 !';

}

