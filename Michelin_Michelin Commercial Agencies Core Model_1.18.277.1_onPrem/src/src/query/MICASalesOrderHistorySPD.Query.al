query 82400 "MICA Sales Order History SPD"
{
    //SPD-002
    QueryType = Normal;
    Caption = 'Sales Order History SPD';

    elements
    {
        dataitem(Sales_Shipment_Header; "Sales Shipment Header")
        {
            DataItemTableFilter = "Order Date" = filter('<> ''''');
            filter(Filter_Posting_Date; "Posting Date") { }
            column("No_"; "No.") { }
            column(Document_Date; "Document Date") { }
            column(Ship_to_Code; "Ship-to Code") { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(Requested_Delivery_Date; "Requested Delivery Date") { }
            column(MICA_Order_Type; "MICA Order Type") { }
            column(Location_Code; "Location Code") { }
            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = Sales_Shipment_Header."Sell-to Customer No.";
                SqlJoinType = LeftOuterJoin;
                column(Customer_Location_Code; "Location Code") { }

                dataitem(Sales_Shipment_Line; "Sales Shipment Line")
                {
                    DataItemTableFilter = Type = const(Item), Quantity = filter(<> 0);
                    DataItemLink = "Document No." = Sales_Shipment_Header."No.";
                    SqlJoinType = LeftOuterJoin;
                    column(Bill_to_Customer_No_; "Bill-to Customer No.") { }
                    column("Item_No"; "No.") { }
                    column(Item_Category_Code; "Item Category Code") { }
                    column(Line_No_; "Line No.") { }
                    column(Document_No_; "Document No.") { }
                    column(Quantity; Quantity) { }
                    column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                    column(Order_No_; "Order No.") { }
                    column(Order_Line_No_; "Order Line No.") { }
                    column(Qty__Shipped_Not_Invoiced; "Qty. Shipped Not Invoiced") { }
                    column(Promised_Delivery_Date; "Promised Delivery Date") { }
                    dataitem(Location; Location)
                    {
                        DataItemTableFilter = "MICA Exclude from DRP" = const(false);
                        DataItemLink = "Code" = Sales_Shipment_Line."Location Code";
                        SqlJoinType = LeftOuterJoin;
                        dataitem(Item; Item)
                        {
                            DataItemLink = "No." = Sales_Shipment_Line."No.";
                            SqlJoinType = LeftOuterJoin;
                            column(MICA_Market_Code; "MICA Market Code") { }

                            dataitem(Sales_Line_Archive; "Sales Line Archive")
                            {
                                DataItemTableFilter = "Document Type" = filter(Order);
                                DataItemLink = "Document No." = Sales_Shipment_Line."Order No.", "Line No." = Sales_Shipment_Line."Order Line No.";
                                SqlJoinType = LeftOuterJoin;

                                column(Arch_Document_No_; "Document No.") { }
                                column(Arch_Line_No_; "Line No.") { }
                                column(MICA_Requested_Receipt_Date; "MICA Requested Receipt Date") { }
                                column(Arch_Doc__No__Occurrence; "Doc. No. Occurrence")
                                {
                                    Method = Max;
                                }
                                column(Arch_Version_No_; "Version No.")
                                {
                                    Method = Max;
                                }
                            }

                        }
                    }
                }
            }
        }
    }
}
