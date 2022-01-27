/// <summary>
/// Table Treatment Hourly Index Grid (ID 51458).
/// </summary>
table 52182485 "Treatment Hourly Index Grid"
//table 39108458 "Treatment Hourly Index Grid"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Treatment Hourly Index Grid',
                FRA = 'Grille des traitements par indices horaires';
    //DrillDownPageID = 39108503;
    //LookupPageID = 39108504;

    fields
    {
        field(1; "No."; Integer)
        {
            CaptionML = ENU = 'No.',
                        FRA = 'N° fonction';
            NotBlank = true;
        }
        field(2; "Function"; Text[50])
        {
            CaptionML = ENU = 'Section',
                        FRA = 'Fonction',
                        FRS = 'Fonction';
            NotBlank = true;
        }
        field(5; CH; Text[30])
        {
            CaptionML = ENU = 'Class',
                        FRA = 'CH',
                        FRS = 'Classe';
        }
        field(6; "Section 1"; Decimal)
        {
            CaptionML = ENU = 'Section 1',
                        FRA = 'Indice 1',
                        FRS = 'Section 1';
        }
        field(7; "Section 2"; Decimal)
        {
            CaptionML = ENU = 'Section 2',
                        FRA = 'Indice 2',
                        FRS = 'Section 2';
        }
        field(8; "Section 3"; Decimal)
        {
            CaptionML = ENU = 'Section 3',
                        FRA = 'Indice 3',
                        FRS = 'Section 3';
        }
        field(9; "Section 4"; Decimal)
        {
            CaptionML = ENU = 'Section 4',
                        FRA = 'Indice 4',
                        FRS = 'Section 4';
        }
        field(10; "Section 5"; Decimal)
        {
            CaptionML = ENU = 'Section 5',
                        FRA = 'Indice 5',
                        FRS = 'Section 5';
        }
        field(11; "Section 6"; Decimal)
        {
            CaptionML = ENU = 'Section 6',
                        FRA = 'Indice 6',
                        FRS = 'Section 6';
        }
        field(12; "Section 7"; Decimal)
        {
            CaptionML = ENU = 'Section 7',
                        FRA = 'Indice 7',
                        FRS = 'Section 7';
        }
        field(13; "Section 8"; Decimal)
        {
            CaptionML = ENU = 'Section 8',
                        FRA = 'Indice 8',
                        FRS = 'Section 8';
        }
        field(14; "Section 9"; Decimal)
        {
            CaptionML = ENU = 'Section 9',
                        FRA = 'Indice 9',
                        FRS = 'Section 9';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }
}

