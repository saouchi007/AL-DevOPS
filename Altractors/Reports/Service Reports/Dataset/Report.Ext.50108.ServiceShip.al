/// <summary>
/// Unknown ISA_ServiceShip_Ext (ID 50108) extends Record Service - Shipment.
/// </summary>
reportextension 50108 ISA_ServiceShip_Ext extends "Service - Shipment"
{
    dataset
    {
        add("Service Shipment Header")
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
            column(DocumentDate_ServiceShipmentHeader; "Document Date")
            {
            }
            column(BilltoCustomerNo_ServiceShipmentHeader; "Bill-to Customer No.")
            {
            }
            column(CustomerNo_ServiceShipmentHeader; "Customer No.")
            {
            }
            column(ISA_TransactionType; ISA_TransactionType)
            {
            }
            column(ISA_SalesPersonName; ISA_SalesPersonName)
            {
            }
            column(ISA_CustomerName; ISA_CustomerName)
            {
            }
            column(Order_No_; "Order No.")
            {
            }
            column(ISA_ServiceItem_Description; ISA_ServiceItem_Description)
            {
            }
            column(ISA_ServiceItem_SerialNo; ISA_ServiceItem_SerialNo)
            {

            }
            column(Location_Code; "Location Code")
            {
            }

        }
        modify("Service Shipment Header")
        {
            trigger OnAfterAfterGetRecord()
            var
                Customer: Record Customer;
                SalesPerson: Record "Salesperson/Purchaser";
                SalandReceiv: Record "Sales & Receivables Setup";
                ServiceShipItemLine: Record "Service Shipment Item Line";
            begin
                SalesPerson.Reset();
                SalandReceiv.Get();
                SalesPerson.SetRange(Code, "Salesperson Code");
                Customer.Reset();
                ServiceShipItemLine.reset();
                Customer.SetRange("No.", "Customer No.");
                if Customer.FindSet or SalesPerson.FindSet then begin
                    ISA_Customer_FiscalID := Customer.ISA_FiscalID;
                    ISA_Customer_ItemNumber := Customer.ISA_ItemNumber;
                    ISA_Customer_StatisticalID := Customer.ISA_StatisticalID;
                    ISA_Customer_TradeRegister := Customer.ISA_TradeRegister;
                    ISA_CustomerName := Customer.Name;
                    ISA_SalesPersonName := SalesPerson.Name;
                    ServiceShipItemLine.SetRange("No.", "Service Shipment Header"."No.");
                    if ServiceShipItemLine.FindSet then begin
                        ISA_ServiceItem_Description := ServiceShipItemLine.Description;
                        ISA_ServiceItem_SerialNo := ServiceShipItemLine."Serial No."
                    end;
                end;

                ISA_TransactionType := "Service Shipment Header"."Gen. Bus. Posting Group";
                if ISA_TransactionType = SalandReceiv.ISA_TransactionType then begin
                    ISA_TransactionType := 'Consommations à Usages Internes';
                end
                else
                    ISA_TransactionType := '';
            end;
        }
    }

    var
        ISA_Customer_FiscalID: Text;
        ISA_Customer_TradeRegister: Text;
        ISA_Customer_ItemNumber: Text;
        ISA_Customer_StatisticalID: Text;

        ISA_SalesPersonName: Text;
        ISA_CustomerName: Text;
        ISA_TransactionType: Text;

        ISA_ServiceItem_Description: Text;
        ISA_ServiceItem_SerialNo: Text;
}