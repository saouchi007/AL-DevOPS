/// <summary>
/// Table Training Subdomain (ID 52182458).
/// </summary>
table 52182458 "Training Subdomain"
//table 39108429 "Training Subdomain"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training Domain',
                FRA = 'Sous-domaine de formation';
    // DrillDownPageID = 39108429;
    // LookupPageID = 39108429;

    fields
    {
        field(1; "Code"; Code[10])
        {
            CaptionML = ENU = 'Code',
                        FRA = 'Code';
        }
        field(2; Description; Text[50])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
        }
        field(3; "Domain Code"; Code[10])
        {
            CaptionML = ENU = 'Domain Code',
                        FRA = 'Code de domaine';
            Editable = true;
            TableRelation = "Training Domain";

            trigger OnValidate();
            begin
                IF "Domain Code" = '' THEN
                    "Domain Description" := ''
                ELSE BEGIN
                    Domain.GET("Domain Code");
                    "Domain Description" := Domain.Description;
                END;
            end;
        }
        field(4; "Domain Description"; Text[50])
        {
            CaptionML = ENU = 'Domain Description',
                        FRA = 'Désignation de domaine';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Code", "Domain Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Domain: Record 52182457;
}

