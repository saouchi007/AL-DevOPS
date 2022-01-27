/// <summary>
/// Report Etat cotisations patronales (ID 52182442).
/// </summary>
report 52182442 "Etat cotisations patronales"
{
    // version HALRHPAIE.6.1.05

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Etat cotisations patronales.rdl';

    dataset
    {
        dataitem(DataItem8955; Payroll)
        {
            DataItemTableView = SORTING(Code);
            RequestFilterFields = "Code";

            trigger OnPostDataItem();
            begin
                IF DataItem8955.GETFILTERS = '' THEN
                    ERROR('Code paie manquant');

                inf.Traitement(DataItem8955.Code);
                dat := FORMAT(DataItem8955."Ending Date", 0, 4);
                dat := COPYSTR(dat, 4, STRLEN(dat) - 3);
            end;
        }
        dataitem(DataItem3942; "Tab Recap des charges sociale")
        {
            DataItemTableView = SORTING(Taux);
            column(dat; dat)
            {
            }
            column(TODAY; TODAY)
            {
            }
            column(unite__Employer_SS_No__; unite."Employer SS No.")
            {
            }
            column(unite_Address; unite.Address)
            {
            }
            column(unite_Name; unite.Name)
            {
            }
            column(unite__Post_Code_; unite."Post Code")
            {
            }
            column(unite_City; unite.City)
            {
            }
            column(unite__Address_2_; unite."Address 2")
            {
            }
            column(Tab_Recap_des_charges_sociale__Tab_Recap_des_charges_sociale__Rubrique; DataItem3942.Rubrique)
            {
            }
            column("Tab_Recap_des_charges_sociale__Tab_Recap_des_charges_sociale__Désignation"; DataItem3942.Désignation)
            {
            }
            column(Tab_Recap_des_charges_sociale__Tab_Recap_des_charges_sociale__Base; DataItem3942.Base)
            {
            }
            column(Tab_Recap_des_charges_sociale__Tab_Recap_des_charges_sociale__Taux; DataItem3942.Taux)
            {
                DecimalPlaces = 0 : 0;
            }
            column(Tab_Recap_des_charges_sociale__Tab_Recap_des_charges_sociale___Charge_patronale_; DataItem3942."Charge patronale")
            {
            }
            column(payrollitem__Account_No__; payrollitem."Account No.")
            {
            }
            column(Tab_Recap_des_charges_sociale_Nombre; Nombre)
            {
                // DecimalPlaces = 0:0;
            }
            column(MontantCaption; MontantCaptionLbl)
            {
            }
            column(TauxCaption; TauxCaptionLbl)
            {
            }
            column(BaseCaption; BaseCaptionLbl)
            {
            }
            column("LibelléCaption"; LibelléCaptionLbl)
            {
            }
            column(CodeCaption; CodeCaptionLbl)
            {
            }
            column(ETAT_DES_COTISATIONS_PATRONALESCaption; ETAT_DES_COTISATIONS_PATRONALESCaptionLbl)
            {
            }
            column(Mois__Caption; Mois__CaptionLbl)
            {
            }
            column(N__CompteCaption; N__CompteCaptionLbl)
            {
            }
            column(N__SS_EmployeurCaption; N__SS_EmployeurCaptionLbl)
            {
            }
            column(NbreCaption; NbreCaptionLbl)
            {
            }
            column("Tab_Recap_des_charges_sociale_Numéro"; Numéro)
            {
            }

            trigger OnAfterGetRecord();
            begin
                Ov := Ov + DataItem3942."Part ouvrière";
                Cp := Cp + DataItem3942."Charge patronale";

                //********** <Code Section 1> ************/
                CompanyInformation.GET;
                //********** </Code Section 1> ************/

                payrollitem.GET(DataItem3942.Rubrique);
            end;

            trigger OnPreDataItem();
            begin
                Ov := 0;
                Cp := 0;
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


    trigger OnPreReport();
    begin
        InfoSociete.GET;
        InfoSociete.CALCFIELDS(Picture);
        ParamUtilisateur.GET(USERID);
        unite.GET(ParamUtilisateur."Company Business Unit");
        InfoSociete.CALCFIELDS(Picture);
    end;

    var
        inf: Codeunit "Charges patronales";
        dat: Text[30];
        Ov: Decimal;
        Cp: Decimal;
        payrollitem: Record "Payroll Item";
        CompanyInformation: Record 79;
        InfoSociete: Record 79;
        unite: Record "Company Business Unit";
        ParamUtilisateur: Record 91;
        MontantCaptionLbl: Label 'Montant';
        TauxCaptionLbl: Label 'Taux';
        BaseCaptionLbl: Label 'Base';
        "LibelléCaptionLbl": Label 'Libellé';
        CodeCaptionLbl: Label 'Code';
        ETAT_DES_COTISATIONS_PATRONALESCaptionLbl: Label 'ETAT DES COTISATIONS PATRONALES';
        Mois__CaptionLbl: Label 'Mois :';
        N__CompteCaptionLbl: Label 'N° Compte';
        N__SS_EmployeurCaptionLbl: Label 'N° SS Employeur';
        NbreCaptionLbl: Label 'Nbre';
}

