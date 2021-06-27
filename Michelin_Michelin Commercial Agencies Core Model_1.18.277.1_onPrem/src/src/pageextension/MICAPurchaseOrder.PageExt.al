pageextension 81141 "MICA Purchase Order" extends "Purchase Order"
{
    layout
    {

        modify("VAT Bus. Posting Group")
        {
            ApplicationArea = All;
            Visible = MultiPosting;
        }

        addafter("VAT Bus. Posting Group")
        {
            field("MICA Vendor Posting Group Alt."; Rec."MICA Vendor Posting Group Alt.")
            {
                ApplicationArea = All;
                Visible = MultiPosting;
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
                field("MICA AL No."; Rec."MICA AL No.")
                {
                    ApplicationArea = All;
                }
                field("MICA Container ID"; Rec."MICA Container ID")
                {
                    ApplicationArea = All;
                }
                field("MICA Location-To Code"; Rec."MICA Location-To Code")
                {
                    ApplicationArea = All;
                }
                field("MICA Shipment Instructions"; Rec."MICA Shipment Instructions")
                {
                    ApplicationArea = All;
                }
                field("MICA 3rd Party"; Rec."MICA 3rd Party")
                {
                    ApplicationArea = All;
                }

            }
            group("MICA Flow Integration")
            {
                Caption = 'Flow Integration';
                field("MICA Send Last Flow Entry No."; Rec."MICA Send Last Flow Entry No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("MICA Send Last Flow Status"; Rec."MICA Send Last Flow Status")
                {
                    Editable = false;
                    ApplicationArea = All;

                }

                field("MICA Rcv. Last Flow Entry No."; Rec."MICA Rcv. Last Flow Entry No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }

                field("MICA Record ID"; Rec."MICA Record ID")
                {
                    ApplicationArea = All;

                }
            }
        }
        addlast(FactBoxes)
        {
            part(FlowResult; "MICA Flow Result")
            {
                ApplicationArea = All;
                SubPageLink = "MICA Send Last Flow Entry No." = FIELD("MICA Send Last Flow Entry No."), "MICA Rcv. Last Flow Entry No." = FIELD("MICA Rcv. Last Flow Entry No.");
            }
        }

        addlast(General)
        {
            field("MICA Auto. Trans. Order"; Rec."MICA Auto. Trans. Order")
            {
                ApplicationArea = All;
            }
            field("MICA ETA"; Rec."MICA ETA")
            {
                ApplicationArea = All;
            }
            field("MICA SRD"; Rec."MICA SRD")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }

    }

    Var
        MultiPosting: Boolean;

    trigger OnOpenPage()
    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
    begin
        if MICAFinancialReportingSetup.Get() then
            MultiPosting := MICAFinancialReportingSetup."Multi-Posting"
        else
            MultiPosting := false;

    End;

    trigger OnAfterGetRecord()
    begin
        CurrPage.FlowResult.Page.Initialize(Rec."MICA Send Last Flow Entry No.", Rec."MICA Rcv. Last Flow Entry No.", Rec."MICA Record ID");
    end;
}