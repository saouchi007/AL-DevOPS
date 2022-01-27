/// <summary>
/// Page Advance Registration (ID 52182561).
/// </summary>
page 52182561 "Advance Registration"
{
    // version HALRHPAIE.6.1.01

    // HALKORB - HALRHPAIE - F.HAOUS - Mai 2010
    // 01 : Cloisonnement par unité

    CaptionML = ENU = 'Advance Registration',
                FRA = 'Saisie des avances';
    DataCaptionFields = "Employee No.";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Employee Advance";

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
                field("First Name"; "First Name")
                {
                }
                field("Advance Date"; "Advance Date")
                {
                }
                field("Cause of Advance Code"; "Cause of Advance Code")
                {
                }
                field(Description; Description)
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
                field("Groupe Statistique"; "Groupe Statistique")
                {
                }
                field(Comment; Comment)
                {
                }
                field("Payroll Bank Account No."; "Payroll Bank Account No.")
                {
                }
                field("RIB Key"; "RIB Key")
                {
                }
                field("Advanced Amount"; "Advanced Amount")
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
                            FRA = '&Avances';
                Image = ContactPerson;
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST(1), //employe advance
                                  "Table Line No." = FIELD("Entry No.");
                }
                action("Etat des avances")
                {
                    Caption = 'Etat des avances';
                    Image = PrepaymentCreditMemo;

                    trigger OnAction();
                    begin
                        AvanceSalarie.RESET;
                        AvanceSalarie.SETRANGE("Employee Structure Code", "Employee Structure Code");
                        REPORT.RUNMODAL(51452, TRUE, FALSE, AvanceSalarie);
                    end;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        EXIT(Employee.GET("Employee No."));
    end;

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
        Employee: Record 5200;
        ParamUtilisateur: Record 91;
        Text01: Label 'Utilisateur %1 non configuré !';
        Text02: Label 'Direction non paramétrée pour l''utilisateur %1 !';
        AvanceSalarie: Record "Employee Advance";

}

