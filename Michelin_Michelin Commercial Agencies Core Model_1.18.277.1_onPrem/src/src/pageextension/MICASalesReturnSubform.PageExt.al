pageextension 81642 "MICA Sales Return Subform" extends "Sales return Order Subform"
{
    layout
    {
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
                Editable = false;
            }
            field("MICA Due Date"; Rec."MICA Due Date")
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
        addafter(Quantity)
        {
            field("MICA Status"; Rec."MICA Status")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}