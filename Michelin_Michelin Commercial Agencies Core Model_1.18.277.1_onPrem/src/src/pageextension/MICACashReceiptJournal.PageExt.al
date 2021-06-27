pageextension 82142 "MICA Cash Receipt Journal" extends "Cash Receipt Journal"
{
    layout
    {
        modify("VAT Bus. Posting Group")
        {
            Visible = MICAMultiPosting;
        }

        addafter(Description)
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