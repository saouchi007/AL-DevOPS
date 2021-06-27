pageextension 81980 "MICA Sales Lines" extends "Sales Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("MICA Prev. Planned Del. Date"; Rec."MICA Prev. Planned Del. Date")
            {
                ApplicationArea = All;
                Editable = false;
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
            field("MICA Requested Receipt Date"; Rec."MICA Requested Receipt Date")
            {

                ApplicationArea = All;
            }
            field("MICA Promised Receipt Date"; Rec."MICA Promised Receipt Date")
            {
                ApplicationArea = All;
            }
            field("MICA Requested Delivery Date"; Rec."Requested Delivery Date")
            {
                ApplicationArea = All;
            }
            field("MICA Promised Delivery Date"; Rec."Promised Delivery Date")
            {
                ApplicationArea = All;
            }
            field("MICA Planned Shipment Date"; Rec."Planned Shipment Date")
            {
                ApplicationArea = All;
            }
            field("MICA Planned Delivery Date"; Rec."Planned Delivery Date")
            {
                ApplicationArea = All;
            }

        }
    }

}