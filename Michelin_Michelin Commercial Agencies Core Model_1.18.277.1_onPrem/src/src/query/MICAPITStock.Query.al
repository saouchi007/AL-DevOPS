query 82360 "MICA PIT Stock"
{
    QueryType = Normal;

    elements
    {
        dataitem(Purchase_Line; "Purchase Line")
        {
            DataItemTableFilter = "Document Type" = const (Order), "Completely Received" = const (false), Type = const (Item);
            filter(Location_Code; "Location Code") { }
            column(Document_No_; "Document No.") { }
            column(Line_No_; "Line No.") { }
            column(No_; "No.") { }
            column(Quantity; Quantity) { }
            column(Item_Category_Code; "Item Category Code") { }
            column(Dimension_Set_ID; "Dimension Set ID") { }
            column(MICA_Location_To_Code; "MICA Location-To Code") { }
            column(MICA_DC14; "MICA DC14") { }
            column(MICA_Ship_From_Vendor; "MICA Ship From Vendor") { }
            column(MICA_SRD; "Expected Receipt Date") { }
            column(MICA_AL_No_; "MICA AL No.") { }
            column(MICA_Country_of_Origin; "MICA Country of Origin") { }

            dataitem(Location; Location)
            {
                DataItemTableFilter = "MICA Exclude from DRP" = const(false);
                DataItemLink = "Code" = Purchase_Line."MICA Location-To Code";
                SqlJoinType = LeftOuterJoin;
                dataitem(Item; Item)
                {
                    DataItemLink = "No." = Purchase_Line."No.";
                    DataItemTableFilter = Blocked = const (false), Type = const (Inventory);
                    filter(MICA_User_Item_Type; "MICA User Item Type") { }
                    column(Country_Region_of_Origin_Code; "Country/Region of Origin Code") { }


                    dataitem(Purchase_Header; "Purchase Header")
                    {
                        DataItemLink = "No." = Purchase_Line."Document No.";
                        SqlJoinType = LeftOuterJoin;
                        column(Document_Date; "Document Date") { }
                        column(Order_Date; "Order Date") { }
                        column(PurchHeader_MICA_Location_To_Code; "MICA Location-To Code") { }
                    }
                }
            }
        }
    }

}