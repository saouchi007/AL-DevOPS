/// <summary>
/// Unknown ISA_SalesInvoice (ID 50233) extends Record Sales - Invoice GB.
/// </summary>
reportextension 50104 ISA_SalesInvoice extends "Standard Sales - Invoice"
{
    RDLCLayout = './Reports/Sales Invoice Customised.rdl';
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

            column(Customer_FiscalID; Customer_FiscalID)
            {
            }
            column(Customer_ItemNumber; Customer_ItemNumber)
            {
            }
            column(Customer_StatisticalID; Customer_StatisticalID)
            {
            }
            column(Customer_TradeRegister; Customer_TradeRegister)
            {
            }

            column(SalesShipNo; SalesShipNo)
            {
            }
            column(AmountInWords; AmountInWords)
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
                Customer.SetRange("No.", Header."Bill-to Customer No.");
                SalesShipHeader.SetRange("Order No.", '1032');

                if Customer.FindSet or SalesShipHeader.FindSet then begin
                    Customer_FiscalID := Customer.ISA_FiscalID;
                    Customer_ItemNumber := Customer.ISA_ItemNumber;
                    Customer_StatisticalID := Customer.ISA_StatisticalID;
                    Customer_TradeRegister := Customer.ISA_TradeRegister;
                    SalesShipNo := SalesShipHeader."No.";
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
        SalesShipHeader: Record "Sales Shipment Header";
        Customer_FiscalID: Text;
        Customer_TradeRegister: Text;
        Customer_ItemNumber: Text;
        Customer_StatisticalID: Text;
        SalesShipNo: Text;
}