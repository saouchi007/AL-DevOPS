/// <summary>
/// Report Etat de virement (ID 52182433).
/// </summary>
report 52182433 "Etat de virement"
{
    // version HALRHPAIE.6.2.00

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Etat de virement.rdl';

    dataset
    {
        dataitem(DataItem8955; Payroll)
        {
            RequestFilterFields = "Code";
        }
        dataitem(DataItem8072; "Payroll Bank Account")
        {
            RequestFilterFields = "Code";
        }
        dataitem(DataItem7528; 5200)
        {
            RequestFilterFields = "No.";
        }
        dataitem(DataItem8074; "Etat de virement")
        {
            DataItemTableView = SORTING("Payroll Bank Account", "No.");
            column(CodeAgenceCompany; CodeAgenceCompany)
            {
            }
            column(CodeBanqueCompany; CodeBanqueCompany)
            {
            }
            column(CompteBancaireeCompany; CompteBancaireeCompany)
            {
            }
            column(CleRibCompany; CleRibCompany)
            {
            }
            column(CodeBanqueSalarie; DataItem8074."Code banque")
            {
            }
            column(CodeAgenceSalarie; DataItem8074."Code agence")
            {
            }
            column(TotalPage; TotalPage)
            {
            }
            column(Periode; Periode)
            {
            }
            column(CodePaie; CodePaie)
            {
            }
            column(Unite_Address; Unite.Address)
            {
            }
            column(Unite_City; Unite.City)
            {
            }
            column(Unite_Name; Unite.Name)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(Unite__Post_Code_; Unite."Post Code")
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(Periode_Control1000000008; Periode)
            {
            }
            column(Unite_Address_Control1000000012; Unite.Address)
            {
            }
            column(Unite_City_Control1000000015; Unite.City)
            {
            }
            column(Unite_Name_Control1000000017; Unite.Name)
            {
            }
            column(CurrReport_PAGENO_Control1000000021; CurrReport.PAGENO)
            {
            }
            column(Unite__Post_Code__Control1000000057; Unite."Post Code")
            {
            }
            column(FORMAT_TODAY_0_4__Control1000000059; FORMAT(TODAY, 0, 4))
            {
            }
            column(Etat_de_virement_Amount; Amount)
            {
            }
            column(DesignationBanqueSalarie; DesignationBanqueSalarie)
            {
            }
            column(OrdrePaiement; OrdrePaiement)
            {
            }
            column(Text04; Text04)
            {
            }
            column(PayrollBank; PayrollBank)
            {
            }
            column(NombreDeVirement; NumLigne)
            {
            }
            column(Etat_de_virement__No__; "No.")
            {
            }
            column(Payroll_Bank_Account_No________FORMAT__RIB_Key__2_0_; "Payroll Bank Account No." + '  ' + FORMAT("RIB Key", 2, 0))
            {
            }
            column(Payroll_Bank_Account_No; "Payroll Bank Account No.")
            {
            }
            column(RIB_Key; "RIB Key")
            {
            }
            column(NomSalarie; NomSalarie)
            {
            }
            column(Etat_de_virement_Amount_Control1000000033; Amount)
            {
            }
            column(Etat_de_virement_Amount_Control1000000018; Amount)
            {
            }
            column(DescriptionLine_1_; DescriptionLine[1])
            {
            }
            column(DescriptionLine_2_; DescriptionLine[2])
            {
            }
            column(TotalPage_Control1000000031; TotalPage)
            {
            }
            column(Etat_de_virement_Amount_Control1000000005; Amount)
            {
            }
            column(TotalPage_Control1000000029; TotalPage)
            {
            }
            column(TotalPage_Control1000000026; TotalPage)
            {
            }
            column(Report__Caption; Report__CaptionLbl)
            {
            }
            column(ORDRE_DE_VIREMENTCaption; ORDRE_DE_VIREMENTCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(ORDRE_DE_VIREMENTCaption_Control1000000001; ORDRE_DE_VIREMENTCaption_Control1000000001Lbl)
            {
            }
            column(CurrReport_PAGENO_Control1000000021Caption; CurrReport_PAGENO_Control1000000021CaptionLbl)
            {
            }
            column(Report__Caption_Control1000000000; Report__Caption_Control1000000000Lbl)
            {
            }
            column(N__de_compteCaption; N__de_compteCaptionLbl)
            {
            }
            column(MontantCaption; MontantCaptionLbl)
            {
            }
            column("Nom_et_prénomCaption"; Nom_et_prénomCaptionLbl)
            {
            }
            column(MatriculeCaption; MatriculeCaptionLbl)
            {
            }
            column(N_Caption; N_CaptionLbl)
            {
            }
            column("Total_général__Caption"; Total_général__CaptionLbl)
            {
            }
            column("Arrêter_le_présent_état_à_la_somme_de__Caption"; Arrêter_le_présent_état_à_la_somme_de__CaptionLbl)
            {
            }
            column(Total_de_page__Caption; Total_de_page__CaptionLbl)
            {
            }
            column("Total_à_reporter__Caption"; Total_à_reporter__CaptionLbl)
            {
            }
            column(Total_de_page__Caption_Control1000000028; Total_de_page__Caption_Control1000000028Lbl)
            {
            }
            column(Total_de_page__Caption_Control1000000023; Total_de_page__Caption_Control1000000023Lbl)
            {
            }
            column(Etat_de_virement_Payroll_Bank_Account; "Payroll Bank Account")
            {
            }
            column(PayrollBankAccountNo; "Payroll Bank Account No.")
            {
            }

            trigger OnAfterGetRecord();
            begin


                IF (Payroll_Bank_Account_Old <> "Payroll Bank Account") THEN
                    TotalSalaireNet := 0;



                Numero := Outils.Format_Text(FORMAT(NumLigne), 4, '0', TRUE);
                IF "Payroll Bank Account" <> '' THEN BEGIN
                    CpteBancaireSalarie.GET("Payroll Bank Account");
                    DesignationBanqueSalarie := CpteBancaireSalarie.Name + ' ' + CpteBancaireSalarie.City + ' N° : '
                    + CpteBancaireSalarie."Agency Code";
                END;
                IF "Middle Name" = '' THEN
                    NomSalarie := "Last Name" + ' ' + "First Name"
                ELSE
                    IF Sex = Sex::Female THEN
                        NomSalarie := "Last Name" + ' née ' + "Middle Name" + ' ' + "First Name";
                TotalSalaireNet := TotalSalaireNet + Amount;
                IF TotalPage + Amount > ParamPaie."Limite page état de virement" THEN BEGIN
                    SautPage := TRUE;
                    //CurrReport.NEWPAGE;
                END;


                CLEAR(DescriptionLine);
                CheckReport.InitTextVariable;
                CheckReport.FormatNoText(DescriptionLine, TotalSalaireNet, '');
                Payroll_Bank_Account_Old := "Payroll Bank Account";
            end;

            trigger OnPreDataItem();
            begin
                IF CodePaie = '' THEN BEGIN
                    IF Mois = 0 THEN
                        ERROR(Text03, 'Mois');
                    IF Annee = 0 THEN
                        ERROR(Text03, 'Année');
                    IF (Mois < 1) OR (Mois > 12) THEN
                        ERROR('Mois inccorect !');
                    IF (Annee < 1900) OR (Annee > 2100) THEN
                        ERROR('Année inccorecte !');
                END
                ELSE BEGIN
                    Mois := DATE2DMY(Paie."Ending Date", 2);
                    Annee := DATE2DMY(Paie."Ending Date", 3);
                END;
                MoisFormate := FORMAT(Mois);

                IF Mois < 10 THEN
                    MoisFormate := '0' + MoisFormate;
                Periode := FORMAT(Mois) + '/' + FORMAT(Annee);
                IF CodePaie <> '' THEN
                    Periode := Periode + ' [' + CodePaie + ']';
                TableDonnees.RESET;
                TableDonnees.DELETEALL;
                ArchivePaieEntete.RESET;
                ArchivePaieEntete.SETCURRENTKEY("Payroll Bank Account", "No.", "Payment Method Code", "Company Business Unit Code");
                ArchivePaieEntete.SETCURRENTKEY("Payroll Bank Account", "No.");
                ArchivePaieEntete.SETRANGE("Payment Method Code", ParamPaie."Report Payment Method");
                IF CodeUnite <> '' THEN
                    ArchivePaieEntete.SETRANGE("Company Business Unit Code", CodeUnite);
                ArchivePaieEntete.SETFILTER("No.", FiltreSalarie);
                ArchivePaieEntete.SETFILTER("Payroll Bank Account", FiltreCpteBancaire);

                IF CodePaie <> '' THEN
                    ArchivePaieEntete.SETRANGE("Payroll Code", CodePaie);
                IF ArchivePaieEntete.FINDFIRST THEN
                    REPEAT
                        Paie.GET(ArchivePaieEntete."Payroll Code");
                        IF (CodePaie <> '') OR ((CodePaie = '') AND (DATE2DMY(Paie."Ending Date", 2) = Mois)
                        AND (DATE2DMY(Paie."Ending Date", 3) = Annee)) THEN BEGIN
                            SalaireNet := 0;
                            ParamPaie.GET;
                            EcriturePaie.RESET;
                            EcriturePaie.SETCURRENTKEY("Document No.", "Employee No.", "Item Code");
                            EcriturePaie.SETRANGE("Document No.", ArchivePaieEntete."Payroll Code");
                            EcriturePaie.SETRANGE("Employee No.", ArchivePaieEntete."No.");
                            EcriturePaie.SETRANGE("Item Code", ParamPaie."Net Salary");
                            NumLigne := NumLigne + 1;
                            IF EcriturePaie.FINDFIRST THEN
                                SalaireNet := EcriturePaie.Amount;
                            IF SalaireNet > 0 THEN BEGIN
                                IF TableDonnees.GET(ArchivePaieEntete."No.") THEN BEGIN
                                    TableDonnees.GET(ArchivePaieEntete."No.");
                                    TableDonnees.Amount := TableDonnees.Amount + SalaireNet;
                                    TableDonnees.MODIFY;
                                END
                                ELSE BEGIN
                                    TableDonnees2.INIT;
                                    TableDonnees2."No." := ArchivePaieEntete."No.";
                                    TableDonnees2."First Name" := ArchivePaieEntete."First Name";
                                    TableDonnees2."Last Name" := ArchivePaieEntete."Last Name";
                                    TableDonnees2."Payroll Bank Account" := ArchivePaieEntete."Payroll Bank Account";
                                    TableDonnees2.Amount := SalaireNet;
                                    TableDonnees2."RIB Key" := ArchivePaieEntete."RIB Key";

                                    IF ArchivePaieEntete."Payroll Bank Account No." = '' THEN BEGIN
                                        TableDonnees2."Code banque" := COPYSTR(ArchivePaieEntete."N ° CCP", 1, 3);
                                        TableDonnees2."Code agence" := COPYSTR(ArchivePaieEntete."N ° CCP", 4, 5);
                                        TableDonnees2."Payroll Bank Account No." := COPYSTR(ArchivePaieEntete."N ° CCP", 9, 12);
                                    END
                                    ELSE BEGIN
                                        TableDonnees2."Code banque" := COPYSTR(ArchivePaieEntete."Payroll Bank Account No.", 1, 3);
                                        TableDonnees2."Code agence" := COPYSTR(ArchivePaieEntete."Payroll Bank Account No.", 4, 5);
                                        TableDonnees2."Payroll Bank Account No." := COPYSTR(ArchivePaieEntete."Payroll Bank Account No.", 9, 12);
                                    END;
                                    //TableDonnees2."Payroll Bank Account No.":=ArchivePaieEntete."Payroll Bank Account No.";
                                    //TableDonnees2."N° CCP":=ArchivePaieEntete."N ° CCP";
                                    TableDonnees2.INSERT;
                                END;
                            END;
                        END;
                    UNTIL ArchivePaieEntete.NEXT = 0;
                IF "Payroll Bank Account" = '' THEN
                    "Payroll Bank Account" := DataItem7528."CCP N";
                /*  IF "Payroll Bank Account"<>''THEN
                  BEGIN
                    CpteBancaireSalarie.GET("Payroll Bank Account");
                    DesignationBanqueSalarie:=CpteBancaireSalarie.Name+' '+CpteBancaireSalarie.City+' N° : '
                    +CpteBancaireSalarie."Agency Code";
                
                
                  END; */


            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                //Caption = 'Période';
                field(Mois; Mois)
                {
                    Caption = 'Mois';
                }
                field(Annee; Annee)
                {
                    Caption = 'Année';
                }
                field(UniteConcernee; UniteConcernee)
                {
                    Caption = 'Unité';
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

        NumLigne := 0;
        CompanyInfo.GET;
        ParamPaie.GET;
        IF NOT GestionnairePaie.GET(USERID) THEN
            ERROR(Text06, USERID);
        CodeUnite := GestionnairePaie."Company Business Unit Code";
        IF CodeUnite = '' THEN
            UniteConcernee := 'Toutes les unités'
        ELSE
            UniteConcernee := CodeUnite;
        Mois := DATE2DMY(TODAY, 2);
        Annee := DATE2DMY(TODAY, 3);
        TotalPage := 0;
        SautPage := FALSE;
    end;

    trigger OnPreReport();
    begin
        CompanyInfo.GET;

        CodeAgenceCompany := COPYSTR(CompanyInfo."Bank Account 2 No.", 4, 6);
        CodeBanqueCompany := CompanyInfo."Bank Branch 2 No.";
        CompteBancaireeCompany := COPYSTR(CompanyInfo."Bank Account 2 No.", 10, 12);
        CleRibCompany := COPYSTR(CompanyInfo."Bank Account 2 No.", 22, 2);

        OrdrePaiement := 'Par le débit de notre compte N° ' + CompteBancaireeCompany + ', veuillez créditer les comptes des bénéficiaires domiciliés à :';
        IF DataItem8955.GETFILTERS = '' THEN
            CodePaie := ''
        ELSE BEGIN
            Paie.COPYFILTERS(DataItem8955);
            Paie.FINDFIRST;
            CodePaie := Paie.Code;
            IF Paie."Company Business Unit Code" <> CodeUnite THEN
                ERROR(Text09, USERID, CodePaie);
            IF Paie."Ending Date" = 0D THEN
                ERROR(Text01, Paie.FIELDCAPTION("Ending Date"), CodePaie);
        END;
        IF EcriturePaie.ISEMPTY THEN
            ERROR(Text07, CodePaie);
        ParamCompta.GET;
        Employee2.RESET;
        DataItem7528.COPYFILTER("No.", Employee2."No.");
        IF CodeUnite <> '' THEN BEGIN
            Employee2.SETRANGE(Employee2."Company Business Unit Code", CodeUnite);
            Unite.GET(CodeUnite);
            IntituleUnite := Unite.Code + ' - ' + Unite.Name;
            FiltreCpteBancaire := DataItem8072.GETFILTER(Code);
            FiltreSalarie := DataItem7528.GETFILTER("No.");
            //OrdrePaiement:='Par le débit de notre compte N° XXX, veuillez créditer les comptes des bénéficiaires domiciliés à :';
            IF Unite."Payroll Bank Account" <> '' THEN BEGIN
                PayrollBankAccount.GET(Unite."Payroll Bank Account");
                PayrollBank := PayrollBankAccount.Name + ' ' + PayrollBankAccount.Address + ' Agence : '
                + PayrollBankAccount."Agency Code";
                //OrdrePaiement:='Par le débit de notre compte N° '+PayrollBankAccount."Bank Account No."
                //+', veuillez créditer les comptes des bénéficiaires domiciliés à :';
            END;
        END;
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        ParamPaie.GET;
        TotalSalaireNet := 0;
        Payroll_Bank_Account_Old := '';
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        NumLigne: Integer;
        NomSalarie: Text[100];
        Numero: Text[30];
        DesignationBanqueSalarie: Text[100];
        PayrollBank: Text[100];
        CpteBancaireSalarie: Record "Payroll Bank Account";
        FiltreCpteBancaire: Text[250];
        PayrollBankAccount: Record 270;
        Unite: Record "Company Business Unit";
        Employee2: Record 5200;
        Text02: Label 'Aucun salarié n''est affecté à l''unité %1 !';
        Text04: Label 'A Monsieur le Directeur de :';
        CompanyInfo: Record 79;
        EcriturePaie: Record "Payroll Entry";
        GestionnairePaie: Record "Payroll Manager";
        CodeUnite: Code[10];
        Text06: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        Paie: Record Payroll;
        Text07: Label 'Paie %1 non encore calculée  !';
        CodePaie: Code[20];
        OrdrePaiement: Text[250];
        SalaireNet: Decimal;
        ParamPaie: Record Payroll_Setup;
        TotalNetSalary: Decimal;
        CurrentPayrollBankAccount: Code[20];
        DescriptionLine: array[2] of Text[80];
        Text08: Label 'Code d''unité manquant pour la paie %1 !';
        IntituleUnite: Text[50];
        CheckReport: Report 1401;
        ParamCompta: Record 98;
        Adresse: Text[100];
        i: Integer;
        Salarie: Record 5200;
        FiltreSalarie: Text[250];
        ArchivePaieEntete: Record "Payroll Archive Header";
        TableDonnees: Record "Etat de virement";
        TableDonnees2: Record "Etat de virement";
        Outils: Codeunit "Tools Library";
        TotalSalaireNet: Decimal;
        Mois: Integer;
        Annee: Integer;
        Text03: Label 'Information manquante : %1 !';
        MoisFormate: Text[2];
        Text01: Label '%1 non paramétrée pour la paie %2 !';
        Periode: Text[100];
        Text09: Label 'Utilisateur %1 non autorisé à visualiser la paie %2 !';
        TotalPage: Decimal;
        SautPage: Boolean;
        UniteConcernee: Text[30];
        Report__CaptionLbl: Label 'Report :';
        ORDRE_DE_VIREMENTCaptionLbl: Label 'ORDRE DE VIREMENT';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        ORDRE_DE_VIREMENTCaption_Control1000000001Lbl: Label 'ORDRE DE VIREMENT';
        CurrReport_PAGENO_Control1000000021CaptionLbl: Label 'Page';
        Report__Caption_Control1000000000Lbl: Label 'Report :';
        N__de_compteCaptionLbl: Label 'N° de compte';
        MontantCaptionLbl: Label 'Montant';
        "Nom_et_prénomCaptionLbl": Label 'Nom et prénom';
        MatriculeCaptionLbl: Label 'Matricule';
        N_CaptionLbl: Label 'N°';
        "Total_général__CaptionLbl": Label 'Total général :';
        "Arrêter_le_présent_état_à_la_somme_de__CaptionLbl": Label 'Arrêter le présent état à la somme de :';
        Total_de_page__CaptionLbl: Label 'Total de page :';
        "Total_à_reporter__CaptionLbl": Label 'Total à reporter :';
        Total_de_page__Caption_Control1000000028Lbl: Label 'Total de page :';
        Total_de_page__Caption_Control1000000023Lbl: Label 'Total de page :';
        Payroll_Bank_Account_Old: Text[200];
        CodeAgenceCompany: Text[50];
        CodeBanqueCompany: Text[50];
        CompteBancaireeCompany: Text[50];
        CleRibCompany: Text[50];

}

