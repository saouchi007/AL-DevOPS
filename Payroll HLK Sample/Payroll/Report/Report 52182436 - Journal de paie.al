/// <summary>
/// Report Journal de paie (ID 52182436).
/// </summary>
report 52182436 "Journal de paie"
{
    // version HALRHPAIE.6.2.01

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Journal de paie.rdl';
    Caption = 'Livre de Paie';
    UseRequestPage = true;

    dataset
    {
        dataitem(DataItem8955; Payroll)
        {
            RequestFilterFields = "Code";
        }
        dataitem(DataItem5487; "Journal de paie")
        {

            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(Unite_Name; Unite.Name)
            {
            }
            column(Unite_Address; Unite.Address)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(Periode; Periode)
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
            column(Unite__Address_2_; Unite."Address 2")
            {
            }
            column(Journal_de_paie_Description; Description)
            {
            }
            column(Journal_de_paie__Employee_1_; "Employee 1")
            {
            }
            column(Journal_de_paie__Employee_2_; "Employee 2")
            {
            }
            column(Journal_de_paie__Employee_7_; "Employee 7")
            {
            }
            column(Journal_de_paie__Employee_6_; "Employee 6")
            {
            }
            column(Journal_de_paie__Employee_5_; "Employee 5")
            {
            }
            column(Journal_de_paie__Employee_4_; "Employee 4")
            {
            }
            column(Journal_de_paie__Employee_3_; "Employee 3")
            {
            }
            column(Journal_de_paie__Intitules_Report_; "Intitules Report")
            {
            }
            column(Journal_de_paie_Description_Control1000000010; Description)
            {
            }
            column(Journal_de_paie__Employee_1__Control1000000012; "Employee 1")
            {
            }
            column(Journal_de_paie__Employee_2__Control1000000014; "Employee 2")
            {
            }
            column(Journal_de_paie__Employee_3__Control1000000016; "Employee 3")
            {
            }
            column(Journal_de_paie__Employee_4__Control1000000018; "Employee 4")
            {
            }
            column(Journal_de_paie__Employee_5__Control1000000004; "Employee 5")
            {
            }
            column(Journal_de_paie__Employee_6__Control1000000020; "Employee 6")
            {
            }
            column(Journal_de_paie__Employee_7__Control1000000022; "Employee 7")
            {
            }
            column(Journal_de_paie__Item_Code_; "Item Code")
            {
            }
            column(Journal_de_paie__Report_Mnt_Droite_; "Report Mnt Droite")
            {
            }
            column(Journal_de_paie__Report_Eff_Droite_; "Report Eff Droite")
            {
            }
            column(Journal_de_paie__Report_Eff_Gauche_; "Report Eff Gauche")
            {
            }
            column(Journal_de_paie__Report_Mnt_Gauche_; "Report Mnt Gauche")
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Journal_de_paie_Entry_No_; "Entry No.")
            {
            }
            column(Condition1____________________________1; Condition1)
            {
            }
            column(Condition2; Condition2)
            {
            }
            column(Condition3; Condition3)
            {
            }
            column(Condition4; Condition4)
            {
            }
            column(Condition5; Condition5)
            {
            }
            column(Condition6; Condition6)
            {
            }
            column(groupeJournal; groupeJournal)
            {
            }
            column(Condition7; Condition7)
            {
            }

            trigger OnAfterGetRecord();
            begin


                Condition1 := ("Employee 1" <> '') AND ("Employee 1" <> '0,00');
                Condition2 := ("Employee 2" <> '') AND ("Employee 2" <> '0,00');
                Condition3 := ("Employee 3" <> '') AND ("Employee 3" <> '0,00');
                Condition4 := ("Employee 4" <> '') AND ("Employee 4" <> '0,00');
                Condition5 := ("Employee 5" <> '') AND ("Employee 5" <> '0,00');
                Condition6 := ("Employee 6" <> '') AND ("Employee 6" <> '0,00');
                Condition7 := ("Employee 7" <> '') AND ("Employee 7" <> '0,00');


                JournalPaieRec.GET("Entry No.");
                IF (JournalPaieRec.Description = 'Matricule') THEN
                    groupeJournal := groupeJournal + 1;

                JournalPaieRec.groupe := groupeJournal;
                JournalPaieRec.MODIFY;

                IF (Description = 'Matricule') AND ("Entry No." > 1) THEN
                    CurrReport.NEWPAGE;
            end;

            trigger OnPreDataItem();
            begin


                Periode := FORMAT(DataItem8955."Ending Date", 0, 4);
                Periode := COPYSTR(Periode, 4, STRLEN(Periode) - 3);
                IF CodePaie = '' THEN BEGIN
                    IF Mois = 0 THEN
                        ERROR(Text01, 'Mois');
                    IF Annee = 0 THEN
                        ERROR(Text01, 'Année');
                    IF (Mois < 1) OR (Mois > 12) THEN
                        ERROR('Mois inccorect');
                END
                ELSE BEGIN
                    IF Paie."Ending Date" = 0D THEN
                        ERROR(Text02, Paie.FIELDCAPTION("Ending Date"), CodePaie);
                    Mois := DATE2DMY(Paie."Ending Date", 2);
                    Annee := DATE2DMY(Paie."Ending Date", 3);
                    Periode := Periode + ' [' + CodePaie + ']';
                END;
                EcriturePaie.RESET;
                EcriturePaie.SETRANGE("Document No.", CodePaie);
                EcriturePaie.FINDFIRST;
                SalariePaie.RESET;
                SalariePaie.DELETEALL;
                JournalPaie.RepererSalaries(CodePaie, NbrePages);
                NbreLignes := NbrePages;
                JournalPaie.RemplirTable(CodePaie, EcriturePaie."Employee No.", NbreLignes);
                JournalPaie.TotaliserRubriquesJournal;
                JournalPaie.CalculerReports;
            end;
        }
        dataitem(DataItem2245; "Payroll Book Totalisation")
        {
            DataItemTableView = SORTING("Item Code");
            column(Periode_Control1000000073; Periode)
            {
            }
            column(Unite_Name_Control1000000075; Unite.Name)
            {
            }
            column(Unite_Address_Control1000000076; Unite.Address)
            {
            }
            column(Unite__Address_2__Control1000000077; Unite."Address 2")
            {
            }
            column(Unite__Post_Code__Control1000000078; Unite."Post Code")
            {
            }
            column(Unite_City_Control1000000079; Unite.City)
            {
            }
            column(Payroll_Book_Totalisation__Item_Code_; "Item Code")
            {
            }
            column(Payroll_Book_Totalisation_Description; Description)
            {
            }
            column(Payroll_Book_Totalisation_Amount; Amount)
            {
            }
            column(Payroll_Book_Totalisation__Item_Code_Caption; FIELDCAPTION("Item Code"))
            {
            }
            column(Payroll_Book_Totalisation_DescriptionCaption; FIELDCAPTION(Description))
            {
            }
            column(Payroll_Book_Totalisation_AmountCaption; FIELDCAPTION(Amount))
            {
            }
            column(Journal_de_totalisation_des_rubriques_de_paieCaption; Journal_de_totalisation_des_rubriques_de_paieCaptionLbl)
            {
            }

            trigger OnAfterGetRecord();
            begin
                CurrReport.NEWPAGE;
            end;

            trigger OnPreDataItem();
            begin
                CurrReport.NEWPAGE;
            end;
        }
    }

    requestpage
    {

        layout
        {
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
        Mois := DATE2DMY(TODAY, 2);
        Annee := DATE2DMY(TODAY, 3);
        EVALUATE(NumReport, COPYSTR(FORMAT(CurrReport.OBJECTID(FALSE)), 8, 100));
        IF SelectionEtats.GET(NumReport) THEN
            Titre := SelectionEtats."Report Name"
        ELSE
            Titre := CurrReport.OBJECTID(TRUE);
        InfoSociete.GET;
        InfoSociete.CALCFIELDS(Picture);
        Unite.GET(GestionnairePaie."Company Business Unit Code");
        groupeJournal := 0;

    end;

    trigger OnPreReport();
    begin
        IF DataItem8955.GETFILTERS = '' THEN
            CodePaie := ''
        ELSE BEGIN
            Paie.COPYFILTERS(DataItem8955);
            Paie.FINDFIRST;
            CodePaie := Paie.Code;
        END;
    end;

    var
        EcriturePaie: Record "Payroll Entry";
        JournalPaie: Codeunit "Journal de paie";
        NbrePages: Integer;
        Periode: Text[30];
        Condition1: Boolean;
        Condition2: Boolean;
        Condition3: Boolean;
        Condition4: Boolean;
        Condition5: Boolean;
        Condition6: Boolean;
        Condition7: Boolean;
        Unite: Record "Company Business Unit";
        InfoSociete: Record 79;
        Titre: Text[100];
        SelectionEtats: Record "HR Payroll Report Selections";
        NumReport: Integer;
        GestionnairePaie: Record "Payroll Manager";
        Annee: Integer;
        Mois: Integer;
        Vr: Decimal;
        Rt: Decimal;
        Text01: Label 'Information manquante : %1 !';
        NbreLignes: Integer;
        Text02: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie';
        CodePaie: Code[20];
        Paie: Record Payroll;
        SalariePaie: Record "Payroll Employee";
        Tri: Option Matricule,Nom;
        Matri: Text[30];
        Nom: Text[30];
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Journal_de_totalisation_des_rubriques_de_paieCaptionLbl: Label 'Journal de totalisation des rubriques de paie';
        groupeJournal: Integer;
        JournalPaieRec: Record "Journal de paie";
        nb: Integer;

}

