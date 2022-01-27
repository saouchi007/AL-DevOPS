/// <summary>
/// Page Contract Registration (ID 52182462).
/// </summary>
page 52182462 "Contract Registration" //Sasie des contrat de travail
{
    // version HALRHPAIE

    // HALKORB - CGMP cloisonnement par direction - F.HAOUS - Mars 2010
    // 01 : Cloisonnement par direction

    CaptionML = ENU = 'Employment Contract Registration',
                FRA = 'Saisie des contrats de travail';
    DelayedInsert = true;
    Editable = true;
    PageType = List;
    SourceTable = "Employee Contract";

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
                field("Stucture code"; "Stucture code")
                {
                }
                field("Designation structure"; "Designation structure")
                {
                }
                field("Company Business Unit Code"; "Company Business Unit Code")
                {
                }
                field("Employment Contract Code"; "Employment Contract Code")
                {
                }
                field(Nature; Nature)
                {
                }
                field("From Date"; "From Date")
                {
                }
                field("To Date"; "To Date")
                {
                }
                field("Contract Reference"; "Contract Reference")
                {
                }
                field("Installation Date"; "Installation Date")
                {
                }
                field(Period; Period)
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field("Trial Period"; "Trial Period")
                {
                }
                field("Date fin de période d'essai"; "Date fin de période d'essai")
                {
                }
                field("Cause of Contract Termination"; "Cause of Contract Termination")
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
            group("&Contract")
            {
                CaptionML = ENU = '&Contract',
                            FRA = '&Contrat';
                Image = ContactReference;
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST(2), // const(11)
                                  "Table Line No." = FIELD("Entry No.");
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

