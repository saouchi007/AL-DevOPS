report 83000 "MICA Rebate Pool Statement"
{
    UsageCategory = None;
    Caption = 'Rebate Pool Statement';
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rdl83000.MICARebatePoolStatement.rdl';

    dataset
    {
        dataitem(MICARebatePoolEntry; "MICA Rebate Pool Entry")
        {
            DataItemTableView = sorting("Customer No.");
            RequestFilterFields = "Customer No.";
            column(Customer_No_; "Customer No.")
            {

            }
            column(CustomerName; CustomerName)
            {

            }
            column(BaseAmountLbl; BaseAmountLbl)
            {

            }
            column(ConsumedAmountLbl; ConsumedAmountLbl)
            {

            }
            column(SituationDateLbl; SituationDateLbl)
            {

            }
            column(SituationDate; Format(Workdate(), 0, '<Day,2>/<Month,2>/<Year4>'))
            {

            }
            column(RebatePoolStatementLbl; RebatePoolStatementLbl)
            {

            }
            dataitem(Integer; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(Picture_CompanyInfo; CompanyInfo.Picture)
                {

                }

                column(CompanyAddr1; CompanyAddr[1])
                {

                }
                column(CompanyAddr2; CompanyAddr[2])
                {

                }
                column(CompanyAddr3; CompanyAddr[3])
                {

                }
                column(CompanyAddr4; CompanyAddr[4])
                {

                }
                column(CompanyAddr5; CompanyAddr[5])
                {

                }
                column(CompanyAddr6; CompanyAddr[6])
                {

                }
                column(CompanyAddr7; CompanyAddr[7])
                {

                }
                column(CompanyAddr8; CompanyAddr[8])
                {

                }
                column(CustAddr1; CustAddr[1])
                {

                }
                column(CustAddr2; CustAddr[2])
                {

                }
                column(CustAddr3; CustAddr[3])
                {

                }
                column(CustAddr4; CustAddr[4])
                {

                }
                column(CustAddr5; CustAddr[5])
                {

                }
                column(CustAddr6; CustAddr[6])
                {

                }
                column(CustAddr7; CustAddr[7])
                {

                }
                column(CustAddr8; CustAddr[8])
                {

                }
                column(Rebate_CodeCaption; MICARebatePoolEntry.FieldCaption("Rebate Code"))
                {

                }
                column(Rebate_Code; MICARebatePoolEntry."Rebate Code")
                {

                }
                column(CustomerDescriptionCaption_RemainingAmount_RebatePoolEntry; MICARebatePoolEntry.FieldCaption("Customer Description"))
                {

                }
                column(CustomerDescription_RemainingAmount_RebatePoolEntry; MICARebatePoolEntry."Customer Description")
                {

                }
                column(OriginalAmount_RebatePoolEntry; MICARebatePoolEntry."Original Amount")
                {

                }
                column(RemainingAmountCaption_RebatePoolEntry; MICARebatePoolEntry.FieldCaption("Remaining Amount"))
                {

                }
                column(RemainingAmount_RebatePoolEntry; MICARebatePoolEntry."Remaining Amount")
                {

                }
                column(VATRegistrationNoCaption_CompanyInfo; CompanyInfo.FieldCaption("VAT Registration No."))
                {

                }

                column(VATRegistrationNo_CompanyInfo; CompanyInfo."VAT Registration No.")
                {

                }
                column(HomePageCaption_CompanyInfo; CompanyInfo.FieldCaption("Home Page"))
                {

                }
                column(HomePage_CompanyInfo; CompanyInfo."Home Page")
                {

                }
                column(PhoneNoCaption_CompanyInfo; CompanyInfo.FieldCaption("Phone No."))
                {

                }
                column(PhoneNo_CompanyInfo; CompanyInfo."Phone No.")
                {

                }
                column(EmailCaption_CompanyInfo; CompanyInfo.FieldCaption("E-Mail"))
                {

                }
                column(Email_CompanyInfo; CompanyInfo."E-Mail")
                {

                }
            }

            trigger OnAfterGetRecord()
            var
                Customer: Record Customer;
            begin
                CustomerName := '';
                if Customer.Get(MICARebatePoolEntry."Customer No.") then
                    CustomerName := Customer.Name;

                FormatAddr.Customer(CustAddr, Customer);
            end;

            trigger OnPreDataItem()
            begin
                MICARebatePoolEntry.SetAutoCalcFields(MICARebatePoolEntry."Remaining Amount");

                with CompanyInfo do
                    FormatAddr.FormatAddr(CompanyAddr, Name, "Name 2", '', Address, "Address 2",
                    City, "Post Code", County, "Country/Region Code");
            end;

        }
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        CompanyAddr: array[8] of Text[50];
        CustAddr: array[8] of Text[50];
        CustomerName: Text[100];
        BaseAmountLbl: Label 'Base Amount';
        ConsumedAmountLbl: Label 'Consumed Amount';
        SituationDateLbl: Label 'Situation Date';
        RebatePoolStatementLbl: Label 'Rebate Pool Statement';
}