/// <summary>
/// Unknown ISA_ServiceQuote_Ext (ID 50106) extends Record Service Quote.
/// </summary>
reportextension 50106 ISA_ServiceQuote_Ext extends "Service Quote"
{
    dataset
    {
        add("Service Header")
        {
            column(Payment_Terms_Code; "Payment Terms Code")
            {
            }
            column(Payment_Method_Code; "Payment Method Code")
            {
            }
            column(Response_Time; "Response Time")
            {
            }
            column(ISA_Customer_FiscalID; ISA_Customer_FiscalID)
            {
            }
            column(ISA_Customer_ItemNumber; ISA_Customer_ItemNumber)
            {
            }
            column(ISA_Customer_StatisticalID; ISA_Customer_StatisticalID)
            {
            }
            column(ISA_Customer_TradeRegister; ISA_Customer_TradeRegister)
            {
            }
            column(ISA_SalesPersonName; ISA_SalesPersonName)
            {
            }
            column(Customer_No_; "Customer No.")
            {
            }
            column(ISA_CustomerName; ISA_CustomerName)
            {
            }
            column(ISA_AmountInWords; ISA_AmountInWords)
            {
            }
            column(Location_Code; "Location Code")
            {

            }
            column(Due_Date; "Due Date")
            {
            }
            column(Finishing_Date; "Finishing Date")
            {

            }

        }
        add("Service Line")
        {
            column(VAT__; "VAT %")
            {
            }
            column(VAT_Base_Amount; "VAT Base Amount")
            {
            }
            column(Amount_Including_VAT; "Amount Including VAT")
            {
            }
            column(Amount; Amount)
            {
            }
        }

        modify("Service Header")
        {
            trigger OnAfterAfterGetRecord()
            var
                Customer: Record Customer;
                SalesPerson: Record "Salesperson/Purchaser";
                ServiceLine: Record "Service Line";
            begin
                Customer.Reset();
                SalesPerson.Reset();
                "Service Line".Reset();
                Customer.SetRange("No.", "Service Header"."Bill-to Customer No.");
                SalesPerson.SetRange(Code, "Salesperson Code");
                ServiceLine.SetRange("No.", "No.");
                if Customer.FindSet or SalesPerson.FindSet then begin
                    ISA_Customer_FiscalID := Customer.ISA_FiscalID;
                    ISA_Customer_ItemNumber := Customer.ISA_ItemNumber;
                    ISA_Customer_StatisticalID := Customer.ISA_StatisticalID;
                    ISA_Customer_TradeRegister := Customer.ISA_TradeRegister;
                    ISA_SalesPersonName := SalesPerson.Name;
                    ISA_CustomerName := Customer.Name;
                end;


            end;
        }
        modify("Service Line")
        {
            trigger OnAfterAfterGetRecord()
            var
                ToolBox: Codeunit ISA_StampDutyProcessor;
            begin
                "Service Line".CalcSums("Amount Including VAT");
                AmountCustomer := "Service Line"."Amount Including VAT" + ISA_StampDuty;
                ToolBox.InitTextVariable();
                ISA_AmountInWords := ToolBox.NumberInWords(Round(AmountCustomer, 0.01), 'Dinars', 'Centimes');
            end;
        }
    }

    var
        ISA_Customer_FiscalID: Text;
        ISA_Customer_TradeRegister: Text;
        ISA_Customer_ItemNumber: Text;
        ISA_Customer_StatisticalID: Text;

        ISA_AmountInWords: Text[100];
        AmountCustomer: Decimal;

        ISA_SalesComments: Record "Sales Comment Line";
        ISA_SalesPersonName: Text;
        ISA_CustomerName: Text;

}