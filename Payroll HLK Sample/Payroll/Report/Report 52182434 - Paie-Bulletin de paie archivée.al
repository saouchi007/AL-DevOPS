/// <summary>
/// Report Paie-Bulletin de paie archivée (ID 52182434).
/// </summary>
report 52182434 "Paie-Bulletin de paie archivée"
{
    // version HALRHPAIE.6.1.01

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Paie-Bulletin de paie archivée.rdl';

    dataset
    {
        dataitem(DataItem4144; "Payroll Archive Header")
        {
            RequestFilterFields = "No.";
            column(CompanyInfo__Right_Logo_; CompanyInfo."Right Logo")
            {
                AutoCalcField = true;
            }
            column(CompanyBusinessUnit__Employer_SS_No__; CompanyBusinessUnit."Employer SS No.")
            {
            }
            column(CompanyBusinessUnit_City; CompanyBusinessUnit.City)
            {
            }
            column(CompanyBusinessUnit__Post_Code_; CompanyBusinessUnit."Post Code")
            {
            }
            column(CompanyBusinessUnit_Address; CompanyBusinessUnit.Address)
            {
            }
            column(CompanyBusinessUnit_Name; CompanyBusinessUnit.Name)
            {
            }
            column(Payroll_Archive_Header__Marital_Status_; "Marital Status")
            {
            }
            column(Payroll_Archive_Header__Social_Security_No__; "Social Security No.")
            {
            }
            column(Payroll_Archive_Header__Employment_Date_; "Employment Date")
            {
            }
            column(Structure_Description_; "Structure Description")
            {
            }
            column(Payroll_Archive_Header__Function_Description_; "Function Description")
            {
            }
            column(PayrollDescription; PayrollDescription)
            {
            }
            column(Nom; Nom)
            {
            }
            column(Payroll_Archive_Header__No__; "No.")
            {
            }
            column(code_postal_; Employee2.City)
            {
            }
            column(Payroll_Archive_Header_Address; Address)
            {
            }
            column(code_postal__Control1000000079; Employee2."Post Code")
            {
            }
            column(Payroll_Archive_Header__Address_2_; "Address 2")
            {
            }
            column(Mode_de_paiement_; Employee2."Payment Method Code")
            {
            }
            column(RIB_Key_; "RIB Key")
            {
            }
            column(Payroll_Archive_Header__Payroll_Bank_Account_No__; "Payroll Bank Account No.")
            {
            }
            column(TotalGain_TotalRetenue; TotalGain + TotalRetenue)
            {
            }
            column(TotalGain; TotalGain)
            {
            }
            column(TotalRetenue; TotalRetenue)
            {
            }
            column(TotalRetenueAffiche; TotalRetenueAffiche)
            {
            }
            column(N__EmployeurCaption; N__EmployeurCaptionLbl)
            {
            }
            column(Situation_FamilialeCaption; Situation_FamilialeCaptionLbl)
            {
            }
            column(Payroll_Archive_Header__Social_Security_No__Caption; FIELDCAPTION("Social Security No."))
            {
            }
            column("Date_d_entréeCaption"; Date_d_entréeCaptionLbl)
            {
            }
            column(AffectationCaption; AffectationCaptionLbl)
            {
            }
            column(FonctionCaption; FonctionCaptionLbl)
            {
            }
            column(Nom_________________Caption; Nom_________________CaptionLbl)
            {
            }
            column(BULLETIN_DE_PAIECaption; BULLETIN_DE_PAIECaptionLbl)
            {
            }
            column(Matricule________Caption; Matricule________CaptionLbl)
            {
            }
            column(DUPLICATACaption; DUPLICATACaptionLbl)
            {
            }
            column(Payroll_Archive_Header_AddressCaption; FIELDCAPTION(Address))
            {
            }
            column(Mode_de_PaiementCaption; Mode_de_PaiementCaptionLbl)
            {
            }
            column(N__compteCaption; N__compteCaptionLbl)
            {
            }
            column(GainCaption; GainCaptionLbl)
            {
            }
            column(RetenueCaption; RetenueCaptionLbl)
            {
            }
            column(TauxCaption; TauxCaptionLbl)
            {
            }
            column(BaseCaption; BaseCaptionLbl)
            {
            }
            column(NombreCaption; NombreCaptionLbl)
            {
            }
            column("DésignationCaption"; DésignationCaptionLbl)
            {
            }
            column(N_Caption; N_CaptionLbl)
            {
            }
            column(Salaire_netCaption; Salaire_netCaptionLbl)
            {
            }
            column(TotauxCaption; TotauxCaptionLbl)
            {
            }
            column(Payroll_Archive_Header_Payroll_Code; "Payroll Code")
            {
            }
            column(OptAdresse__________________________________1; OptAdresse)
            {
            }
            dataitem(DataItem9028; "Payroll Archive Line")
            {
                DataItemLink = "Employee No." = FIELD("No.");
                DataItemTableView = SORTING("Employee No.", "Payroll Code", "Item Code");
                column(Gain; Gain)
                {
                }
                column(Retenue; Retenue)
                {
                }
                column(Payroll_Archive_Line_Rate; Rate)
                {
                }
                column(ABS_Basis_; ABS(Basis))
                {
                }
                column(Payroll_Archive_Line_Number; Number)
                {
                }
                column(Payroll_Archive_Line__Item_Description_; "Item Description")
                {
                }
                column(Payroll_Archive_Line__Item_Code_; "Item Code")
                {
                }
                column(Payroll_Archive_Line_Employee_No_; "Employee No.")
                {
                }
                column(Payroll_Archive_Line_Payroll_Code; "Payroll Code")
                {
                }
                column(BSWI_______________________________________________6; PayrollSetup."Base Salary Without Indemnity")
                {
                }
                column(PostSalary; PayrollSetup."Post Salary")
                {
                }
                column(ECotisation; PayrollSetup."Employer Cotisation")
                {
                }

                trigger OnAfterGetRecord();
                begin

                    PayrollSetup.GET;
                    CurrReport.SHOWOUTPUT(("Item Code" <> PayrollSetup."Base Salary Without Indemnity")
                    AND ("Item Code" <> PayrollSetup."Post Salary") AND ("Item Code" <> PayrollSetup."Employer Cotisation")
                    AND ("Item Code" <> PayrollSetup."Brut Salary"));
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

                    IF "Item Code" = PayrollSetup."Employer Cotisation" THEN
                        PartPatronale := Amount;
                    IF "Item Code" = PayrollSetup."Post Salary" THEN
                        SalairePoste := Amount;
                    IF (Category = Category::Employer)
                    OR ("Item Code" = PayrollSetup."Net Salary")
                    OR ("Item Code" = PayrollSetup."Brut Salary")
                    OR ("Item Code" = PayrollSetup."Employer Cotisation")
                    OR ("Payroll Code" <> CodePaie) THEN
                        CurrReport.SKIP;
                    IF Amount < 0 THEN
                        TotalRetenue := TotalRetenue + Amount
                    ELSE
                        IF ("Item Code" <> PayrollSetup."Post Salary") AND ("Item Code" <> PayrollSetup."Net Salary")
                        AND ("Item Code" <> PayrollSetup."Taxable Salary") AND ("Item Code" <> PayrollSetup."Base Salary Without Indemnity")
                        AND ("Item Code" <> PayrollSetup."Employer Cotisation") AND ("Item Code" <> PayrollSetup."Brut Salary")
                        AND ("Item Code" <> 'B100') THEN
                            TotalGain := TotalGain + Amount;
                end;
            }

            trigger OnAfterGetRecord();
            begin

                TotalGain := 0;
                TotalRetenue := 0;
                Nom := Employee2."Last Name" + ' ' + Employee2."First Name";
                Anciennete := FORMAT((TODAY - "Employment Date") DIV 360) + ' ans et ' + FORMAT(((TODAY - "Employment Date") DIV 30) MOD 12) + ' mois';


                IF "Company Business Unit Code" <> CodeDirection THEN
                    CurrReport.SKIP;
                LignePaieArchive.RESET;
                LignePaieArchive.SETRANGE("Payroll Code", CodePaie);
                LignePaieArchive.SETRANGE("Employee No.", "No.");
                IF LignePaieArchive.ISEMPTY THEN
                    CurrReport.SKIP;
                StructureDescription := '';
                IF "Structure Code" <> '' THEN
                    IF Structure.GET("Structure Code") THEN
                        StructureDescription := Structure.Description;
                Salarie.GET("No.");
                Salarie.CALCFIELDS("Total Leave Indem. No.");
                SoldeCongeNbre := Salarie."Total Leave Indem. No.";
            end;

            trigger OnPreDataItem();
            begin

                IF OptRetenueNegative THEN
                    TotalRetenueAffiche := TotalRetenue
                ELSE
                    TotalRetenueAffiche := -1 * TotalRetenue;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    field(OptAdresse; OptAdresse)
                    {
                        Caption = 'Adresse';
                    }
                    field(OptDateEntree; OptDateEntree)
                    {
                        Caption = 'Date d''entrée';
                    }
                    field(OptAnciennete; OptAnciennete)
                    {
                        Caption = 'Ancienneté';
                    }
                    field(OptRetenueNegative; OptRetenueNegative)
                    {
                        Caption = 'Retenues en positif';
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
        "Payroll Archive Header".COPYFILTER("Payroll Code", EntetePaieArchive."Payroll Code");
        EntetePaieArchive.FINDFIRST;
        CodePaie := EntetePaieArchive."Payroll Code";
        Paie.GET(CodePaie);
        PayrollDescription := Paie.Description;
        CodeDirection := Paie."Company Business Unit Code";
        IF CodeDirection = '' THEN
            ERROR(Text08, CodePaie);
        PayrollManager.RESET;
        PayrollManager.SETRANGE("User ID", USERID);
        PayrollManager.SETRANGE("Company Business Unit Code", CodeDirection);
        IF NOT PayrollManager.FINDSET THEN
            ERROR(Text03, USERID, CodePaie);
        Employee2.RESET;
        "Payroll Archive Header".COPYFILTER("No.", Employee2."No.");
        Employee2.SETRANGE(Employee2."Company Business Unit Code", CodeDirection);
        ParamCompta.GET;
        IF Employee2.FINDSET(FALSE, FALSE) THEN
            REPEAT
                IF ParamCompta."Global Dimension 1 Code" <> '' THEN
                    Employee2.TESTFIELD(Employee2."Global Dimension 1 Code");
                IF ParamCompta."Global Dimension 2 Code" <> '' THEN
                    Employee2.TESTFIELD(Employee2."Global Dimension 2 Code");
            UNTIL Employee2.NEXT = 0
        ELSE
            ERROR(Text02, CodeDirection);
        CompanyBusinessUnit.GET(CodeDirection);
        BusinessUnitDescription := CompanyBusinessUnit.Code + ' - ' + CompanyBusinessUnit.Name;
        NumSSEmployeur := CompanyBusinessUnit."Employer SS No.";
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS("Right Logo");
        "EmployerSSNo." := CompanyInfo."Employer SS No.";
        TauxPartPatronale := '[' + FORMAT(PayrollSetup."Employer Cotisation %") + ' %]';
    end;

    var
        Text01: Label 'Code de paie manquant !';
        Text02: Label 'Aucun salarié n''est affecté à la direction %1 !';
        Text04: Label 'A Monsieur le Directeur de :';
        Text05: Label 'Code de direction non configuré dans la table des gestionnaires de paie pour l''utilisateur %1 !';
        Text06: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        Text08: Label 'Code de direction manquant pour la paie %1 !';
        PayrollManager: Record "Payroll Manager";
        CodeDirection: Code[10];
        CodePaie: Code[20];
        Employee2: Record 5200;
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
        OptDateEntree: Boolean;
        OptRetenueNegative: Boolean;
        Anciennete: Text[30];
        Gain: Decimal;
        Retenue: Decimal;
        TotalRetenueAffiche: Decimal;
        Text03: Label 'L''utilisateur %1 n''est pas autorisé à calculer la paie %2 !';
        EntetePaieArchive: Record "Payroll Archive Header";
        LignePaieArchive: Record "Payroll Archive Line";
        Paie: Record Payroll;
        ParamCompta: Record 98;
        NumSSEmployeur: Text[30];
        SoldeCongeNbre: Decimal;
        Salarie: Record 5200;
        Nom: Text[200];
        N__EmployeurCaptionLbl: Label 'N° Employeur';
        Situation_FamilialeCaptionLbl: Label 'Situation Familiale';
        "Date_d_entréeCaptionLbl": TextConst ENU = 'Date d''entrée', FRA = 'Date D''entrée ';
        AffectationCaptionLbl: Label 'Affectation';
        FonctionCaptionLbl: Label 'Fonction';
        Nom_________________CaptionLbl: Label '"Nom                 "';
        BULLETIN_DE_PAIECaptionLbl: Label 'BULLETIN DE PAIE';
        Matricule________CaptionLbl: Label '"Matricule        "';
        DUPLICATACaptionLbl: Label 'DUPLICATA';
        Mode_de_PaiementCaptionLbl: Label 'Mode de Paiement';
        N__compteCaptionLbl: Label 'N° compte';
        GainCaptionLbl: Label 'Gain';
        RetenueCaptionLbl: Label 'Retenue';
        TauxCaptionLbl: Label 'Taux';
        BaseCaptionLbl: Label 'Base';
        NombreCaptionLbl: Label 'Nombre';
        "DésignationCaptionLbl": Label 'Désignation';
        N_CaptionLbl: Label 'N°';
        Salaire_netCaptionLbl: Label 'Salaire net';
        TotauxCaptionLbl: Label 'Totaux';
        "Payroll Archive Header": Record "Payroll Archive Header";

}

