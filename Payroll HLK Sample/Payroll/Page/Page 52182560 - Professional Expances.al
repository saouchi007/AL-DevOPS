/// <summary>
/// Page Professional Expances (ID 52182560).
/// </summary>
page 52182560 "Professional Expances"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Contributions Payment Registr.',
                FRA = 'Saisie des frais de mission ';
    PageType = List;
    SourceTable = "Professional Expances";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field(Contribution; Contribution)
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Post Code"; "Post Code")
                {
                }
                field(Amount; Amount)
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
                field(Quantity; Quantity)
                {
                }
                field(Comment; Comment)
                {
                }
                field(Destination; Destination)
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
        area(navigation)
        {
            group("&Contract")
            {
                CaptionML = ENU = '&Contract',
                            FRA = '&Frais';
                Image = ContactPerson;
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST(1), //Const(11)
                                  "Table Line No." = FIELD("Entry No.");
                }
                action("Imprimer décompte des frais")
                {
                    Caption = 'Imprimer décompte des frais';
                    Image = Print;

                    trigger OnAction();
                    begin
                        FraisSalarie.RESET;
                        FraisSalarie.SETRANGE("Employee No.", "Employee No.");
                        REPORT.RUNMODAL(51448, TRUE, FALSE, FraisSalarie);

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
            FILTERGROUP(0);
        END;
        //+++01+++
    end;

    var
        ParamUtilisateur: Record 91;
        Direction: Record "Company Business Unit";
        Text01: Label 'Utilisateur %1 non configuré !';
        Text02: Label 'Direction non paramétrée pour l''utilisateur %1 !';
        FraisSalarie: Record "Professional Expances";

}

