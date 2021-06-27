query 82460 "MICA Whse. Shipment Lines"
{
    QueryType = Normal;
    Caption = 'Warehouse Shipment Lines';

    elements
    {
        dataitem(Warehouse_Shipment_Line; "Warehouse Shipment Line")
        {
            column(No_; "No.")
            {
                Caption = 'No.';
            }
            column(Line_No_; "Line No.")
            {
                Caption = 'Line No.';
            }
            column(Source_Document; "Source Document")
            {
                Caption = 'Source Document';
            }
            column(Source_No_; "Source No.")
            {
                Caption = 'Sourece No.';
            }
            column(Source_Line_No_; "Source Line No.")
            {
                Caption = 'Sourece Line No.';
            }
            column(Item_No_; "Item No.")
            {
                Caption = 'Item No.';
            }
            column(Description; Description)
            {
                Caption = 'Description';
            }
            column(Location_Code; "Location Code")
            {
                Caption = 'Lication Code';
            }
            column(Quantity; Quantity)
            {
                Caption = 'Quantity';
            }
            column(Qty__to_Ship; "Qty. to Ship")
            {
                Caption = 'Qty. to Ship';
            }
            column(Unit_of_Measure_Code; "Unit of Measure Code")
            {
                Caption = 'Unit of Measure Code';
            }
            column(MICA_Shipping_Agent_Code; "MICA Shipping Agent Code")
            {
                Caption = 'Shipping Agent Code';
            }
            column(MICA_Shipp__Agent_Service_Code; "MICA Shipp. Agent Service Code")
            {
                Caption = 'Shipping Agent Service Code';
            }
            column(Due_Date; "Due Date")
            {
                Caption = 'Due Date';
            }
            column(Shipment_Date; "Shipment Date")
            {
                Caption = 'Shipment Date';
            }
            column(MICA_Ship_to_Name; "MICA Ship-to Name")
            {
                Caption = 'Ship-to Name';
            }
            column(MICA_Ship_to_Address; "MICA Ship-to Address")
            {
                Caption = 'Ship-to Address';
            }
            column(MICA_Ship_to_City; "MICA Ship-to City")
            {
                Caption = 'Ship-to City';
            }
            column(MICA_3PL_Product_Weight; "MICA 3PL Product Weight")
            {
                Caption = '3PL Product Weight';
            }
            column(MICA_3PL_Line_Weight; "MICA 3PL Line Weight")
            {
                Caption = '3PL Line Weight';
            }
            column(MICA_3PL_Weight_UoM; "MICA 3PL Weight UoM")
            {
                Caption = '3PL Weight UoM';
            }
            column(MICA_3PL_Product_Volume; "MICA 3PL Product Volume")
            {
                Caption = '3PL Product Volume';
            }
            column(MICA_3PL_Line_Volume; "MICA 3PL Line Volume")
            {
                Caption = '3PL Line Volume';
            }
            column(MICA_3PL_Volume_UoM; "MICA 3PL Volume UoM")
            {
                Caption = '3PL Volume UoM';
            }
            column(MICA_Customer_Transport; "MICA Customer Transport")
            {
                Caption = 'Customer Transport';
            }
            column(Shipping_Advice; "Shipping Advice")
            {
                Caption = 'Shipping Advice';
            }

        }
    }
}