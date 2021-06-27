page 81241 "MICA FlowInt-Whs. Receipt Line"
{
    Caption = 'Flow Integration';
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Warehouse Receipt Line";

    layout
    {
        area(Content)
        {
            field("MICA Send Last Flow Entry No."; Rec."MICA Send Last Flow Entry No.")
            {
                ApplicationArea = All;
            }

            field("MICA Send Ack. Received"; Rec."MICA Send Ack. Received")
            {
                ApplicationArea = All;
            }
            field("MICA Rcv. Last Flow Entry No."; Rec."MICA Rcv. Last Flow Entry No.")
            {
                ApplicationArea = All;
            }

        }

    }

}