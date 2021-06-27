#pragma implicitwith disable
pageextension 80082 "MICA ChartOfAccount" extends "Chart of Accounts"
{
    layout
    {
        addlast(Control1)
        {
            field("MICA No. 2"; Rec."No. 2")
            {
                ApplicationArea = All;
            }
            field("MICA Excl. From Flux2 Report"; Rec."MICA Excl. From Flux2 Report")
            {
                ApplicationArea = All;
            }
            field("MICA F2 Incl. Year Amt. Only"; Rec."MICA F2 Incl. Year Amt. Only")
            {
                ApplicationArea = All;
                Editable = not Rec."MICA Excl. From Flux2 Report";
            }
            field("MICA Incl. on Flux2 Code3 Rpt."; Rec."MICA Incl. on Flux2 Code3 Rpt.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(Dimensions)
        {
            action("MICA Forced_Dimension")
            {
                Caption = 'Forced Dimension';
                Promoted = true;
                PromotedCategory = Process;
                image = ChangeDimensions;
                ApplicationArea = All;
                RunObject = page "MICA G/L Acc. Forced Dim.";
                RunPageLink = "MICA G/L Account No." = field("No.");
            }
            action("MICA Allowed_Dimension")
            {
                Caption = 'Allowed Dimension';
                Promoted = true;
                PromotedCategory = Process;
                image = MapDimensions;
                ApplicationArea = All;
                RunObject = page "MICA G/L Acc. Allowed Dim.";
                RunPageLink = "MICA G/L Account No." = field("No.");
            }
        }
    }
}
#pragma implicitwith restore
