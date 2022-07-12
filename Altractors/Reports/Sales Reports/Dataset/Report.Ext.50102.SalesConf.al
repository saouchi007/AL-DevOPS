/// <summary>
/// Unknown ISA_SalesConf (ID 50232) extends Record Standard Sales - Order Conf..
/// </summary>
reportextension 50102 ISA_SalesConf extends "Standard Sales - Order Conf."
{
    RDLCLayout = './Reports/Sales Conf Stamp Duty.rdl';
    dataset
    {
        add(Header)
        {
            column(ISA_StampDuty; ISA_StampDuty)
            {
            }
            column(StampDutywithDocTotal; StampDutywithDocTotal)
            { }

            column(FiscalID; FiscalID)
            {
            }
            column(TradeRegister; TradeRegister)
            { }
            column(ItemNumber; ItemNumber)
            { }
            column(StatisticalID; StatisticalID)
            { }
            column(AmountInWords; AmountInWords)
            { }

        }

        add(Line)
        {
            column(Bin_Code; "Bin Code")
            {
            }
        }
        modify(Line)
        {
            trigger OnAfterAfterGetRecord()
            begin
                //Line.CalcSums("Amount Including VAT");
                //StampDutywithDocTotal := Line."Amount Including VAT" + Header.ISA_StampDuty;

            end;
        }
        modify(Header)
        {
            trigger OnAfterAfterGetRecord()
            begin
                Header.CalcFields("Amount Including VAT");
                //AmountCustomer := Header."Amount Including VAT" + Header.ISA_StampDuty;
                StampDutywithDocTotal := Header."Amount Including VAT" + Header.ISA_StampDuty;
                RepCheck.InitTextVariable();
                RepCheck.FormatNoText(NoText, Round(StampDutywithDocTotal, 0.01), '');
                AmountInWords := NoText[1];
                //Message('AmountInWords : %1 \AmountCustomer - %2', AmountInWords, Header."Amount Including VAT");
            end;
        }
    }
    var
        StampDutywithDocTotal: Decimal;
        FiscalID: Label 'NIF : 0 999 1600 07189 04';
        StatisticalID: Label 'N° Statistique : 0 994 4228 03302 33';
        TradeRegister: Label 'Code Activité : 408301 408406 410321';
        ItemNumber: Label 'Article : 607002 609002 61320';
        Text021: Label 'VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID';
        RepCheck: Report Check;
        NoText: array[2] of Text;
        AmountInWords: Text[100];
        AmountCustomer: Decimal;

}