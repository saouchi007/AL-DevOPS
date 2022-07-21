/// <summary>
/// Unknown ISA_SalesShip_Ext (ID 50101) extends Record Standard Sales - Shipment.
/// </summary>
reportextension 50101 ISA_SalesShip_Ext extends "Sales - Shipment"
{
    //RDLCLayout = './Reports/AltrApp Reports/Posted Sales Shipment.rdl';
    dataset
    {
        add("Sales Shipment Header")
        {
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
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {
            }
            column(ISA_TransactionType; ISA_TransactionType)
            {
            }
            column(ISA_SalesPersonName; ISA_SalesPersonName)
            {
            }
            column(Document_Date; "Document Date")
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

                ISA_TransactionType := "Sales Shipment Header"."Gen. Bus. Posting Group";
                if ISA_TransactionType = 'DOMESTIC' then begin //TODO review which posting group to use to display the correct transaction type 
                    ISA_TransactionType := 'Consommations à Usages Internes';
                end;
                ISA_TransactionType := '';
            end;
        }
    }
    var
        ISA_TransactionType: Text;
        ISA_Customer_FiscalID: Text;
        ISA_Customer_TradeRegister: Text;
        ISA_Customer_ItemNumber: Text;
        ISA_Customer_StatisticalID: Text;
        ISA_SalesPersonName: Text;

}