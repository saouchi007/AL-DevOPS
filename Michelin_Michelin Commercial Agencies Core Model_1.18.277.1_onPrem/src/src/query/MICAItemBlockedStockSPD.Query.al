query 82340 "MICA Item Blocked Stock SPD"
{
    QueryType = Normal;

    elements
    {
        dataitem(Item; Item)
        {
            DataItemTableFilter = Blocked = const(false), Type = const(Inventory);
            filter(MICA_User_Item_Type; "MICA User Item Type")
            {

            }
            column(No_; "No.")
            {

            }
            column(MICA_Business_Line; "MICA Business Line")
            {

            }
            column(Item_Category_Code; "Item Category Code")
            {

            }
            dataitem(Item_Ledger_Entry; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = Item."No.";
                column(Quantity; Quantity)
                {
                    ColumnFilter = Quantity = filter(> 0);
                    Method = Sum;
                }
                dataitem(Location; Location)
                {
                    DataItemLink = Code = Item_Ledger_Entry."Location Code";
                    DataItemTableFilter = "MICA DRP IN Location Code" = filter(<> ''), "MICA Entry Type" = const("P (Main)"),
                                            "Use As In-Transit" = const(false), "MICA SPD Blocked Qty. Code" = filter(<> ''),
                                            "MICA Exclude from DRP" = const(false);

                    column(MICA_SPD_Blocked_Qty__Code; "MICA SPD Blocked Qty. Code")
                    {

                    }


                }
            }

        }
    }

}