query 82401 "MICA Sales Order Open SPD"
{
    //SPD-002
    QueryType = Normal;
    Caption = 'Sales Order Open SPD';
    elements
    {
        dataitem(Sales_Header; "Sales Header")
        {
            DataItemTableFilter = "Document Type" = const(Order), Status = filter(Released | "Pending Approval");
            column(Document_Date; "Document Date") { }
            column(Ship_to_Code; "Ship-to Code") { }
            column(MICA_Order_Type; "MICA Order Type") { }

            dataitem(Sales_Line; "Sales Line")
            {
                DataItemTableFilter = Type = const(Item), "Quantity Shipped" = filter(= 0);
                DataItemLink = "Document Type" = Sales_Header."Document Type", "Document No." = Sales_Header."No.";
                SqlJoinType = LeftOuterJoin;

                column(Line_No_; "Line No.") { }
                column(Document_No_; "Document No.") { }
                column(Bill_to_Customer_No_; "Bill-to Customer No.") { }
                column("Item_No"; "No.") { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Requested_Delivery_Date; "Requested Delivery Date") { }
                column(Planned_Delivery_Date; "Planned Delivery Date") { }
                column(Item_Category_Code; "Item Category Code") { }
                column(Location_Code; "Location Code") { }
                column(Promised_Delivery_Date; "Promised Delivery Date") { }
                column(Shipment_Date; "Shipment Date") { }
                column(MICA_Requested_Receipt_Date; "MICA Requested Receipt Date") { }
                column(MICA_Status; "MICA Status") { }
                dataitem(Location; Location)
                {
                    DataItemTableFilter = "MICA Exclude from DRP" = const(false);
                    DataItemLink = "Code" = Sales_Line."Location Code";
                    SqlJoinType = LeftOuterJoin;
                    dataitem(Item; Item)
                    {
                        DataItemLink = "No." = Sales_Line."No.";
                        SqlJoinType = LeftOuterJoin;
                        column(MICA_Market_Code; "MICA Market Code") { }
                    }
                }
            }
        }
    }
}


