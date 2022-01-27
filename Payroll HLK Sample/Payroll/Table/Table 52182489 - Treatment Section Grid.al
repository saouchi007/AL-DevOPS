/// <summary>
/// Table Treatment Section Grid (ID 51462).
/// </summary>
table 52182489 "Treatment Section Grid"
//table 39108462 "Treatment Section Grid"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Treatment Section Grid',
                FRA = 'Grille des traitements par sections';
    //DrillDownPageID = 39108508;
    //LookupPageID = 39108508;

    fields
    {
        field(1; Class; Code[10])
        {
            CaptionML = ENU = 'Class',
                        FRA = 'Classe';
            NotBlank = true;
        }
        field(2; Section; Integer)
        {
            CaptionML = ENU = 'Section',
                        FRA = 'Section';
            NotBlank = true;
        }
        field(3; Category; Code[10])
        {
            CaptionML = ENU = 'Category',
                        FRA = 'Catégorie';
            TableRelation = "Socio-professional Category";
        }
        field(5; "Minimal Index"; Integer)
        {
            CaptionML = ENU = 'Minimal Index',
                        FRA = 'Indice minimal';
        }
        field(6; "Level 1"; Integer)
        {
            CaptionML = ENU = 'Level 1',
                        FRA = 'Echelon 1';
        }
        field(7; "Level 2"; Integer)
        {
            CaptionML = ENU = 'Level 2',
                        FRA = 'Echelon 2';
        }
        field(8; "Level 3"; Integer)
        {
            CaptionML = ENU = 'Level 3',
                        FRA = 'Echelon 3';
        }
        field(9; "Level 4"; Integer)
        {
            CaptionML = ENU = 'Level 4',
                        FRA = 'Echelon 4';
        }
        field(10; "Level 5"; Integer)
        {
            CaptionML = ENU = 'Level 5',
                        FRA = 'Echelon 5';
        }
        field(11; "Level 6"; Integer)
        {
            CaptionML = ENU = 'Level 6',
                        FRA = 'Echelon 6';
        }
        field(12; "Level 7"; Integer)
        {
            CaptionML = ENU = 'Level 7',
                        FRA = 'Echelon 7';
        }
        field(13; "Level 8"; Integer)
        {
            CaptionML = ENU = 'Level 8',
                        FRA = 'Echelon 8';
        }
        field(14; "Level 9"; Integer)
        {
            CaptionML = ENU = 'Level 9',
                        FRA = 'Echelon 9';
        }
        field(15; "Level 10"; Integer)
        {
            CaptionML = ENU = 'Level 10',
                        FRA = 'Echelon 10';
        }
        field(16; "Level 11"; Integer)
        {
            CaptionML = ENU = 'Level 11',
                        FRA = 'Echelon 11';
        }
        field(17; "Level 12"; Integer)
        {
            CaptionML = ENU = 'Level 12',
                        FRA = 'Echelon 12';
        }
        field(18; "Level 13"; Integer)
        {
            CaptionML = ENU = 'Level 13',
                        FRA = 'Echelon 13';
        }
        field(19; "Level 14"; Integer)
        {
            CaptionML = ENU = 'Level 14',
                        FRA = 'Echelon 14';
        }
        field(20; "Level 15"; Integer)
        {
            CaptionML = ENU = 'Level 15',
                        FRA = 'Echelon 15';
        }
        field(21; "Level 16"; Integer)
        {
            CaptionML = ENU = 'Level 16',
                        FRA = 'Echelon 16';
        }
        field(22; "Level 17"; Integer)
        {
            CaptionML = ENU = 'Level 17',
                        FRA = 'Echelon 17';
        }
        field(23; "Level 18"; Integer)
        {
            CaptionML = ENU = 'Level 18',
                        FRA = 'Echelon 18';
        }
        field(24; "Level 19"; Integer)
        {
            CaptionML = ENU = 'Level 19',
                        FRA = 'Echelon 19';
        }
        field(25; "Level 20"; Integer)
        {
            CaptionML = ENU = 'Level 20',
                        FRA = 'Echelon 20';
        }
    }

    keys
    {
        key(Key1; Class, Section)
        {
        }
    }

    fieldgroups
    {
    }
}

