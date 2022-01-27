/// <summary>
/// Table Company Business Unit (ID 52182429).
/// </summary>
table 52182429 "Company Business Unit"
//table 39108400 "Company Business Unit"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Company Business Unit',
                FRA = 'Unité de société';
    //DrillDownPageID = 51402;
    //LookupPageID = 51402;

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
        field(12; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            CaptionML = ENU = 'Global Dimension 1 Code',
                        FRA = 'Code axe principal 1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(13; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            CaptionML = ENU = 'Global Dimension 2 Code',
                        FRA = 'Code axe principal 2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(14; "Location Code"; Code[10])
        {
            CaptionML = ENU = 'Location Code',
                        FRA = 'Code magasin';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(15; County; Text[30])
        {
            CaptionML = ENU = 'County',
                        FRA = 'Région';
        }
        field(16; "Current Payroll"; Code[20])
        {
            CaptionML = ENU = 'Current Payroll Code',
                        FRA = 'Paie courante';
            TableRelation = Payroll;
        }
        field(17; "Payroll Journal Template Name"; Code[10])
        {
            CaptionML = ENU = 'Journal Template Name',
                        FRA = 'Nom modèle feuille paie';
            TableRelation = "Gen. Journal Template";
        }
        field(18; "Payroll Journal Batch Name"; Code[10])
        {
            CaptionML = ENU = 'Journal Batch Name',
                        FRA = 'Nom feuille paie';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Payroll Journal Template Name"));
        }
        field(19; "Current Leave Perid"; Code[20])
        {
            CaptionML = ENU = 'Current Payroll Code',
                        FRA = 'Période de congé courante';
            TableRelation = "Leave Period";
        }
        field(20; "Leave Nbre of Days by Month"; Decimal)
        {
            CaptionML = ENU = 'Leave Nbre of Days by Month',
                        FRA = 'Nbre de jours de congé par mois';
            DecimalPlaces = 2 : 15;
        }
        field(21; "Constater la CACOBATPH"; Boolean)
        {
            Caption = 'Constater la CACOBATPH';
        }
        field(22; "Agence CNAS"; Text[30])
        {
        }
        field(23; "Adresse CNAS"; Text[30])
        {
        }
        field(24; "Ville CNAS"; Text[30])
        {
        }
        field(25; "N° CCP CNAS"; Text[30])
        {
        }
        field(26; "N° Cpte Trésor CNAS"; Text[30])
        {
        }
        field(27; "N° Tél. CNAS"; Text[30])
        {
        }
        field(28; "Code Agence CNAS"; Text[30])
        {
        }
        field(29; "Nbre de jours de congé par an"; Integer)
        {
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
        field(50000; "Employer SS No."; Text[30])
        {
            CaptionML = ENU = 'Employer SS No.',
                        FRA = 'N° SS employeur';
        }
        field(50001; "CNAS Center"; Code[5])
        {
            Caption = 'Centre payeur';
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

    var
        PostCode: Record 225;
        DimMgt: Codeunit 408;

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

