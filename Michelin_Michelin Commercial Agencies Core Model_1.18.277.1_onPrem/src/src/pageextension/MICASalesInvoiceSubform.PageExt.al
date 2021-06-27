pageextension 80187 "MICA Sales Invoice Subform" extends "Sales Invoice Subform"
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
            field("MICA Sales Agreement No."; Rec."MICA Sales Agreement No.")
            {
                ApplicationArea = All;
            }
            field("MICA Priority Code"; Rec."MICA Priority Code")
            {
                ApplicationArea = All;
            }
            field("MICA Payment Terms Code"; Rec."MICA Payment Terms Code")
            {
                ApplicationArea = All;
            }
            field("MICA Payment Method Code"; Rec."MICA Payment Method Code")
            {
                ApplicationArea = All;
            }
            field("MICA Item Category Code"; Rec."Item Category Code")
            {
                ApplicationArea = All;
            }
            field("MICA Due Date"; Rec."MICA Due Date")
            {
                ApplicationArea = All;
            }
            field("MICA Courntermark"; Rec."MICA Countermark")
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
        addlast("Related Information")
        {
            action("MICA Applied Sales Line Disc.ne Disc.")
            {
                Caption = 'Applied Sales Line Disc.';
                Promoted = true;
                PromotedCategory = Category6;
                image = LineDiscount;
                ApplicationArea = All;
                RunObject = page "MICA Applied Sales Line Disc.";
                RunPageLink = "Document Type" = FIELD ("Document Type"), "Document No." = FIELD ("Document No."), "Document Line No." = FIELD ("Line No.");
            }
        }
    }
}