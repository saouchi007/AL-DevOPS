pageextension 80641 "MICA Location List" extends "Location List"
{
    layout
    {
        addlast(Control1)
        {
            field("MICA Entry Type"; Rec."MICA Entry Type")
            {
                ApplicationArea = all;
            }
            field("MICA 3PL Integration"; Rec."MICA 3PL Integration")
            {
                ApplicationArea = All;
                visible = false;
            }
            field("MICA 3PL Location Code"; Rec."MICA 3PL Location Code")
            {
                ApplicationArea = All;
                visible = false;
            }
            field("MICA 3PL Location Name"; Rec."MICA 3PL Location Name")
            {
                ApplicationArea = All;
                visible = false;
            }
            field("MICA 3PL Email Pstd. Shpt."; Rec."MICA 3PL Email Pstd. Shpt.")
            {
                ApplicationArea = All;
                Visible = false;
            }

            field("MICA 3PL Email Pstd. Inv."; Rec."MICA 3PL Email Pstd. Inv.")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("MICA DRP IN Location Code"; Rec."MICA DRP IN Location Code")
            {
                ApplicationArea = All;
                visible = false;
            }
            field("MICA DRP OUT Location Code"; Rec."MICA DRP OUT Location Code")
            {
                ApplicationArea = All;
                visible = false;
            }
            field("MICA Blocked Inv. Location"; Rec."MICA Blocked Inv. Location")
            {
                ApplicationArea = All;
            }
            field("MICA Whse. Receipt Creation Period"; Rec."MICA Whse. Receipt Creat. Per.")
            {
                ApplicationArea = All;
            }
            field("MICA SRD Default Delay"; Rec."MICA SRD Default Delay")
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
        }
    }
}