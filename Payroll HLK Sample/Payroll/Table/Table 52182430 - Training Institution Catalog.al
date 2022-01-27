/// <summary>
/// Table Training Institution Catalog (ID 52182430).
/// </summary>
table 52182430 "Training Institution Catalog"
//table 39108401 "Training Institution Catalog"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training Institution Catalog',
                FRA = 'Catalogue de formations établissement';
    //DrillDownPageID = 39108403;
    //LookupPageID = 39108455;

    fields
    {
        field(1; "Training Institution No."; Code[20])
        {
            CaptionML = ENU = 'Training Institution No.',
                        FRA = 'No. Etablissement de formation';
            NotBlank = true;
            TableRelation = "Training Institution";

            trigger OnValidate();
            begin
                IF "Training Institution No." = '' THEN
                    "Institution Description" := ''
                ELSE BEGIN
                    Institution.GET("Training Institution No.");
                    "Institution Description" := Institution.Name;
                END;
            end;
        }
        field(2; "Training No."; Code[20])
        {
            CaptionML = ENU = 'Training No.',
                        FRA = 'N° Formation';
            NotBlank = true;
            TableRelation = Training;

            trigger OnValidate();
            begin
                IF "Training No." = '' THEN
                    "Institution Description" := ''
                ELSE BEGIN
                    Training.GET("Training No.");
                    "Training Description" := Training.Description;
                END;
            end;
        }
        field(3; Period; Integer)
        {
            CaptionML = ENU = 'Period',
                        FRA = 'Durée';
        }
        field(4; "Coût"; Decimal)
        {
            CaptionML = ENU = 'Cost',
                        FRA = 'Coût';
        }
        field(5; "Training Description"; Text[50])
        {
            CaptionML = ENU = 'Training Description',
                        FRA = 'Désignation de formation';
        }
        field(6; "Institution Description"; Text[50])
        {
            CaptionML = ENU = 'Institution Description',
                        FRA = 'Désignation d''établissement';
        }
        field(7; "Institution Reference"; Text[20])
        {
            CaptionML = ENU = 'Institution Reference',
                        FRA = 'Référence établissement';
        }
        field(8; "Editor Reference"; Text[20])
        {
            CaptionML = ENU = 'Editor Reference',
                        FRA = 'Référence éditeur';
        }
        field(9; "No. of Sessions"; Integer)
        {
            CalcFormula = Count("Training Session" WHERE("Institution No." = FIELD("Training Institution No."),
                                                          "Training No." = FIELD("Training No.")));
            CaptionML = ENU = 'No. of Sessions',
                        FRA = 'Nbre de sessions';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Unit of Measure"; Option)
        {
            CaptionML = ENU = 'Unit of Measure',
                        FRA = 'Unité de mesure';
            OptionCaptionML = ENU = 'Hour,Day,Month,Year',
                              FRA = 'Heure,Jour,Mois,An';
            OptionMembers = Hour,Day,Month,Year;
        }
    }

    keys
    {
        key(Key1; "Training Institution No.", "Training No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Training: Record 52182432;
        Institution: Record 52182428;
}

