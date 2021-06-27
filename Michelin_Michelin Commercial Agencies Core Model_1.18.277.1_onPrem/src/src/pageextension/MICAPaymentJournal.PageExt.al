pageextension 81550 "MICA Payment Journal" extends "Payment Journal" //MyTargetPageId
{

    layout
    {
        addafter("Account No.")
        {
            field("MICA Tax Payment"; Rec."MICA Tax Payment")
            {
                ApplicationArea = All;
            }
        }
        moveafter("MICA Tax Payment"; "Exported to Payment File")
        modify("VAT Bus. Posting Group")
        {
            Visible = MICAMultiPosting;
        }

        addafter("VAT Prod. Posting Group")
        {
            field("MICA Posting Group Alt."; Rec."MICA Posting Group Alt.")
            {
                ApplicationArea = All;
                Visible = MICAMultiPosting;
            }
        }
        addafter(Description)
        {
            field("MICA Additional Information 1"; Rec."MICA Additional Information 1")
            {
                ApplicationArea = All;
                Editable = AdditionalInfoAllowed and not Rec."Exported to Payment File";
            }
            field("MICA Additional Information 2"; Rec."MICA Additional Information 2")
            {
                ApplicationArea = All;
                Editable = AdditionalInfoAllowed and not Rec."Exported to Payment File";
            }
            field("MICA Additional Information 3"; Rec."MICA Additional Information 3")
            {
                ApplicationArea = All;
                Editable = AdditionalInfoAllowed and not Rec."Exported to Payment File";
            }
            field("MICA Additional Information 4"; Rec."MICA Additional Information 4")
            {
                ApplicationArea = All;
                Editable = AdditionalInfoAllowed and not Rec."Exported to Payment File";
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action("MICA Generate XML")
            {
                Image = CreateXMLFile;
                Caption = 'Generate XML Mass Payment';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"MICA Execute Mass Payment", Rec);
                end;
            }
            action("MICA Unmark Exported Payment")
            {
                Image = Close;
                Caption = 'Unmark Exported Payment';
                ApplicationArea = All;
                trigger OnAction()
                var
                    ToGenJnlLine: Record "Gen. Journal Line";
                begin
                    SetSelectionFilter(ToGenJnlLine);
                    Rec.UnmarkExportedPayment(ToGenJnlLine);
                end;
            }

            action("MICA Send Mass Payment Files")
            {
                Image = SendTo;
                Caption = 'Send Mass Payment File(s)';
                ApplicationArea = All;
                trigger OnAction()
                var
                    ExecuteMassPayment: codeunit "MICA Execute Mass Payment";
                begin
                    ExecuteMassPayment.ExecuteSendFlowMassPayment();
                end;
            }

            action("MICA SuggestVendorPayments")
            {
                Image = SuggestVendorPayments;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                Ellipsis = true;
                Caption = 'Suggest Vendor Payments';
                ApplicationArea = All;
                ToolTip = 'Create payment suggestions as lines in the payment journal.';
                trigger OnAction()
                var
                    SuggestVendorPayments: report "MICA Suggest Vendor Payments";
                begin
                    CLEAR(SuggestVendorPayments);
                    SuggestVendorPayments.SetGenJnlLine(Rec);
                    SuggestVendorPayments.RUNMODAL();
                End;
            }
            action("MICA SuggestEmployeePayments")
            {
                Image = SuggestVendorPayments;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                Ellipsis = true;
                Caption = 'Suggest Employee Payments';
                ApplicationArea = All;
                ToolTip = 'Create payment suggestions as lines in the payment journal.';
                trigger OnAction()
                var
                    SuggestEmployeePayments: Report "MICA Suggest Employee Payments";
                begin
                    CLEAR(SuggestEmployeePayments);
                    SuggestEmployeePayments.SetGenJnlLine(Rec);
                    SuggestEmployeePayments.RUNMODAL();
                End;
            }
        }

        modify(SuggestVendorPayments)
        {
            Visible = false;
        }

        modify(SuggestEmployeePayments)
        {
            Visible = false;
        }

        addlast("&Payments")
        {
            action("MICA Print Remi&ttance Advice")
            {
                Caption = 'Print Remi&ttance Advice';
                Image = PrintAttachment;
                ToolTip = 'Print the remittance advice before posting a payment journal and after posting a payment. This advice displays vendor invoice numbers, which helps vendors to perform reconciliations.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    GenJnlLine: Record "Gen. Journal Line";
                begin
                    GenJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    CurrPage.SetSelectionFilter(GenJnlLine);
                    REPORT.RUN(REPORT::"MICA Remitance Advice Journal", TRUE, FALSE, GenJnlLine);
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
                    GenJnlLine: Record "Gen. Journal Line";
                begin
                    GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    CurrPage.SetSelectionFilter(GenJnlLine);
                    DocumentSendingProfile.SendVendorRecords(
                        DummyReportSelections.Usage::"V.Remittance".AsInteger(), GenJnlLine, RemittanceAdviceTxt,
                        Rec."Account No.", Rec."Document No.", Rec.FieldNo("Account No."), Rec.FieldNo("Document No."));
                end;
            }
        }

    }

    var
        MICAMultiPosting: Boolean;
        AdditionalInfoAllowed: Boolean;
        RemittanceAdviceTxt: Label 'Remittance Advice';

    trigger OnOpenPage()
    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        if MICAFinancialReportingSetup.Get() then
            MICAMultiPosting := MICAFinancialReportingSetup."Multi-Posting"
        else
            MICAMultiPosting := false;
        if PurchasesPayablesSetup.Get() then
            AdditionalInfoAllowed := PurchasesPayablesSetup."MICA Add. Info. in Mass Pmt.";
    End;

}
