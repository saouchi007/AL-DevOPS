pageextension 80382 "MICA Sales Order Arch. Subform" extends "Sales Order Archive Subform"
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
            field("MICA Status"; Rec."MICA Status")
            {
                ApplicationArea = All;
            }
            field("MICA Cancel. Reason"; Rec."MICA Cancel. Reason")
            {
                ApplicationArea = All;
            }
            field("MICA Cancelled"; Rec."MICA Cancelled")
            {
                ApplicationArea = All;
            }
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
            field("MICA Exceptional Disc. %"; Rec."MICA Exceptional Disc. %")
            {
                ApplicationArea = All;
            }
            field("MICA Except. Rebate Reason"; Rec."MICA Except. Rebate Reason")
            {
                ApplicationArea = All;
            }
            field("MICA Payment Terms Line Disc. %"; Rec."MICA Pay. Terms Line Disc. %")
            {
                ApplicationArea = All;
            }
            field("MICA Splitted Line"; Rec."MICA Splitted Line")
            {
                ApplicationArea = All;
            }
            field("MICA Catalog Item No."; Rec."MICA Catalog Item No.")
            {
                ApplicationArea = All;
            }

            field("MICA Source Line Commit Date"; Rec."MICA Source Line Commit Date")
            {
                ApplicationArea = All;
            }

            field("MICA Split Src. Express Order Qty (base)"; Rec."MICA Split Src Exp Ord Qty (b)")
            {
                ApplicationArea = All;
            }
            field("MICA 3PL Whse Shpt. Comment"; Rec."MICA 3PL Whse Shpt. Comment")
            {
                ApplicationArea = All;
            }
            field("MICA Delivery Date Modified"; Rec."MICA Delivery Date Modified")
            {
                ApplicationArea = All;
            }
            field("MICA Release Status Count"; Rec."MICA Release Status Count")
            {
                ApplicationArea = All;
            }
            field("MICA Prev. Planned Del. Date"; Rec."MICA Prev. Planned Del. Date")
            {
                ApplicationArea = All;
            }
            field("MICA Requested Receipt Date"; Rec."MICA Requested Receipt Date")
            {
                ApplicationArea = All;
            }

            field("MICA Promised Receipt Date"; Rec."MICA Promised Receipt Date")
            {
                ApplicationArea = All;
            }
            field("MICA Transport Instruction"; Rec."MICA Transport Instruction")
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
    }
}