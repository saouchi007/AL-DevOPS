/// <summary>
/// Table Recruitment Mode (ID 52182472).
/// </summary>
table 52182472 "Recruitment Mode"
//table 39108444 "Recruitment Mode"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Recruitment Mode',
                FRA = 'Mode recrutement';
    //DrillDownPageID = 39108461;
    //LookupPageID = 39108461;

    fields
    {
        field(1; "Code"; Code[20])
        {
            CaptionML = ENU = 'Code',
                        FRA = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[80])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
        }
        field(3; "Availability Nbre of Days"; Integer)
        {
            CaptionML = ENU = 'Availability Nbre of Days',
                        FRA = 'Nbre de jours de Validité';

            trigger OnValidate();
            begin
                IF "Availability Nbre of Days" < 0 THEN
                    ERROR(Text01);
            end;
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

    var
        Text01: Label 'Le nombre de jours de validité doit être positif !';
}

