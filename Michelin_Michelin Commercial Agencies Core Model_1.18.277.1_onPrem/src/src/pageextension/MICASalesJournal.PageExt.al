pageextension 82141 "MICA Sales Journal" extends "Sales Journal"
{
    layout
    {

        addafter(Description)
        {
            field("MICA Posting Group Alt."; Rec."MICA Posting Group Alt.")
            {
                ApplicationArea = All;
                Visible = MICAMultiPosting;
            }
        }

        modify("VAT Bus. Posting Group")
        {
            Visible = MICAMultiPosting;
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