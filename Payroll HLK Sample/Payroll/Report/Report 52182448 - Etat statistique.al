/// <summary>
/// Report Etat statistique (ID 52182448).
/// </summary>
report 52182448 "Etat statistique"
{
    // version HALRHPAIE.6.2.01

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Etat statistique.rdl';

    dataset
    {
        dataitem(DataItem9911; "Payroll Item")
        {
            RequestFilterFields = "Code";
        }
        dataitem(DataItem8955; Payroll)
        {
            RequestFilterFields = "Code";
        }
        dataitem(DataItem4859; "Etat statistique")
        {
            DataItemTableView = SORTING("Employee No.");
            column(Periode; Periode)
            {
            }
            column(Payroll_Item__Description; DataItem9911.Description)
            {
            }
            column(CompanyInformation_Picture; InfoSociete."Right Logo")
            {
                AutoCalcField = true;
            }
            column(Unite_Name; Unite.Name)
            {
            }
            column(Unite_Address; Unite.Address)
            {
            }
            column(Unite__Post_Code_; Unite."Post Code")
            {
            }
            column(Unite_City; Unite.City)
            {
            }
            column(Titre; Titre)
            {
            }
            column(USERID; USERID)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(Unite__Address_2_; Unite."Address 2")
            {
            }
            column(Payroll_Item__Code; DataItem9911.Code)
            {
            }
            column(DesignationPaie; DesignationPaie)
            {
            }
            column(Compteur; Compteur)
            {
            }
            column(Etat_statistique_Basis; Basis)
            {
            }
            column(Etat_statistique_Rate; Rate)
            {
            }
            column(Etat_statistique_Amount; Amount)
            {
            }
            column(Etat_statistique__Last_Name_; "Last Name")
            {
            }
            column(Etat_statistique__First_Name_; "First Name")
            {
            }
            column(Etat_statistique_Number; Number)
            {
            }
            column(Compteur_Control1000000033; Compteur)
            {
            }
            column(MontantPied; MontantPied)
            {
            }
            column(BasePied; BasePied)
            {
            }
            column(RatioPied; RatioPied)
            {
            }
            column(NombrePied; NombrePied)
            {
            }
            column(N_Caption; N_CaptionLbl)
            {
            }
            column(BaseCaption; BaseCaptionLbl)
            {
            }
            column(Etat_statistique_RateCaption; FIELDCAPTION(Rate))
            {
            }
            column(MontantCaption; MontantCaptionLbl)
            {
            }
            column("Nom_et_prénomCaption"; Nom_et_prénomCaptionLbl)
            {
            }
            column("Période__Caption"; Période__CaptionLbl)
            {
            }
            column(Rubrique__Caption; Rubrique__CaptionLbl)
            {
            }
            column(NombreCaption; NombreCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(EmptyStringCaption; EmptyStringCaptionLbl)
            {
            }
            column(Paies__Caption; Paies__CaptionLbl)
            {
            }
            column(Totaux___Caption; Totaux___CaptionLbl)
            {
            }
            column("Nombre_de_salariés__Caption"; Nombre_de_salariés__CaptionLbl)
            {
            }
            column(Etat_statistique_Employee_No_; "Employee No.")
            {
            }
            column(TotalBase; TotalBase)
            {
            }
            column(TotalMontant; TotalMontant)
            {
            }
            column(TotalNombre; TotalNombre)
            {
            }

            trigger OnAfterGetRecord();
            begin
                Compteur := Compteur + 1;

                IF Basis > 0 THEN
                    Base := Basis
                ELSE
                    Base := -Basis;
                IF Amount > 0 THEN
                    Montant := Amount
                ELSE
                    Montant := -Amount;
                TotalBase := TotalBase + Base;
                TotalMontant := TotalMontant + Montant;
                TotalNombre := TotalNombre + Number;
            end;

            trigger OnPreDataItem();
            begin
                IF FiltrePaie = '' THEN BEGIN
                    IF MoisDebut = 0 THEN
                        ERROR(Text03, 'Mois début');
                    IF MoisFin = 0 THEN
                        ERROR(Text03, 'Mois fin');
                    IF AnneeDebut = 0 THEN
                        ERROR(Text03, 'Année début');
                    IF AnneeFin = 0 THEN
                        ERROR(Text03, 'Année fin');
                    IF (MoisDebut < 1) OR (MoisDebut > 12) THEN
                        ERROR('Mois début inccorect !');
                    IF (MoisFin < 1) OR (MoisFin > 12) THEN
                        ERROR('Mois fin inccorect !');
                    IF (AnneeDebut < 1900) OR (AnneeDebut > 2100) THEN
                        ERROR('Année début inccorecte !');
                    IF (AnneeFin < 1900) OR (AnneeFin > 2100) THEN
                        ERROR('Année fin inccorecte !');
                END
                ELSE BEGIN
                    Paie.SETFILTER(Code, FiltrePaie);
                    Paie.FINDFIRST;
                    REPEAT
                        IF Paie."Ending Date" = 0D THEN
                            ERROR(Text05, Paie.FIELDCAPTION("Ending Date"), FiltrePaie);
                    UNTIL Paie.NEXT = 0;
                    MoisDebut := DATE2DMY(Paie."Ending Date", 2);
                    MoisFin := MoisDebut;
                    AnneeDebut := DATE2DMY(Paie."Ending Date", 3);
                    AnneeFin := AnneeDebut;
                END;
                Traitement;
                CASE Tri OF
                    Tri::Matricule:
                        SETCURRENTKEY("Employee No.");
                    Tri::Nom:
                        SETCURRENTKEY("Last Name", "First Name");
                END;


                IF FiltrePaie = '' THEN
                    DesignationPaie := 'Du ' + FORMAT(MoisDebut) + '/' + FORMAT(AnneeDebut)
                    + ' au ' + FORMAT(MoisFin) + '/' + FORMAT(AnneeFin)
                ELSE
                    DesignationPaie := FiltrePaie;
                Periode := 'du ' + FORMAT(MoisDebut) + '/' + FORMAT(AnneeDebut) + ' au ' + FORMAT(MoisFin) + '/' + FORMAT(AnneeFin);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(Tri; Tri)
                    {
                        Caption = 'Trier par :';
                    }
                    field("Période du"; '')
                    {
                        Caption = 'Période du';
                    }
                    field(MoisDebut; MoisDebut)
                    {
                        Caption = 'Mois';
                    }
                    field(AnneeDebut; AnneeDebut)
                    {
                        Caption = 'Année';
                    }
                    field(Au; '')
                    {
                        Caption = 'Au';
                    }
                    field(MoisFin; MoisFin)
                    {
                        Caption = 'Mois';
                    }
                    field(AnneeFin; AnneeFin)
                    {
                        Caption = 'Année';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        IF NOT GestionnairePaie.GET(USERID) THEN
            ERROR(Text02, USERID);
        IF GestionnairePaie."Company Business Unit Code" <> '' THEN
            Unite.GET(GestionnairePaie."Company Business Unit Code");
        CodeUnite := GestionnairePaie."Company Business Unit Code";
        MoisDebut := DATE2DMY(TODAY, 2);
        MoisFin := MoisDebut;
        AnneeDebut := DATE2DMY(TODAY, 3);
        AnneeFin := AnneeDebut;
        EVALUATE(NumReport, COPYSTR(FORMAT(CurrReport.OBJECTID(FALSE)), 8, 100));
        IF SelectionEtats.GET(NumReport) THEN
            Titre := SelectionEtats."Report Name"
        ELSE
            Titre := CurrReport.OBJECTID(TRUE);
        InfoSociete.GET;
        InfoSociete.CALCFIELDS(Picture);
        InfoSociete.CALCFIELDS("Right Logo");
        ParamPaie.GET;
    end;

    trigger OnPreReport();
    begin
        IF DataItem9911.GETFILTERS = '' THEN
            ERROR(Text01, 'Code rubrique');
        Rubrique.COPYFILTERS(DataItem9911);
        Rubrique.FINDFIRST;
        CodeRubrique := Rubrique.Code;
        IF DataItem8955.GETFILTERS = '' THEN
            FiltrePaie := ''
        ELSE BEGIN
            IF COPYSTR(DataItem8955.GETFILTERS, 1, 4) <> 'Code' THEN
                ERROR(Text07);
            FiltrePaie := COPYSTR(DataItem8955.GETFILTERS, 7, 200);
            Paie.SETFILTER(Code, FiltrePaie);
            Paie.FINDFIRST;
            REPEAT
                IF (Paie."Company Business Unit Code" <> CodeUnite) AND (CodeUnite <> '') THEN
                    ERROR(Text03, USERID, Paie.Code);
            UNTIL Paie.NEXT = 0;
        END;
    end;

    var
        DesignationPaie: Text[200];
        Periode: Text[50];
        Salarie: Record 5200;
        Compteur: Integer;
        TotalBase: Decimal;
        TotalMontant: Decimal;
        TotalNombre: Decimal;
        Unite: Record "Company Business Unit";
        InfoSociete: Record 79;
        Titre: Text[100];
        SelectionEtats: Record "HR Payroll Report Selections";
        NumReport: Integer;
        GestionnairePaie: Record "Payroll Manager";
        Text01: Label 'Information manquante %1 !';
        Text02: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        Text03: Label 'L''utilisateur %1 n''est pas autorisé à visualiser la paie %2 !';
        Paie: Record Payroll;
        Text04: Label 'Code de direction manquant pour la paie %1 !';
        FiltrePaie: Code[200];
        CodeUnite: Code[10];
        Tri: Option Matricule,Nom;
        AnneeDebut: Integer;
        AnneeFin: Integer;
        MoisDebut: Integer;
        MoisFin: Integer;
        ParamPaie: Record Payroll_Setup;
        TableDonnees: Record "Etat statistique";
        Text05: Label '%1 non paramétrée pour la paie %2 !';
        Text06: Label 'Paie %1 non calculée !';
        HistTransactPaie: Record "Payroll Register";
        ActionActivee: Boolean;
        Mois: Integer;
        Annee: Integer;
        LignePaie: Record "Payroll Entry";
        Rubrique: Record "Payroll Item";
        CodeRubrique: Code[10];
        Base: Decimal;
        Montant: Decimal;
        BasePied: Decimal;
        NombrePied: Decimal;
        RatioPied: Decimal;
        MontantPied: Decimal;
        Text07: Label 'Filtre de paies erroné !';
        DatePaie: Date;
        DebutPeriode: Date;
        FinPeriode: Date;
        N_CaptionLbl: Label 'N°';
        BaseCaptionLbl: Label 'Base';
        MontantCaptionLbl: Label 'Montant';
        "Nom_et_prénomCaptionLbl": Label 'Nom et prénom';
        "Période__CaptionLbl": Label 'Période :';
        Rubrique__CaptionLbl: Label 'Rubrique :';
        NombreCaptionLbl: Label 'Nombre';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        EmptyStringCaptionLbl: Label '-';
        Paies__CaptionLbl: Label 'Paies :';
        Totaux___CaptionLbl: Label '"Totaux : "';
        "Nombre_de_salariés__CaptionLbl": Label 'Nombre de salariés :';


    procedure Traitement();
    begin
        TableDonnees.RESET;
        TableDonnees.DELETEALL;
        HistTransactPaie.RESET;
        IF FiltrePaie <> '' THEN BEGIN
            HistTransactPaie.SETFILTER("Payroll Code", FiltrePaie);
            IF NOT HistTransactPaie.FINDFIRST THEN
                ERROR(Text06, Paie.Code);
        END;
        DebutPeriode := DMY2DATE(1, MoisDebut, AnneeDebut);
        FinPeriode := DMY2DATE(1, MoisFin, AnneeFin);
        //MESSAGE('%1&%2',DebutPeriode,FinPeriode);
        LignePaie.RESET;
        LignePaie.SETRANGE("Item Code", CodeRubrique);
        HistTransactPaie.FINDFIRST;
        REPEAT
            ActionActivee := FALSE;
            Paie.GET(HistTransactPaie."Payroll Code");
            Mois := DATE2DMY(Paie."Ending Date", 2);
            Annee := DATE2DMY(Paie."Ending Date", 3);
            DatePaie := DMY2DATE(1, Mois, Annee);
            IF GestionnairePaie."Company Business Unit Code" = '' THEN
                ActionActivee := TRUE
            ELSE
                IF Paie."Company Business Unit Code" = CodeUnite THEN
                    ActionActivee := TRUE;
            IF ActionActivee THEN BEGIN
                IF (DatePaie >= DebutPeriode) AND (DatePaie <= FinPeriode) THEN     // ici
                  BEGIN
                    LignePaie.SETRANGE("Document No.", HistTransactPaie."Payroll Code");
                    IF LignePaie.FINDFIRST THEN
                        REPEAT
                            IF NOT TableDonnees.GET(LignePaie."Employee No.") THEN BEGIN
                                TableDonnees.INIT;
                                TableDonnees."Employee No." := LignePaie."Employee No.";
                                Salarie.GET(LignePaie."Employee No.");
                                TableDonnees."First Name" := Salarie."First Name";
                                TableDonnees."Last Name" := Salarie."Last Name";
                                TableDonnees.INSERT;
                            END;
                            TableDonnees.GET(LignePaie."Employee No.");
                            IF Rubrique."Item Type" <> Rubrique."Item Type"::"Libre saisie" THEN
                                TableDonnees.Basis := TableDonnees.Basis + LignePaie.Basis;
                            IF Rubrique."Item Type" = Rubrique."Item Type"::"Libre saisie" THEN
                                TableDonnees.Number := TableDonnees.Number + LignePaie.Number;
                            IF Rubrique."Item Type" = Rubrique."Item Type"::Formule THEN
                                TableDonnees.Number := TableDonnees.Number + LignePaie.Number;
                            TableDonnees.Rate := TableDonnees.Rate + LignePaie.Rate;
                            TableDonnees.Amount := ROUND(TableDonnees.Amount + LignePaie.Amount);
                            TableDonnees.MODIFY;
                        UNTIL LignePaie.NEXT = 0;
                END;
            END;
        UNTIL HistTransactPaie.NEXT = 0;
        TableDonnees.RESET;
        TableDonnees.FINDFIRST;
        REPEAT
            CASE Rubrique."Item Type" OF
                Rubrique."Item Type"::"Libre saisie":
                    IF TableDonnees.Number <> 0 THEN
                        TableDonnees.Basis := ROUND(TableDonnees.Amount / TableDonnees.Number);
                Rubrique."Item Type"::Formule:
                    BEGIN
                        IF TableDonnees.Number <> 0 THEN
                            TableDonnees.Number := TableDonnees.Number ELSE
                            IF TableDonnees.Rate <> 0 THEN
                                TableDonnees.Rate := TableDonnees.Rate;
                    END;
                Rubrique."Item Type"::Pourcentage:
                    IF TableDonnees.Basis <> 0 THEN
                        TableDonnees.Rate := ROUND(TableDonnees.Amount / TableDonnees.Basis);
                Rubrique."Item Type"::"Au prorata":
                    IF TableDonnees.Basis <> 0 THEN
                        TableDonnees.Rate := ROUND(TableDonnees.Amount / TableDonnees.Basis);
                Rubrique."Item Type"::"Au prorata autorisé":
                    IF TableDonnees.Basis <> 0 THEN
                        TableDonnees.Rate := ROUND(TableDonnees.Amount / TableDonnees.Basis);
            END;
            IF TableDonnees.Number < 0 THEN TableDonnees.Number := -1 * TableDonnees.Number;// ELSE
            IF TableDonnees.Amount < 0 THEN TableDonnees.Amount := -1 * TableDonnees.Amount;
            TableDonnees.MODIFY;
        UNTIL TableDonnees.NEXT = 0;
    end;
}

