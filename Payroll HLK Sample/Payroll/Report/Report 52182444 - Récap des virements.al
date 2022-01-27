/// <summary>
/// Report Récap des virements (ID 52182444).
/// </summary>
report 52182444 "Récap des virements"
{
    // version HALRHPAIE.6.2.00

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Récap des virements.rdl';

    dataset
    {
        dataitem(DataItem8955; Payroll)
        {
            RequestFilterFields = "Code";

            trigger OnPostDataItem();
            begin
                dat := FORMAT(DataItem8955."Ending Date", 0, 4);
                dat := COPYSTR(dat, 4, STRLEN(dat) - 3);
                IF DataItem8955.GETFILTERS <> '' THEN
                    COD.Traitement(DataItem8955.Code)
                ELSE
                    ERROR('Veuillez selectionner une paie dans l onglet paie');
            end;
        }
        dataitem(DataItem8064; "tab recap des virements")
        {
            DataItemTableView = SORTING(modepaie, "No agence")
                                ORDER(Ascending);
            column(dat; dat)
            {
            }
            column(CompanyInformation_Picture; InfoSociete.Picture)
            {
                AutoCalcField = true;
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
            column(tab_recap_des_virements__tab_recap_des_virements__NomMode; DataItem8064.NomMode)
            {
            }
            column(tab_recap_des_virements__tab_recap_des_virements___Nom_agence_; DataItem8064."Nom agence")
            {
            }
            column(tab_recap_des_virements__tab_recap_des_virements__montant; DataItem8064.montant)
            {
            }
            column(tab_recap_des_virements__tab_recap_des_virements__NomMode_Control1000000014; DataItem8064.NomMode)
            {
            }
            column(tab_recap_des_virements__tab_recap_des_virements___Nom_agence__Control1000000015; DataItem8064."Nom agence")
            {
            }
            column(tab_recap_des_virements__tab_recap_des_virements__montant_Control1000000017; DataItem8064.montant)
            {
            }
            column(tab_recap_des_virements_montant; montant)
            {
            }
            column(Mode_de_PaiementCaption; Mode_de_PaiementCaptionLbl)
            {
            }
            column(Nom_AgenceCaption; Nom_AgenceCaptionLbl)
            {
            }
            column(MontantCaption; MontantCaptionLbl)
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
            column(Total__Caption; Total__CaptionLbl)
            {
            }
            column(tab_recap_des_virements_modepaie; modepaie)
            {
            }
            column(tab_recap_des_virements_No_agence; "No agence")
            {
            }
            column(ModePaie; DataItem8064.modepaie)
            {
            }
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
        dat: Text[30];
        COD: Codeunit "cod recap des virements";
        Unite: Record "Company Business Unit";
        ParamUtilisateur: Record 91;
        InfoSociete: Record 79;
        Titre: Text[100];
        SelectionEtats: Record "HR Payroll Report Selections";
        NumReport: Integer;
        PayrollManager: Record "Payroll Manager";
        text06: Text[30];
        Mode_de_PaiementCaptionLbl: Label 'Mode de Paiement';
        Nom_AgenceCaptionLbl: Label 'Nom Agence';
        MontantCaptionLbl: Label 'Montant';
        Mois__CaptionLbl: Label 'Mois :';
        N__EmployeurCaptionLbl: Label 'N° Employeur';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Total__CaptionLbl: Label 'Total :';

}

