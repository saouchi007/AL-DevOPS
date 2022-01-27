/// <summary>
/// Table Wilaya (ID 52182542).
/// </summary>
table 52182542 Wilaya
//table 39108630 Wilaya
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Wilaya',
                FRA = 'Wilaya';
    //LookupPageID = 39108556;

    fields
    {
        field(1; "Code"; Code[10])
        {
            CaptionML = ENU = 'Code',
                        FRA = 'Code';
            NotBlank = true;
        }
        field(2; Name; Text[50])
        {
            CaptionML = ENU = 'Name',
                        FRA = 'Nom';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
        key(Key2; Name)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    var
        VATRegNoFormat: Record 381;
    begin
    end;
}

