/// <summary>
/// Table Antenna (ID 52182521).
/// </summary>
table 52182521 Antenna
//table 39108604 Antenna
{
    // version HALRHPAIE.6.1.01

    // HALKORB - CGMP cloisonnement par direction - F.HAOUS - Mars 2010
    // 01 : Cloisonnement des immobilisations

    CaptionML = ENU = 'Antenna',
                FRA = 'Antenne de Direction';
    //DrillDownPageID = 39108555;
    //LookupPageID = 39108555;

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
        field(3; Address; Text[50])
        {
            CaptionML = ENU = 'Address',
                        FRA = 'Adresse';
        }
        field(4; "Address 2"; Text[50])
        {
            CaptionML = ENU = 'Address 2',
                        FRA = 'Adresse (2ème ligne)';
        }
        field(5; City; Text[30])
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
        field(6; "Post Code"; Code[20])
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
        field(7; "Country/Region Code"; Code[10])
        {
            CaptionML = ENU = 'Country/Region Code',
                        FRA = 'Code pays/région';
            TableRelation = "Country/Region";
        }
        field(8; "Phone No."; Text[30])
        {
            CaptionML = ENU = 'Phone No.',
                        FRA = 'N° téléphone';
        }
        field(9; "Fax No."; Text[30])
        {
            CaptionML = ENU = 'Fax No.',
                        FRA = 'N° télécopie';
        }
        field(10; "Name 2"; Text[50])
        {
            CaptionML = ENU = 'Name 2',
                        FRA = 'Nom 2';
        }
        field(11; Contact; Text[50])
        {
            CaptionML = ENU = 'Contact',
                        FRA = 'Contact';
        }
        field(15; County; Text[30])
        {
            CaptionML = ENU = 'County',
                        FRA = 'Région';
        }
        field(16; "Current Payroll Code"; Code[20])
        {
            CaptionML = ENU = 'Current Payroll Code',
                        FRA = 'Code paie courante';
            TableRelation = Payroll;
        }
        field(102; "E-Mail"; Text[80])
        {
            CaptionML = ENU = 'E-Mail',
                        FRA = 'E-mail';
        }
        field(103; "Home Page"; Text[90])
        {
            CaptionML = ENU = 'Home Page',
                        FRA = 'Page d''accueil';
        }
        field(104; "Date Filter"; Date)
        {
            CaptionML = ENU = 'Date Filter',
                        FRA = 'Filtre date';
            FieldClass = FlowFilter;
        }
        field(105; "Contract Gain/Loss Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Contract Gain/Loss Entry".Amount WHERE("Responsibility Center" = FIELD(Code),
                                                                       "Change Date" = FIELD("Date Filter")));
            CaptionML = ENU = 'Contract Gain/Loss Amount',
                        FRA = 'Montant gain/perte contrat';
            Editable = false;
            FieldClass = FlowField;
        }
        field(106; "Payroll Bank Account"; Code[20])
        {
            CaptionML = ENU = 'Payroll Bank Account',
                        FRA = 'Compte bancaire de paie';
            TableRelation = "Bank Account" WHERE("No." = FIELD("Payroll Bank Account"));
        }
        field(107; "Company Business Unit"; Code[10])
        {
            Caption = 'Direction de société';
            Editable = false;
            TableRelation = "Company Business Unit";
        }
        field(50000; "Employer SS No."; Text[30])
        {
            CaptionML = ENU = 'Employer SS No.',
                        FRA = 'N° SS employeur';
            Description = 'HALRHPAIE';
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

    trigger OnDelete();
    begin
        DimMgt.DeleteDefaultDim(DATABASE::"Company Business Unit", Code);
    end;

    trigger OnInsert();
    begin
        //---01---
        IF NOT ParamUtilisateur.GET(USERID) THEN
            ERROR(Text02);
        IF ParamUtilisateur."Company Business Unit" = '' THEN
            ERROR(Text04);
        "Company Business Unit" := ParamUtilisateur."Company Business Unit";
        //+++01+++
    end;

    var
        PostCode: Record 225;
        DimMgt: Codeunit 408;
        ParamUtilisateur: Record 91;
        Direction: Record 52182429;
        Text02: Label 'Utilisateur %1 non configuré !';
        Text04: Label 'Direction non paramétrée pour l''utilisateur %1 !';

    /// <summary>
    /// ValidateShortcutDimCode.
    /// </summary>
    /// <param name="FieldNumber">Integer.</param>
    /// <param name="ShortcutDimCode">VAR Code[20].</param>
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::"Company Business Unit", Code, FieldNumber, ShortcutDimCode);
        MODIFY;
    end;
}

