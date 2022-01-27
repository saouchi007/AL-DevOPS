/// <summary>
/// Table Masse salariale (ID 52182529).
/// </summary>
table 52182529 "Masse salariale"
//table 39108613 "Masse salariale"
{
    // version HALRHPAIE.6.1.05


    fields
    {
        field(1; CodeStructure; Code[20])
        {
        }
        field(2; DesignationStructure; Text[50])
        {
        }
        field(3; Categorie; Code[10])
        {
        }
        field(4; NbreSalaries; Integer)
        {
        }
        field(5; SalaireBase; Decimal)
        {
        }
        field(6; Cotisable; Decimal)
        {
        }
        field(7; Imposable; Decimal)
        {
        }
        field(8; NonImposable; Decimal)
        {
        }
        field(9; FraisPersonnel; Decimal)
        {
        }
        field(10; ChargesSociales; Decimal)
        {
        }
        field(11; ChargesFiscales; Decimal)
        {
        }
        field(12; AutresCharges; Decimal)
        {
        }
        field(13; TotalMasseSalariale; Decimal)
        {
        }
        field(14; Cacobatph; Decimal)
        {
            Caption = 'Cacobatph';
        }
        field(15; Pretbath; Decimal)
        {
            Caption = 'Pretbath';
        }
        field(16; "Non Imposable Non cotisable"; Decimal)
        {
            Caption = 'Non Imposable Non cotisable';
        }
        field(17; "Imposable Non Cotisable"; Decimal)
        {
            Caption = 'Imposable Non Cotisable';
        }
    }

    keys
    {
        key(Key1; CodeStructure, Categorie)
        {
        }
    }

    fieldgroups
    {
    }
}

