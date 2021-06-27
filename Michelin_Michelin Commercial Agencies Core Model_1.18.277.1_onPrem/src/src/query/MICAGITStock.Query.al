query 82361 "MICA GIT Stock"
{
    QueryType = Normal;

    elements
    {
        dataitem(Location; Location)
        {
            DataItemTableFilter = "MICA Blocked Inv. Location" = const(false), "Use As In-Transit" = const(false), "MICA DRP IN Location Code" = filter(<> ''),
                                    "MICA Exclude from DRP" = const(false);
            dataitem(Transfer_Header; "Transfer Header")
            {
                DataItemLink = "Transfer-to Code" = Location.Code;
                column(No_; "No.") { }
                column(Transfer_to_Code; "Transfer-to Code") { }
                dataitem(Transfer_Line; "Transfer Line")
                {
                    DataItemLink = "Document No." = Transfer_Header."No.";
                    DataItemTableFilter = "Completely Received" = const (false), "Derived From Line No." = const (0);
                    column(Line_No_; "Line No.") { }
                    column(MICA_Purchase_Order_No_; "MICA Purchase Order No.") { }
                    column(MICA_Purchase_Order_Line_No_; "MICA Purchase Order Line No.") { }
                    column(Item_No_; "Item No.") { }
                    column(TransLineQuantity; Quantity) { }
                    column(Shipment_Date; "MICA Initial Shipment Date") { }
                    column(MICA_SRD; "MICA SRD") { }
                    column(Item_Category_Code; "Item Category Code") { }
                    column(Dimension_Set_ID; "Dimension Set ID") { }
                    column(MICA_DC14; "MICA DC14") { }
                    column(MICA_ASN_No_; "MICA ASN No.") { }
                    column(MICA_ASN_Line_No_; "MICA ASN Line No.") { }
                    column(MICA_Ship_From_Vendor; "MICA Ship From Vendor") { }
                    column(MICA_Shipment_Line_Num; "MICA Shipment Line Num") { }
                    column(MICA_ASN_Date; "MICA ASN Date") { }
                    column(MICA_Country_of_Origin; "MICA Country of Origin") { }

                    dataitem(Item; Item)
                    {
                        DataItemLink = "No." = Transfer_Line."Item No.";
                        DataItemTableFilter = Blocked = const (false), Type = const (Inventory);

                        filter(MICA_User_Item_Type; "MICA User Item Type") { }
                        column(Country_Region_of_Origin_Code; "Country/Region of Origin Code") { }

                    }

                }
            }
        }

    }

}
