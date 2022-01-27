/// <summary>
/// Page Examination Registration (ID 52182503).
/// </summary>
page 52182503 "Examination Registration" // Saisie et programmation visite medicale
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Examination Registration',
                FRA = 'Saisie des visites médicales';
    Editable = true;
    PageType = List;
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
                field("First Name"; "First Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field("Examination Date"; "Examination Date")
                {
                }
                field("<Date de prélèvement sanguin>"; "Date de prélèvement sanguin")
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
                field(Result; Result)
                {
                }
                field("Groupe statistique"; "Groupe statistique")
                {
                }
                field(Comptage; Comptage)
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
                image = ConsumptionJournal;

                action("historique viste medicales")
                {
                    Caption = 'historique viste medicales';
                    //RunObject = Page 50049;
                    //RunPageLink = Field1 = FIELD("Employee No.");
                }
                action("Co&ments")
                {
                    CaptionML = ENU = 'Co&ments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST(1), //cons(19)
                                  "Table Line No." = FIELD("Entry No.");
                }
                action(Valider)
                {
                    Caption = 'Valider';
                    Visible = false;

                    trigger OnAction();
                    begin
                        VALIDATE("Employee No.");
                        MODIFY;
                    end;
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
            Direction.GET(ParamUtilisateur."Company Business Unit");
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
        Employee: Record 5200;
        ParamUtilisateur: Record 91;
        Direction: Record "Company Business Unit";
        Text01: Label 'Utilisateur %1 non configuré !';
        Text02: Label 'Direction non paramétrée pour l''utilisateur %1 !';
}

