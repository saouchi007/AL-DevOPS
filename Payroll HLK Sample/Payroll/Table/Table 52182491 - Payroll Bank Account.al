/// <summary>
/// Table Payroll Bank Account (ID 51464).
/// </summary>
table 52182491 "Payroll Bank Account"
//table 39108464 "Payroll Bank Account"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Payroll Bank Account',
                FRA = 'Compte bancaire paie';
    DataCaptionFields = "Code", Name;
    //DrillDownPageID = 39108511;
    //LookupPageID = 39108511;

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
        field(3; "Name 2"; Text[50])
        {
            CaptionML = ENU = 'Name 2',
                        FRA = 'Nom 2';
        }
        field(4; Address; Text[50])
        {
            CaptionML = ENU = 'Address',
                        FRA = 'Adresse';
        }
        field(5; "Address 2"; Text[50])
        {
            CaptionML = ENU = 'Address 2',
                        FRA = 'Adresse (2ème ligne)';
        }
        field(6; City; Text[30])
        {
            CaptionML = ENU = 'City',
                        FRA = 'Ville';

            trigger OnLookup();
            begin
                PostCode.LookUpCity(City, "Post Code", TRUE);
            end;

            trigger OnValidate();
            begin
                //PostCode.ValidatePostCode_old(City,"Post Code");
                PostCode.ValidateCity_old(City, "Post Code");
            end;
        }
        field(7; "Post Code"; Code[20])
        {
            CaptionML = ENU = 'Post Code',
                        FRA = 'Code postal';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup();
            begin
                //PostCode.UpdateFromSalesHeader(City,"Post Code",TRUE);
                PostCode.LookUpPostCode(City, "Post Code", TRUE);
            end;

            trigger OnValidate();
            begin
                //PostCode.LookUpPostCode(City,"Post Code");
                PostCode.ValidatePostCode_old(City, "Post Code");
            end;
        }
        field(8; Contact; Text[50])
        {
            CaptionML = ENU = 'Contact',
                        FRA = 'Contact';
        }
        field(9; "Phone No."; Text[30])
        {
            CaptionML = ENU = 'Phone No.',
                        FRA = 'N° téléphone';
        }
        field(10; "Telex No."; Text[20])
        {
            CaptionML = ENU = 'Telex No.',
                        FRA = 'N° télex';
        }
        field(11; "Bank Branch No."; Text[20])
        {
            CaptionML = ENU = 'Bank Branch No.',
                        FRA = 'Code établissement';
        }
        field(12; "Agency Code"; Text[5])
        {
            CaptionML = ENU = 'Agency Code',
                        FRA = 'Code agence';

            trigger OnValidate();
            begin
                IF STRLEN("Agency Code") < 5 THEN
                    "Agency Code" := PADSTR('', 5 - STRLEN("Agency Code"), '0') + "Agency Code";
            end;
        }
        field(13; "E-Mail"; Text[80])
        {
            CaptionML = ENU = 'E-Mail',
                        FRA = 'E-mail';
        }
        field(14; "Home Page"; Text[80])
        {
            CaptionML = ENU = 'Home Page',
                        FRA = 'Page d''accueil';
        }
        field(15; "Language Code"; Code[10])
        {
            CaptionML = ENU = 'Language Code',
                        FRA = 'Code langue';
            TableRelation = Language;
        }
        field(16; "Currency Code"; Code[10])
        {
            CaptionML = ENU = 'Currency Code',
                        FRA = 'Code devise';
            TableRelation = Currency;
        }
        field(17; "Country/Region Code"; Code[10])
        {
            CaptionML = ENU = 'Country/Region Code',
                        FRA = 'Code pays/région';
            TableRelation = "Country/Region";
        }
        field(18; County; Text[30])
        {
            CaptionML = ENU = 'County',
                        FRA = 'Région';
        }
        field(19; "Fax No."; Text[30])
        {
            CaptionML = ENU = 'Fax No.',
                        FRA = 'N° télécopie';
        }
        field(20; "Telex Answer Back"; Text[20])
        {
            CaptionML = ENU = 'Telex Answer Back',
                        FRA = 'Télex retour';
        }
        field(21; "No. of Domiciliated Employees"; Integer)
        {
            CalcFormula = Count(Employee WHERE("Payroll Bank Account" = FIELD(Code)));
            CaptionML = ENU = 'No. of Domiciliated Employees',
                        FRA = 'Nbre de salariés domiciliés';
            Editable = false;
            FieldClass = FlowField;
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
        PostCode: Record 225;
        RIBKey: Codeunit 52182450;
}

