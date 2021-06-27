pageextension 81622 "MICA Order Processor Role Cent" extends "Order Processor Role Center"
{
    layout
    {

    }

    actions
    {
        //3PL-009: Whse. Shipment BSC to 3PL
        addafter("Sales Orders")
        {
            action("MICA Sales Order Lines")
            {
                ApplicationArea = All;
                Caption = 'Sales Order Lines';
                Image = AllLines;
                RunObject = page "Sales Lines";
                RunPageView = where ("Document Type" = const (Order), Type = const (Item));
                RunPageLink = "Completely Shipped" = const (false);
            }
        }

        //>>For Testing
        // addlast(Tasks)
        // {
        //     action("MICA Create All Warehouse Shipments")
        //     {
        //         Caption = 'Create All Warehouse Shipments';
        //         Image = Warehouse;
        //         ApplicationArea = All;
        //         RunObject = codeunit "MICA Whse. Shipment BSC to 3PL";
        //     }
        // }
        //<<For Testing
    }
}