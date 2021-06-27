#pragma implicitwith disable
pageextension 80220 "MICA Location Card" extends "Location Card"
{
    layout
    {
        addlast(Content)
        {
            group("MICA Michelin")
            {
                Caption = 'Michelin';
                field("MICA Outbound Whse. Handling Time Express Order"; Rec."MICA Outb Whse Hand T Exp Ord")
                {
                    ApplicationArea = All;
                }

                field("MICA Base Calendar Code Express Order"; Rec."MICA Base Cal. Code Exp. Order")
                {
                    ApplicationArea = All;
                }

                field("MICA Regular Cut Off"; Rec."MICA Regular Cut Off")
                {
                    ApplicationArea = All;
                }

                field("MICA Express Cut Off"; Rec."MICA Express Cut Off")
                {
                    ApplicationArea = All;
                }

                field("MICA Entry Type"; Rec."MICA Entry Type")
                {
                    ApplicationArea = All;
                }
                field("MICA PIT Location Code"; Rec."MICA PIT Location Code")
                {
                    ApplicationArea = All;
                }
                field("MICA DRP IN Location Code"; Rec."MICA DRP IN Location Code")
                {
                    ApplicationArea = All;
                }
                field("MICA DRP OUT Location Code"; Rec."MICA DRP OUT Location Code")
                {
                    ApplicationArea = All;
                }
                field("MICA Blocked Inv. Location"; Rec."MICA Blocked Inv. Location")
                {
                    ApplicationArea = All;
                }
                field("MICA 3PL Location Code"; Rec."MICA 3PL Location Code")
                {
                    ApplicationArea = All;
                }
                field("MICA 3PL Location Name"; Rec."MICA 3PL Location Name")
                {
                    ApplicationArea = All;
                }
                field("MICA 3PL Integration"; Rec."MICA 3PL Integration")
                {
                    ApplicationArea = All;
                }
                field("MICA SRD Default Delay"; Rec."MICA SRD Default Delay")
                {
                    ApplicationArea = All;
                }
                field("MICA Whse. Receipt Creation Period"; Rec."MICA Whse. Receipt Creat. Per.")
                {
                    ApplicationArea = All;
                }
                field("MICA Commitment Type"; Rec."MICA Commitment Type")
                {
                    ApplicationArea = All;
                }
                field("MICA 3PL Anticipation Period"; Rec."MICA 3PL Anticipation Period")
                {
                    ApplicationArea = All;
                }
                field("MICA 3PL E-Mail for Sales Docs"; Rec."MICA 3PL E-Mail for Sales Docs")
                {
                    ApplicationArea = All;
                }
                field("MICA 3PL Email Pstd. Shpt."; Rec."MICA 3PL Email Pstd. Shpt.")
                {
                    ApplicationArea = All;
                }

                field("MICA 3PL Email Pstd. Inv."; Rec."MICA 3PL Email Pstd. Inv.")
                {
                    ApplicationArea = All;
                }

                field("MICA eFDM On Hand Quantity"; Rec."MICA eFDM On Hand Quantity")
                {
                    ApplicationArea = All;
                }
                field("MICA eFDM Blocked Quantity"; Rec."MICA eFDM Blocked Quantity")
                {
                    ApplicationArea = All;
                }
                field("MICA SPD OnHand Qty. Code"; Rec."MICA SPD OnHand Qty. Code")
                {
                    ApplicationArea = All;
                }
                field("MICA SPD Blocked Qty. Code"; Rec."MICA SPD Blocked Qty. Code")
                {
                    ApplicationArea = All;
                }
                field("MICA Pick-Up Calendar"; Rec."MICA Pick-Up Calendar")
                {
                    ApplicationArea = All;
                }
                field("MICA Pick-Up Shipping Agent"; Rec."MICA Pick-Up Shipping Agent")
                {
                    ApplicationArea = All;
                }
                field("MICA PickUp Ship Agent Service"; Rec."MICA PickUp Ship Agent Service")
                {
                    ApplicationArea = All;
                }
                field("MICA Allocation Detail"; Rec."MICA Allocation Detail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Allocation Detail';
                }
                field("MICA Inventory Organization"; Rec."MICA Inventory Organization")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Inventory Organization';
                }
                field("MICA Exclude from DRP"; Rec."MICA Exclude from DRP")
                {
                    ApplicationArea = All;
                }
                field("MICA 3rd Party Vendor No."; Rec."MICA 3rd Party Vendor No.")
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
#pragma implicitwith restore
