pageextension 82143 "MICA Purchase Journal" extends "Purchase Journal"
{
    layout
    {
        modify("VAT Bus. Posting Group")
        {
            Visible = MICAMultiPosting;
        }

        addafter(DocumentAmount)
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