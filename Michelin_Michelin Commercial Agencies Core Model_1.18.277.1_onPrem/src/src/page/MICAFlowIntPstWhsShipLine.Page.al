page 80960 "MICA FlowInt-Pst.Whs.Ship Line"
{
    Caption = 'Flow Integration';
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Posted Whse. Shipment Line";

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