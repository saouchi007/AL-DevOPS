pageextension 81150 "MICA Posted Purchase Invoice" extends "Posted Purchase Invoice"
{
    layout
    {
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

                field("MICA Vendor Posting Group"; Rec."Vendor Posting Group")
                {
                    ApplicationArea = All;
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
        }
        addlast(FactBoxes)
        {
            part(FlowResult; "MICA Flow Result")
            {
                ApplicationArea = All;
                SubPageLink = "MICA Send Last Flow Entry No." = FIELD("MICA Send Last Flow Entry No."), "MICA Rcv. Last Flow Entry No." = FIELD("MICA Rcv. Last Flow Entry No.");
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        CurrPage.FlowResult.Page.Initialize(Rec."MICA Send Last Flow Entry No.", Rec."MICA Rcv. Last Flow Entry No.", Rec."MICA Record ID");
    end;
}