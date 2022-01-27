/// <summary>
/// Report Rembours.-Accusé de réception (ID 51396).
/// </summary>
report 52182427 "Rembours.-Accusé de réception"
{
    // version HALRHPAIE.6.1.01

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Rembours.-Accusé de réception.rdl';

    dataset
    {
        dataitem(DataItem7730; "Medical Refund Header")
        {
            DataItemTableView = WHERE("Document Type" = CONST(Blank));
            RequestFilterFields = "No.";
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
                AutoCalcField = true;
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(CompanyInfo_Address; CompanyInfo.Address)
            {
            }
            column(CompanyInfo__Address_2_; CompanyInfo."Address 2")
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(USERID; USERID)
            {
            }
            column(Medical_Refund_Header__No__; "No.")
            {
            }
            column(DescriptionLine_2_; DescriptionLine[2])
            {
            }
            column(DescriptionLine_1_; DescriptionLine[1])
            {
            }
            column(TotalAmount; TotalAmount)
            {
            }
            column(ACCUSE_DE_RECEPTIONCaption; ACCUSE_DE_RECEPTIONCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Medical_Refund_Header__No__Caption; FIELDCAPTION("No."))
            {
            }
            column("Arrêter_le_présent_état_à_la_somme_de__Caption"; Arrêter_le_présent_état_à_la_somme_de__CaptionLbl)
            {
            }
            column(Total__Caption; Total__CaptionLbl)
            {
            }
            column(Medical_Refund_Header_Document_Type; "Document Type")
            {
            }
            dataitem(DataItem1392; "Medical Refund Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                column(Text01; Text01)
                {
                }
                column(Medical_Refund_Line__Collection_Date_; "Collection Date")
                {
                }
                column(Medical_Refund_Line_Amount; Amount)
                {
                }
                column(Medical_Refund_Line__No__; "No.")
                {
                }
                column(Medical_Refund_Line__Last_Name_; "Last Name")
                {
                }
                column(Medical_Refund_Line__First_Name_; "First Name")
                {
                }
                column(Medical_Refund_Line_AmountCaption; FIELDCAPTION(Amount))
                {
                }
                column(Medical_Refund_Line__Collection_Date_Caption; FIELDCAPTION("Collection Date"))
                {
                }
                column(Medical_Refund_Line__No__Caption; FIELDCAPTION("No."))
                {
                }
                column(Medical_Refund_Line__Last_Name_Caption; FIELDCAPTION("Last Name"))
                {
                }
                column(Medical_Refund_Line__First_Name_Caption; FIELDCAPTION("First Name"))
                {
                }
                column(Medical_Refund_Line_Document_Type; "Document Type")
                {
                }
                column(Medical_Refund_Line_Document_No_; "Document No.")
                {
                }
                column(Medical_Refund_Line_Line_No_; "Line No.")
                {
                }
            }

            trigger OnPreDataItem();
            begin
                CLEAR(DescriptionLine);
                ToolsLibrary.InitTextVariable;
                ToolsLibrary.Money2Text(DescriptionLine, TotalAmount);
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
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record 79;
        Text01: Label 'Je soussigné, le chargé des relations avec la CNAS, avoir reçu les documents suivants :';
        DescriptionLine: array[2] of Text[80];
        TotalAmount: Decimal;
        CurrentEmployee: Code[20];
        ReimbursementHeader: Record "Medical Refund Header";
        ToolsLibrary: Codeunit "Tools Library";
        ACCUSE_DE_RECEPTIONCaptionLbl: Label 'ACCUSE DE RECEPTION';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        "Arrêter_le_présent_état_à_la_somme_de__CaptionLbl": Label 'Arrêter le présent état à la somme de :';
        Total__CaptionLbl: Label 'Total :';

}

