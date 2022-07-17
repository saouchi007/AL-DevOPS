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

        }


        modify(Header)
        {
            trigger OnAfterAfterGetRecord()
            var
                Customer: Record Customer;
                SalesPerson: Record "Salesperson/Purchaser";
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

                Header.CalcFields(Amount, "Amount Including VAT");
                StampDutywithDocTotal := Header."Amount Including VAT" + Header.ISA_StampDuty;
                RepCheck.InitTextVariable();
                RepCheck.FormatNoText(NoText, Round(StampDutywithDocTotal, 0.01), '');
                AmountInWords := NoText[1];
            end;
        }
    }

    var
        StampDutywithDocTotal: Decimal;
        Company_FiscalID: Label 'NIF : 0 999 1600 07189 04';
        Company_StatisticalID: Label 'N° Statistique : 0 994 4228 03302 33';
        Company_TradeRegister: Label 'Code Activité : 408301 408406 410321';
        Company_ItemNumber: Label 'Article : 607002 609002 61320';
        Text021: Label 'VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID';
        RepCheck: Report Check;
        NoText: array[2] of Text;
        AmountInWords: Text[100];
        // AmountCustomer: Decimal; replaced by StampDutywithDocTotal to add up the SDuty with the doc total 
        ISA_Customer_FiscalID: Text;
        ISA_Customer_TradeRegister: Text;
        ISA_Customer_ItemNumber: Text;
        ISA_Customer_StatisticalID: Text;
        ISA_SalesPersonName: Text;

}