/// <summary>
/// Report Etat de paiement (ID 52182445).
/// </summary>
report 52182445 "Etat de paiement"
{
    // version HALRHPAIE.6.2.00

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Etat de paiement.rdl';

    dataset
    {
        dataitem(DataItem8955; Payroll)
        {
            DataItemTableView = SORTING(Code);
            RequestFilterFields = "Code";
            column(mode; mode)
            {
            }
            column(dat; dat)
            {
            }
            column(CompanyInformation_Picture; InfoSociete.Picture)
            {
                AutoCalcField = true;
            }
            column(Unite_Name; Unite.Name)
            {
            }
            column(Unite_Address; Unite.Address)
            {
            }
            column(Unite__Employer_SS_No__; Unite."Employer SS No.")
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
            column(mode_de_paiement__Caption; mode_de_paiement__CaptionLbl)
            {
            }
            column(Mois__Caption; Mois__CaptionLbl)
            {
            }
            column(MatriculeCaption; MatriculeCaptionLbl)
            {
            }
            column(Nom_PrenomCaption; Nom_PrenomCaptionLbl)
            {
            }
            column(MontantCaption; MontantCaptionLbl)
            {
            }
            column(EmargementCaption; EmargementCaptionLbl)
            {
            }
            column(N__EmployeurCaption; N__EmployeurCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Payroll_Code; Code)
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF DataItem8955.GETFILTERS = '' THEN
                    ERROR('Code paie manquant')
                ELSE BEGIN
                    dat := FORMAT(DataItem8955."Ending Date", 0, 4);
                    dat := COPYSTR(dat, 4, STRLEN(dat) - 3);
                    codEtatdepaiement.traitement(DataItem8955.Code, FORMAT(mode), montant1);
                END;
            end;

            trigger OnPreDataItem();
            begin
                CompanyInformation.GET;
            end;
        }
        dataitem(DataItem2689; "Tab Etat de paiement")
        {
            DataItemTableView = SORTING(matricule)
                                ORDER(Ascending);
            column(Tab_Etat_de_paiement__Tab_Etat_de_paiement__Montant; DataItem2689.Montant)
            {
            }
            column(Tab_Etat_de_paiement__Tab_Etat_de_paiement__Nomprenoms; DataItem2689.Nomprenom)
            {
            }
            column(Tab_Etat_de_paiement__Tab_Etat_de_paiement__matricule; DataItem2689.matricule)
            {
            }
            column(montant1; montant1)
            {
            }
            column(Total_GeneralCaption; Total_GeneralCaptionLbl)
            {
            }
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
                    field(mode; mode)
                    {
                        Caption = 'Mode de paiement :';
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
            ERROR(text06, USERID);
    end;

    trigger OnPreReport();
    begin
        InfoSociete.GET;
        InfoSociete.CALCFIELDS(Picture);
        ParamUtilisateur.GET(USERID);
        Unite.GET(ParamUtilisateur."Company Business Unit");
    end;

    var
        codEtatdepaiement: Codeunit "cod Etat de paiement";
        mode: Option ESPECE,CHEQUE;
        montant1: Decimal;
        dat: Text[30];
        Unite: Record "Company Business Unit";
        ParamUtilisateur: Record 91;
        InfoSociete: Record 79;
        CompanyInformation: Record 79;
        Titre: Text[100];
        SelectionEtats: Record "HR Payroll Report Selections";
        NumReport: Integer;
        PayrollManager: Record "Payroll Manager";
        text06: Text[30];
        mode_de_paiement__CaptionLbl: Label 'mode de paiement :';
        Mois__CaptionLbl: Label 'Mois :';
        MatriculeCaptionLbl: Label 'Matricule';
        Nom_PrenomCaptionLbl: Label 'Nom Prenom';
        MontantCaptionLbl: Label 'Montant';
        EmargementCaptionLbl: Label 'Emargement';
        N__EmployeurCaptionLbl: Label 'N° Employeur';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Total_GeneralCaptionLbl: Label 'Total General';

}

