report 82942 "MICA Updte Combine Ship. On SO"
{
    Caption = 'Update Combine Shipment On Sales Orders';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;


    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = Sorting("No.") where("Combine Shipments" = const(true));
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Customer';

            dataitem(SalesOrder; "Sales Header")
            {
                DataItemLink = "Bill-to Customer No." = field("No.");
                DataItemTableView = sorting("Document Type", "Bill-to Customer No.") where("Document Type" = const(Order));
                RequestFilterFields = "Bill-to Customer No.";
                RequestFilterHeading = 'Sales Order';


                trigger OnAfterGetRecord()
                begin
                    if GuiAllowed then
                        Window.Update(2, SalesOrder."No.");
                    SalesOrder.Validate("Combine Shipments", true);
                    SalesOrder.Modify();
                end;

            }

            trigger OnAfterGetRecord()
            begin
                if GuiAllowed then
                    Window.Update(1, Customer."No.");

            end;

            trigger OnPostDataItem()
            begin
                if GuiAllowed then
                    Window.Close();
            end;
        }


    }

    trigger OnInitReport()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then begin
            if not UserSetup."MICA Allow Combine Shipments" then
                Error(AutorizationErrorLbl);
        end else
            Error(AutorizationErrorLbl);
    end;

    trigger OnPreReport()
    begin
        if GuiAllowed then
            Window.Open(
                      Text002Lbl +
                      Text003Lbl +
                      Text004Lbl);
    end;



    var
        Window: Dialog;
        AutorizationErrorLbl: Label 'You are not allowed to run the Update Combine Shipment On Sales Orders process.';
        Text002Lbl: Label 'Updating Combining shipments...\\';
        Text003Lbl: Label 'Customer No.    #1##########\';
        Text004Lbl: Label 'Order No.       #2##########\';
}