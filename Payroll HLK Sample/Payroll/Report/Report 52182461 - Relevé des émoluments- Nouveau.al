report 51491 "Relevé des émoluments- Nouveau"
{
    // version HALRHPAIE.6.1.05

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Relevé des émoluments- Nouveau.rdl';

    dataset
    {
        dataitem(DataItem8955; Payroll)
        {
            RequestFilterFields = "Code";
        }
        dataitem(DataItem7528; 5200)
        {
            RequestFilterFields = "No.";
            column(EmployeeFullName; EmployeeFullName)
            {
            }
            column(BirthDateAndPlace; BirthDateAndPlace)
            {
            }
            column(Employee_Employee__Function_Description_; DataItem7528."Job Title")
            {
            }
            column(TypeContratEtDateRecrutement; TypeContratEtDateRecrutement)
            {
            }
            column(PictureBoxLogo; CompanyInfo.Picture)
            {
            }
            column(Sexe; Sexe)
            {
            }
            column(Empl; Empl)
            {
            }
            column(NumRef; NumRef)
            {
            }
            column(NomEntreprise; NomEntreprise)
            {
            }
            column(Employee_Employee__Employment_Date_; DataItem7528."Employment Date")
            {
            }
            column(Texte; Texte)
            {
            }
            column(FaitA; FaitA)
            {
            }
            column(DIRECTION_DES_RESSOURCES_HUMAINESCaption; DIRECTION_DES_RESSOURCES_HUMAINESCaptionLbl)
            {
            }
            column(SERVICE_DU_PERSONNELCaption; SERVICE_DU_PERSONNELCaptionLbl)
            {
            }
            column(RELEVE_DES_EMOLUMENTSCaption; RELEVE_DES_EMOLUMENTSCaptionLbl)
            {
            }
            column(Date_et_lieu_de_naissance__Caption; Date_et_lieu_de_naissance__CaptionLbl)
            {
            }
            column(depuis_le___Caption; depuis_le___CaptionLbl)
            {
            }
            column("Toutes_les_indications_et_mentions_portées_sur_la_présente_attestation_sont_certifiées_Caption"; Toutes_les_indications_et_mentions_portées_sur_la_présente_attestation_sont_certifiées_CaptionLbl)
            {
            }
            column(exactes_Caption; exactes_CaptionLbl)
            {
            }
            column("P_Le_GérantCaption"; P_Le_GérantCaptionLbl)
            {
            }
            column("V1__Préciser_si_à_titre_permanent_ou_temporaireCaption"; V1__Préciser_si_à_titre_permanent_ou_temporaireCaptionLbl)
            {
            }
            column(V2__Mentionner_toutes_retenues_sur_salaire_par_decision_de_justice__pension_ouCaption; V2__Mentionner_toutes_retenues_sur_salaire_par_decision_de_justice__pension_ouCaptionLbl)
            {
            }
            column("remboursement_de_prêtCaption"; remboursement_de_prêtCaptionLbl)
            {
            }
            column(Employee_No_; "No.")
            {
            }
            dataitem(DataItem9028; "Payroll Archive Line")
            {
                DataItemLink = "Employee No." = FIELD("No.");
                DataItemTableView = SORTING("Employee No.", "Payroll Code", "Item Code");
                column(Payroll_Archive_Line__Payroll_Archive_Line___Item_Description_; DataItem9028."Item Description")
                {
                }
                column(Payroll_Archive_Line__Amount__12; (DataItem9028.Amount) * 12)
                {
                }
                column(Payroll_Archive_Line__Payroll_Archive_Line__Amount; DataItem9028.Amount)
                {
                }
                column(Payroll_Archive_Line__Payroll_Archive_Line___Item_Description__Control1000000028; DataItem9028."Item Description")
                {
                }
                column(Payroll_Archive_Line_Employee_No_; "Employee No.")
                {
                }
                column(Payroll_Archive_Line_Payroll_Code; "Payroll Code")
                {
                }
                column(Payroll_Archive_Line_Item_Code; "Item Code")
                {
                }
                column(footer1; footer1)
                {
                }
                column(footer2; footer2)
                {
                }
                column(footer3; footer3)
                {
                }
                column(AfficherLigne; AfficherLigne)
                {
                }
                column(Mensuel; Mensuel)
                {
                }
                column(annuel; Annuel)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    //************************************ <CodeSection> *************************//
                    AfficherLigne := TRUE;
                    // Verifier si la rubrique n'est pas variable
                    Rubrique.GET(DataItem9028."Item Code");
                    IF Rubrique.Variable THEN
                        AfficherLigne := FALSE;

                    // Verifier si la rubrique corespond a la paie selectionée
                    IF (DataItem8955.Code <> DataItem9028."Payroll Code") THEN
                        AfficherLigne := FALSE;

                    IF (DataItem9028."Item Code" = ParamPaie."Base Salary") OR (DataItem9028."Item Code" = ParamPaie."Brut Salary") THEN
                        AfficherLigne := FALSE;

                    IF DataItem9028.Category = DataItem9028.Category::Employer THEN
                        AfficherLigne := FALSE;
                    //************************************ </CodeSection> *************************//
                end;
            }

            trigger OnAfterGetRecord();
            begin
                EmployeeFullName := DataItem7528."First Name" + ' ' + DataItem7528."Last Name";
                BirthDateAndPlace := FORMAT(DataItem7528."Birth Date") + ' à ' + DataItem7528."Birthplace City";

                IF DataItem7528.Gender = DataItem7528.Gender::Female THEN BEGIN
                    IF DataItem7528."Marital Status" = DataItem7528."Marital Status"::Married THEN BEGIN
                        Sexe := 'Madame :';
                    END
                    ELSE BEGIN
                        Sexe := 'Mademoiselle :';
                    END;
                END;

                IF DataItem7528.Gender = DataItem7528.Gender::Male THEN
                    Sexe := 'Monsieur :';

                IF DataItem7528.Gender = DataItem7528.Gender::Female THEN
                    Empl := 'Est employée au sein de notre organisme en qualité de : ';

                IF DataItem7528.Gender = DataItem7528.Gender::Male THEN
                    Sexe := 'Monsieur :';
                IF DataItem7528.Gender = DataItem7528.Gender::Male THEN
                    Empl := 'Est employé au sein de notre organisme en qualité de : ';

                footer1 := 'Au capital social de '
                            + CompanyInfo."Stock Capital"
                            + ' - '
                            + CompanyInfo.Address
                            + '  '
                            + CompanyInfo."Address 2"
                            + ' - '
                            + CompanyInfo."Trade Register";
                footer2 := 'Tél: ' + CompanyInfo."Phone No." + '&' + CompanyInfo."Phone No. 2"
                            + ' - '
                            + 'Fax: ' + CompanyInfo."Fax No."
                            + ' - Compte bancaire ' + CompanyInfo."Bank Name" + ' N° ' + CompanyInfo."Bank Account No.";
                footer3 := 'N° ART: ' + CompanyInfo."VAT Registration No."
                            + ' - ' + 'NIS & Matricule fiscal :' + CompanyInfo."Registration No.";

                //************************** <CodeSection Header1> **********************************************//
                // Tester si l'employé est permanent ou temporaire
                IF (DataItem7528."Emplymt. Contract Code" <> 'CDI') THEN
                    TypeContratEtDateRecrutement := 'Temporaire'
                ELSE
                    TypeContratEtDateRecrutement := 'Permanent';
                ;

                // Nom de l'entreprise
                NomEntreprise := CompanyInfo.Name;

                //Numero Reference
                NumRef := 'REF : N°     /SP/' + FORMAT(DATE2DMY(TODAY, 3));

                IF Mensuel THEN
                    Texte := STRSUBSTNO('Et perçoit à ce titre, une rémunération mensuelle nette, non frappée d''opposition déduction faite des rappels, primes et indemnités non permanentes et détaillées comme suit (2) :')
                ELSE
                    Texte := STRSUBSTNO('Et perçoit à ce titre, une rémunération annuelle nette, non frappée d''opposition, déduction faite des rappels, primes et indemnités non permanentes et détaillées comme suit (2) :');
                //************************** </CodeSection Header> **********************************************//


                //************************** <CodeSection Footer> **********************************************//
                // Recuper
                ParamUtilisateur.GET(USERID);
                CompanyBusinnesUnit.GET(ParamUtilisateur."Company Business Unit");
                FaitA := 'Fait à ' + CompanyBusinnesUnit."Address 2" + ' le ' + FORMAT(TODAY);
                //************************** </CodeSection Footer> **********************************************//
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
                    field(Annuel; Annuel)
                    {
                    }
                    field(Mensuel; Mensuel)
                    {
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
        // Verifier si l''utilisateur en cours et defini comme gestionnaire de Paie
        PayrollManager.RESET;
        PayrollManager.SETRANGE("User ID", USERID);
        IF NOT PayrollManager.FINDSET THEN
            ERROR(UserNotPayrollManagerErrorMsg, USERID);
        ParamPaie.GET;
    end;

    trigger OnPreReport();
    begin
        // Verifier si une Paie est selectionnée
        IF DataItem8955.GETFILTERS = '' THEN
            ERROR(NoFiltreErrorMsg);

        // Filtrer les lignes de Paie sur la Paie Selectionnée
        DataItem8955.COPYFILTER(Code, PayrollEntry."Document No.");

        // Tester si la Paie possede des lignes calculées
        IF (PayrollEntry.ISEMPTY) THEN
            ERROR(PaieNonCalculéErrorMsg, DataItem8955.Code);

        // Vérifier que un seul salarié est Selectionné
        IF (DataItem7528.GETFILTERS = '') THEN
            ERROR(NoSalariéErrorMessage);

        IF DataItem7528.COUNT > 1 THEN
            ERROR(NbSalariéErrorMsg);

        // Récuperer le logo de l'entreprise
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        CompanyInfo.CALCFIELDS("Right Logo");
    end;

    var
        EmployeeFullName: Text[100];
        BirthDateAndPlace: Text[50];
        AfficherLigne: Boolean;
        Rubrique: Record "Payroll Item";
        PayrollEntry: Record "Payroll Entry";
        NoFiltreErrorMsg: Label 'Aucune paie n''a été selectionnée';
        "PaieNonCalculéErrorMsg": Label 'La paie %1 n''est pas calculée';
        PayrollManager: Record "Payroll Manager";
        UserNotPayrollManagerErrorMsg: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        FaitA: Text[100];
        CompanyBusinnesUnit: Record "Company Business Unit";
        ParamUtilisateur: Record 91;
        TypeContratEtDateRecrutement: Text[100];
        CompanyInfo: Record 79;
        Sexe: Text[30];
        Empl: Text[100];
        footer1: Text[200];
        footer2: Text[200];
        footer3: Text[200];
        NomEntreprise: Text[50];
        NumRef: Text[50];
        "NbSalariéErrorMsg": Label 'Un seul salarié peut etre selectionnée';
        "NoSalariéErrorMessage": Label 'Aucun salarié n''a été selectionné';
        Annuel: Boolean;
        Mensuel: Boolean;
        Texte: Text[200];
        ParamPaie: Record Payroll_Setup;
        DIRECTION_DES_RESSOURCES_HUMAINESCaptionLbl: Label 'DIRECTION DES RESSOURCES HUMAINES';
        SERVICE_DU_PERSONNELCaptionLbl: Label 'SERVICE DU PERSONNEL';
        RELEVE_DES_EMOLUMENTSCaptionLbl: Label 'RELEVE DES EMOLUMENTS';
        Date_et_lieu_de_naissance__CaptionLbl: Label 'Date et lieu de naissance :';
        depuis_le___CaptionLbl: Label ', depuis le :';
        "Toutes_les_indications_et_mentions_portées_sur_la_présente_attestation_sont_certifiées_CaptionLbl": Label '"Toutes les indications et mentions portées sur la présente attestation sont certifiées "';
        exactes_CaptionLbl: Label 'exactes.';
        "P_Le_GérantCaptionLbl": Label 'P/Le Gérant';
        "V1__Préciser_si_à_titre_permanent_ou_temporaireCaptionLbl": Label '(1) Préciser si à titre permanent ou temporaire';
        V2__Mentionner_toutes_retenues_sur_salaire_par_decision_de_justice__pension_ouCaptionLbl: Label '(2) Mentionner toutes retenues sur salaire par decision de justice, pension ou';
        "remboursement_de_prêtCaptionLbl": Label 'remboursement de prêt';

}

