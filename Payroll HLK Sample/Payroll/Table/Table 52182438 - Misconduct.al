/// <summary>
/// Table Misconduct (ID 52182438).
/// </summary>
table 52182438 Misconduct
//table 39108409 Misconduct
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Misconduct',
                FRA = 'Faute';
    //DrillDownPageID = 39108412;
    //LookupPageID = 39108412;

    fields
    {
        field(1; "Code"; Code[20])
        {
            CaptionML = ENU = 'Code',
                        FRA = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[250])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
        }
        field(3; Degree; Option)
        {
            CaptionML = ENU = 'Degree',
                        FRA = 'Degré';
            OptionCaptionML = ENU = 'Degree 1,Degree 2,Degree 3',
                              FRA = '1er degré,2nd degré,3ème degré';
            OptionMembers = "Degree 1","Degree 2","Degree 3";
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

