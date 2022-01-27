/// <summary>
/// Table Payroll_Setup (ID 52182483).
/// </summary>
table 52182483 "Payroll_Setup" // I add the "_" because there is also Payroll Setup in BC17 his Id is 1660 
//table 39108456 "Payroll Setup"
{
    // version HALRHPAIE.6.2.01

    CaptionML = ENU = 'Payroll Setup',
                FRA = 'Paramètres de paie';

    fields
    {
        field(1; "Clé primaire"; Code[10])
        {
            CaptionML = ENU = 'Primary Key',
                        FRA = 'Clé primaire';
        }
        field(2; "Base Salary"; Text[10])
        {
            CaptionML = ENU = 'Base Salary',
                        FRA = 'Salaire de base';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));

            trigger OnValidate();
            begin
                IF "Base Salary" = '' THEN
                    EXIT;
                PayrollItem.GET("Base Salary");
                PayrollItem.TESTFIELD(PayrollItem.Nature, PayrollItem.Nature::Calculated);
            end;
        }
        field(3; "Post Salary"; Text[10])
        {
            CaptionML = ENU = 'Post Salary',
                        FRA = 'Salaire de poste';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));

            trigger OnValidate();
            begin
                IF "Post Salary" = '' THEN
                    EXIT;
                PayrollItem.GET("Post Salary");
                PayrollItem.TESTFIELD(PayrollItem.Nature, PayrollItem.Nature::Calculated);
            end;
        }
        field(4; "Taxable Salary"; Text[10])
        {
            CaptionML = ENU = 'Taxable Salary',
                        FRA = 'Salaire imposable';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));

            trigger OnValidate();
            begin
                IF "Taxable Salary" = '' THEN
                    EXIT;
                PayrollItem.GET("Taxable Salary");
                PayrollItem.TESTFIELD(PayrollItem.Nature, PayrollItem.Nature::Calculated);
            end;
        }
        field(5; "Net Salary"; Text[10])
        {
            CaptionML = ENU = 'Net Salary',
                        FRA = 'Salaire net';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));

            trigger OnValidate();
            begin
                IF "Net Salary" = '' THEN
                    EXIT;
                PayrollItem.GET("Net Salary");
                PayrollItem.TESTFIELD(PayrollItem.Nature, PayrollItem.Nature::Calculated);
            end;
        }
        field(6; "Employee SS Deduction"; Text[10])
        {
            CaptionML = ENU = 'Social Security Deduction',
                        FRA = 'Retenue SS salarié';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));

            trigger OnValidate();
            begin
                IF "Employee SS Deduction" = '' THEN
                    EXIT;
                PayrollItem.GET("Employee SS Deduction");
                PayrollItem.TESTFIELD(PayrollItem.Nature, PayrollItem.Nature::Calculated);
            end;
        }
        field(7; "TIT Deduction"; Text[10])
        {
            CaptionML = ENU = 'Total Income Tax Deduction',
                        FRA = 'Retenue IRG';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));

            trigger OnValidate();
            begin
                IF "TIT Deduction" = '' THEN
                    EXIT;
                PayrollItem.GET("TIT Deduction");
                PayrollItem.TESTFIELD(PayrollItem.Nature, PayrollItem.Nature::Calculated);
            end;
        }
        field(8; "Employee SS %"; Decimal)
        {
            CaptionML = ENU = 'Employee SS %',
                        FRA = 'Retenue SS salarié %';
        }
        field(9; "SS Basis"; Text[10])
        {
            CaptionML = ENU = 'SS Basis',
                        FRA = 'Base retenue SS';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));

            trigger OnValidate();
            begin
                IF "SS Basis" = '' THEN
                    EXIT;
                PayrollItem.GET("SS Basis");
                PayrollItem.TESTFIELD(PayrollItem.Nature, PayrollItem.Nature::Calculated);
            end;
        }
        field(10; "TIT Basis"; Text[10])
        {
            CaptionML = ENU = 'TIT Basis',
                        FRA = 'Base IRG';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));

            trigger OnValidate();
            begin
                IF "TIT Basis" = '' THEN
                    EXIT;
                PayrollItem.GET("TIT Basis");
                PayrollItem.TESTFIELD(PayrollItem.Nature, PayrollItem.Nature::Calculated);
            end;
        }
        field(11; "Employer Cotisation %"; Decimal)
        {
            CaptionML = ENU = 'Employer Cotisation %',
                        FRA = 'Cotisation employeur %';
        }
        field(12; "Employer Cotisation"; Text[10])
        {
            CaptionML = ENU = 'Employer Cotisation',
                        FRA = 'Cotisation employeur';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));

            trigger OnValidate();
            begin
                IF "Employer Cotisation" = '' THEN
                    EXIT;
                PayrollItem.GET("Employer Cotisation");
                PayrollItem.TESTFIELD(PayrollItem.Nature, PayrollItem.Nature::Calculated);
            end;
        }
        field(13; "Payroll Bank Account"; Code[20])
        {
            CaptionML = ENU = 'Payroll Bank Account',
                        FRA = 'Compte bancaire de paie';
            TableRelation = "Bank Account" WHERE("No." = FIELD("Payroll Bank Account"));
        }
        field(15; "Delete Existing Entries"; Boolean)
        {
            CaptionML = ENU = 'Delete Existing Entries',
                        FRA = 'Supprimer les écritures existantes';
        }
        field(16; "Overtime Filter"; Text[30])
        {
            CaptionML = ENU = 'Overtime Filter',
                        FRA = 'Filtre heures supplémentaires';
        }
        field(17; "No. of Hours By Day"; Integer)
        {
            CaptionML = ENU = 'No. of Hours By Day',
                        FRA = 'Nbre d''heures par jour';
        }
        field(18; "Index Point Value"; Decimal)
        {
            CaptionML = ENU = 'Index Point Value',
                        FRA = 'Valeur du point indiciaire';
        }
        field(19; "No. of Worked Days"; Integer)
        {
            CaptionML = ENU = 'No. of Working Days',
                        FRA = 'Nbre de jours par mois';
        }
        field(20; "Base Salary Without Indemnity"; Text[10])
        {
            CaptionML = ENU = 'Base Salary Without Indemnity',
                        FRA = 'Salaire de base hors indemnités';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));

            trigger OnValidate();
            begin
                IF "Base Salary Without Indemnity" = '' THEN
                    EXIT;
                PayrollItem.GET("Base Salary Without Indemnity");
                PayrollItem.TESTFIELD(PayrollItem.Nature, PayrollItem.Nature::Calculated);
            end;
        }
        field(21; "Advance Deduction"; Text[10])
        {
            CaptionML = ENU = 'Advance Deduction',
                        FRA = 'Retenue avance sur salaire';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));

            trigger OnValidate();
            begin
                IF "Advance Deduction" = '' THEN
                    EXIT;
                PayrollItem.GET("Advance Deduction");
                PayrollItem.TESTFIELD(PayrollItem.Nature, PayrollItem.Nature::Calculated);
            end;
        }
        field(22; "No. of Worked Hours"; Decimal)
        {
            CaptionML = ENU = 'Nbre of Worked Hours',
                        FRA = 'Nbre d''heures par mois';
        }
        field(23; "Union Subscription Deduction"; Text[10])
        {
            CaptionML = ENU = 'Union Subscription Deduction',
                        FRA = 'Retenue souscription mutuelle';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));

            trigger OnValidate();
            begin
                IF "Union Subscription Deduction" = '' THEN
                    EXIT;
                PayrollItem.GET("Union Subscription Deduction");
                PayrollItem.TESTFIELD(PayrollItem.Nature, PayrollItem.Nature::Calculated);
            end;
        }
        field(24; "Overtime Base Unit of Measure"; Code[10])
        {
            CaptionML = ENU = 'Overtime Base Unit of Measure',
                        FRA = 'Unité de base heures supp.';
            TableRelation = "Payroll Unit of Measure";
        }
        field(25; "Medical Reimbursement No."; Code[10])
        {
            CaptionML = ENU = 'Medical Reimbursement No.',
                        FRA = 'N° remboursement médical';
            TableRelation = "No. Series";
        }
        field(26; "Leave Nbre of Days by Month"; Decimal)
        {
            CaptionML = ENU = 'Leave Nbre of Days by Month',
                        FRA = 'Nbre de jours de congé par mois';
        }
        field(27; "Union Rate"; Decimal)
        {
            CaptionML = ENU = 'Union Rate',
                        FRA = 'Taux mutuelle';
        }
        field(28; "Payroll Template No."; Code[10])
        {
            CaptionML = ENU = 'Payroll Template No.',
                        FRA = 'N° modèle de paie';
            TableRelation = "No. Series";
        }
        field(29; "Medical Refund"; Text[10])
        {
            CaptionML = ENU = 'Medical Refund',
                        FRA = 'Remboursement frais médical';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));

            trigger OnValidate();
            begin
                IF "Medical Refund" = '' THEN
                    EXIT;
                PayrollItem.GET("Medical Refund");
                PayrollItem.TESTFIELD(PayrollItem.Nature, PayrollItem.Nature::Calculated);
            end;
        }
        field(30; "Include Minimal Index"; Boolean)
        {
            CaptionML = ENU = 'Include Minimal Index',
                        FRA = 'Inclure indice minimal';
        }
        field(31; "No. of Levels"; Integer)
        {
            CaptionML = ENU = 'No. of Columns',
                        FRA = 'Nbre d''échelons';
            MaxValue = 20;
            MinValue = 1;

            trigger OnValidate();
            begin
                IF "No. of Levels" < 1 THEN
                    ERROR(Text01, FIELDCAPTION("No. of Levels"));
            end;
        }
        field(37; Absences; Boolean)
        {
            CaptionML = ENU = 'Absences',
                        FRA = 'Absences';
        }
        field(38; Advances; Boolean)
        {
            CaptionML = ENU = 'Advances',
                        FRA = 'Avances';
        }
        field(39; Overtime; Boolean)
        {
            CaptionML = ENU = 'Overtime',
                        FRA = 'Heures supplémentaires';
        }
        field(40; "Union/Insurance"; Boolean)
        {
            CaptionML = ENU = 'Union/Insurance',
                        FRA = 'Mutuelle/Assurance';
        }
        field(41; "Medical Refunds"; Boolean)
        {
            CaptionML = ENU = 'Medical Refunds',
                        FRA = 'Remboursements médicaux';
        }
        field(42; "Professional Expances"; Text[20])
        {
            Caption = 'Frais de mission';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));

            trigger OnValidate();
            begin
                IF "Professional Expances" = '' THEN
                    EXIT;
                PayrollItem.GET("Professional Expances");
                PayrollItem.TESTFIELD(PayrollItem.Nature, PayrollItem.Nature::Calculated);
            end;
        }
        field(43; "Professional Expances Refund"; Text[20])
        {
            Caption = 'Remb. frais de mission';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));

            trigger OnValidate();
            begin
                IF "Professional Expances Refund" = '' THEN
                    EXIT;
                PayrollItem.GET("Professional Expances Refund");
                PayrollItem.TESTFIELD(PayrollItem.Nature, PayrollItem.Nature::Calculated);
            end;
        }
        field(44; "Treatment Grid Type"; Option)
        {
            CaptionML = ENU = 'Treatment Grid Type',
                        FRA = 'Type de grille de traitements';
            OptionCaptionML = ENU = 'Sections,Hourly Index',
                              FRA = 'Sections,Indices horaires';
            OptionMembers = Sections,"Hourly Index";

            trigger OnValidate();
            begin
                Salarie.RESET;
                IF Salarie.FINDSET THEN
                    REPEAT
                        Salarie."Treatment Grid Type" := "Treatment Grid Type";
                        Salarie.MODIFY;
                    UNTIL Salarie.NEXT = 0;
            end;
        }
        field(45; "No. of Index"; Integer)
        {
            Caption = 'Nbre d''indices';

            trigger OnValidate();
            begin
                IF "No. of Index" < 1 THEN
                    ERROR(Text01, FIELDCAPTION("No. of Index"));
            end;
        }
        field(46; "Reminder Journal Template Name"; Code[10])
        {
            CaptionML = ENU = 'Journal Template Name',
                        FRA = 'Nom modèle feuille rappel';
            TableRelation = "Gen. Journal Template";
        }
        field(47; "Reminder Journal Batch Name"; Code[10])
        {
            CaptionML = ENU = 'Journal Batch Name',
                        FRA = 'Nom feuille rappel';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Reminder Journal Template Name"));
        }
        field(48; "Limit Leaves to Rights"; Boolean)
        {
            CaptionML = ENU = 'Limit Leaves to Rights',
                        FRA = 'Limiter les congés aux droits';
        }
        field(49; "Apply Index Point Value"; Boolean)
        {
            CaptionML = ENU = 'Apply Index Point Value',
                        FRA = 'Appliquer le point indiciaire';
        }
        field(50; IEP; Code[10])
        {
            Caption = 'IEP';
            TableRelation = "Payroll Item";
        }
        field(51; "TIT Out of Grid %"; Decimal)
        {
            Caption = '% IRG hors barème';
            MaxValue = 100;
            MinValue = 0;
        }
        field(52; "TIT Out of Grid"; Code[10])
        {
            Caption = 'IRG hors barème';
            TableRelation = "Payroll Item";
        }
        field(53; "Deduct Lending From Payroll"; Boolean)
        {
            Caption = 'Retenir le prêt de la paie';
        }
        field(54; "Lending Deduction (Capital)"; Code[10])
        {
            Caption = 'Retenue prêt (capital)';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));
        }
        field(55; "No. of Hours (Hourly Vacatary)"; Code[10])
        {
            Caption = 'Nbre d''heures (vacataire horaire)';
            TableRelation = "Payroll Item";
        }
        field(56; "No. of Days (Daily Vacatary)"; Code[10])
        {
            Caption = 'Nbre de jours (vacataire journalier)';
            TableRelation = "Payroll Item";
        }
        field(57; "Leave TIT"; Code[10])
        {
            Caption = 'IRG congé';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));
        }
        field(58; "Allow TIT Manual Modif."; Boolean)
        {
            Caption = 'Modif. manuelle de l''IRG';
        }
        field(60; "Allow SS Manual Modif."; Boolean)
        {
            Caption = 'Modif. manuelle de la SS employé';
        }
        field(61; "Base oeuvres sociales"; Text[200])
        {
            Caption = 'Base oeuvres sociales';
        }
        field(63; "Taux oeuvres sociales"; Decimal)
        {
            Caption = 'Taux oeuvres sociales';
        }
        field(64; "Taux cotisation patronale"; Decimal)
        {
            Caption = 'Taux cotisation patronale';
        }
        field(65; "Intitule oeuvres sociales 1"; Text[30])
        {
            Caption = 'Intitule oeuvres sociales 1';
        }
        field(66; "Intitule oeuvres sociales 2"; Text[30])
        {
            Caption = 'Intitule oeuvres sociales 2';
        }
        field(67; "Report Payment Method"; Code[10])
        {
            Caption = 'Mode de paiement de l''état de virement';
            TableRelation = "Payment Method";
        }
        field(68; "Brut Salary"; Text[30])
        {
            Caption = 'Salaire Brut';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));
        }
        field(69; "DAIP Taxable Salary"; Text[10])
        {
            CaptionML = ENU = 'Taxable Salary',
                        FRA = 'Salaire imposable DAIP';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));

            trigger OnValidate();
            begin
                IF "Taxable Salary" = '' THEN
                    EXIT;
                PayrollItem.GET("Taxable Salary");
                PayrollItem.TESTFIELD(PayrollItem.Nature, PayrollItem.Nature::Calculated);
            end;
        }
        field(70; "Allow Absence Free Entrance"; Boolean)
        {
            Caption = 'Autoriser libre saisie des absences';
        }
        field(71; "Reminder Nos."; Code[10])
        {
            CaptionML = ENU = 'Medical Reimbursement No.',
                        FRA = 'N° rappel';
            TableRelation = "No. Series";
        }
        field(72; "TIT merged"; Boolean)
        {
            Caption = 'IRG groupé';
        }
        field(73; "Allow Payroll Manual Adjust."; Boolean)
        {
            Caption = 'Autoriser ajustement manuel de la paie';
        }
        field(74; "Base cotisation patronale"; Text[200])
        {
        }
        field(75; "Leave Cause of Absence"; Code[10])
        {
            Caption = 'Motif d''absence pour congé';
            TableRelation = "Cause of Absence";
        }
        field(76; "Cpte oeuvres sociales (débit)"; Text[20])
        {
            Caption = 'Cpte oeuvres sociales (débit)';
            TableRelation = "G/L Account";
        }
        field(77; "Cpte oeuvres sociales (crédit)"; Text[20])
        {
            Caption = 'Cpte oeuvres sociales (crédit)';
            TableRelation = "G/L Account";
        }
        field(78; "Cpte 1 cotis. patron. (débit)"; Text[20])
        {
            Caption = 'Cpte 1 cotis. patron. (débit)';
            TableRelation = "G/L Account";
        }
        field(79; "Cpte 2 cotis. patron. (débit)"; Text[30])
        {
            Caption = 'Cpte 2 cotis. patron. (débit)';
            TableRelation = "G/L Account";
        }
        field(80; "Cpte cotis.patronales (crédit)"; Text[20])
        {
            Caption = 'Cpte cotis.patronales (crédit)';
            TableRelation = "G/L Account";
        }
        field(81; "Cpte taxe form. appr. (débit)"; Text[30])
        {
            Caption = 'Cpte taxe form. appr. (débit)';
            TableRelation = "G/L Account";
        }
        field(82; "Cpte taxe form. appr. (crédit)"; Text[30])
        {
            Caption = 'Cpte taxe form. appr. (crédit)';
            TableRelation = "G/L Account";
        }
        field(83; "Base taxe formation"; Text[200])
        {
            Caption = 'Base taxe formation';
        }
        field(84; "Taux taxe formation"; Decimal)
        {
            Caption = 'Taux taxe formation';
        }
        field(85; "Absence Unit of Measure"; Option)
        {
            CaptionML = ENU = 'Unit of Measure',
                        FRA = 'Unité de mesure absence';
            OptionCaptionML = ENU = 'Day,Hour',
                              FRA = 'Jour,Heure';
            OptionMembers = Day,Hour;
        }
        field(86; "TIT Filter"; Text[200])
        {
            CaptionML = ENU = 'Overtime Filter',
                        FRA = 'Filtre IRG';
        }
        field(87; "Compta. les charges patronales"; Boolean)
        {
            Caption = 'Compta. les charges patronales';
        }
        field(88; "Maximal IEP"; Decimal)
        {
            Caption = 'IEP maximal';
        }
        field(89; "Show Post Salary Basis"; Boolean)
        {
            Caption = 'Tarif journalier du salaire de base';
        }
        field(90; "Base CAC. salarié"; Text[200])
        {
            Caption = 'Base CAC. salarié';
        }
        field(91; "Taux CAC. salarié"; Decimal)
        {
            Caption = 'Taux CAC. salarié';
            DecimalPlaces = 2 : 3;
        }
        field(92; "CAC. salarié (crédit)"; Text[10])
        {
            Caption = 'CAC. salarié (crédit)';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));
        }
        field(93; "Base CAC. employeur"; Text[200])
        {
            Caption = 'Base CAC. employeur';
        }
        field(94; "Taux CAC. employeur"; Decimal)
        {
            Caption = 'Taux CAC. employeur';
            DecimalPlaces = 2 : 3;
        }
        field(95; "CAC. employeur (crédit)"; Text[10])
        {
            Caption = 'CAC. employeur (crédit)';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));
        }
        field(96; "Base CAC. intempérie"; Text[200])
        {
            Caption = 'Base CAC. intempérie';
        }
        field(97; "Taux CAC. intempérie"; Decimal)
        {
            Caption = 'Taux CAC. intempérie';
            DecimalPlaces = 2 : 3;
        }
        field(98; "CAC. intempérie (crédit)"; Text[10])
        {
            Caption = 'CAC. intempérie (crédit)';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));
        }
        field(99; "Cpte CAC. cotisation (débit)"; Text[30])
        {
            Caption = 'Cpte CAC. cotisation (débit)';
            TableRelation = "G/L Account";
        }
        field(100; "Cpte CAC. intempérie (débit)"; Text[30])
        {
            Caption = 'Cpte CAC. intempérie (débit)';
            TableRelation = "G/L Account";
        }
        field(101; "Constater les oeuvres sociales"; Boolean)
        {
            Caption = 'Constater les oeuvres sociales';
        }
        field(102; "Constater la part patronale"; Boolean)
        {
            Caption = 'Constater la part patronale';
        }
        field(103; "Constater les taxes formation"; Boolean)
        {
            Caption = 'Constater les taxes formation';
        }
        field(104; "Family Allowance Filter"; Text[30])
        {
            CaptionML = ENU = 'Overtime Filter',
                        FRA = 'Filtre allocations familiales';
            Description = 'CGMP - Annexe 11';
        }
        field(105; "Taxable Deduction Filter"; Text[250])
        {
            Caption = 'Filtre des rubriques non imposables';
        }
        field(106; "Year Separated Leave Indemnity"; Boolean)
        {
            Caption = 'Indemnité de congé par exercices';
        }
        field(107; "Do Not Generate Blank TIT"; Boolean)
        {
            Caption = 'Ne pas générer d''IRG nul';
        }
        field(108; "Limite page état de virement"; Decimal)
        {
            Caption = 'Limite page état de virement';
        }
        field(109; "Leave days by year"; Decimal)
        {
            Caption = 'Jours congé par An';
        }
        field(110; "Payroll Journal Template Name"; Code[10])
        {
            CaptionML = ENU = 'Journal Template Name',
                        FRA = 'Nom modèle feuille paie';
            TableRelation = "Gen. Journal Template";
        }
        field(111; "Payroll Journal Batch Name"; Code[10])
        {
            CaptionML = ENU = 'Journal Batch Name',
                        FRA = 'Nom feuille paie';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Payroll Journal Template Name"));
        }
        field(112; "Accident cause of absence"; Code[10])
        {
            Caption = 'Motif d''absence pour Accident de travail';
            TableRelation = "Cause of Absence";
        }
        field(113; "Include leave days"; Boolean)
        {
            Caption = 'Inclure jours absence congé';
        }
        field(114; "Indemnité de transport"; Text[10])
        {
            Caption = 'Indemnité de transport';
        }
        field(115; "Prime de Panier"; Text[10])
        {
            Caption = 'Prime de Panier';
        }
        field(116; "Cotisation employeur cacobatph"; Decimal)
        {
            Caption = 'Cotisation employeur cacobatph %';
        }
        field(117; "Cotisation employeur pretbath"; Decimal)
        {
            Caption = 'Cotisation employeur pretbath %';
        }
        field(118; "Employer Cotisation Cacobaptph"; Text[10])
        {
            Caption = 'Cotisation employeur cacobatph';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));
        }
        field(119; "Employer Cotisation pretbath"; Text[10])
        {
            Caption = 'Employer Cotisation pretbath';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));
        }
        field(120; "Inclure Cacobatph"; Boolean)
        {
            Caption = 'Inclure Cacobatph';
        }
    }

    keys
    {
        key(Key1; "Clé primaire")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PayrollItem: Record 52182481;
        Salarie: Record 5200;
        Text01: Label '%1 doit être positif !';
}

