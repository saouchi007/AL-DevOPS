pageextension 81240 "MICA Warehouse Receipts" extends "Warehouse Receipts"
{
    layout
    {
        addlast(Control1)
        {
            field("MICA 3PL Update Status"; Rec."MICA 3PL Update Status")
            {
                ApplicationArea = All;
                Visible = false;
            }
            //Flow integration
            field("MICA Send Last Flow Entry No."; Rec."MICA Send Last Flow Entry No.")
            {
                Editable = false;
                ApplicationArea = All;
                Visible = false;
            }
 
            field("MICA Send Ack. Received"; Rec."MICA Send Ack. Received")
            {
                Editable = false;
                ApplicationArea = All;
                Visible = false;
            }
            field("MICA Rcv. Last Flow Entry No."; Rec."MICA Rcv. Last Flow Entry No.")
            {
                Editable = false;
                ApplicationArea = All;
                Visible = false;
            }

            field("MICA Record ID"; Rec."MICA Record ID")
            {
                ApplicationArea = All;
                Visible = false;
            }

        }

        addafter("Sorting Method")
        {
            field("MICA Status"; Rec."MICA Status")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action("MICA Release")
            {
                Caption = 'Release';
                ApplicationArea = all;
                Image = ReleaseDoc;
                Promoted = true;
                trigger OnAction()
                var
                    ReleaseWhseReceipt: Codeunit "MICA Whse.-Receipt Release";
                begin
                    CurrPage.Update(true);
                    if Rec."MICA Status" = Rec."MICA Status"::Open then
                        ReleaseWhseReceipt.Release(Rec);
                end;
            }

            action("MICA Reopen")
            {
                Caption = 'Reopen';
                ApplicationArea = all;
                Image = ReOpen;
                Promoted = true;
                trigger OnAction()
                var
                    ReleaseWhseReceipt: Codeunit "MICA Whse.-Receipt Release";
                begin
                    CurrPage.Update(true);
                    if Rec."MICA Status" = Rec."MICA Status"::Released then
                        ReleaseWhseReceipt.Reopen(Rec);
                end;
            }

        }
    }

}