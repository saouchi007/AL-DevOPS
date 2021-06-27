pageextension 81041 "MICA Sales Order List" extends "Sales Order List"
{
    layout
    {
        addlast(Control1)
        {
            field("MICA Shipment"; Rec."MICA Shipment")
            {
                Caption = 'Shipment';
                ApplicationArea = All;

            }
            field("MICA Order Date"; Rec."Order Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter("External Document No.")
        {
            field("MICA SC Unique Webshop Document Id"; Rec."SC Unique Webshop Document Id")
            {
                Caption = 'Unique Webshop Document ID';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        modify("Create &Warehouse Shipment")
        {
            Visible = false;
        }
        // modify("Post")
        // {
        //     Visible = false;
        //     Enabled = false;
        // }
        // modify("Post &Batch")
        // {
        //     Visible = false;
        //     Enabled = false;
        // }
        // modify(PostAndSend)
        // {
        //     Visible = false;
        //     Enabled = false;
        // }
        addafter("Create Inventor&y Put-away/Pick")
        {
            action("MICA Create Warehouse Shipment")
            {
                Caption = 'Create &Warehouse Shipment';
                ToolTip = 'Create a warehouse shipment to start a pick a ship process according to an advanced warehouse configuration.';
                AccessByPermission = TableData "Warehouse Shipment Header" = R;
                ApplicationArea = All;
                Image = NewShipment;
                trigger OnAction()
                var
                    GetSourceDocOutbound: Codeunit "MICA Get Source Doc. Outbound";
                begin
                    GetSourceDocOutbound.CreateFromSalesOrder(Rec);
                end;
            }
        }
        // addfirst("P&osting")
        // {
        //     action("MICA Post")
        //     {
        //         Caption = 'P&ost';
        //         Promoted = true;
        //         PromotedCategory = Process;
        //         image = PostOrder;
        //         ApplicationArea = Basic, Suite;
        //         trigger OnAction()
        //         var
        //             TOPMgt: Codeunit "MICA Terms Of Payment Mgt";
        //         begin
        //             TOPMgt.PostSalesOrder(Rec);
        //         end;
        //     }
        // }
    }
}