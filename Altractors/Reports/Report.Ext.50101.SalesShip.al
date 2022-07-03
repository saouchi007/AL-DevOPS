/// <summary>
/// Unknown ISA_SalesShip_Ext (ID 50101) extends Record Standard Sales - Shipment.
/// </summary>
reportextension 50101 ISA_SalesShip_Ext extends "Sales - Shipment"
{
    RDLCLayout = './Reports/Sales Ship Customised.rdl';
    dataset
    {
        add("Sales Shipment Header")
        {
            column(ISA_Company_FiscalID; ISA_Company_FiscalID)
            { }
            column(ISA_Company_TradeRegister; ISA_Company_TradeRegister)
            { }
            column(ISA_Company_ItemNumber; ISA_Company_ItemNumber)
            { }
            column(ISA_Company_StatisticalID; ISA_Company_StatisticalID)
            { }
            column(ISA_TransactionType; ISA_TransactionType)
            {
            }
        }

        add("Sales Shipment Line")
        {
            column(Bin_Code; "Bin Code")
            {
            }
        }
        modify("Sales Shipment Header")
        {
            trigger OnAfterAfterGetRecord()
            begin
                ISA_TransactionType := "Sales Shipment Header"."Gen. Bus. Posting Group";
                if ISA_TransactionType = 'DOMESTIC' then begin
                    ISA_TransactionType := 'Consommations à Usages Internes';
                    Message(ISA_TransactionType);
                end;
                ISA_TransactionType := '';
                Message(ISA_TransactionType);
            end;
        }
    }
    var
        ISA_Company_FiscalID: Label 'NIF : 0 999 1600 07189 04';
        ISA_Company_StatisticalID: Label 'N° Statistique : 0 994 4228 03302 33';
        ISA_Company_TradeRegister: Label 'Code Activité : 408301 408406 410321';
        ISA_Company_ItemNumber: Label 'Article : 607002 609002 61320';
        ISA_TransactionType: Text;


}