pageextension 81660 "MICA Vendor Ledger Entries" extends "Vendor Ledger Entries"
{
    layout
    {
        addafter("Exported to Payment File")
        {
            field("MICA Closed by Entry No."; Rec."Closed by Entry No.")
            {
                ApplicationArea = All;

            }
            field("MICA Closed at Date"; Rec."Closed at Date")
            {
                ApplicationArea = All;
            }

        }

        addlast(Control1)
        {
            field("MICA MICAMessage to Recipient"; Rec."Message to Recipient")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addLast("F&unctions")
        {
            action("MICA Remittance Advise")
            {
                Caption = 'Remittance Advice';
                Image = Attach;
                ToolTip = 'View which documents have been included in the payment.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    VendLedgEntry: Record "Vendor Ledger Entry";
                begin
                    VendLedgEntry.COPYFILTERS(Rec);
                    CurrPage.SetSelectionFilter(VendLedgEntry);
                    REPORT.RUN(REPORT::"MICA Remittance Advice Entries", TRUE, FALSE, VendLedgEntry);
                end;
            }
            action("MICA SendRemittanceAdvice")
            {
                ApplicationArea = All;
                Caption = 'Send Remittance Advice';
                Image = SendToMultiple;
                ToolTip = 'Send the remittance advice before posting a payment journal or after posting a payment. The advice contains vendor invoice numbers, which helps vendors to perform reconciliations.';

                trigger OnAction()
                var
                    DocumentSendingProfile: Record "Document Sending Profile";
                    DummyReportSelections: Record "Report Selections";
                    VendLedgEntry: Record "Vendor Ledger Entry";
                begin
                    VendLedgEntry.COPYFILTERS(Rec);
                    CurrPage.SetSelectionFilter(VendLedgEntry);
                    DocumentSendingProfile.SendVendorRecords(
                      DummyReportSelections.Usage::"P.V.Remit.".AsInteger(), VendLedgEntry, RemittanceAdviceTxt,
                      Rec."Vendor No.", Rec."Document No.", Rec.FIELDNO("Vendor No."), Rec.FIELDNO("Document No."));
                end;
            }

        }
    }

    var
        RemittanceAdviceTxt: Label 'Remittance Advice';
}