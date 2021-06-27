query 82582 "Alloc. Details Transfer Order"
{
    QueryType = Normal;

    elements
    {
        dataitem(Transfer_Line; "Transfer Line")
        {
            DataItemTableFilter = "Derived From Line No." = const (0);
            filter(Item_No_Filter; "Item No.")
            {

            }
            filter(Transfer_to_Code_Filter; "Transfer-to Code")
            {

            }
            column(Item_No_; "Item No.")
            {

            }
            column(Transfer_to_Code; "Transfer-to Code")
            {

            }
            column(Quantity; Quantity)
            {
                Method = Sum;
            }
            dataitem(Item; Item)
            {
                DataItemLink = "No." = Transfer_Line."Item No.";
                DataItemTableFilter = Type = const (Inventory);
                SqlJoinType = LeftOuterJoin;
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
                column(Unit_Cost; "Unit Cost")
                {

                }
                dataitem(Location; Location)
                {
                    DataItemLink = Code = Transfer_Line."Transfer-to Code";
                    DataItemTableFilter = "MICA Allocation Detail" = const (true);
                }
            }
        }
    }
}