query 81860 "MICA Sales Orders"
{
    QueryType = Normal;
    Caption = 'Sales Orders';
    elements
    {
        dataitem(Sales_Header; "Sales Header")
        {
            DataItemTableFilter = "Document Type" = CONST (Order);
            column("No_"; "No.")
            {
                Caption = 'No.';
            }
            column(Order_Date; "Order Date")
            {
                Caption = 'Order Date';
            }
            column(Posting_Date; "Posting Date")
            {
                Caption = 'Posting Date';
            }
            column(Salesperson_Code; "Salesperson Code")
            {
                Caption = 'Saleperson Code';
            }
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {
                Caption = 'Sell-to Customer No.';
            }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {
                Caption = 'Sell-to Customer Name';
            }
            column(Ship_to_Code; "Ship-to Code")
            {
                Caption = 'Ship-to Code';
            }
            column(Ship_to_Name; "Ship-to Name")
            {
                Caption = 'Ship-to Name';
            }
            column(Ship_to_Address; "Ship-to Address")
            {
                Caption = 'Ship-to Address';
            }
            column(Ship_to_Address_2; "Ship-to Address 2")
            {
                Caption = 'Ship-to Address 2';
            }
            column(Ship_to_City; "Ship-to City")
            {
                Caption = 'Ship-to City';
            }
            column(Ship_to_County; "Ship-to County")
            {
                Caption = 'Ship-to County';
            }
            column(Ship_to_Country_Region_Code; "Ship-to Country/Region Code")
            {
                Caption = 'Ship-to Country/Region Code';
            }
            column(MICA_Order_Type; "MICA Order Type")
            {
                Caption = 'Order Type';
            }
            column(Status; Status)
            {
                Caption = 'Status';
            }
            column(SC_Unique_Webshop_Document_Id; "SC Unique Webshop Document Id")
            {
                Caption = 'SC Unique Webshop Document Id';
            }
            column(Bill_to_Customer_No_; "Bill-to Customer No.")
            {
                Caption = 'Bill-to Customer No.';
            }
            column(Bill_to_Name; "Bill-to Name")
            {
                Caption = 'Bill-to Name';
            }
            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = Sales_Header."Sell-to Customer No.";
                SqlJoinType = LeftOuterJoin;
                column(Sell_to_Customer_County; County)
                {
                    Caption = 'Sell-to Customer County';
                }
                column(MICA_Market_Code; "MICA Market Code")
                {
                    Caption = 'Market Code';
                }
                column(Sell_to_Customer_MDMID; "MICA MDM ID BT")
                {
                    Caption = 'Sell-to Customer MDMID';
                }
                column(Sell_To_Territory_Code; "Territory Code")
                {
                    Caption = 'Sell-to Territory Code';
                }
                dataitem(Customer2; Customer)
                {
                    DataItemLink = "No." = Sales_Header."Bill-to Customer No.";
                    SqlJoinType = LeftOuterJoin;
                    column(Bill_to_Customer_County; County)
                    {
                        Caption = 'Bill-to Customer County';
                    }
                    column(Bill_to_Customer_MDMID; "MICA MDM ID BT")
                    {
                        Caption = 'Bill-to Customer MDMID';
                    }
                    column(Bill_To_Territory_Code; "Territory Code")
                    {
                        Caption = 'Bill-to Territory Code';
                    }
                    dataitem(Ship_to_Addresses; "Ship-to Address")
                    {
                        DataItemLink = "Customer No." = Sales_Header."Sell-to Customer No.", Code = Sales_Header."Ship-to Code";
                        SqlJoinType = LeftOuterJoin;
                        column(MDMID_Ship_To; "MICA MDM ID")
                        {
                            Caption = 'MDMID Ship-to';
                        }

                        dataitem(Sales_Line; "Sales Line")
                        {
                            DataItemLink = "Document Type" = Sales_Header."Document Type", "Document No." = Sales_Header."No.";
                            DataItemTableFilter = "No." = filter ('<>''''');

                            SqlJoinType = LeftOuterJoin;

                            column("Item_No"; "No.")
                            {
                                Caption = 'Item No.';
                            }
                            column(Item_Category_Code; "Item Category Code")
                            {
                                Caption = 'Item Category Code';
                            }
                            column(MICA_Status; "MICA Status")
                            {
                                Caption = 'Status';
                            }
                            column(Location_Code; "Location Code")
                            {
                                Caption = 'Location Code';
                            }
                            column(Quantity; Quantity)
                            {
                                Caption = 'Quantity';
                            }
                            column(Unit_Price; "Unit Price")
                            {
                                Caption = 'Unit Price';
                            }
                            column(Line_Amount; "Line Amount")
                            {
                                Caption = 'Line Amount';

                            }
                            column(Line_Discount_Amount; "Line Discount Amount")
                            {
                                Caption = 'Line Discount Amount';
                            }
                            column(Line_Discount_Pourcentage; "Line Discount %")
                            {
                                Caption = 'Line Discount %';
                            }
                            column(Outstanding_Amount__LCY_; "Outstanding Amount (LCY)")
                            {
                                Caption = 'Outstanding Amount (LCY)';
                            }
                            column(Shipped_Not_Inv___LCY__No_VAT; "Shipped Not Inv. (LCY) No VAT")
                            {
                                Caption = 'Shipped Not Inv. (LCY) No VAT';
                            }
                            column(Reserved_Quantity; "Reserved Quantity")
                            {
                                Caption = 'Reserved Quantity';
                            }
                            column(Quantity_Shipped; "Quantity Shipped")
                            {
                                Caption = 'Quantity Shipped';
                            }
                            column(Qty__Shipped_Not_Invoiced; "Qty. Shipped Not Invoiced")
                            {
                                Caption = 'Qty. Shipped Not Invoiced';
                            }
                            column(Quantity_Invoiced; "Quantity Invoiced")
                            {
                                Caption = 'Quantity Invoiced';
                            }
                            column(Requested_Delivery_Date; "Requested Delivery Date")
                            {
                                Caption = 'Requested Delivery Date';
                            }
                            column(Promised_Delivery_Date; "Promised Delivery Date")
                            {
                                Caption = 'Promised Delivery Date';
                            }
                            column(Shipment_Date; "Shipment Date")
                            {
                                Caption = 'Shipment Date';
                            }
                            column(Planned_Shipment_Date; "Planned Shipment Date")
                            {
                                Caption = 'Planned Shipment Date';
                            }
                            column(Planned_Delivery_Date; "Planned Delivery Date")
                            {
                                Caption = 'Planned Delivery Date';
                            }
                            column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code")
                            {
                                Caption = 'Shortcut Dimension 1 Code';
                            }
                            column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code")
                            {
                                Caption = 'Shortcut Dimension 2 Code';
                            }
                            dataitem(Item; Item)
                            {
                                DataItemLink = "No." = Sales_Line."No.";
                                SqlJoinType = LeftOuterJoin;
                                column(Description; Description)
                                {
                                    caption = 'Description';
                                }
                                column(No__2; "No. 2")
                                {
                                    Caption = 'No. 2';
                                }
                                column(Type; Type)
                                {
                                    Caption = 'Type';
                                }
                                column(MICA_Brand; "MICA Brand")
                                {
                                    Caption = 'Brand';
                                }
                                column(MICA_Product_Segment; "MICA Product Segment")
                                {
                                    Caption = 'Product Segment';
                                }
                                column(MICA_Tire_Size; "MICA Tire Size")
                                {
                                    Caption = 'Tire Size';
                                }
                                column(MICA_Pattern_Code; "MICA Pattern Code")
                                {
                                    Caption = 'Pattern Code';
                                }
                                column(MICA_Product_Weight; "MICA Product Weight")
                                {
                                    Caption = 'Product Weight';
                                }
                                column(MICA_Product_Weight_UOM; "MICA Product Weight UOM")
                                {
                                    Caption = 'Product Weight UOM';
                                }
                                column(MICA_Rim_Diameter; "MICA Rim Diameter")
                                {
                                    Caption = 'Rim Diameter';
                                }
                                column(MICA_Product_Volume; "MICA Product Volume")
                                {
                                    Caption = 'Product Volume';
                                }
                                column(MICA_Product_Volume_UoM; "MICA Product Volume UoM")
                                {
                                    Caption = 'Product Volume UoM';
                                }
                                /*dataitem(Item_Unit_of_Measure; "Item Unit of Measure")
                                {
                                    DataItemLink = "Item No." = Item."No.", Code = Sales_line."Unit of Measure Code";
                                    SqlJoinType = LeftOuterJoin;

                                    column(Cubage; Cubage)
                                    {
                                        Caption = 'Cubage';
                                    }
                                }*/
                                dataitem(MICA_Forecast_Customer_Code; "MICA Forecast Customer Code")
                                {
                                    DataItemLink = "Customer Code" = Customer."No.", "Product Line" = Item."Item Category Code";
                                    SqlJoinType = LeftOuterJoin;
                                    column(Forecast_Code; "Forecast Code")
                                    {
                                        Caption = 'Forecast Code';
                                    }
                                    dataitem(GLSetup; "General Ledger Setup")
                                    {
                                        SqlJoinType = CrossJoin;

                                        dataitem(Dimension_Value; "Dimension Value")
                                        {
                                            DataItemlink = "Code" = Sales_Line."Shortcut Dimension 2 Code", "Dimension Code" = GLSetup."Global Dimension 2 Code";
                                            SqlJoinType = LeftOuterJoin;
                                            Column(Michelin_Code; "MICA Michelin Code")
                                            {
                                                Caption = 'Michelin Code';
                                            }
                                        }

                                    }
                                }
                            }
                        }
                    }
                }
            }

        }

    }
}