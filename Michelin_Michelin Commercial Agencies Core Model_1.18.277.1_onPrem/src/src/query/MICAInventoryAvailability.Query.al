query 82580 "MICA Inventory Availability"
{
    QueryType = Normal;

    elements
    {
        dataitem(Location; Location)
        {
            column(Code; Code)
            {

            }
            column(MICA_Allocation_Detail;"MICA Allocation Detail")
            {

            }
            dataitem(Item; Item)
            {
                DataItemTableFilter = Type = filter (Inventory);
                SqlJoinType = CrossJoin;
                column(No_; "No.")
                {

                }
                column(No__2; "No. 2")
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

                dataitem(Item_Ledger_Entry; "Item Ledger Entry")
                {
                    DataItemLink = "Item No." = Item."No.", "Location Code" = Location.Code;
                    SqlJoinType = LeftOuterJoin;
                    column(Quantity; Quantity)
                    {

                        Method = Sum;
                    }
                }
            }
        }

    }
}