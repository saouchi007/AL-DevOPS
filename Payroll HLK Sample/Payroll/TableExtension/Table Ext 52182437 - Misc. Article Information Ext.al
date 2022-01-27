/// <summary>
/// TableExtension Misc. Article Information Ext (ID 52182437) extends Record Misc. Article Information.
/// </summary>
tableextension 52182437 "Misc. Article Information Ext" extends "Misc. Article Information"
{
    fields
    {
        field(95000; "Company Business Unit Code"; Code[10])
        {
            CaptionML = ENU = 'Company Business Unit Code',
                        FRA = 'Code unité';
            Description = 'HALRHPAIE';
            Editable = false;
            TableRelation = "Company Business Unit";
        }
        field(95001; Returned; Boolean)
        {
            Caption = 'Restitué';
            Description = 'HALRHPAIE';
        }
        field(95002; "Return Date"; Date)
        {
            Caption = 'Date restitution';
            Description = 'HALRHPAIE';
        }
        field(95006; "Structure Code"; Code[20])
        {
            CaptionML = ENU = 'Structure Code',
                        FRA = 'Code de structure';
            Description = 'HALRHPAIE';
            TableRelation = Structure;

            trigger OnValidate();
            begin
                IF "Structure Code" = '' THEN
                    "Structure Description" := ''
                ELSE BEGIN
                    Structure.GET("Structure Code");
                    "Structure Description" := Structure.Description;
                END;

            end;
        }
        field(95022; "Structure Description"; Text[80])
        {
            CaptionML = ENU = 'Structure Description',
                        FRA = 'Désignation structure';
            Description = 'HALRHPAIE';
            Editable = false;
        }
    }

    var
        Text000: TextConst ENU = 'You cannot delete information if there are comments associated with it.', FRA = 'Vous ne pouvez pas supprimer les informations s''il existe des commentaires associés.';
        MiscArticle: Record 52182437;
        ParamUtilisateur: Record 91;
        Direction: Record "Company Business Unit";
        Salarie: Record 5200;
        Structure: Record Structure;
}