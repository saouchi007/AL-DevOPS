/// <summary>
/// Table Declaration IRG (ID 51605).
/// </summary>
table 52182522 "Declaration IRG"
//table 39108605 "Declaration IRG"
{
    // version HALRHPAIE.6.2.00


    fields
    {
        field(1; Matricule; Code[20])
        {
            Caption = 'Matricule';
        }
        field(2; NomPrenom; Text[50])
        {
            Caption = 'Nom et Prenom';
        }
        field(3; NbreEnf; Integer)
        {
            Caption = 'Nbre enfants';
        }
        field(4; Statut; Code[20])
        {
            Caption = 'Statut';
        }
        field(5; "function"; Text[50])
        {
            Caption = 'Fonction';
        }
        field(6; address; Text[100])
        {
            Caption = 'Adresse';
        }
        field(7; SalaireImp1; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Salaire Imp Janvier';
        }
        field(8; RetenueIrg1; Decimal)
        {
            Caption = 'Retenue Irg Janvier';
        }
        field(9; SalaireImp2; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Salaire Imp Fevrier';
        }
        field(10; RetenueIrg2; Decimal)
        {
            Caption = 'Retenue Irg Fevrier';
        }
        field(11; SalaireImp3; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Salaire Imp Mars';
        }
        field(12; RetenueIrg3; Decimal)
        {
            Caption = 'Retenue Irg Mars';
        }
        field(13; SalaireImp4; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Salaire Imp Avril';
        }
        field(14; RetenueIrg4; Decimal)
        {
            Caption = 'Retenue Irg Avril';
        }
        field(39; SalaireImp5; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Salaire Imp Mai';
        }
        field(40; RetenueIrg5; Decimal)
        {
            Caption = 'Retenue Irg Mai';
        }
        field(41; SalaireImp6; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Salaire Imp Juin';
        }
        field(42; RetenueIrg6; Decimal)
        {
            Caption = 'Retenue Irg Juin';
        }
        field(47; SalaireImp7; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Salaire Imp Juillet';
        }
        field(48; RetenueIrg7; Decimal)
        {
            Caption = 'Retenue Irg Juillet';
        }
        field(49; SalaireImp8; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Salaire Imp Aout';
        }
        field(50; RetenueIrg8; Decimal)
        {
            Caption = 'Retenue Irg Aout';
        }
        field(51; SalaireImp9; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Salaire Imp Septembre';
        }
        field(52; RetenueIrg9; Decimal)
        {
            Caption = 'Retenue Irg Septembre';
        }
        field(53; SalaireImp10; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Salaire Imp Octobre';
        }
        field(54; RetenueIrg10; Decimal)
        {
            Caption = 'Retenue Irg Octobre';
        }
        field(55; SalaireImp11; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Salaire Imp Novembre';
        }
        field(56; RetenueIrg11; Decimal)
        {
            Caption = 'Retenue Irg Novembre';
        }
        field(57; SalaireImp12; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Salaire Imp Décembre';
        }
        field(58; RetenueIrg12; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Retenue Irg Décembre';
        }
        field(59; BsHBareme; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Base IRG Hors barème';
        }
        field(60; MtRHBareme; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Montant IRG HB';
        }
        field(61; CID; Decimal)
        {
        }
        field(62; Prenom; Text[30])
        {
            Caption = 'Prenom';
        }
        field(63; PrimeRetenueIRG1; Decimal)
        {
            Caption = 'PrimeRetenueIRG1';
        }
        field(64; BasePrime1; Decimal)
        {
            Caption = 'BasePrime1';
        }
        field(65; PrimeRetenueIRG2; Decimal)
        {
            Caption = 'PrimeRetenueIRG2';
        }
        field(66; BasePrime2; Decimal)
        {
            Caption = 'BasePrime2';
        }
        field(67; PrimeRetenueIRG3; Decimal)
        {
            Caption = 'PrimeRetenueIRG3';
        }
        field(68; BasePrime3; Decimal)
        {
            Caption = 'BasePrime3';
        }
        field(69; PrimeRetenueIRG4; Decimal)
        {
            Caption = 'PrimeRetenueIRG4';
        }
        field(70; BasePrime4; Decimal)
        {
            Caption = 'BasePrime4';
        }
        field(71; PrimeRetenueIRG5; Decimal)
        {
            Caption = 'PrimeRetenueIRG5';
        }
        field(72; BasePrime5; Decimal)
        {
            Caption = 'BasePrime5';
        }
        field(73; PrimeRetenueIRG6; Decimal)
        {
            Caption = 'PrimeRetenueIRG6';
        }
        field(74; BasePrime6; Decimal)
        {
            Caption = 'BasePrime6';
        }
        field(75; PrimeRetenueIRG7; Decimal)
        {
            Caption = 'PrimeRetenueIRG7';
        }
        field(76; BasePrime7; Decimal)
        {
            Caption = 'BasePrime7';
        }
        field(77; PrimeRetenueIRG8; Decimal)
        {
            Caption = 'PrimeRetenueIRG8';
        }
        field(78; BasePrime8; Decimal)
        {
            Caption = 'BasePrime8';
        }
        field(79; PrimeRetenueIRG9; Decimal)
        {
            Caption = 'PrimeRetenueIRG9';
        }
        field(80; BasePrime9; Decimal)
        {
            Caption = 'BasePrime9';
        }
        field(81; PrimeRetenueIRG10; Decimal)
        {
            Caption = 'PrimeRetenueIRG10';
        }
        field(82; BasePrime10; Decimal)
        {
            Caption = 'BasePrime10';
        }
        field(83; PrimeRetenueIRG11; Decimal)
        {
            Caption = 'PrimeRetenueIRG11';
        }
        field(84; BasePrime11; Decimal)
        {
            Caption = 'BasePrime11';
        }
        field(85; PrimeRetenueIRG12; Decimal)
        {
            Caption = 'PrimeRetenueIRG12';
        }
        field(86; BasePrime12; Decimal)
        {
            Caption = 'BasePrime12';
        }
    }

    keys
    {
        key(Key1; Matricule)
        {
            SumIndexFields = SalaireImp1;
        }
    }

    fieldgroups
    {
    }
}

