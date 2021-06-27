pageextension 82021 "MICA Posted Purchase Cr. Memo" extends "Posted Purchase Credit Memo"
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
            }
        }
    }

    actions
    {
    }
}