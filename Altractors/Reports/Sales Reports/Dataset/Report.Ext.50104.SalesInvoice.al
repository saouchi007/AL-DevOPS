/// <summary>
/// Unknown ISA_SalesInvoice (ID 50233) extends Record Sales - Invoice GB.
/// </summary>
reportextension 50104 ISA_SalesInvoice extends "Standard Sales - Invoice"
{
    //RDLCLayout = './Reports/Sales Invoice Customised.rdl';
    dataset
    {
        add(Header)
        {
            column(ISA_StampDuty; ISA_StampDuty)
            { }

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
            column(Order_No_; "Order No.")
            {
            }
            column(AmountExclVatAfterDiscount; AmountExclVatAfterDiscount)
            {
            }

        }


        modify(Header)
        {
            trigger OnAfterAfterGetRecord()
            var
                Customer: Record Customer;
                SalesPerson: Record "Salesperson/Purchaser";
                ToolBox: Codeunit ISA_StampDutyProcessor;
            begin
                SalesPerson.Reset();
                SalesPerson.SetRange(Code, "Salesperson Code");
                Customer.Reset();
                Customer.SetRange("No.", "Sell-to Customer No.");
                if Customer.FindSet or SalesPerson.FindSet then begin
                    ISA_Customer_FiscalID := Customer.ISA_FiscalID;
                    ISA_Customer_ItemNumber := Customer.ISA_ItemNumber;
                    ISA_Customer_StatisticalID := Customer.ISA_StatisticalID;
                    ISA_Customer_TradeRegister := Customer.ISA_TradeRegister;

                    ISA_SalesPersonName := SalesPerson.Name;

                end;

                Header.CalcFields(Amount, "Amount Including VAT", "Invoice Discount Amount");
                StampDutywithDocTotal := Header."Amount Including VAT" + Header.ISA_StampDuty;
                //RepCheck.InitTextVariable();
                ToolBox.InitTextVariable();
                AmountInWords := ToolBox.NumberInWords(Round(StampDutywithDocTotal, 0.01), 'DINARS', 'CENTIMES');

                AmountExclVatAfterDiscount := Header.Amount - Header."Invoice Discount Amount";
                /*
                                //IntPart := Format("Amount Including VAT", 0, '<Integer>');
                                //DeciPart := CopyStr(Format("Amount Including VAT", 0, '<Decimals>'), 2, StrLen(Format("Amount Including VAT", 0, '<Decimals>')));
                                //Message('%1 :\Int : %2\Dec : %3', "Amount Including VAT", WholePart, DecimalPart);

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

                                ReplaceString(AmountInWords, 'ONE HUNDRED ', 'CENT');
                */
                //Message(AmountInWords);

            end;
        }
    }
    //AND 0/100

    local procedure ReplaceString(String: Text[250]; FindWhat: Text[250]; ReplaceWith: Text[250]) NewString: Text[250]
    begin
        WHILE STRPOS(AmountInWords, 'UN CENT') > 0 DO
            String := DELSTR(String, STRPOS(String, FindWhat)) + ReplaceWith + COPYSTR(String, STRPOS(String, FindWhat) + STRLEN(FindWhat));
        NewString := String;
    end;

    var
        StampDutywithDocTotal: Decimal;
        Company_FiscalID: Label 'NIF : 0 999 1600 07189 04';
        Company_StatisticalID: Label 'N° Statistique : 0 994 4228 03302 33';
        Company_TradeRegister: Label 'Code Activité : 408301 408406 410321';
        Company_ItemNumber: Label 'Article : 607002 609002 61320';
        AmountInWords: Text[300];
        // AmountCustomer: Decimal; replaced by StampDutywithDocTotal to add up the SDuty with the doc total 
        ISA_Customer_FiscalID: Text;
        ISA_Customer_TradeRegister: Text;
        ISA_Customer_ItemNumber: Text;
        ISA_Customer_StatisticalID: Text;
        ISA_SalesPersonName: Text;
        AmountExclVatAfterDiscount: Decimal;

        //************
        IntPart: Text[300];
        DeciPart: Text[300];
        RepCheck: Report Check;
        NoText: array[2] of Text[300];
        AmountIntoWordsIntPart: Text[300];
        AmountIntoWordsDecPart: Text[300];

        WholePart: Integer;
        DecimalPart: Integer;

}