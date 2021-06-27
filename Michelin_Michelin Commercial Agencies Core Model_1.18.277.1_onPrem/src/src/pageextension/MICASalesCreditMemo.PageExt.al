pageextension 81644 "MICA Sales Credit Memo" extends "Sales Credit Memo"
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
        addlast(General)
        {
            field("MICA Credit Memo Reason Code"; Rec."MICA Credit Memo Reason Code")
            {
                ApplicationArea = All;
            }
            field("MICA Credit Memo Reason Desc."; Rec."MICA Credit Memo Reason Desc.")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter(IncomingDocument)
        {
            action("MICA Close Rebate Pool Entry")
            {
                ApplicationArea = All;
                Caption = 'Close Rebate Pool Entry';
                Image = ClosePeriod;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category9;

                trigger OnAction()
                var
                    MICARebatePoolMgt: Codeunit "MICA Rebate Pool Mgt.";
                begin
                    MICARebatePoolMgt.SetRecord(Rec);
                    MICARebatePoolMgt.CreateCrMemoLinesFromRebPoolEntries();
                end;
            }
        }
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