/// <summary>
/// Table Training Domain (ID 52182457).
/// </summary>
table 52182457 "Training Domain"
//table 39108428 "Training Domain"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training Domain',
                FRA = 'Domaine de formation';
    //LookupPageID = 39108428;

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
        field(3; "No. of Subdomains"; Integer)
        {
            CalcFormula = Count("Training Subdomain" WHERE("Domain Code" = FIELD("Code")));
            CaptionML = ENU = 'No. of Subdomains',
                        FRA = 'Nbre de sous-domaines';
            Editable = false;
            FieldClass = FlowField;
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

