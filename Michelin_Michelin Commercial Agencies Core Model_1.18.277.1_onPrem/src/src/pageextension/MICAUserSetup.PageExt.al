pageextension 80760 "MICA User Setup" extends "User Setup" //MyTargetPageId
{
    layout
    {
        addlast(Control1)
        {
            field("MICA AllowRunJobQueue"; Rec."MICA Allow Run JobQueue")
            {
                Caption = 'Allow Run JobQueue';
                ApplicationArea = All;
            }
            field("MICA Allow SalePrice & CTC Upd"; Rec."MICA Allow SalePrice & CTC Upd")
            {
                Caption = 'Allow Sales Price & CTC Modification';
                ApplicationArea = All;
            }
            field("MICA Allow Dates SO lines"; Rec."MICA Allow Dates SO lines")
            {
                ApplicationArea = All;
            }
            field("MICA Allow Amt.FCY Era.Process"; Rec."MICA Allow Amt.FCY Era.Process")
            {
                ApplicationArea = All;
            }
            field("MICA Allow Combine Shipments"; Rec."MICA Allow Combine Shipments")
            {
                ApplicationArea = All;
            }
            field("MICA Allow Deletion Rebates"; Rec."MICA Allow Deletion Rebates")
            {
                ApplicationArea = All;
            }
            field("MICA Allow Calc. Rebates"; Rec."MICA Allow Calc. Rebates")
            {
                ApplicationArea = All;
            }
            field("MICA 3rd Party Vendor No."; Rec."MICA 3rd Party Vendor No.")
            {
                ApplicationArea = All;
            }
            field("MICA Allow Edit Reb. Pool Jnl."; Rec."MICA Allow Edit Reb. Pool Jnl.")
            {
                ApplicationArea = All;
            }
        }
        addafter(Email)
        {
            field("MICA User Category"; Rec."MICA User Category")
            {
                Caption = 'User Category';
                ApplicationArea = ALL;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action("MICA Update Posting period")
            {
                ApplicationArea = all;
                Caption = 'Update Posting period';
                RunObject = report "MICA Update Posting Period";
                Image = Calculate;
                Promoted = true;

            }
        }
    }
}