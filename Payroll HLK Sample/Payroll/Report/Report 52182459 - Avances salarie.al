report 51452 "Avances salarie"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Avances salarie.rdl';

    dataset
    {
        dataitem(DataItem3093; "Employee Advance")
        {
            DataItemTableView = SORTING("Employee Structure Code", "Groupe Statistique");
            RequestFilterFields = "Employee Structure Code", "Groupe Statistique", "Employee No.", "Advance Date";
            column(Mois; Mois)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(Employee_Advance__Employee_Structure_Code_; "Employee Structure Code")
            {
            }
            column(Employee_Advance__Employee_Structure_Description_; "Employee Structure Description")
            {
            }
            column(Employee_Advance__Employee_No__; "Employee No.")
            {
            }
            column(Employee_Advance_Description; Description)
            {
            }
            column(Employee_Advance_Amount; Amount)
            {
            }
            column(Employee_Advance__Groupe_Statistique_; "Groupe Statistique")
            {
            }
            column(Employee_Advance__Employee_Structure_Description__Control1000000032; "Employee Structure Description")
            {
            }
            column(Nom; Nom)
            {
            }
            column(LineNumber; LineNumber)
            {
            }
            column(Employee_Advance_Amount_Control1000000035; Amount)
            {
            }
            column(TotalFor___FIELDCAPTION__Employee_Structure_Code__; TotalFor + FIELDCAPTION("Employee Structure Code"))
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(Employee_AdvanceCaption; Employee_AdvanceCaptionLbl)
            {
            }
            column(SARL_Laiterie_SOUMMAMCaption; SARL_Laiterie_SOUMMAMCaptionLbl)
            {
            }
            column(Direction_des_Ressources_HumainesCaption; Direction_des_Ressources_HumainesCaptionLbl)
            {
            }
            column(Service_du_PersonnelCaption; Service_du_PersonnelCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Employee_Advance__Employee_No__Caption; FIELDCAPTION("Employee No."))
            {
            }
            column("Nom_PrénomCaption"; Nom_PrénomCaptionLbl)
            {
            }
            column(Employee_Advance_DescriptionCaption; FIELDCAPTION(Description))
            {
            }
            column(Employee_Advance_AmountCaption; FIELDCAPTION(Amount))
            {
            }
            column(Employee_Advance__Groupe_Statistique_Caption; FIELDCAPTION("Groupe Statistique"))
            {
            }
            column(Employee_Advance__Employee_Structure_Description__Control1000000032Caption; FIELDCAPTION("Employee Structure Description"))
            {
            }
            column(EmargementCaption; EmargementCaptionLbl)
            {
            }
            column(N_Caption; N_CaptionLbl)
            {
            }
            column(Employee_Advance__Employee_Structure_Code_Caption; FIELDCAPTION("Employee Structure Code"))
            {
            }
            column(Akbou_le__Caption; Akbou_le__CaptionLbl)
            {
            }
            column(Le_responsable_hierarchique__Caption; Le_responsable_hierarchique__CaptionLbl)
            {
            }
            column(Employee_Advance_Entry_No_; "Entry No.")
            {
            }

            trigger OnPreDataItem();
            begin
                LastFieldNo := FIELDNO("Employee Structure Code");
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

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: Label '"Total "';
        Nom: Text[40];
        Mois: Text[30];
        Payroll: Record Payroll;
        LineNum: Integer;
        LineNumber: Text[30];
        Employee_AdvanceCaptionLbl: TextConst ENU = 'Employee Advance', FRA = 'ETAT DES AVANCES';
        SARL_Laiterie_SOUMMAMCaptionLbl: Label 'SARL Laiterie SOUMMAM';
        Direction_des_Ressources_HumainesCaptionLbl: Label 'Direction des Ressources Humaines';
        Service_du_PersonnelCaptionLbl: Label 'Service du Personnel';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        "Nom_PrénomCaptionLbl": Label 'Nom Prénom';
        EmargementCaptionLbl: Label 'Emargement';
        N_CaptionLbl: Label 'N°';
        Akbou_le__CaptionLbl: Label 'Akbou le :';
        Le_responsable_hierarchique__CaptionLbl: Label 'Le responsable hierarchique :';
}

