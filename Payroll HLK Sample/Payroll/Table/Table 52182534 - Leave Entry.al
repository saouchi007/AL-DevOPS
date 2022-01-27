/// <summary>
/// Table Leave Entry (ID 52182534).
/// </summary>
table 52182534 "Leave Entry"
//table 39108619 "Leave Entry"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Leave Entry',
                FRA = 'Ecritures de congé';
    // DrillDownPageID = 39108568;
    // LookupPageID = 39108568;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.',
                        FRA = 'N° séquence';
        }
        field(3; "Entry Type"; Option)
        {
            CaptionML = ENU = 'Entry Type',
                        FRA = 'Type écriture';
            OptionCaptionML = ENU = 'Right,Consumption',
                              FRA = 'Droit,Consommation';
            OptionMembers = Right,Consumption;
        }
        field(4; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° Salarié';
            NotBlank = true;
        }
        field(5; "Payroll Code"; Code[20])
        {
            Caption = 'Code paie';
        }
        field(6; Amount; Decimal)
        {
            Caption = 'Montant';
        }
        field(7; Days; Decimal)
        {
            Caption = 'Jours';
        }
        field(8; "Calculated Amount"; Decimal)
        {
            Caption = 'Montant recalculé';
            Editable = true;
        }
        field(11; Closed; Boolean)
        {
            Caption = 'Clôturé';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Entry Type")
        {
            SumIndexFields = Amount, Days, "Calculated Amount";
        }
        key(Key3; "Employee No.", Closed, "Entry Type")
        {
            SumIndexFields = "Calculated Amount", Days;
        }
    }

    fieldgroups
    {
    }
}

