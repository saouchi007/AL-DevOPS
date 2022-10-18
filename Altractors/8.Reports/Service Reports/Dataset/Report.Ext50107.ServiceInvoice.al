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

            column(Location_Code; "Location Code")
            {
            }
            column(ISA_ServiceItem_Description; ISA_ServiceItem_Description)
            {
            }
            column(ISA_StampDuty; ISA_StampDuty)
            {
            }
            column(CommentFetched; CommentFetched)
            {

            }
            column(ISA_PayMethDescription; ISA_PayMethDescription)
            {

            }
            column(ISA_PayTermsDescription; ISA_PayTermsDescription)
            {

            }
        }
        add("Service Invoice Line")
        {
            column(ISA_AmountInWords; ISA_AmountInWords)
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
                ISA_ServiceComments: Record "Service Comment Line";
                ISA_PaymMethod: Record "Payment Method";
                ISA_PayTerms: Record "Payment Terms";
            begin
                Customer.Reset();
                SalesPerson.Reset();
                "Service Invoice Line".Reset();
                ServiceItemLine.Reset();
                ServiceShipItemLine.reset();
                ISA_ServiceComments.Reset();
                ISA_PaymMethod.Reset();
                ISA_PayTerms.Reset();


                Customer.SetRange("No.", "Service Invoice Header"."Bill-to Customer No.");
                SalesPerson.SetRange(Code, "Salesperson Code");
                "Service Invoice Line".SetRange("Document No.", "Service Invoice Header"."No.");
                ServiceShipHeader.SetRange("Order No.", "Service Invoice Header"."Order No.");
                ISA_ServiceComments.SetFilter(Type, 'General');
                ISA_ServiceComments.SetRange("No.", "Service Invoice Header"."No.");
                ISA_PaymMethod.SetRange(Code, "Service Invoice Header"."Payment Method Code");
                ISA_PayTerms.SetRange(Code, "Service Invoice Header"."Payment Terms Code");

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

                if ISA_ServiceComments.FindSet then begin
                    repeat begin
                        CommentFetched += '- ' + ISA_ServiceComments.Comment + ',';
                    end until ISA_ServiceComments.Next = 0;
                end;

                if ISA_PaymMethod.FindSet or ISA_PayTerms.FindSet then begin
                    ISA_PayMethDescription := ISA_PaymMethod.Description;
                    ISA_PayTermsDescription := ISA_PayTerms.Description;
                end;

            end;
        }

        modify("Service Invoice Line")
        {
            trigger OnAfterAfterGetRecord()
            var
                ToolBox: Report ISA_Check;
            begin
                "Service Invoice Line".CalcSums("Amount Including VAT");
                AmountCustomer := "Service Invoice Line"."Amount Including VAT" + "Service Invoice Header".ISA_StampDuty;
                ToolBox.InitTextVariable();
                ToolBox.FormatNoText(NoText, Round(AmountCustomer, 0.01), '');
                ISA_AmountInWords := NoText[1];
            end;
        }
    }

    var
        ISA_Customer_FiscalID: Text;
        ISA_Customer_TradeRegister: Text;
        ISA_Customer_ItemNumber: Text;
        ISA_Customer_StatisticalID: Text;

        ISA_AmountInWords: Text[100];
        AmountCustomer: Decimal;
        NoText: array[2] of Text[100];

        ISA_SalesPersonName: Text;
        ISA_CustomerName: Text;
        ISA_ServiceItem_Description: Text;

        CommentFetched: Text;

        ISA_PayMethDescription: Text;
        ISA_PayTermsDescription: Text;

}