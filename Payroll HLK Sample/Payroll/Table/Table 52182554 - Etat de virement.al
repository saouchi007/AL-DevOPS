/// <summary>
/// Table Etat de virement (ID 52182554).
/// </summary>
table 52182554 "Etat de virement"
//table 39108645 "Etat de virement"
{
    // version HALRHPAIE.6.2.00


    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.',
                        FRA = 'N°';
        }
        field(2; "First Name"; Text[30])
        {
            CaptionML = ENU = 'First Name',
                        FRA = 'Prénom';
        }
        field(3; "Last Name"; Text[30])
        {
            CaptionML = ENU = 'Last Name',
                        FRA = 'Nom';
        }
        field(4; "Payroll Bank Account"; Code[20])
        {
            CaptionML = ENU = 'Payroll Bank Account',
                        FRA = 'Compte bancaire de paie';
            TableRelation = "Payroll Bank Account";
        }
        field(5; "Payroll Bank Account No."; Text[20])
        {
            CaptionML = ENU = 'Payroll Bank Account No.',
                        FRA = 'N° compte bancaire de paie';
        }
        field(6; Amount; Decimal)
        {
            Caption = 'Montant';
        }
        field(7; "RIB Key"; Text[2])
        {
            CaptionML = ENU = 'RIB Key',
                        FRA = 'Clé RIB';
        }
        field(8; "Middle Name"; Text[30])
        {
            CaptionML = ENU = 'Middle Name',
                        FRA = 'Nom de jeune fille';
        }
        field(9; Sex; Option)
        {
            CaptionML = ENU = 'Sex',
                        FRA = 'Sexe';
            OptionCaptionML = ENU = ' ,Female,Male',
                              FRA = ' ,Féminin,Masculin';
            OptionMembers = " ",Female,Male;
        }
        field(50000; "N° CCP"; Text[20])
        {
            Caption = 'N° CCP';
        }
        field(50001; "Code banque"; Text[20])
        {
            Caption = 'Code banque';
        }
        field(50002; "Code agence"; Text[20])
        {
            Caption = 'Code agence';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Payroll Bank Account", "No.")
        {
        }
    }

    fieldgroups
    {
    }
}

