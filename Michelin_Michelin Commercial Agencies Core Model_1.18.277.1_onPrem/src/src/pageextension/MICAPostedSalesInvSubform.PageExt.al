pageextension 80188 "MICA Posted Sales Inv. Subform" extends "Posted Sales Invoice Subform"
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
            field("MICA Whse Ship. No."; Rec."MICA Whse Ship. No.")
            {
                ApplicationArea = All;
            }
            field("MICA Whse Ship. Line No."; Rec."MICA Whse Ship. Line No.")
            {
                ApplicationArea = All;
            }
            field("MICA Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
            }
            field("MICA Order Line No."; Rec."Order Line No.")
            {
                ApplicationArea = All;
            }
            field("MICA Shipment No."; Rec."Shipment No.")
            {
                ApplicationArea = All;
            }
            field("MICA Shipment Line No."; Rec."Shipment Line No.")
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
                RunPageView = WHERE("Posted Document Type" = CONST(Invoice));
                RunPageLink = "Posted Document No." = FIELD("Document No."), "Posted Document Line No." = FIELD("Line No.");

            }

        }
    }
}