/// <summary>
/// Table Payroll Item (ID 52182481).
/// </summary>
table 52182481 "Payroll Item"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Payroll Item',
                FRA = 'Rubrique de paie';
    //LookupPageID = 51552;

    fields
    {
        field(1; Code; Text[20])
        {
            CaptionML = ENU = 'Code',
                        FRA = 'Code';
            NotBlank = true;

            trigger OnValidate();
            begin
                //CheckOptions;
            end;
        }
        field(2; Description; Text[50])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
        }
        field(3; Nature; Option)
        {
            CaptionML = ENU = 'Nature',
                        FRA = 'Nature';
            OptionCaptionML = ENU = 'Gain,Deduction,Calculated',
                              FRA = 'Gain,Retenue,Calculée';
            OptionMembers = Gain,Deduction,Calculated;

            trigger OnValidate();
            begin
                IF Nature = Nature::Calculated THEN
                    VALIDATE("Item Type", "Item Type"::Formule);
                //CheckOptions;
            end;
        }
        field(4; "Item Type"; Option)
        {
            CaptionML = ENU = 'Type',
                        FRA = 'Type';
            OptionCaption = 'Libre saisie,Formule,Pourcentage,Au prorata,Au prorata autorisé';
            OptionMembers = "Libre saisie",Formule,Pourcentage,"Au prorata","Au prorata autorisé";

            trigger OnValidate();
            begin
                IF "Item Type" = "Item Type"::Formule THEN BEGIN
                    "Basis of Calculation" := '';
                    "Calculation Rate" := 0;
                END;
                IF "Item Type" = "Item Type"::"Libre saisie" THEN BEGIN
                    "Basis of Calculation" := '';
                    "Calculation Rate" := 0;
                    "Calculation Formula" := '';
                END;
                IF "Item Type" = "Item Type"::Pourcentage THEN
                    "Calculation Formula" := '';
            end;
        }
        field(5; "Basis of Calculation"; Code[20])
        {
            CaptionML = ENU = 'Basis of Calculation',
                        FRA = 'Base de calcul';
            TableRelation = "Payroll Item".Code;

            trigger OnValidate();
            begin
                IF "Basis of Calculation" = '' THEN
                    EXIT;
                IF ("Item Type" <> "Item Type"::Pourcentage) AND ("Item Type" <> "Item Type"::"Au prorata autorisé") THEN
                    ERROR('Le champ [Base de Calcul] ne peut pas être renseigné quand le type est [%1].', "Item Type");
            end;
        }
        field(6; "Ignored When Reminder"; Boolean)
        {
            Caption = 'Ignorée lors du rappel';
        }
        field(7; Taxable; Boolean)
        {
            CaptionML = ENU = 'Taxable',
                        FRA = 'Imposable';
            Editable = true;
            Enabled = true;
            /*trigger OnValidate();
            begin
                RubriqueSalarie.RESET;
                //RubriqueSalarie.SETRANGE("Item Code", Code);
                IF RubriqueSalarie.FINDFIRST THEN BEGIN
                    RubriqueSalarie.MODIFYALL(Taxable, Taxable);
                    MESSAGE(Text002);
                END;
            end;*/
        }
        field(8; "Calculation Rate"; Decimal)
        {
            CaptionML = ENU = 'Calculation Rate',
                        FRA = 'Taux de calcul';

            trigger OnValidate();
            begin
                IF "Calculation Rate" = 0 THEN
                    EXIT;
                IF "Item Type" <> "Item Type"::Pourcentage THEN
                    ERROR('Le champ [Taux de Calcul] ne peut pas être renseigné quand le type est [%1].', "Item Type");
            end;
        }
        field(9; "Calculation Formula"; Text[250])
        {
            CaptionML = ENU = 'Calculation Formula',
                        FRA = 'Formule de calcul';
            CharAllowed = '09||..';

            trigger OnValidate();
            begin
                IF "Calculation Formula" = '' THEN
                    EXIT;
                IF "Item Type" <> "Item Type"::Formule THEN
                    ERROR('Le champ [Formule de Calcul] ne peut pas être renseigné quand le type est [%1].', "Item Type");
            end;
        }
        field(10; Balance; Decimal)
        {
            CalcFormula = Sum("Payroll Entry".Amount WHERE("Item Code" = FIELD(Code)));
            CaptionML = ENU = 'Balance',
                        FRA = 'Solde';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Net Change"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Payroll Entry".Amount WHERE("Document No." = FIELD("Payroll Filter"),
                                                            "Item Code" = FIELD(Code),
                                                            "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                            "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                            "Document Date" = FIELD("Date Filter")));
            CaptionML = ENU = 'Net Change',
                        FRA = 'Solde période';
            Editable = false;

        }
        field(12; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            CaptionML = ENU = 'Global Dimension 1 Filter',
                        FRA = 'Filtre axe principal 1';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(13; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            CaptionML = ENU = 'Global Dimension 2 Filter',
                        FRA = 'Filtre axe principal 2';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(14; "Payroll Filter"; Code[20])
        {
            CaptionML = ENU = 'Payroll Filter',
                        FRA = 'Filtre paie';
            FieldClass = FlowFilter;
            //TableRelation = Payroll;
        }
        field(15; "Date Filter"; Date)
        {
            CaptionML = ENU = 'Date Filter',
                        FRA = 'Filtre date';
            FieldClass = FlowFilter;
        }
        field(16; Category; Option)
        {
            CaptionML = ENU = 'Category',
                        FRA = 'Catégorie';
            OptionCaptionML = ENU = 'Employee,Employer',
                              FRA = 'Salarié,Employeur';
            OptionMembers = Employee,Employer;
        }
        field(17; "Account No."; Code[20])
        {
            CaptionML = ENU = 'Account No.',
                        FRA = 'N° compte';
            TableRelation = "G/L Account";
        }
        field(18; "Bal. Account No."; Code[20])
        {
            CaptionML = ENU = 'Bal. Account No.',
                        FRA = 'N° compte contrepartie';
            TableRelation = "G/L Account";
        }
        field(19; Tarification; Decimal)
        {
            Caption = 'Tarif';
        }
        field(20; "Submitted To Leave"; Boolean)
        {
            Caption = 'Soumise à congé';

            /*trigger OnValidate();
            begin
                RubriqueSalarie.RESET;
                //RubriqueSalarie.SETRANGE("Item Code", Code);
                IF RubriqueSalarie.FINDFIRST THEN BEGIN
                    RubriqueSalarie.MODIFYALL("Submitted To Leave", "Submitted To Leave");
                    MESSAGE(Text002);
                END;
            end;*/
        }
        field(21; "TIT Out of Grid"; Boolean)
        {
            Caption = 'IRG hors barème';

            /*trigger OnValidate();
            begin
                //Element 25 Début
                RubriqueSalarie.RESET;
                //RubriqueSalarie.SETRANGE("Item Code", Code);
                IF RubriqueSalarie.FINDFIRST THEN BEGIN
                    RubriqueSalarie.MODIFYALL("TIT Out of Grid", "TIT Out of Grid");
                    MESSAGE(Text002);
                END;
                //Element 25 Fin
            end;*/
        }
        field(22; Variable; Boolean)
        {
            Caption = 'Variable';
        }
        field(24; Blocked; Option)
        {
            CaptionML = ENU = 'Blocked',
                        FRA = 'Bloqué';
            OptionCaptionML = ENU = ' ,Display,Use,All',
                              FRA = ' ,Affichage,Utilisation,Tous';
            OptionMembers = "None",Display,Use,All;
        }
        field(25; Regularization; Boolean)
        {
            CaptionML = ENU = 'Taxable',
                        FRA = 'Régularisation';

            /*trigger OnValidate();
            begin
                RubriqueSalarie.RESET;
                //RubriqueSalarie.SETRANGE("Item Code", Code);
                IF RubriqueSalarie.FINDFIRST THEN BEGIN
                    RubriqueSalarie.MODIFYALL(Regularization, Regularization);
                    MESSAGE(Text002);
                END;
                IF Regularization THEN BEGIN
                    "Reminder +" := '';
                    "Reminder -" := '';
                END;
            end;*/
        }
        field(26; "Reminder +"; Code[20])
        {
            Caption = 'R+';
            TableRelation = IF (Regularization = CONST(false)) "Payroll Item".Code WHERE(Regularization = CONST(true));
        }
        field(27; "Reminder -"; Code[20])
        {
            Caption = 'R-';
            TableRelation = IF (Regularization = CONST(false)) "Payroll Item".Code WHERE(Regularization = CONST(true));
        }
        field(28; "Non Cotisable et Imposable"; Boolean)
        {
            Caption = 'Non Cotisable et Imposable';
            Description = 'Pour la masse salariale';
        }
        field(29; "Non Cotisable Non Imposable"; Boolean)
        {
            Caption = 'Non Cotisable Non Imposable';
            Description = 'Pour la masse salariale';
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

    /*trigger OnDelete();
    begin
        EXIT;
        EmployeePayrollItem.SETRANGE("Item Code", Code);
        IF EmployeePayrollItem.FIND('-') THEN
            ERROR(Text001, Code, 'des rubriques salarié');
        PayrollEntry.SETRANGE("Item Code", Code);
        IF PayrollEntry.FIND('-') THEN
            ERROR(Text001, Code, 'des écritures de paie');
        PayrollSetup.GET;
        IF (Code = PayrollSetup."Base Salary")
        OR (Code = PayrollSetup."Post Salary")
        OR (Code = PayrollSetup."Taxable Salary")
        OR (Code = PayrollSetup."Net Salary") THEN
            ERROR(Text001, Code, 'des paramètres de paie');
    end;*/

    trigger OnInsert();
    begin
        //CheckOptions;
    end;

    trigger OnModify();
    begin
        ValidateFormula;
    end;

    var
        Rubrique: Record 52182481;
        Chn1: Text[250];
        Chn2: Text[10];
        Debut: Integer;
        Taille: Integer;
        Position: Integer;
        Arret: Boolean;
        i: Integer;
        PayrollSetup: Record 52182483;
        //EmployeePayrollItem: Record 51455;
        //PayrollEntry: Record 51622;
        Text001: Label 'Suppression impossible de la rubrique %1 car elle est utilisée dans la table %2 .';
        //RubriqueSalarie: Record 51455;
        Text002: Label 'Rubrique actuellement utilisée.\Relancer le calcul de la paie.';

    /// <summary>
    /// ValidateFormula.
    /// </summary>
    procedure ValidateFormula();
    begin
        EXIT;
        IF "Calculation Formula" = '' THEN
            EXIT;
        Chn1 := "Calculation Formula";
        /*Contrôle du format de la formule*/
        IF (Chn1[1] = '|') OR (Chn1[STRLEN(Chn1)] = '|') THEN BEGIN
            ERROR('Rubrique calculée %1\Formule de calcul erronée !', Code);
            EXIT;
        END;
        Arret := FALSE;
        i := 1;
        REPEAT
            i := i + 1;
            IF i > STRLEN(Chn1) THEN
                Arret := TRUE
            ELSE
                IF (Chn1[i] = '|') AND (Chn1[i - 1] = '|') THEN
                    Arret := TRUE;
        UNTIL Arret;
        IF i < STRLEN(Chn1) THEN BEGIN
            ERROR('Rubrique calculée %1\Formule de calcul erronée !', Code);
            EXIT;
        END;
        /*Contrôle des rubriques*/
        Debut := 1;
        Arret := FALSE;
        Rubrique.RESET;
        REPEAT
            Position := STRPOS(COPYSTR(Chn1, Debut, STRLEN(Chn1)), '|');
            IF Position = 0 THEN
                Position := STRLEN(Chn1) + 1;
            Chn2 := COPYSTR(Chn1, Debut, Position - 1);
            IF Rubrique.GET(Chn2) THEN BEGIN
                Debut := Debut + Position;
                IF Position = STRLEN(Chn1) + 1 THEN
                    Arret := TRUE;
            END
            ELSE
                Arret := TRUE;
        UNTIL Arret;
        IF Debut < STRLEN(Chn1) + 1 THEN
            ERROR('Rubrique calculée %1\Formule de calcul erronée ! Rubrique %2 inexistante.',
            Code, Chn2);

    end;

    /// <summary>
    /// CheckOptions.
    /// </summary>
    /*procedure CheckOptions();
    begin

        PayrollSetup.GET;
        IF Nature = Nature::Deduction THEN BEGIN
            Contributory := FALSE;
            Regularisation := FALSE;
            EXIT;
        END;
        IF Nature = Nature::Calculated THEN BEGIN
            Contributory := FALSE;
            Regularisation := FALSE;
            EXIT;
        END;
        IF (PayrollSetup."Post Salary" = '') OR (PayrollSetup."Taxable Salary" = '') THEN
            EXIT;
        IF Code <= PayrollSetup."Post Salary" THEN BEGIN
            IF Nature = Nature::Gain THEN BEGIN
                Contributory := TRUE;
                Regularisation := TRUE;
            END;
        END
        ELSE
            IF Code <= PayrollSetup."Taxable Salary" THEN BEGIN
                IF Nature = Nature::Gain THEN BEGIN
                    Contributory := FALSE;
                    Regularisation := TRUE;
                END;
            END
            ELSE BEGIN
                IF Nature = Nature::Gain THEN BEGIN
                    Contributory := FALSE;
                    Regularisation := FALSE;
                END;
            END;


    end;*/
}

