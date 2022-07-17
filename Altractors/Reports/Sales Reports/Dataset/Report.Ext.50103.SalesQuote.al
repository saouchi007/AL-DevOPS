/// <summary>
/// Unknown ISA_SalesQuote_Ext (ID 50103) extends Record Standard Sales - Quote.
/// </summary>
reportextension 50103 ISA_SalesQuote_Ext extends "Standard Sales - Quote"
{
    //RDLCLayout = './Reports/Sales Quote.rdl';
    dataset
    {
        add(Header)
        {
            column(Bill_to_Contact; "Bill-to Contact")
            {

            }
            column(Sell_to_Contact; "Sell-to Contact")
            {

            }
            column(Sell_to_Phone_No_; "Sell-to Phone No.")
            {

            }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {

            }
            column(Sell_to_Customer_Name_2; "Sell-to Customer Name 2")
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
            column(ISA_SalesComments; ISA_SalesComments.Comment)
            {
            }
            column(Requested_Delivery_Date; "Requested Delivery Date")
            {
            }
            column(ISA_AmountInWords; ISA_AmountInWords)
            {
            }
        }

        modify(Header)
        {
            trigger OnAfterAfterGetRecord()
            var
                Customer: Record Customer;
            begin
                Customer.Reset();
                ISA_SalesComments.reset();
                ISA_SalesComments.SetRange("No.", Header."No.");
                Customer.SetRange("No.", Header."Sell-to Customer No.");
                if Customer.FindSet or ISA_SalesComments.FindSet then begin
                    ISA_Customer_FiscalID := Customer.ISA_FiscalID;
                    ISA_Customer_ItemNumber := Customer.ISA_ItemNumber;
                    ISA_Customer_StatisticalID := Customer.ISA_StatisticalID;
                    ISA_Customer_TradeRegister := Customer.ISA_TradeRegister;
                end;

                Header.CalcFields(Amount, "Amount Including VAT");
                AmountCustomer := Header."Amount Including VAT";
                RepCheck.InitTextVariable();
                RepCheck.FormatNoText(NoText, Round(AmountCustomer, 0.01), '');
                ISA_AmountInWords := NoText[1];
            end;
        }
    }

    var
        ISA_Customer_FiscalID: Text;
        ISA_Customer_TradeRegister: Text;
        ISA_Customer_ItemNumber: Text;
        ISA_Customer_StatisticalID: Text;

        RepCheck: Report Check;
        NoText: array[2] of Text;
        ISA_AmountInWords: Text[100];
        AmountCustomer: Decimal;

        ISA_SalesComments: Record "Sales Comment Line";

}

