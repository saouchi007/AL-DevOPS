/// <summary>
/// Report Déclaration ATS Page 2 (ID 52182464).
/// </summary>
report 52182464 "Déclaration ATS Page 2"
{
    // version HALRHPAIE.6.2.00

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Déclaration ATS Page 2.rdl';

    dataset
    {
        dataitem(DataItem7528; 5200)
        {
            RequestFilterFields = "No.";
            column(Nom; Nom)
            {
            }
            column(Tab_Releve_des_emoluments_Mois; Employee."No.")
            {
            }
            column(OptMatri; OptMatri)
            {
            }
            column(Lieu; Lieu)
            {
            }
            column(ImpDate; ImpDate)
            {
            }
            column(Signataire; Signataire)
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF NOT GestionnairePaie.GET(USERID) THEN
                    ERROR(Text04);
                IF GestionnairePaie."Company Business Unit Code" = '' THEN
                    ERROR(Text05);
                IF NOT Employee.GET("No.") THEN
                    ERROR(Text07, "No.")
                ELSE
                    IF Employee."Company Business Unit Code" <> GestionnairePaie."Company Business Unit Code" THEN
                        ERROR(Text06, "No.", GestionnairePaie."Company Business Unit Code");
                IF Employee.Status = Employee.Status::Inactive THEN
                    ERROR(Text08, "No.");


                Nom := Employee."Last Name" + ' ' + Employee."Middle Name" + ' ' + Employee."First Name";
            end;

            trigger OnPostDataItem();
            begin
                IF Employee.GETFILTERS <> '' THEN
                    CodeUnitATS.Traitement(Employee."No.", MoisDebut, MoisFin, AnneeDebut, AnneeFin)
                ELSE
                    ERROR('Veuillez sélectionner un salarié.');
            end;

            trigger OnPreDataItem();
            begin
                IF MoisDebut = 0 THEN
                    ERROR(Text09, 'Mois début');
                IF MoisFin = 0 THEN
                    ERROR(Text09, 'Mois fin');
                IF AnneeDebut = 0 THEN
                    ERROR(Text09, 'Année début');
                IF AnneeFin = 0 THEN
                    ERROR(Text09, 'Année fin');
                IF (MoisDebut < 1) OR (MoisDebut > 12) THEN
                    ERROR(Text10, 'Mois début');
                IF (MoisFin < 1) OR (MoisFin > 12) THEN
                    ERROR(Text10, 'Mois fin');
                IF DMY2DATE(1, MoisDebut, AnneeDebut) > DMY2DATE(1, MoisFin, AnneeFin) THEN
                    ERROR(Text11);
            end;
        }
        dataitem(DataItem2764; ATS)
        {
            DataItemTableView = SORTING(Annee);
            column(ATS_Description; Description)
            {
            }
            column(Tab_Releve_des_emoluments_base; Base)
            {
            }
            column(Tab_Releve_des_emoluments_retenue; Retenue)
            {
            }
            column(ATS_Duree; Duree)
            {
            }
            column(ATS_Motif; Motif)
            {
            }
            column(ATS_Annee; Annee)
            {
            }
            column(ATS_Mois; Mois)
            {
            }
            column(ATS_PaieCompl; PaieCompl)
            {
            }

            trigger OnAfterGetRecord();
            begin
                TotalBases := TotalBases + ATS.Base;
                TotalRetenues := TotalRetenues + ATS.Retenue;
            end;

            trigger OnPreDataItem();
            begin
                TotalBases := 0;
                TotalRetenues := 0;
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
                    group("Periode Début:")
                    {
                        Caption = 'Periode Début:';
                        field(MoisDebut; MoisDebut)
                        {
                            Caption = 'Mois';
                        }
                        field(AnneeDebut; AnneeDebut)
                        {
                            Caption = 'Année';
                        }
                    }
                    group("Periode Fin:")
                    {
                        Caption = 'Periode Fin:';
                        field(MoisFin; MoisFin)
                        {
                            Caption = 'Mois';
                        }
                        field(AnneeFin; AnneeFin)
                        {
                            Caption = 'Année';
                        }
                    }
                    field(ImpDate; ImpDate)
                    {
                        Caption = 'Date d''édition';
                    }
                    field(Lieu; Lieu)
                    {
                        Caption = 'Lieu d''édition';
                    }
                    field(Signataire; Signataire)
                    {
                        Caption = 'Nom,Prénom et qualité du signature:';
                    }
                    field(OptMatri; OptMatri)
                    {
                        Caption = 'Afficher Matricule Salarié';
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

        EVALUATE(NumReport, COPYSTR(FORMAT(CurrReport.OBJECTID(FALSE)), 8, 100));
        IF SelectionEtats.GET(NumReport) THEN
            Titre := SelectionEtats."Report Name"
        ELSE
            Titre := CurrReport.OBJECTID(TRUE);
        PayrollManager.RESET;
        PayrollManager.SETRANGE("User ID", USERID);
        IF NOT PayrollManager.FINDSET THEN
            ERROR(Text06, USERID);
        MoisDebut := 1;
        MoisFin := 12;
        AnneeDebut := DATE2DMY(TODAY, 3);
        AnneeFin := DATE2DMY(TODAY, 3);
        Lieu := Unite.City;
        ImpDate := TODAY;
    end;

    trigger OnPreReport();
    begin
        InfosSociete.GET;
        InfosSociete.CALCFIELDS(Picture);
        InfosSociete.CALCFIELDS("Right Logo");
        GestionnairePaie.GET(USERID);
        Unite.GET(GestionnairePaie."Company Business Unit Code");
        ParamPaie.GET;
        IF ParamPaie."Leave Cause of Absence" = '' THEN
            ERROR(Text02, ParamPaie.FIELDCAPTION("Leave Cause of Absence"));
        MotifAbsence.GET(ParamPaie."Leave Cause of Absence");
        IF MotifAbsence."Item Code" = '' THEN
            ERROR(Text03, ParamPaie."Leave Cause of Absence");
        IF Lieu = ''
        THEN
            ERROR('Veuillez saisir le lieu et la Date d''édition dans l''onglet Options');
    end;

    var
        MoisDebut: Integer;
        ATS: Record ATS;
        Employee: Record 5200;
        MoisFin: Integer;
        AnneeDebut: Integer;
        AnneeFin: Integer;
        CodeUnitATS: Codeunit ATS;
        TotalBases: Decimal;
        TotalRetenues: Decimal;
        datdv: Text[30];
        datf: Text[30];
        an2: Date;
        InfosSociete: Record 79;
        GestionnairePaie: Record "Payroll Manager";
        Unite: Record "Company Business Unit";
        Titre: Text[100];
        SelectionEtats: Record "HR Payroll Report Selections";
        NumReport: Integer;
        PayrollManager: Record "Payroll Manager";
        Companyadress: Text[100];
        CodeUnite: Code[10];
        Text01: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        Text04: Label 'Utilisateur %1 non configuré !';
        Text05: Label 'Direction non paramétrée pour l''utilisateur %1 !';
        Text06: Label 'Salarié %1 n''appartenant pas à l''unité %2 !';
        Text07: Label 'Salarié %1 inexistant !';
        Text08: Label 'Salarié %1 inactif !';
        ParamPaie: Record Payroll_Setup;
        Text02: Label 'Paramètre de paie manquant : %1 !';
        MotifAbsence: Record 5206;
        Text03: Label 'Rubrique non paramétrée pour le motif %1 !';
        Text09: Label 'Information manquante : %1 !';
        Text10: Label 'Valeur incorrecte : %1 !';
        Text11: Label 'Date de début doit être antérieure à la date de fin !';
        ImpDate: Date;
        Lieu: Text[30];
        Signataire: Text[100];
        Nom: Text[100];
        OptMatri: Boolean;

}

