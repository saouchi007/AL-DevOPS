/// <summary>
/// Table Structure (ID 52182434).
/// </summary>
table 52182434 Structure
//table 39108405 Structure
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Structure',
                FRA = 'Structure';
    //  DrillDownPageID = 51410;
    // LookupPageID = 51410;

    fields
    {
        field(1; "Code"; Code[20])
        {
            CaptionML = ENU = 'Code',
                        FRA = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
        }
        field(3; "Structure Type"; Option)
        {
            CaptionML = ENU = 'Structure Type',
                        FRA = 'Type structure';
            OptionCaptionML = ENU = 'Standard,Heading,Total,Begin-Total,End-Total',
                              FRA = 'Standard,Titre,Total,Début total,Fin total';
            OptionMembers = Standard,Heading,Total,"Begin-Total","End-Total";
        }
        field(4; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            CaptionML = ENU = 'Global Dimension 1 Code',
                        FRA = 'Code axe principal 1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(5; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            CaptionML = ENU = 'Global Dimension 2 Code',
                        FRA = 'Code axe principal 2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(6; Totaling; Text[250])
        {
            CaptionML = ENU = 'Totaling',
                        FRA = 'Totalisation';

            trigger OnValidate();
            begin
                IF NOT ("Structure Type" IN
                  ["Structure Type"::Total, "Structure Type"::"End-Total"]) AND (Totaling <> '')
                THEN
                    FIELDERROR("Structure Type");
            end;
        }
        field(7; Blocked; Boolean)
        {
            CaptionML = ENU = 'Blocked',
                        FRA = 'Bloqué';
        }
        field(8; Indentation; Integer)
        {
            CaptionML = ENU = 'Indentation',
                        FRA = 'Indentation';
        }
        field(9; Responsable; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

