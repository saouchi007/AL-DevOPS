pageextension 81360 "MICA Item Ledger Entries" extends "Item Ledger Entries" //MyTargetPageId
{
    layout
    {
        movefirst(Control1; "Entry No.")
        moveafter("Entry No."; "Item No.")

        addafter(Quantity)
        {
            field("MICA Document Date"; Rec."Document Date")
            {
                ApplicationArea = All;
            }
            field("MICA External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
            field("MICA Document Line No."; Rec."Document Line No.")
            {
                ApplicationArea = All;
            }
            field("MICA Source Type"; Rec."Source Type")
            {
                ApplicationArea = All;
            }
            field("MICA Source No."; Rec."Source No.")
            {
                ApplicationArea = All;
            }
        }
        moveafter("MICA External Document No."; "Document Type")
        //moveafter("Document Line No."; "Order Type")
        addafter("Order Type")
        {
            field("MICA Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
            }
            field("MICA Order Line No."; Rec."Order Line No.")
            {
                ApplicationArea = All;
            }
            field("MICA Unit of Measure Code"; Rec."Unit of Measure Code")
            {
                ApplicationArea = All;
            }
            field("MICA Item Category Code"; Rec."Item Category Code")
            {
                ApplicationArea = All;
            }

            field("MICA Nonstock"; Rec.Nonstock)
            {
                Visible = true;
                ApplicationArea = All;
            }

            field("MICA Return Reason Code"; Rec."Return Reason Code")
            {
                ApplicationArea = All;
            }
            field("MICA Reason Code"; Rec."MICA Reason Code")
            {
                ApplicationArea = All;
            }

        }

        // moveafter("MICA Nonstock"; "Cost Amount (Actual)")

        modify("Invoiced Quantity")
        {
            Visible = false;
        }
        modify("Remaining Quantity")
        {
            Visible = false;
        }

        addlast(Control1)
        {
            field("MICA Send Last Flow Entry No."; Rec."MICA Send Last Flow Entry No.")
            {
                Visible = false;
                Editable = false;
                ApplicationArea = All;
            }
            field("MICA Send Last Flow Status"; Rec."MICA Send Last Flow Status")
            {
                Visible = false;
                Editable = false;
                ApplicationArea = All;

            }

            field("MICA Send Ack. Received"; Rec."MICA Send Ack. Received")
            {
                Visible = false;
                Editable = false;
                ApplicationArea = All;
            }

            field("MICA Rcv. Last Flow Entry No."; Rec."MICA Rcv. Last Flow Entry No.")
            {
                Visible = false;
                Editable = false;
                ApplicationArea = All;
            }
            field("MICA Record ID"; Rec."MICA Record ID")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("MICA User Item Type"; Rec."MICA User Item Type")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
        addlast(FactBoxes)
        {
            part(FlowResult; "MICA Flow Result")
            {
                ApplicationArea = All;
                SubPageLink = "MICA Send Last Flow Entry No." = FIELD("MICA Send Last Flow Entry No."), "MICA Rcv. Last Flow Entry No." = FIELD("MICA Rcv. Last Flow Entry No.");
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        CurrPage.FlowResult.Page.Initialize(Rec."MICA Send Last Flow Entry No.", Rec."MICA Rcv. Last Flow Entry No.", Rec."MICA Record ID");
    end;
}
