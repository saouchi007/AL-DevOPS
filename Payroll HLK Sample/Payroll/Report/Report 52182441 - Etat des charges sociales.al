/// <summary>
/// Report Etat des charges sociales (ID 52182441).
/// </summary>
report 52182441 "Etat des charges sociales"
{
    // version HALRHPAIE.6.1.06

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Etat des charges sociales.rdl';

    dataset
    {
        dataitem(DataItem8955; Payroll)
        {
            DataItemTableView = SORTING(Code);
            RequestFilterFields = "Code";

            trigger OnAfterGetRecord();
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
            DataItemTableView = SORTING(Numéro);
            column(dat; dat)
            {
            }
            column(Unite_Name; Unite.Name)
            {
            }
            column(Unite_Address; Unite.Address)
            {
            }
            column(Unite_City; Unite.City)
            {
            }
            column(Unite__Post_Code_; Unite."Post Code")
            {
            }
            column(Unite__Employer_SS_No__; Unite."Employer SS No.")
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
            column(Titre; Titre)
            {
            }
            column(Unite__Address_2_; Unite."Address 2")
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
            column(Tab_Recap_des_charges_sociale__Tab_Recap_des_charges_sociale__Nombre; DataItem3942.Nombre)
            {
            }
            column("Tab_Recap_des_charges_sociale__Tab_Recap_des_charges_sociale___Part_ouvrière_"; DataItem3942."Part ouvrière")
            {
            }
            column(Tab_Recap_des_charges_sociale__Tab_Recap_des_charges_sociale___Charge_patronale_; DataItem3942."Charge patronale")
            {
            }
            column(PartOuvriere; PartOuvriere)
            {
            }
            column(ChargePatronale; ChargePatronale)
            {
            }
            column(PartOuvriere_ChargePatronale; PartOuvriere + ChargePatronale)
            {
            }
            column(DescriptionLine_1_; DescriptionLine[1])
            {
            }
            column(DescriptionLine_2_; DescriptionLine[2])
            {
            }
            column(Charge_patronaleCaption; Charge_patronaleCaptionLbl)
            {
            }
            column("Part_ouvrièreCaption"; Part_ouvrièreCaptionLbl)
            {
            }
            column(NombreCaption; NombreCaptionLbl)
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
            column(Mois__Caption; Mois__CaptionLbl)
            {
            }
            column(N__EmployeurCaption; N__EmployeurCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(TotauxCaption; TotauxCaptionLbl)
            {
            }
            column("Total_généralCaption"; Total_généralCaptionLbl)
            {
            }
            column("Arrêter_le_présent_état_à_la_somme_de__Caption"; Arrêter_le_présent_état_à_la_somme_de__CaptionLbl)
            {
            }
            column("Tab_Recap_des_charges_sociale_Numéro"; Numéro)
            {
            }

            trigger OnAfterGetRecord();
            begin
                PartOuvriere := PartOuvriere + DataItem3942."Part ouvrière";
                ChargePatronale := ChargePatronale + DataItem3942."Charge patronale";
                //******************* <Code Section Footer> ************************//
                CLEAR(DescriptionLine);
                CheckReport.InitTextVariable;
                CheckReport.FormatNoText(DescriptionLine, ROUND(PartOuvriere + ChargePatronale), '');
                //******************* </Code Section Footer> ************************//
            end;

            trigger OnPreDataItem();
            begin
                PartOuvriere := 0;
                ChargePatronale := 0;
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
        EVALUATE(NumReport, COPYSTR(FORMAT(CurrReport.OBJECTID(FALSE)), 8, 100));
        IF SelectionEtats.GET(NumReport) THEN
            Titre := SelectionEtats."Report Name"
        ELSE
            Titre := CurrReport.OBJECTID(TRUE);
    end;

    trigger OnPreReport();
    begin
        InfoSociete.GET;
        InfoSociete.CALCFIELDS(Picture);
        ParamUtilisateur.GET(USERID);
        Unite.GET(ParamUtilisateur."Company Business Unit");
    end;

    var
        inf: Codeunit "Charges patronales";
        dat: Text[30];
        PartOuvriere: Decimal;
        ChargePatronale: Decimal;
        CompanyInformation: Record 79;
        Unite: Record "Company Business Unit";
        InfoSociete: Record 79;
        ParamUtilisateur: Record 91;
        Titre: Text[100];
        SelectionEtats: Record "HR Payroll Report Selections";
        NumReport: Integer;
        DescriptionLine: array[2] of Text[80];
        CheckReport: Report 1401;
        Charge_patronaleCaptionLbl: Label 'Charge patronale';
        "Part_ouvrièreCaptionLbl": Label 'Part ouvrière';
        NombreCaptionLbl: Label 'Nombre';
        TauxCaptionLbl: Label 'Taux';
        BaseCaptionLbl: Label 'Base';
        "LibelléCaptionLbl": Label 'Libellé';
        CodeCaptionLbl: Label 'Code';
        Mois__CaptionLbl: Label 'Mois :';
        N__EmployeurCaptionLbl: Label 'N° Employeur';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        TotauxCaptionLbl: Label 'Totaux';
        "Total_généralCaptionLbl": Label 'Total général';
        "Arrêter_le_présent_état_à_la_somme_de__CaptionLbl": Label 'Arrêter le présent état à la somme de :';
}

