/// <summary>
/// Page Recovery Registration (ID 51459).
/// </summary>
page 52182494 "Recovery Registration"// page de saisie des recupération.
{
    // version HALRHPAIE.6.1.01

    // HALKORB - CGMP cloisonnement par direction - F.HAOUS - Mars 2010
    // 01 : Cloisonnement par direction

    CaptionML = ENU = 'Recovery Registration',
                FRA = 'Saisie des récupérations';
    //DataCaptionFields = "Employee No.";
    //DelayedInsert = true;
    Editable = true;
    PageType = List;
    SourceTable = "Employee Recovery";

    layout
    {
        area(content)
        {
            repeater(New)
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
                field(nature; nature)
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
        area(navigation)
        {
            group("&Recovery")
            {
                Image = Recalculate;
                CaptionML = ENU = '&Recovery',
                            FRA = '&Récupération';
                action("Co&ments")
                {
                    Image = ViewComments;
                    CaptionML = ENU = 'Co&ments',
                                FRA = 'Co&mmentaires';
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST(1),
                    "Table Line No." = FIELD("Entry No.");
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        EXIT(Employee.GET("Employee No."));
    end;



    var
        Employee: Record 5200;
        Text01: Label 'Utilisateur %1 non configuré !';
        Text02: Label 'Direction non paramétrée pour l''utilisateur %1 !';
        ParamUtilisateur: Record 91;
        Direction: Record "Company Business Unit";
}

