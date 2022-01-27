/// <summary>
/// Page Employee Payroll Items (ID 52182525).
/// </summary>
page 52182525 "Employee Payroll Items"
{
    // version HALRHPAIE.6.1.07

    // ##########################################################################################################
    // CodeModif|Sté     |date modif |Nom   | description des devs spec
    // ##########################################################################################################
    // 001MK    |Soum    |20/02/2012 |MK    |Statut de la paie
    // ----------------------------------------------------------------------------------------------------------

    CaptionML = ENU = 'Employee Payroll Items',
                FRA = 'Saisie des rubriques salarié';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = Card;
    SourceTable = 5200;

    layout
    {
        area(content)
        {
            group("Général")
            {
                Caption = 'Général';
                Editable = true;
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("First Name"; "First Name")
                {
                    Editable = false;
                }
                field("Last Name"; "Last Name")
                {
                    Editable = false;
                }
                field("Middle Name"; "Middle Name")
                {
                    Editable = false;
                }
                field("Payroll Type Code"; "Payroll Type Code")
                {
                }
                field("Payroll Template No."; "Payroll Template No.")
                {

                    trigger OnValidate();
                    begin
                        PayrollTemplateNoOnAfterValida;
                    end;
                }
                field(Observation; Observation)
                {
                    MultiLine = true;
                }
                field("STC Payroll"; "STC Payroll")
                {
                }
                field("Regime IRG"; "Regime IRG")
                {
                }
                field("Grand Sud"; "Grand Sud")
                {
                }
                field(DatePaie; DatePaie)
                {
                    CaptionML = ENU = 'Date Filter',
                                FRA = 'Filtre Date';
                    Editable = false;
                }
                field(StatutPay; StatutPay)
                {
                    Caption = 'Statut';
                    Editable = false;
                }
                field("Total Absences Days"; "Total Absences Days")
                {
                }
                field(UserPay; UserPay)
                {
                    Caption = 'User';
                    Editable = false;
                    Style = Unfavorable;
                }
                field("Total Absences Hours"; "Total Absences Hours")
                {
                }
                field("Total Advance"; "Total Advance")
                {
                }
                field("Total Overtime (Base)"; "Total Overtime (Base)")
                {
                }
                field("Total Medical Refund"; "Total Medical Refund")
                {
                }
                field("Total Professional Expances"; "Total Professional Expances")
                {
                }
                field("Total Profess. Expances Refund"; "Total Profess. Expances Refund")
                {
                }
            }
            part("Employee Payroll Items Subform"; 52182526)
            {
                SubPageLink = "Employee No." = FIELD("No.");
            }
            group(Administration)
            {
                Caption = 'Administration';
                Editable = true;
                field("Job Title"; "Job Title")
                {
                    Editable = false;
                }
                field("Structure Description"; "Structure Description")
                {
                    Editable = false;
                }
                field("Socio-Professional Category"; "Socio-Professional Category")
                {
                    Editable = false;
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("Company Business Unit Code"; "Company Business Unit Code")
                {
                    Editable = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Statistics Group Code"; "Statistics Group Code")
                {
                }
                field("Leave Indemnity Amount"; "Leave Indemnity Amount")
                {
                    Caption = 'Indemnité de congé (mnt)';
                    Editable = false;
                }
                field("Leave Indemnity No."; "Leave Indemnity No.")
                {
                    Editable = false;
                }
                group("Section grid : ")
                {
                    CaptionML = ENU = 'Section grid : ',
                                FRA = 'Grille par sections : ';
                    field(ClassSections; "Section Grid Class")
                    {
                        Editable = false;
                    }
                    field(SectionSections; "Section Grid Section")
                    {
                        Editable = false;
                    }
                    field(LevelSections; "Section Grid Level")
                    {
                        Editable = false;
                    }
                }
                group("Hourly Index Grid")
                {
                    CaptionML = ENU = 'Hourly Index Grid',
                                FRA = 'Grille par indices horaires : ';
                    field("Hourly Index Grid Function No."; "Hourly Index Grid Function No.")
                    {
                        Editable = false;
                    }
                    field("Hourly Index Grid Function"; "Hourly Index Grid Function")
                    {
                        Editable = false;
                    }
                    field("Hourly Index Grid CH"; "Hourly Index Grid CH")
                    {
                        Editable = false;
                    }
                    field("Hourly Index Grid Index"; "Hourly Index Grid Index")
                    {
                        Editable = false;
                    }
                }
                field("Base salary"; "Base salary")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("E&mployee")
            {
                CaptionML = ENU = 'E&mployee',
                            FRA = '&Salarié';
                Image = GeneralLedger;
                action(Fiche)
                {
                    Caption = 'Fiche';
                    Image = Card;
                    RunObject = Page 5201;
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+F5';
                }
                action(Dimensions)
                {
                    CaptionML = ENU = 'Dimensions',
                                FRA = 'A&xes analytiques';
                    Image = Dimensions;
                    RunObject = Page 540;
                    RunPageLink = "Table ID" = CONST(5200),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }

                action("A&bsences")
                {
                    CaptionML = ENU = 'A&bsences',
                                FRA = 'A&bsences';
                    Image = Absence;
                    RunObject = Page 5212;
                    RunPageLink = "Employee No." = FIELD("No."),
                                  "From Date" = FIELD("Date Filter");
                    ShortCutKey = 'Shift+Ctrl+B';
                }
                action("&Misconducts")
                {
                    CaptionML = ENU = '&Misconducts',
                                FRA = 'C&ongés';
                    Image = Holiday;
                    RunObject = Page 52182550;
                    RunPageLink = "Employee No." = FIELD("No."),
                                  "Starting Date" = FIELD("Date Filter"),
                                  "Ending Date" = FIELD("Date Filter");
                    ShortCutKey = 'Shift+Ctrl+C';
                }

                action("A&dvances")
                {
                    CaptionML = ENU = 'A&dvances',
                                FRA = 'Av&ances';
                    Image = Prepayment;
                    RunObject = Page 52182561;
                    RunPageLink = "Employee No." = FIELD("No."),
                                  "Advance Date" = FIELD("Date Filter");
                    ShortCutKey = 'Shift+Ctrl+V';
                }
                action("&Overtime")
                {
                    CaptionML = ENU = '&Overtime',
                                FRA = '&Heures supp.';
                    Image = ServiceHours;
                    RunObject = Page 52182543;
                    RunPageLink = "Employee No." = FIELD("No."),
                                  "Overtime Date" = FIELD("Date Filter");
                    ShortCutKey = 'Shift+Ctrl+H';
                }

                action("F&rais de mission")
                {
                    CaptionML = FRA = 'F&rais de mission',
                                FRS = 'Versements des cotisations AF';
                    Image = ProjectExpense;
                    RunObject = Page 52182560;
                    RunPageLink = "Employee No." = FIELD("No."),
                                  "Deduction Payroll Code" = CONST();
                    ShortCutKey = 'Shift+Ctrl+F';
                }
                action("M&utuelle")
                {
                    CaptionML = FRA = 'M&utuelle',
                                FRS = 'Versements des cotisations mutuelle';
                    Image = InsuranceRegisters;
                    RunObject = Page "Union/Insur. Subs.Registration";
                    RunPageLink = "Employee No." = FIELD("No."),
                                  "Starting Date" = FIELD("Date Filter"),
                                  "Ending Date" = FIELD("Date Filter");
                    ShortCutKey = 'Shift+Ctrl+M';
                }
                action("P&rêt")
                {
                    Caption = 'P&rêt';
                    Image = Prepayment;
                    RunObject = Page 52182575;
                    RunPageLink = "Employee No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+P';
                }
            }
            group("&Functins")
            {
                CaptionML = ENU = '&Functins',
                            FRA = '&Fonctions';
                Image = Job;
                action(Dimensions1)
                {
                    CaptionML = ENU = 'Dimensions',
                                FRA = '&Calculer la paie';
                    Image = Dimensions;
                    ShortCutKey = 'F9';

                    trigger OnAction();
                    begin
                        //001MK*****************************
                        StatutPay := 'Calculé';
                        UserPay := USERID;
                        MODIFY;
                        //001MK*****************************
                        GestionPaie.ControlerParametres("No.");
                        GestionPaie.CalcPaieSalarie("No.");
                    end;
                }

                action("Attribuer l'indemnité de congé")
                {
                    Caption = 'Attribuer l''indemnité de congé';
                    Image = Holiday;
                    RunObject = Page 52182584;
                    RunPageLink = "No." = FIELD("No.");
                }

                action("Générer le STC")
                {
                    Caption = 'Générer le STC';
                    Image = Stop;

                    trigger OnAction();
                    begin
                        ParamPaie.GET;
                        Salarie.GET("No.");
                        //***Génération de la rubrique de STC***
                        RubriqueSalarie.RESET;
                        RubriqueSalarie.SETRANGE("Employee No.", "No.");
                        RubriqueSalarie.SETRANGE("Item Code", '222');
                        IF RubriqueSalarie.FINDFIRST THEN
                            RubriqueSalarie.DELETE;
                        GestionPaie.ControlerParametres("No.");
                        GestionPaie.CalcPaieSalarie("No.");
                        Salarie.CALCFIELDS("Total Leave Indem. Amount");
                        Salarie.CALCFIELDS("Total Leave Indem. No.");
                        //***Indemnité***
                        RubriqueSalarie.INIT;
                        RubriqueSalarie."Employee No." := "No.";
                        RubriqueSalarie."Item Code" := '222';
                        Rubrique.GET('222');
                        CongeMontant := Salarie."Total Leave Indem. Amount" + Salarie."Leave Indemnity Amount";
                        CongeNbreJours := Salarie."Total Leave Indem. No." + Salarie."Leave Indemnity No.";
                        RubriqueSalarie."Item Description" := Rubrique.Description;
                        RubriqueSalarie.Basis := CongeMontant / CongeNbreJours;
                        RubriqueSalarie.Number := CongeNbreJours;
                        RubriqueSalarie.Amount := CongeMontant;
                        RubriqueSalarie.Type := Rubrique."Item Type";
                        RubriqueSalarie.INSERT;
                        Salarie.GET("No.");
                        Salarie."STC Payroll" := TRUE;
                        Salarie.MODIFY;
                    end;
                }
                action("Générer le STC Global")
                {
                    Caption = 'Générer le STC Global';
                    Image = DepositSlip;

                    trigger OnAction();
                    begin
                        ParamPaie.GET;
                        //Salarie.GET("No.");
                        Salarie.RESET;
                        Salarie.SETRANGE(Status, Status::Active);
                        IF Salarie.FINDFIRST THEN
                            REPEAT
                                //***Génération de la rubrique de STC***
                                RubriqueSalarie.RESET;
                                RubriqueSalarie.SETRANGE("Employee No.", Salarie."No.");
                                RubriqueSalarie.SETRANGE("Item Code", '222');
                                IF RubriqueSalarie.FINDFIRST THEN
                                    RubriqueSalarie.DELETE;
                                GestionPaie.ControlerParametres(Salarie."No.");
                                GestionPaie.CalcPaieSalarie(Salarie."No.");
                                Salarie.CALCFIELDS("Total Leave Indem. Amount");
                                Salarie.CALCFIELDS("Total Leave Indem. No.");
                                //***Indemnité***
                                RubriqueSalarie.INIT;
                                RubriqueSalarie."Employee No." := Salarie."No.";
                                RubriqueSalarie."Item Code" := '222';
                                Rubrique.GET('222');
                                CongeMontant := Salarie."Total Leave Indem. Amount" + Salarie."Leave Indemnity Amount";
                                CongeNbreJours := Salarie."Total Leave Indem. No." + Salarie."Leave Indemnity No.";
                                RubriqueSalarie."Item Description" := Rubrique.Description;
                                RubriqueSalarie.Basis := CongeMontant / CongeNbreJours;
                                RubriqueSalarie.Number := CongeNbreJours;
                                RubriqueSalarie.Amount := CongeMontant;
                                RubriqueSalarie.Type := Rubrique."Item Type";
                                RubriqueSalarie.INSERT;
                                Salarie.GET("No.");
                                Salarie."STC Payroll" := TRUE;
                                Salarie.MODIFY;
                            UNTIL Salarie.NEXT = 0;
                    end;
                }
                action("Annuler le STC")
                {
                    Caption = 'Annuler le STC';
                    Image = Delete;

                    trigger OnAction();
                    begin
                        ParamPaie.GET;
                        Salarie.GET("No.");



                        Salarie."STC Payroll" := FALSE;
                        Salarie.MODIFY;
                    end;
                }
                action("Annuler simulation")
                {
                    Caption = 'Annuler simulation';
                    Image = Delete;

                    trigger OnAction();
                    begin
                        Salarie.RESET;
                        Salarie.FINDFIRST;
                        REPEAT
                            Salarie.StatutPay := '';
                            Salarie.UserPay := '';
                            Salarie.MODIFY;
                        UNTIL Salarie.NEXT = 0;
                    end;
                }
                action("Générer Paie de référence")
                {
                    Caption = 'Générer Paie de référence';
                    Image = DepositSlip;

                    trigger OnAction();
                    begin
                        ParamPaie.GET;
                        TermsPay.RESET;
                        TermsPay.SETRANGE("Employee No.", "No.");
                        TermsPay.DELETEALL;
                        RubriqueSalarie.RESET;
                        RubriqueSalarie.SETRANGE("Employee No.", "No.");
                        RubriqueSalarie.SETFILTER(Type, '<>%1', 1);
                        IF RubriqueSalarie.FINDFIRST THEN
                            REPEAT
                                TermsPay.INIT;
                                TermsPay."Employee No." := RubriqueSalarie."Employee No.";
                                TermsPay.Description := RubriqueSalarie."Item Description";
                                TermsPay."Item Code" := RubriqueSalarie."Item Code";
                                TermsPay.Amount := RubriqueSalarie.Amount;
                                TermsPay.INSERT;
                            UNTIL RubriqueSalarie.NEXT = 0;


                        MESSAGE('TRAITEMENT TERMINE');
                    end;
                }
            }
        }
    }

    trigger OnOpenPage();
    begin


        PayrollManager.RESET;
        ParamRH.GET;
        PayrollManager.SETRANGE("User ID", USERID);
        IF NOT PayrollManager.FINDSET THEN
            ERROR(Text09, USERID);
        IF PayrollManager."Company Business Unit Code" = '' THEN
            ERROR(Text08, USERID);
        CompanyBusinessUnit.GET(PayrollManager."Company Business Unit Code");
        CompanyBusinessUnit.TESTFIELD("Current Payroll");
        CodeDirection := CompanyBusinessUnit.Code;
        CodePaie := CompanyBusinessUnit."Current Payroll";
        Payroll.GET(CodePaie);
        RESET;
        FILTERGROUP(6);
        SETRANGE("Company Business Unit Code", PayrollManager."Company Business Unit Code");
        IF ParamRH."Show Only Active Employees" THEN
            SETRANGE(Status, Status::Active);
        FILTERGROUP(0);
        SETFILTER("Date Filter", '%1..%2', Payroll."Starting Date", Payroll."Ending Date");
        DatePaie := FORMAT(Payroll."Starting Date") + '..' + FORMAT(Payroll."Ending Date");
    end;

    var
        RubriqueSalarie: Record "Employee Payroll Item";
        ParamPaie: Record Payroll_Setup;
        Text01: Label 'Rubrique "retenue jours d''absences" déjà existante !';
        Rubrique: Record "Payroll Item";
        Text02: Label 'Rubrique "salaire de base" manquante !';
        BaseSalary: Decimal;
        Text03: Label 'Rubrique "retenue avance sur salaire" déjà existante !';
        Text04: Label 'Aucune absence n''est enregistrée pour la période %1 !';
        Text05: Label 'Aucune avance sur salaire n''est enregistrée pour la période %1 !';
        Mois: Integer;
        Annee: Integer;
        DebutMois: Date;
        FinMois: Date;
        Text06: Label 'Souhaitez-vous appliquer le modèle de paie %1 ?';
        Text07: Label 'Les rubriques actuelles seront supprimées.';
        Payroll: Record Payroll;
        CompanyBusinessUnit: Record "Company Business Unit";
        User: Record 2000000120;
        Text08: Label 'Code de direction non configuré dans la table des gestionnaires de paie pour l''utilisateur %1 !';
        Text09: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        PayrollManager: Record "Payroll Manager";
        GestionPaie: Codeunit 52182430;
        CodePaie: Code[20];
        Salarie: Record 5200;
        CodeDirection: Code[10];
        EnteteArchivePaie: Record "Payroll Archive Header";
        ParamRH: Record 5218;
        NumeroSalarie: Code[10];
        CongeNbreJours: Decimal;
        CongeMontant: Decimal;
        TermsPay: Record "Terms of pay";
        DatePaie: Text[200];


    local procedure PayrollTemplateNoOnAfterValida();
    begin
        CurrPage.SAVERECORD;
        CurrPage.UPDATE(FALSE);
    end;
}

