/// <summary>
/// Unknown ISA_SalesCreditMemo (ID 50105) extends Record Standard Sales - Credit Memo.
/// </summary>
reportextension 50105 ISA_SalesCreditMemo extends "Standard Sales - Credit Memo"
{
    dataset
    {
        add(Header)
        {
            column(ISA_StampDuty; ISA_StampDuty)
            {
            }
            column(Company_FiscalID; Company_FiscalID)
            { }
            column(Company_TradeRegister; Company_TradeRegister)
            { }
            column(Company_ItemNumber; Company_ItemNumber)
            { }
            column(Company_StatisticalID; Company_StatisticalID)
            { }

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

            column(AmountInWords; AmountInWords)
            {
            }
            column(ISA_SalesPersonName; ISA_SalesPersonName)
            {
            }
            column(Pre_Assigned_No_; "Pre-Assigned No.")
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
                SalesPerson: Record "Salesperson/Purchaser";
                ToolBox: Report ISA_Check;
                ISA_SalesComments: Record "Sales Comment Line";

            begin
                SalesPerson.Reset();
                SalesPerson.SetRange(Code, "Salesperson Code");
                Customer.Reset();
                Customer.SetRange("No.", "Sell-to Customer No.");
                if Customer.FindSet or SalesPerson.FindSet or ISA_SalesComments.FindSet then begin
                    ISA_Customer_FiscalID := Customer.ISA_FiscalID;
                    ISA_Customer_ItemNumber := Customer.ISA_ItemNumber;
                    ISA_Customer_StatisticalID := Customer.ISA_StatisticalID;
                    ISA_Customer_TradeRegister := Customer.ISA_TradeRegister;

                    ISA_SalesPersonName := SalesPerson.Name;

                    ISA_SalesComments.SetFilter("Document Type", 'Posted Credit Memo');
                    ISA_SalesComments.SetRange("No.", Header."No.");

                    if ISA_SalesComments.FindSet then begin
                        repeat begin
                            CommentFetched += '- ' + ISA_SalesComments.Comment + ', ';
                        end until ISA_SalesComments.Next = 0;
                    end;
                end;

                Header.CalcFields(Amount, "Amount Including VAT");
                StampDutywithDocTotal := Header."Amount Including VAT" + Header.ISA_StampDuty;
                //RepCheck.InitTextVariable();

                ToolBox.InitTextVariable();
                ToolBox.FormatNoText(NoText, Round(StampDutywithDocTotal, 0.01), '');
                AmountInWords := NoText[1];
                //AmountInWords := ToolBox.NumberInWords(Round(StampDutywithDocTotal, 0.01), 'DINARS', 'CENTIMES');
                /*
                                WholePart := ROUND(ABS(StampDutywithDocTotal), 1, '<');
                                DecimalPart := ABS((ABS(StampDutywithDocTotal) - WholePart) * 100);


                                RepCheck.FormatNoText(NoText, Round(WholePart, 0.01), '');
                                AmountIntoWordsIntPart := NoText[1];
                                AmountIntoWordsIntPart := DelChr(AmountIntoWordsIntPart, '=', '*');
                                AmountInWords := DelChr(AmountIntoWordsIntPart, '>', '0/100');

                                RepCheck.FormatNoText(NoText, Round(DecimalPart, 1), '');
                                AmountIntoWordsDecPart := NoText[1];
                                AmountIntoWordsDecPart := DelChr(AmountIntoWordsDecPart, '=', '*');
                                AmountInWords += ' ET ' + DelChr(AmountIntoWordsDecPart, '>', '0/100') + ' CENTIMES';
                */
                // Message(AmountInWords);
            end;
        }
    }


    var
        StampDutywithDocTotal: Decimal;
        Company_FiscalID: Label 'NIF : 0 999 1600 07189 04';
        Company_StatisticalID: Label 'N° Statistique : 0 994 4228 03302 33';
        Company_TradeRegister: Label 'Code Activité : 408301 408406 410321';
        Company_ItemNumber: Label 'Article : 607002 609002 61320';
        AmountInWords: Text[100];
        // AmountCustomer: Decimal; replaced by StampDutywithDocTotal to add up the SDuty with the doc total 
        ISA_Customer_FiscalID: Text;
        ISA_Customer_TradeRegister: Text;
        ISA_Customer_ItemNumber: Text;
        ISA_Customer_StatisticalID: Text;
        ISA_SalesPersonName: Text;

        CommentFetched: Text;

        RepCheck: Report Check;
        NoText: array[2] of Text[100];
        AmountIntoWordsIntPart: Text[100];
        AmountIntoWordsDecPart: Text[100];

        WholePart: Integer;
        DecimalPart: Integer;
}