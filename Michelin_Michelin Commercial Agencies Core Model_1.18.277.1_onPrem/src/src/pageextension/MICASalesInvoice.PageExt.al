pageextension 81643 "MICA Sales Invoice" extends "Sales Invoice"
{

    layout
    {
        modify("Payment Terms Code")
        {
            Visible = false;
        }
        modify("Payment Method Code")
        {
            visible = false;
        }

        modify("VAT Bus. Posting Group")
        {
            ApplicationArea = All;
            Visible = MICAMultiPosting;
        }

        addafter("VAT Bus. Posting Group")
        {
            field("MICA Customer Posting Group Alt."; Rec."MICA Cust. Posting Group Alt.")
            {
                ApplicationArea = All;
                Visible = MICAMultiPosting;
            }

            field("MICA Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
    }

    actions
    {
    }

    Var
        MICAMultiPosting: Boolean;

    trigger OnOpenPage()
    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
    begin
        if MICAFinancialReportingSetup.Get() then
            MICAMultiPosting := MICAFinancialReportingSetup."Multi-Posting"
        else
            MICAMultiPosting := false;

    End;
}