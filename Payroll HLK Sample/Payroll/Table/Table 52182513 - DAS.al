/// <summary>
/// Table DAS (ID 52182513).
/// </summary>
table 52182513 DAS
{
    // version HALRHPAIE.6.2.00


    fields
    {
        field(1; Matricule; Code[20])
        {
            Caption = 'Matricule';
        }
        field(2; "Num SS"; Code[20])
        {
            Caption = 'N° SS';
        }
        field(3; Nom; Text[30])
        {
            Caption = 'Nom';
        }
        field(4; "Durée 1"; Integer)
        {
        }
        field(5; "Montant 1"; Decimal)
        {
        }
        field(6; "Prénom"; Text[30])
        {
        }
        field(7; "Durée 2"; Integer)
        {
        }
        field(8; "Montant 2"; Decimal)
        {
        }
        field(10; "Durée 3"; Integer)
        {
        }
        field(11; "Montant 3"; Decimal)
        {
        }
        field(13; "Durée 4"; Integer)
        {
        }
        field(14; "Montant 4"; Decimal)
        {
        }
        field(39; "Date de naissance"; Text[30])
        {
        }
        field(40; "Montant annuel"; Decimal)
        {
        }
        field(41; "Date d'entrée"; Date)
        {
        }
        field(42; "Date de sortie"; Date)
        {
        }
        field(50000; "Bank Account No."; Text[30])
        {
            CaptionML = ENU = 'Bank Account No.',
                        FRA = 'N° compte bancaire';
        }
        field(50001; "Birthplace City"; Text[30])
        {
            CaptionML = ENU = 'Birthplace City',
                        FRA = 'Ville lieu de naissance';
            Description = 'HALRHPAIE';

            trigger OnLookup();
            begin
                //PostCode.LookUpCity("Birthplace City","Birthplace Post Code",TRUE);
            end;

            trigger OnValidate();
            begin
                //PostCode.ValidateCity_old("Birthplace City","Birthplace Post Code");
            end;
        }
        field(50002; Address; Text[50])
        {
            CaptionML = ENU = 'Address',
                        FRA = 'Adresse';
        }
        field(50003; City; Text[30])
        {
            CaptionML = ENU = 'City',
                        FRA = 'Ville';
            //This property is currently not supported
            //TestTableRelation = false;

            //ValidateTableRelation = false;  commented by AK

            trigger OnValidate();
            begin
                //PostCode.ValidateCity(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(50004; "Post Code"; Code[20])
        {
            CaptionML = ENU = 'Post Code',
                        FRA = 'Code postal';
            //This property is currently not supported
            //TestTableRelation = false;

            // ValidateTableRelation = false; commented by AK

            trigger OnValidate();
            begin
                //PostCode.ValidatePostCode(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(50005; "CCP N"; Text[20])
        {
            Caption = 'N° CCP';
            Description = 'HALRHPAIE';
        }
        field(50006; "Mobile Phone No."; Text[30])
        {
            CaptionML = ENU = 'Mobile Phone No.',
                        FRA = 'N° téléphone mobile';
            ExtendedDatatype = PhoneNo;
        }
        field(50007; "E-Mail"; Text[80])
        {
            CaptionML = ENU = 'Email',
                        FRA = 'Adresse e-mail';
            ExtendedDatatype = EMail;

            trigger OnValidate();
            var
                MailManagement: Codeunit 9520;
            begin
                //MailManagement.ValidateEmailAddressField("E-Mail");
            end;
        }
        field(50008; "Marital Status"; Text[1])
        {
            CaptionML = ENU = 'Marital Status',
                        FRA = 'Situation de famille';
        }
        field(50009; Gender; Text[1])
        {
            CaptionML = ENU = 'Gender',
                        FRA = 'Sexe';
        }
        field(50010; "Présumé"; Boolean)
        {
            Caption = 'Présumé';
        }
        field(50011; "Job Title"; Text[30])
        {
            CaptionML = ENU = 'Job Title',
                        FRA = 'Fonction';
        }
        field(50012; Etranger; Boolean)
        {
            Caption = 'Etranger';
        }
        field(50013; "N° Carte identité nationale"; Text[15])
        {
            Caption = 'N° Carte identité nationale';
        }
        field(50014; "N° Identification National"; Text[18])
        {
            Caption = 'N° Identification National';
        }
        field(50015; "N° acte de naissance"; Text[5])
        {
            Caption = 'N° acte de naissance';
        }
        field(50016; "Prénom de la mère"; Text[40])
        {
            CaptionML = ENU = 'First Name',
                        FRA = 'Prénom de la mère';
        }
        field(50017; "Nom de la mère"; Text[40])
        {
            CaptionML = ENU = 'Last Name',
                        FRA = 'Nom de la mère';
        }
        field(50018; "Prénom du père"; Text[40])
        {
            Caption = 'Prénom du père';
        }
        field(50019; "Code nationalité cacobatph"; Text[3])
        {
            Caption = 'Code nationalité cacobatph';
        }
        field(50020; Banque; Text[10])
        {
            Caption = 'Banque';
        }
        field(50021; "Agence bancaire"; Text[20])
        {
            Caption = 'Agence bancaire';
        }
        field(50022; "Type E/S"; Text[1])
        {
            Caption = 'Type E/S';
        }
        field(50023; "Total annuel"; Decimal)
        {
            CalcFormula = Sum(DAS."Montant annuel");
            Editable = false;
            FieldClass = FlowField;
        }
        field(50024; "Durée de travail"; Integer)
        {
        }
        field(50025; "DuréeCaco 1"; Decimal)
        {
        }
        field(50026; "DuréeCaco 2"; Decimal)
        {
        }
        field(50027; "DuréeCaco 3"; Decimal)
        {
        }
        field(50028; "DuréeCaco 4"; Decimal)
        {
        }
        field(50029; "Matricule VIRM CPA"; Text[31])
        {
        }
        field(50030; "Total annuel CPA"; Decimal)
        {
            CalcFormula = Sum(DAS."Montant 1");
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; Matricule)
        {
            SumIndexFields = "Montant 1", "Montant 2", "Montant 3", "Montant 4", "Montant annuel";
        }
    }

    fieldgroups
    {
    }
}

