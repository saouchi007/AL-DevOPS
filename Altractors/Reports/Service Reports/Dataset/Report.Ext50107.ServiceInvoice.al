/// <summary>
/// Unknown ISA_ServiceInvoice_Ext (ID 50107) extends Record Service - Invoice.
/// </summary>
reportextension 50107 ISA_ServiceInvoice_Ext extends "Service - Invoice"
{
    dataset
    {
        add("Service Invoice Header")
        {
            column(Payment_Terms_Code; "Payment Terms Code")
            {
            }
            column(Payment_Method_Code; "Payment Method Code")
            {
            }
            column(Response_Time; "Response Time")
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
            column(ISA_SalesPersonName; ISA_SalesPersonName)
            {
            }
            column(Customer_No_; "Customer No.")
            {
            }
            column(ISA_CustomerName; ISA_CustomerName)
            {
            }
            column(ISA_AmountInWords; ISA_AmountInWords)
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            column(ISA_ServiceItem_Description; ISA_ServiceItem_Description)
            {
            }
            column(ISA_StampDuty; ISA_StampDuty)
            {
            }
        }

        modify("Service Invoice Header")
        {
            trigger OnAfterAfterGetRecord()
            var
                Customer: Record Customer;
                SalesPerson: Record "Salesperson/Purchaser";
                ServiceItemLine: Record "Service Item Line";
                ServiceShipHeader: Record "Service Shipment Header";
                ServiceShipItemLine: Record "Service Shipment Item Line";
            begin
                Customer.Reset();
                SalesPerson.Reset();
                "Service Invoice Line".Reset();
                ServiceItemLine.Reset();
                ISA_SalesComments.reset();
                ServiceShipItemLine.reset();


                //ISA_SalesComments.SetRange("No.", "Service Header"."No.");
                Customer.SetRange("No.", "Service Invoice Header"."Bill-to Customer No.");
                SalesPerson.SetRange(Code, "Salesperson Code");
                "Service Invoice Line".SetRange("Document No.", "Service Invoice Header"."No.");
                ServiceShipHeader.SetRange("Order No.", "Service Invoice Header"."Order No.");

                if Customer.FindSet or SalesPerson.FindSet or "Service Invoice Line".FindSet or ServiceShipHeader.FindSet then begin
                    ISA_Customer_FiscalID := Customer.ISA_FiscalID;
                    ISA_Customer_ItemNumber := Customer.ISA_ItemNumber;
                    ISA_Customer_StatisticalID := Customer.ISA_StatisticalID;
                    ISA_Customer_TradeRegister := Customer.ISA_TradeRegister;
                    ISA_SalesPersonName := SalesPerson.Name;
                    ISA_CustomerName := Customer.Name;
                    //Message('%1 - %2', ServiceShipHeader."Customer No.", ServiceShipHeader."No.");
                    ServiceShipItemLine.SetRange("No.", ServiceShipHeader."No.");
                    if ServiceShipItemLine.FindSet then
                        ISA_ServiceItem_Description := ServiceShipItemLine.Description;
                end;

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
        ISA_SalesPersonName: Text;
        ISA_CustomerName: Text;
        ISA_ServiceItem_Description: Text;
}