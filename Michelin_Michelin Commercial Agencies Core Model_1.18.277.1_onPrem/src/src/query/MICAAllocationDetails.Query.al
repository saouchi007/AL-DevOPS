query 82581 "MICA Allocation Details"
{
    QueryType = Normal;

    elements
    {

        dataitem(Sales_Line; "Sales Line")
        {
            DataItemTableFilter = "Document Type" = const (Order), Type = const (Item),
                "MICA Status" = filter ("Reserve OnHand" | "Reserve InTransit" | "Waiting Allocation" | "Send to Execution");
            SqlJoinType = LeftOuterJoin;
            filter(No_Filter;"No.")
            {

            }
            filter(Location_Code_Filter;"Location Code")
            {

            }
            filter(MICA_Status_Filter;"MICA Status")
            {

            }
            column(No_; "No.")
            {

            }
            column(Location_Code; "Location Code")
            {

            }
            column(MICA_Status; "MICA Status")
            {

            }
            column(Quantity; Quantity)
            {
                Method = Sum;
            }
            dataitem(Item; Item)
            {
                DataItemLink = "No." = Sales_line."No.";
                DataItemTableFilter = Type = const (Inventory);
                SqlJoinType = LeftOuterJoin;
                column(No__2;"No. 2")
                {

                }
                column(Description; Description)
                {

                }
                column(MICA_Business_Line; "MICA Business Line")
                {

                }
                column(Item_Category_Code; "Item Category Code")
                {

                }
                column(MICA_Market_Code; "MICA Market Code")
                {

                }
                column(MICA_User_Item_Type; "MICA User Item Type")
                {

                }
                column(MICA_Brand; "MICA Brand")
                {

                }
                column(MICA_Item_Class; "MICA Item Class")
                {

                }
                column(Unit_Cost;"Unit Cost")
                {
                    
                }
                dataitem(Location; Location)
                {
                    DataItemLink = Code = Sales_Line."Location Code";
                    DataItemTableFilter = "MICA Allocation Detail" = const (true);
                }

            }
        }
    }
}
