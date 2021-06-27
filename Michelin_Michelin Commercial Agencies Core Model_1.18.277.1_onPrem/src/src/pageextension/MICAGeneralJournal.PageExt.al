pageextension 82140 "MICA General Journal" extends "General Journal"
{
    layout
    {

        modify("VAT Bus. Posting Group")
        {
            ApplicationArea = All;
            Visible = MICAMultiPosting;
        }

        addafter("Account No.")
        {
            field("MICA Posting Group Alt."; Rec."MICA Posting Group Alt.")
            {
                ApplicationArea = All;
                Visible = MICAMultiPosting;
            }
        }
    }
    var
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