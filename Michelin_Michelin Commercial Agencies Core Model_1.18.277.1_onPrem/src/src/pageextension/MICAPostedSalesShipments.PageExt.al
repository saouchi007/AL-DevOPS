pageextension 81060 "MICA Posted Sales Shipments" extends "Posted Sales Shipments"
{
    layout
    {
        addlast(Control1)
        {
            field("MICA Stat./Send. S. Doc./Whse."; Rec."MICA Stat./Send. S. Doc./Whse.")
            {
                ApplicationArea = All;
            }
            field("MICA Send. S. Doc./Whse. Text"; Rec."MICA Send. S. Doc./Whse. Text")
            {
                ApplicationArea = All;
                trigger OnAssistEdit()
                begin
                    Rec.ShowSendEmailWhseErrorMessage();
                end;
            }
            field("MICA S.Doc. Type to Send/Whse."; Rec."MICA S.Doc. Type to Send/Whse.")
            {
                ApplicationArea = All;
            }
            field("MICA DT Email to Whse. Status"; Rec."MICA DT Email to Whse. Status")
            {
                ApplicationArea = All;
            }
            field("MICA User Email to Whse. St."; Rec."MICA User Email to Whse. St.")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
        addafter("Location Code")
        {
            field("MICA Truck Driver Info"; Rec."MICA Truck Driver Info")
            {
                ApplicationArea = All;
            }
            field("MICA Truck License Plate"; Rec."MICA Truck License Plate")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast("F&unctions")
        {
            action("MICA Force Email Sending to Warehouse")
            {
                ApplicationArea = All;
                Image = "Invoicing-Mail";
                caption = 'Force email sending to warehouse';
                trigger OnAction()
                var
                    SalesShipmentHeader: Record "Sales Shipment Header";
                    WhseEmailAfterPost: Codeunit "MICA Whse. Email After Post";
                    SendEmailRunnedLbl: label 'Force email sending to warehouse executed with success. Check %1 on posted sales shipment';
                    SendEmailRunnedErr: label 'Force email sending to warehouse executed with errors. Last error was %1';
                begin
                    CurrPage.SetSelectionFilter(SalesShipmentHeader);
                    WhseEmailAfterPost.SetSpecificFiltersOnSalesShptHdrToForceSending(SalesShipmentHeader);
                    ClearLastError();
                    if WhseEmailAfterPost.Run() then
                        message(StrSubstNo(SendEmailRunnedLbl, SalesShipmentHeader.FieldCaption("MICA Stat./Send. S. Doc./Whse.")))
                    else
                        message(StrSubstNo(SendEmailRunnedErr, GetLastErrorText()));
                    CurrPage.Update(true);
                end;

            }
            action("MICA Cancel Email Sending to Warehouse")
            {
                ApplicationArea = All;
                Image = "Invoicing-MailCanceled";
                Caption = 'Cancel email sending to warehouse';
                trigger OnAction()
                var
                    SalesShipmentHeader: Record "Sales Shipment Header";
                    WhseEmailAfterPost: Codeunit "MICA Whse. Email After Post";
                begin
                    CurrPage.SetSelectionFilter(SalesShipmentHeader);
                    WhseEmailAfterPost.CancelEmailSendingToWarehouse(SalesShipmentHeader);
                    CurrPage.Update(true);
                end;
            }
        }
    }
}