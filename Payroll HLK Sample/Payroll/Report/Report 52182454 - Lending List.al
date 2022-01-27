/// <summary>
/// Report Lending List (ID 51441).
/// </summary>
report 52182454 "Lending List"
{
    // version HALRHPAIE.6.1.01

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Lending List.rdl';
    Caption = 'Etat des prêts';

    dataset
    {
        dataitem(DataItem2455; Lending)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(USERID; USERID)
            {
            }
            column(Lending__No__; "No.")
            {
            }
            column(Lending__Employee_No__; "Employee No.")
            {
            }
            column(Lending__Last_Name_; "Last Name")
            {
            }
            column(Lending__Middle_Name_; "Middle Name")
            {
            }
            column(Lending__First_Name_; "First Name")
            {
            }
            column(Lending__Lending_Type_; "Lending Type")
            {
            }
            column(Lending__Lending_Amount_; "Lending Amount")
            {
            }
            column(Lending__Monthly_Amount_; "Monthly Amount")
            {
            }
            column(Lending__Previous_Refund_; "Previous Refund")
            {
            }
            column(Lending__Grant_Date_; "Grant Date")
            {
            }
            column(Lending__End_Date_; "End Date")
            {
            }
            column(Lending_Period; Period)
            {
            }
            column(Lending_Status; Status)
            {
            }
            column("Etat_des_PrêtsCaption"; Etat_des_PrêtsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column("N__PrêtCaption"; N__PrêtCaptionLbl)
            {
            }
            column(Lending__Employee_No__Caption; FIELDCAPTION("Employee No."))
            {
            }
            column(Lending__Last_Name_Caption; FIELDCAPTION("Last Name"))
            {
            }
            column(Lending__Middle_Name_Caption; FIELDCAPTION("Middle Name"))
            {
            }
            column(Lending__First_Name_Caption; FIELDCAPTION("First Name"))
            {
            }
            column(Lending__Lending_Type_Caption; FIELDCAPTION("Lending Type"))
            {
            }
            column(Lending__Lending_Amount_Caption; FIELDCAPTION("Lending Amount"))
            {
            }
            column(Lending__Monthly_Amount_Caption; FIELDCAPTION("Monthly Amount"))
            {
            }
            column(Lending__Previous_Refund_Caption; FIELDCAPTION("Previous Refund"))
            {
            }
            column(Lending__Grant_Date_Caption; FIELDCAPTION("Grant Date"))
            {
            }
            column(Lending__End_Date_Caption; FIELDCAPTION("End Date"))
            {
            }
            column(Lending_PeriodCaption; FIELDCAPTION(Period))
            {
            }
            column(Lending_StatusCaption; FIELDCAPTION(Status))
            {
            }
            column(Lending_Lending_Deduction__Capital_; "Lending Deduction (Capital)")
            {
            }
            dataitem(DataItem9028; "Payroll Archive Line")
            {
                DataItemLink = "Employee No." = FIELD("Employee No."),
                               "Item Code" = FIELD("Lending Deduction (Capital)");
                DataItemTableView = SORTING("Employee No.", "Payroll Code", "Item Code");
                column(Code_retenue; DataItem9028."Item Code")
                {
                }
                column("Montant_prêt"; Amount)
                {
                }
                column(Code_retenue_Control1000000025; "Item Description")
                {
                }
                column("Montant_prêt_Control1000000051"; "Payroll Code")
                {
                }
                column(Lending__Total_Refund_; DataItem2455."Total Refund")
                {
                }
                column(ResteAPayer; ResteAPayer)
                {
                }
                column(TotalRemboursements; TotalRemboursements)
                {
                }
                column("Retenue_prêtCaption"; Retenue_prêtCaptionLbl)
                {
                }
                column("Montant_prêtCaption"; FIELDCAPTION(Amount))
                {
                }
                column("Détail_des_retenues___Caption"; Détail_des_retenues___CaptionLbl)
                {
                }
                column(PaieCaption; PaieCaptionLbl)
                {
                }
                column("Cumul_mensualités__Caption"; Cumul_mensualités__CaptionLbl)
                {
                }
                column(Total_des_remboursements__Caption; Total_des_remboursements__CaptionLbl)
                {
                }
                column("Reste_à_payer__Caption"; Reste_à_payer__CaptionLbl)
                {
                }
                column(Payroll_Archive_Line_Employee_No_; "Employee No.")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                TotalRemboursements := "Total Refund" + "Previous Refund";
                ResteAPayer := "Lending Amount" - "Total Refund" - "Previous Refund";
            end;

            trigger OnPreDataItem();
            begin
                SETRANGE("Company Business Unit Code", CodeUnite);
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
            ERROR(Text01, USERID);
        CodeUnite := GestionnairePaie."Company Business Unit Code";
    end;

    var
        GestionnairePaie: Record "Payroll Manager";
        Text01: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        CodeUnite: Code[10];
        ResteAPayer: Decimal;
        TotalRemboursements: Decimal;
        "Etat_des_PrêtsCaptionLbl": Label 'Etat des Prêts';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        "N__PrêtCaptionLbl": Label 'N° Prêt';
        "Retenue_prêtCaptionLbl": Label 'Retenue prêt';
        "Détail_des_retenues___CaptionLbl": Label '"Détail des retenues : "';
        PaieCaptionLbl: Label 'Paie';
        "Cumul_mensualités__CaptionLbl": Label 'Cumul mensualités :';
        Total_des_remboursements__CaptionLbl: Label 'Total des remboursements :';
        "Reste_à_payer__CaptionLbl": Label 'Reste à payer :';

}

