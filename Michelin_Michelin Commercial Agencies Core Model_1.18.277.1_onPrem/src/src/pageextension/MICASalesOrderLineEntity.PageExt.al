pageextension 82780 "MICA Sales Order Line Entity" extends "Sales Order Line Entity"
{
    layout
    {
        addlast(Control2)
        {
            field("MICA plannedDeliveryDate"; Rec."MICA Planned Delivery Date")
            {
                ApplicationArea = All;
                Caption = 'plannedDeliveryDate';
            }
            field("MICA plannedShipmentDate"; Rec."MICA Planned Shipment Date")
            {
                ApplicationArea = All;
                Caption = 'plannedShipmentDate';
            }
            field("MICA splitSourceLineNo"; Rec."MICA Split Source line No.")
            {
                ApplicationArea = All;
                Caption = 'splitSourceLineNo';
            }
            field(splitSrcExpOrdQtyB; Rec."MICA Split Src Exp Ord Qty (b)")
            {
                ApplicationArea = All;
                Caption = 'splitSrcExpOrdQtyB';
            }
            field("MICA status"; Rec."MICA Status")
            {
                ApplicationArea = All;
                Caption = 'status';
            }

        }
    }
}