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
            column(CommentFetched; CommentFetched)
            {
            }
        }

        modify(Header)
        {
            trigger OnAfterAfterGetRecord()
            var
                Customer: Record Customer;
                ToolBox: Report ISA_Check;
                ISA_SalesComments: Record "Sales Comment Line";

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
                ISA_SalesComments.SetFilter("Document Type", 'Quote');
                ISA_SalesComments.SetRange("No.", Header."No.");

                if ISA_SalesComments.FindSet then begin
                    repeat begin
                        CommentFetched += '- ' + ISA_SalesComments.Comment + ', ';
                    end until ISA_SalesComments.Next = 0;
                end;

                Header.CalcFields(Amount, "Amount Including VAT", "Invoice Discount Amount");
                AmountCustomer := Header."Amount Including VAT";
                //RepCheck.InitTextVariable();
                ToolBox.InitTextVariable();
                ToolBox.FormatNoText(NoText, Round(AmountCustomer, 0.01), '');
                ISA_AmountInWords := NoText[1] + ' ' + NoText[2];
                //ISA_AmountInWords := ToolBox.NumberInWords(Round(AmountCustomer, 0.01), 'DINARS', 'CENTIMES');
                /*
                                WholePart := ROUND(ABS(AmountCustomer), 1, '<');
                                DecimalPart := ABS((ABS(AmountCustomer) - WholePart) * 100);



                                RepCheck.FormatNoText(NoText, Round(WholePart, 0.01), '');
                                AmountIntoWordsIntPart := NoText[1];
                                AmountIntoWordsIntPart := DelChr(AmountIntoWordsIntPart, '=', '*');
                                ISA_AmountInWords := DelChr(AmountIntoWordsIntPart, '>', '0/100');

                                RepCheck.FormatNoText(NoText, Round(DecimalPart, 1), '');
                                AmountIntoWordsDecPart := NoText[1];
                                AmountIntoWordsDecPart := DelChr(AmountIntoWordsDecPart, '=', '*');
                                ISA_AmountInWords += ' ET ' + DelChr(AmountIntoWordsDecPart, '>', '0/100') + ' CENTIMES';
                                */
                //Message(ISA_AmountInWords);
            end;

        }


    }

    var
        ISA_Customer_FiscalID: Text;
        ISA_Customer_TradeRegister: Text;
        ISA_Customer_ItemNumber: Text;
        ISA_Customer_StatisticalID: Text;

        ISA_AmountInWords: Text[300];
        AmountCustomer: Decimal;

        ISA_SalesComments: Record "Sales Comment Line";
        CommentFetched: Text;

        RepCheck: Report Check;
        NoText: array[2] of Text[300];
        AmountIntoWordsIntPart: Text[100];
        AmountIntoWordsDecPart: Text[100];

        WholePart: Integer;
        DecimalPart: Integer;

}

