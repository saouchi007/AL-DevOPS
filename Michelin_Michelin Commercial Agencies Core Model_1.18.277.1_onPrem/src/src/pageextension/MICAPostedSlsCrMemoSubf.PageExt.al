pageextension 80381 "MICA Posted Sls Cr. Memo Subf." extends "Posted Sales Cr. Memo Subform"
{
    layout
    {
        modify("Cross-Reference No.")
        {
            ApplicationArea = All;
            Visible = true;
        }

        addlast(Control1)
        {
            field("MICA Courntermark"; Rec."MICA Countermark")
            {
                ApplicationArea = All;

            }
            field("MICA Rebate Pool Entry No."; Rec."MICA Rebate Pool Entry No.")
            {
                ApplicationArea = All;
            }
        }
        addafter(Description)
        {
            field("MICA Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast("&Line")
        {
            action("MICA Applied Sales Line Disc.ne Disc.")
            {
                Caption = 'Applied Sales Line Disc.';
                Promoted = true;
                PromotedCategory = Category6;
                image = LineDiscount;
                ApplicationArea = All;
                RunObject = page "MICA Posted Applied SL Disc";
                RunPageView = WHERE("Posted Document Type" = CONST("Credit Memo"));
                RunPageLink = "Posted Document No." = FIELD("Document No."), "Posted Document Line No." = FIELD("Line No.");

            }

        }
    }
}