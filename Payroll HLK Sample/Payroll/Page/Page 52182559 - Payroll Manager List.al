/// <summary>
/// Page Payroll Manager List (ID 51530).
/// </summary>
page 52182559 "Payroll Manager List"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Payroll Manager List',
                FRA = 'Liste des gestionnaires de paie';
    PageType = Card;
    UsageCategory = Lists;
    SourceTable = "Payroll Manager";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("User ID"; "User ID")
                {
                }
                field("Company Business Unit Code"; "Company Business Unit Code")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Synchroniser le profil")
            {
                Caption = 'Synchroniser le profil';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    IF NOT ParamUtilisateur.GET("User ID") THEN BEGIN
                        ParamUtilisateur.INIT;
                        ParamUtilisateur."User ID" := "User ID";
                        ParamUtilisateur.INSERT;
                    END;
                    ParamUtilisateur.GET("User ID");
                    ParamUtilisateur."Company Business Unit" := "Company Business Unit Code";
                    ParamUtilisateur.MODIFY;
                    MESSAGE(Text02, "User ID");
                end;
            }
        }
    }



    var
        ParamUtilisateur: Record 91;
        Text01: Label 'Utilisateur %1 non configuré dans la table des paramètres utilisateurs !';
        Text02: Label 'Synchronisation terminée pour l''utilisateur [%1].';

}

