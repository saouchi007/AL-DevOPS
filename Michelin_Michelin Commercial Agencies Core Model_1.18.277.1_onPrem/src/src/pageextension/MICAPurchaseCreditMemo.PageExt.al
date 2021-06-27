pageextension 82023 "MICA Purchase Credit Memo" extends "Purchase Credit Memo"
{
    layout
    {
        modify("VAT Bus. Posting Group")
        {
            ApplicationArea = All;
            Visible = MICAMultiPosting;
        }

        addafter("VAT Bus. Posting Group")
        {
            field("MICA Vendor Posting Group Alt."; Rec."MICA Vendor Posting Group Alt.")
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
        addlast(Content)
        {
            group("MICA Michelin")
            {
                Caption = 'Michelin';
                field("MICA RELFAC Code"; Rec."MICA RELFAC Code")
                {
                    ApplicationArea = All;
                }
                field("MICA Total Inv. Amt.(excl.VAT)"; Rec."MICA Total Inv. Amt.(excl.VAT)")
                {
                    ApplicationArea = All;
                }

                field("MICA GIS Invoice Doc. No."; Rec."MICA GIS Invoice Doc. No.")
                {
                    ApplicationArea = All;
                }

                field("MICA GIS Invoice Doc. Date"; Rec."MICA GIS Invoice Doc. Date")
                {
                    ApplicationArea = All;
                }

                field("MICA GIS Rebill Reason Code"; Rec."MICA GIS Rebill Reason Code")
                {
                    ApplicationArea = All;
                }

                field("MICA GIS Ship-to Location"; Rec."MICA GIS Ship-to Location")
                {
                    ApplicationArea = All;
                }

                field("MICA GIS Despatch Country"; Rec."MICA GIS Despatch Country")
                {
                    ApplicationArea = All;
                }

                field("MICA GIS DCN No."; Rec."MICA GIS DCN No.")
                {
                    ApplicationArea = All;
                }
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