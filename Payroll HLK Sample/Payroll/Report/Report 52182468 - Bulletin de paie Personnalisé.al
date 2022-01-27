/// <summary>
/// Report Bulletin de paie Personnalisé (ID 51559).
/// </summary>
report 52182468 "Bulletin de paie Personnalisé"
{
    // version HALRHPAIE.6.1.06

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Bulletin de paie Personnalisé.rdl';

    dataset
    {
        dataitem(DataItem8955; Payroll)
        {
            RequestFilterFields = "Code";

        }
        dataitem(DataItem7528; 5200)
        {
            RequestFilterFields = "No.", "Statistics Group Code";
            column(PayrollSetupEmployerCotisationCacobaptph; PayrollSetup."Employer Cotisation Cacobaptph")
            {
            }
            column(PayrollSetupEmployerCotisationpretbath; PayrollSetup."Employer Cotisation pretbath")
            {
            }
            column(CompanyInfoNom; CompanyInfo.Name)
            {
            }
            column(CompanyInfoAddress; CompanyInfo.Address)
            {
            }
            column(CompanyInfoCodePostal; CompanyInfo."Post Code")
            {
            }
            column(CompanyInfoVille; CompanyInfo.City)
            {
            }
            column(CompanyInfoTelephone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfoFax; CompanyInfo."Fax No.")
            {
            }
            column(CompanyInfoSiteWeb; CompanyInfo."Home Page")
            {
            }
            column(CompanyInfoAMail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfoCapital; CompanyInfo."Stock Capital")
            {
            }
            column(CompanyInfoRegistreCommerce; CompanyInfo."Trade Register")
            {
            }
            column(CompanyInfoNIF; CompanyInfo."No. IF")
            {
            }
            column(CompanyInfoAI; CompanyInfo."No. AI")
            {
            }
            column(CompanyInfoIS; CompanyInfo."No. IS")
            {
            }
            column(CompanyInfoNomBanque; CompanyInfo."Bank Name")
            {
            }
            column(CompanyInfoCompteBancaire; CompanyInfo."Bank Account No.")
            {
            }
            column(CompanyInfoNomBanque2; CompanyInfo."Bank Name 2")
            {
            }
            column(CompanyInfoCompteBancaire2; CompanyInfo."Bank Account 2 No.")
            {
            }
            column(CompanyInfo__Right_Logo_; CompanyInfo."Right Logo")
            {
                AutoCalcField = true;
            }
            column(CompanyBusinessUnit__Employer_SS_No__; CompanyBusinessUnit."Employer SS No.")
            {
            }
            column(CompanyBusinessUnit_Name; CompanyBusinessUnit.Name)
            {
            }
            column(CompanyBusinessUnit_Address; CompanyBusinessUnit.Address)
            {
            }
            column(CompanyBusinessUnit_City; CompanyBusinessUnit.City)
            {
            }
            column(CompanyBusinessUnit__Post_Code_; CompanyBusinessUnit."Post Code")
            {
            }
            column(NaDherant; CompanyBusinessUnit."Employer SS No.")
            {
            }
            column(Nom; Nom)
            {
            }
            column(CompteBancaire; CompteBancaire)
            {
            }
            column(Employee__No__; "No.")
            {
            }
            column(Employee__Function_Description_; "Job Title")
            {
            }
            column(Employee__Social_Security_No__; "Social Security No.")
            {
            }
            column("NAdhérantMutuelle"; DataItem7528."Union Membership No.")
            {
            }
            column(Structure_Description_; DataItem7528."Structure Description")
            {
            }
            column(Employee__Employment_Date_; "Employment Date")
            {
            }
            column(Employee_Employee__Marital_Status_; DataItem7528."Marital Status")
            {
            }
            column(PayrollDescription; PayrollDescription)
            {
            }
            column(code_postal_; DataItem7528.City)
            {
            }
            column(Employee_Address; Address)
            {
            }
            column(code_postal__Control1000000029; DataItem7528."Post Code")
            {
            }
            column(Employee__Address_2_; "Address 2")
            {
            }
            column(Mode_de_paiement_; DataItem7528."Payment Method Code")
            {
            }
            column(DesignationBanque; DesignationBanque)
            {
            }
            column(Employee__Payroll_Bank_Account_No__; "Payroll Bank Account No.")
            {
            }
            column(RIB_Key_; DataItem7528."RIB Key")
            {
            }
            column(Anciennete; Anciennete)
            {
                //DecimalPlaces = 0 : 0;
            }
            column(Employee_Employee__Total_Leave_Indem__No__; DataItem7528."Total Leave Indem. No.")
            {
            }
            column(TotalGain; TotalGain)
            {
            }
            column(TotalRetenueAffiche; TotalRetenueAffiche)
            {
            }
            column(TotalGain_TotalRetenue; TotalGain + TotalRetenue)
            {
            }
            column(SalaireImposable; SalaireImposable)
            {
            }
            column(SalairePoste; SalairePoste)
            {
            }
            column(SalairePoste_PayrollSetup__Employee_SS____100; SalairePoste * PayrollSetup."Employee SS %" / 100)
            {
            }
            column(SalaireBrut; SalaireBrut)
            {
            }
            column(Employee_Employee__Employer_Cotisation___; DataItem7528."Employer Cotisation %")
            {
            }
            column(PartPatronale; PartPatronale)
            {
            }
            column(Employee_Observation; Observation)
            {
            }
            column(N__EmployeurCaption; N__EmployeurCaptionLbl)
            {
            }
            column(Nom_________________Caption; Nom_________________CaptionLbl)
            {
            }
            column(Matricule________Caption; Matricule________CaptionLbl)
            {
            }
            column(FonctionCaption; FonctionCaptionLbl)
            {
            }
            column(AffectationCaption; AffectationCaptionLbl)
            {
            }
            column(Employee__Social_Security_No__Caption; FIELDCAPTION("Social Security No."))
            {
            }
            column("Date_d_entréeCaption"; Date_d_entréeCaptionLbl)
            {
            }
            column(Situation_FamilialeCaption; Situation_FamilialeCaptionLbl)
            {
            }
            column(BULLETIN_DE_PAIECaption; BULLETIN_DE_PAIECaptionLbl)
            {
            }
            column(Employee_AddressCaption; FIELDCAPTION(Address))
            {
            }
            column(Mode_de_PaiementCaption; Mode_de_PaiementCaptionLbl)
            {
            }
            column(BanqueCaption; BanqueCaptionLbl)
            {
            }
            column(N__compteCaption; N__compteCaptionLbl)
            {
            }
            column("AnciennetéCaption"; AnciennetéCaptionLbl)
            {
            }
            column("Solde_congéCaption"; Solde_congéCaptionLbl)
            {
            }
            column(N_Caption; N_CaptionLbl)
            {
            }
            column("DésignationCaption"; DésignationCaptionLbl)
            {
            }
            column(NombreCaption; NombreCaptionLbl)
            {
            }
            column(BaseCaption; BaseCaptionLbl)
            {
            }
            column(TauxCaption; TauxCaptionLbl)
            {
            }
            column(RetenueCaption; RetenueCaptionLbl)
            {
            }
            column(GainCaption; GainCaptionLbl)
            {
            }
            column(TotauxCaption; TotauxCaptionLbl)
            {
            }
            column(Salaire_netCaption; Salaire_netCaptionLbl)
            {
            }
            column(Base_IRGCaption; Base_IRGCaptionLbl)
            {
            }
            column(Base_cotisableCaption; Base_cotisableCaptionLbl)
            {
            }
            column(Cotisation_salarialeCaption; Cotisation_salarialeCaptionLbl)
            {
            }
            column(Salaire_brutCaption; Salaire_brutCaptionLbl)
            {
            }
            column(EmptyStringCaption; EmptyStringCaptionLbl)
            {
            }
            column(Part_patronaleCaption; Part_patronaleCaptionLbl)
            {
            }
            column(Employee_ObservationCaption; FIELDCAPTION(Observation))
            {
            }
            column(adresse; DataItem7528.Address)
            {
            }
            column(adresse2; DataItem7528."Address 2")
            {
            }
            column(EmployeePostCode; DataItem7528."Post Code")
            {
            }
            column(EmployeeCity; DataItem7528.City)
            {
            }
            column(MATRICULE; DataItem7528."No.")
            {
            }
            column(FunctionDescription; DataItem7528."Job Title")
            {
            }
            dataitem(DataItem6518; "Payroll Entry")
            {
                DataItemLink = "Employee No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Employee No.", "Item Code");
                column(Payroll_Entry__Item_Code_; "Item Code")
                {
                }
                column(Payroll_Entry__Item_Description_; "Item Description")
                {
                }
                column(Payroll_Entry_Number; Number)
                {
                }
                column(ABS_Basis_; ABS(Basis))
                {
                }
                column(Payroll_Entry_Rate; Rate)
                {
                }
                column(Retenue; Retenue)
                {
                }
                column(Gain; Gain)
                {
                }
                column(Taux; "DataItem6518".Rate)
                {
                }
                column(Payroll_Entry_Entry_No_; "Entry No.")
                {
                }
                column(Payroll_Entry_Employee_No_; "Employee No.")
                {
                }
                column(OptAdresse; OptAdresse)
                {
                }
                column("OptAncienneté"; OptAnciennete)
                {
                }
                column("OptSoldeCongé"; OptSoldeConge)
                {
                }
                column(OptSalaireBrut; OptSalaireBrut)
                {
                }
                column(OptSalairePoste; OptSalairePoste)
                {
                }
                column(OptPartPatronale; OptPartPatronale)
                {
                }
                column(OptObs; OptObs)
                {
                }
                column(Item; "DataItem6518"."Item Code")
                {
                }
                column(IteDescription; "DataItem6518"."Item Description")
                {
                }
                column(Number; "DataItem6518".Number)
                {
                }
                column(BaseSalaryWithoutIndemnity; PayrollSetup."Base Salary Without Indemnity")
                {
                }
                column(PostSalary; PayrollSetup."Post Salary")
                {
                }
                column(EmployerCotisation; PayrollSetup."Employer Cotisation")
                {
                }
                column(BrutSalary; PayrollSetup."Brut Salary")
                {
                }

                trigger OnAfterGetRecord();
                begin

                    //*************************** <CodeSection>*************************************************//
                    PayrollSetup.GET;
                    IF Amount < 0 THEN BEGIN
                        Gain := 0;
                        IF OptRetenueNegative THEN
                            Retenue := Amount
                        ELSE
                            Retenue := -1 * Amount;
                    END
                    ELSE BEGIN
                        IF ("Item Code" = PayrollSetup."Taxable Salary") OR ("Item Code" = PayrollSetup."Brut Salary")
                        OR ("Item Code" = 'B100') THEN BEGIN
                            Gain := 0;
                            Retenue := 0;
                        END
                        ELSE BEGIN
                            Gain := Amount;
                            Retenue := 0;
                        END;
                    END;
                    IF ("Item Code" = PayrollSetup."Base Salary") THEN
                        Basis := Gain / PayrollSetup."No. of Worked Days";
                    //*************************** </CodeSection>*************************************************//

                    IF "Document No." = DataItem8955.Code THEN BEGIN

                        IF "Item Code" = PayrollSetup."Employer Cotisation" THEN
                            PartPatronale := Amount;
                        IF "Item Code" = PayrollSetup."Brut Salary" THEN
                            SalaireBrut := Amount;
                        IF "Item Code" = PayrollSetup."Post Salary" THEN
                            SalairePoste := Amount;
                        IF "Item Code" = PayrollSetup."Taxable Salary" THEN
                            SalaireImposable := Amount;
                        IF "Item Code" = PayrollSetup."Employee SS Deduction" THEN
                            RetSS := Amount;
                    END;

                    IF (Category = "DataItem6518".Category::Employer)
                    OR ("Item Code" = PayrollSetup."Net Salary")
                    OR ("DataItem6518"."Document No." <> DataItem8955.Code) THEN
                        CurrReport.SKIP;
                    IF Amount < 0 THEN
                        TotalRetenue := TotalRetenue + Amount
                    ELSE
                        IF ("Item Code" <> PayrollSetup."Post Salary") AND ("Item Code" <> PayrollSetup."Net Salary")
                        AND ("Item Code" <> PayrollSetup."Taxable Salary") AND ("Item Code" <> PayrollSetup."Base Salary Without Indemnity")
                        AND ("Item Code" <> PayrollSetup."Employer Cotisation") AND ("Item Code" <> PayrollSetup."Brut Salary")
                        AND ("Item Code" <> 'B100') AND ("Item Code" <> PayrollSetup."Employer Cotisation Cacobaptph") AND ("Item Code" <> PayrollSetup."Employer Cotisation pretbath") THEN
                            TotalGain := TotalGain + Amount;


                    //**************************** <CodeSection2> **********************//
                    IF OptRetenueNegative THEN
                        TotalRetenueAffiche := TotalRetenue
                    ELSE
                        TotalRetenueAffiche := -1 * TotalRetenue;
                    //**************************** </CodeSection2> **********************//
                end;
            }

            trigger OnAfterGetRecord();
            begin
                IF DataItem7528."Payroll Bank Account No." <> '' THEN BEGIN
                    CompteBancaire := DataItem7528."Payroll Bank Account No." + '' + DataItem7528."RIB Key"
                END
                ELSE
                    CompteBancaire := DataItem7528."CCP N";

                IF DataItem7528."Company Business Unit Code" <> StructureCode THEN
                    CurrReport.SKIP;
                PayrollEntry.RESET;
                PayrollEntry.SETRANGE(PayrollEntry."Document No.", CodePaie);
                PayrollEntry.SETRANGE(PayrollEntry."Employee No.", "No.");
                IF PayrollEntry.ISEMPTY THEN
                    CurrReport.SKIP;
                StructureDescription := '';
                IF "Structure Code" <> '' THEN
                    IF Structure.GET("Structure Code") THEN
                        StructureDescription := Structure.Description;

                DesignationBanque := '';
                IF (Banque.GET("Payroll Bank Account")) AND ("Payroll Bank Account" <> '')
                THEN
                    DesignationBanque := Banque.Name;

                //**************************** <CodeSection2> **********************//
                TotalGain := 0;
                TotalRetenue := 0;
                Anciennete := FORMAT((TODAY - "Employment Date") DIV 360) + ' ans et ' + FORMAT(((TODAY - "Employment Date") DIV 30) MOD 12) + ' mois';
                Nom := "Last Name" + ' ' + "First Name";
                //**************************** </CodeSection2> **********************//
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Optiions)
                {
                    field(Adresse; OptAdresse)
                    {
                    }
                    field("Solde Congé"; OptSoldeConge)
                    {
                    }
                    field("Ancienneté"; OptAnciennete)
                    {
                    }
                    field("Retenue En Positif"; OptRetenueNegative)
                    {
                    }
                    field("Salaire Brut"; OptSalaireBrut)
                    {
                    }
                    field("Salaire De Poste"; OptSalairePoste)
                    {
                    }
                    field("Part patronale"; OptPartPatronale)
                    {
                    }
                    field(Observation; OptObs)
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

        PayrollManager.RESET;
        PayrollManager.SETRANGE("User ID", USERID);
        IF NOT PayrollManager.FINDSET THEN
            ERROR(Text06, USERID);
    end;

    trigger OnPreReport();
    begin
        PayrollSetup.GET;

        IF DataItem8955.GETFILTERS = '' THEN
            ERROR(Text01);
        Payroll2.COPYFILTERS(DataItem8955);
        DataItem8955.COPYFILTER(Code, PayrollEntry."Document No.");
        Payroll2.FINDFIRST;
        CodePaie := Payroll2.Code;
        PayrollDescription := Payroll2.Description;
        IF PayrollEntry.ISEMPTY THEN
            ERROR(Text07, CodePaie);
        StructureCode := Payroll2."Company Business Unit Code";
        IF StructureCode = '' THEN
            ERROR(Text08, CodePaie);
        PayrollManager.RESET;
        PayrollManager.SETRANGE("User ID", USERID);
        PayrollManager.SETRANGE("Company Business Unit Code", StructureCode);
        IF NOT PayrollManager.FINDSET THEN
            ERROR(Text03, USERID, CodePaie);
        Employee2.RESET;
        DataItem7528.COPYFILTER("No.", Employee2."No.");
        Employee2.SETRANGE(Employee2."Company Business Unit Code", StructureCode);
        Employee2.SETRANGE(Status, Employee2.Status::Active);
        ParamCompta.GET;
        IF Employee2.FINDSET(FALSE, FALSE) THEN
            REPEAT
                IF ParamCompta."Shortcut Dimension 7 Code" <> '' THEN
                    Employee2.TESTFIELD(Employee2."Global Dimension 1 Code");
                IF ParamCompta."Shortcut Dimension 8 Code" <> '' THEN
                    Employee2.TESTFIELD(Employee2."Global Dimension 2 Code");
            UNTIL Employee2.NEXT = 0
        ELSE
            ERROR(Text02, StructureCode);
        CompanyBusinessUnit.GET(StructureCode);
        BusinessUnitDescription := CompanyBusinessUnit.Code + ' - ' + CompanyBusinessUnit.Name;
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        CompanyInfo.CALCFIELDS("Right Logo");
        "EmployerSSNo." := CompanyInfo."Employer SS No.";
        TauxPartPatronale := '[' + FORMAT(Employee2."Employer Cotisation %") + ' %]';
    end;

    var
        Text01: Label 'Code de paie manquant !';
        Text02: Label 'Aucun salarié n''est affecté à la direction %1 !';
        Text04: Label 'A Monsieur le Directeur de :';
        Text05: Label 'Code de direction non configuré dans la table des gestionnaires de paie pour l''utilisateur %1 !';
        Text06: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        Text07: Label 'Paie %1 non encore calculée  !';
        Text08: Label 'Code de direction manquant pour la paie %1 !';
        Banque: Record "Payroll Bank Account";
        DesignationBanque: Text[50];
        PayrollManager: Record "Payroll Manager";
        StructureCode: Code[10];
        Payroll2: Record Payroll;
        CodePaie: Code[20];
        PayrollEntry: Record "Payroll Entry";
        //"DataItem6518": Record "Payroll Entry";
        //Payroll: Record Payroll;
        Employee2: Record 5200;
        //Employee: Record 5200;
        CompanyBusinessUnit: Record "Company Business Unit";
        BusinessUnitDescription: Text[50];
        CompanyInfo: Record 79;
        PayrollDescription: Text[60];
        "EmployerSSNo.": Text[30];
        PayrollSetup: Record Payroll_Setup;
        StructureDescription: Text[50];
        Structure: Record Structure;
        TotalGain: Decimal;
        TotalRetenue: Decimal;
        SalairePoste: Decimal;
        PartPatronale: Decimal;
        TauxPartPatronale: Text[30];
        OptAdresse: Boolean;
        OptAnciennete: Boolean;
        OptSoldeConge: Boolean;
        OptRetenueNegative: Boolean;
        Anciennete: Text[30];
        Gain: Decimal;
        Retenue: Decimal;
        TotalRetenueAffiche: Decimal;
        Text03: Label 'L''utilisateur %1 n''est pas autorisé à calculer la paie %2 !';
        SituationF: Integer;
        SituationFM: Text[30];
        "SoldeCongé": Decimal;
        ParamCompta: Record 98;
        SalaireBrut: Decimal;
        OptSalaireBrut: Boolean;
        OptSalairePoste: Boolean;
        OptPartPatronale: Boolean;
        OptObs: Boolean;
        SalaireImposable: Decimal;
        RetSS: Decimal;
        Nom: Text[100];
        N__EmployeurCaptionLbl: Label 'N° Employeur';
        Nom_________________CaptionLbl: Label '"Nom                 "';
        Matricule________CaptionLbl: Label '"Matricule        "';
        FonctionCaptionLbl: Label 'Fonction';
        AffectationCaptionLbl: Label 'Affectation';
        "Date_d_entréeCaptionLbl": TextConst ENU = 'Date d''entrée', FRA = 'Date D''entrée ';
        Situation_FamilialeCaptionLbl: Label 'Situation Familiale';
        BULLETIN_DE_PAIECaptionLbl: Label 'BULLETIN DE PAIE';
        Mode_de_PaiementCaptionLbl: Label 'Mode de Paiement';
        BanqueCaptionLbl: Label 'Banque';
        N__compteCaptionLbl: Label 'N° compte';
        "AnciennetéCaptionLbl": Label 'Ancienneté';
        "Solde_congéCaptionLbl": Label 'Solde congé';
        N_CaptionLbl: Label 'N°';
        "DésignationCaptionLbl": Label 'Désignation';
        NombreCaptionLbl: Label 'Nombre';
        BaseCaptionLbl: Label 'Base';
        TauxCaptionLbl: Label 'Taux';
        RetenueCaptionLbl: Label 'Retenue';
        GainCaptionLbl: Label 'Gain';
        TotauxCaptionLbl: Label 'Totaux';
        Salaire_netCaptionLbl: Label 'Salaire net';
        Base_IRGCaptionLbl: Label 'Base IRG';
        Base_cotisableCaptionLbl: Label 'Base cotisable';
        Cotisation_salarialeCaptionLbl: Label 'Cotisation salariale';
        Salaire_brutCaptionLbl: Label 'Salaire brut';
        EmptyStringCaptionLbl: Label '%';
        Part_patronaleCaptionLbl: Label 'Part patronale';
        CompteBancaire: Text;

}

