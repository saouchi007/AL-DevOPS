/// <summary>
/// Table Journal de paie (ID 52182539).
/// </summary>
table 52182539 "Journal de paie"
//table 39108624 "Journal de paie"
{
    // version HALRHPAIE.6.2.01


    fields
    {
        field(1; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.',
                        FRA = 'N° séquence';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Désignation';
        }
        field(3; "Employee 1"; Text[100])
        {
            Caption = 'Salarié 1';
        }
        field(4; "Employee 2"; Text[100])
        {
            Caption = 'Salarié 2';
        }
        field(5; "Employee 3"; Text[100])
        {
            Caption = 'Salarié 3';
        }
        field(6; "Employee 4"; Text[100])
        {
            Caption = 'Salarié 4';
        }
        field(7; "Employee 5"; Text[100])
        {
            Caption = 'Salarié 5';
        }
        field(8; "Employee 6"; Text[100])
        {
            Caption = 'Salarié 6';
        }
        field(9; "Employee 7"; Text[100])
        {
            Caption = 'Salarié 7';
        }
        field(10; "Employee 8"; Text[100])
        {
            Caption = 'Salarié 8';
        }
        field(11; "Employee 9"; Text[100])
        {
            Caption = 'Salarié 9';
        }
        field(12; "Item Code"; Code[20])
        {
            CaptionML = ENU = 'Item Code',
                        FRA = 'Code rubrique';
        }
        field(13; "Report Mnt Gauche"; Decimal)
        {
        }
        field(14; "Report Eff Gauche"; Integer)
        {
        }
        field(15; "Report Mnt Droite"; Decimal)
        {
        }
        field(16; "Report Eff Droite"; Integer)
        {
        }
        field(17; "Intitules Report"; Text[100])
        {
            Caption = 'Désignation';
        }
        field(18; groupe; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

