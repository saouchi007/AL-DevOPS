query 81861 "MICA Value Entries"
{
    QueryType = Normal;
    Caption = 'Value Entries';
    elements
    {
        dataitem(Value_Entry; "Value Entry")
        {
            column(Item_No_; "Item No.")
            {
                Caption = 'Item No.';
            }
            column(Posting_Date; "Posting Date")
            {
                Caption = 'Posting Date';
            }
            column(Item_Ledger_Entry_Type; "Item Ledger Entry Type")
            {
                Caption = 'Item Ledger Entry Type';
            }
            column(Source_No_; "Source No.")
            {
                Caption = 'Bill-To';
            }
            column(Location_Code; "Location Code")
            {
                Caption = 'Location Code';
            }
            column(Invoiced_Quantity; "Invoiced Quantity")
            {
                Caption = 'Invoiced Quantity';
            }
            column(Sales_Amount__Actual_; "Sales Amount (Actual)")
            {
                Caption = 'Sales Amount (Actual)';
            }
            column(Discount_Amount; "Discount Amount")
            {
                Caption = 'Discount Amount';
            }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code")
            {
                Caption = 'Section Code';
            }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code")
            {
                Caption = 'Structure Code';
            }
            column(Source_Type; "Source Type")
            {
                Caption = 'Source Type';
            }
            column(Cost_Amount__Actual_; "Cost Amount (Actual)")
            {
                Caption = 'Cost Amount (Actual)';
            }
            column(Salespers__Purch__Code; "Salespers./Purch. Code")
            {
                Caption = 'Sales pers/Purch. Code';
            }
            column(Document_Type; "Document Type")
            {
                Caption = 'Document Type';
            }
            column(Document_No_; "Document No.")
            {
                Caption = 'Document No.';
            }
            column(Document_Line_No; "Document Line No.")
            {
                Caption = 'Line No.';
            }
            column(Order_No_; "Order No.")
            {
                Caption = 'Order No.';
            }
            column(Item_Charge_No_; "Item Charge No.")
            {
                Caption = 'Item Charge No.';
            }
            dataitem(Item; Item)
            {
                DataItemLink = "No." = Value_Entry."Item No.";
                SqlJoinType = LeftOuterJoin;
                column(No__2; "No. 2")
                {
                    Caption = 'No. 2';
                }
                column(MICA_Item_Class; "MICA Item Class")
                {
                    Caption = 'Item Class';
                }
                column(Description; Description)
                {
                    Caption = 'Item Description';
                }
                column(Type; Type)
                {
                    Caption = 'Type';
                }
                column(Item_Category_Code; "Item Category Code")
                {
                    Caption = 'Item Category Code';
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
                /*column(MICA_Product_Weight_UOM; "MICA Product Weight UOM")
                {
                    Caption = 'Product Weight UOM';
                }*/
                column(MICA_Commercial_Label; "MICA Commercial Label")
                {
                    Caption = 'Commercial Label';
                }
                column(MICA_Rim_Diameter; "MICA Rim Diameter")
                {
                    Caption = 'Rim Diameter';
                }
                dataitem(Item_Ledger_Entry; "Item Ledger Entry")
                {
                    DataItemLink = "Entry No." = Value_Entry."Item Ledger Entry No.";
                    SqlJoinType = LeftOuterJoin;
                    column(Source_No_Item_Ledger_Entry; "Source No.")
                    {
                        Caption = 'Sell-To';
                    }
                    dataitem(Customer_Sell_To; Customer)
                    {
                        DataItemLink = "No." = Item_Ledger_Entry."Source No.";
                        SqlJoinType = LeftOuterJoin;
                        column(Sell_To_Name; Name)
                        {
                            Caption = 'Sell-To Name';
                        }
                        column(MICA_Market_Code; "MICA Market Code")
                        {
                            Caption = 'Market Code';
                        }
                        column(Territory_Code; "Territory Code")
                        {
                            Caption = 'Territory Code';
                        }
                        column(Customer_Disc__Group; "Customer Disc. Group")
                        {
                            Caption = 'Customer Disc. Group';
                        }
                        dataitem(MICA_Forecast_Customer_Code; "MICA Forecast Customer Code")
                        {
                            DataItemLink = "Customer Code" = Customer_Sell_To."No.", "Product Line" = Item."Item Category Code";
                            SqlJoinType = LeftOuterJoin;
                            column(Forecast_Code; "Forecast Code")
                            {
                                Caption = 'Forecast Code';
                            }
                            dataitem(Customer_Bill_To; Customer)
                            {
                                DataItemLink = "No." = Value_Entry."Source No.";
                                SqlJoinType = LeftOuterJoin;
                                column(Name; Name)
                                {
                                    Caption = 'Bill-to Name';
                                }
                                dataitem(Sales_Invoice_Line; "Sales Invoice Line")
                                {
                                    DataItemLink = "Document No." = Value_Entry."Document No.", "Line No." = Value_Entry."Document Line No.";
                                    SqlJoinType = LeftOuterJoin;
                                    column(Amount_Including_VAT; "Amount Including VAT")
                                    {
                                        Caption = 'Amount Including VAT';
                                    }
                                    dataitem(Dimension_Value; "Dimension Value")
                                    {
                                        DataItemTableFilter = "Global Dimension No." = const(2);
                                        DataItemLink = "Code" = Value_Entry."Global Dimension 2 Code";
                                        SqlJoinType = LeftOuterJoin;
                                        column(Business_Line; "MICA Michelin Code")
                                        {
                                            Caption = 'Michelin Code';
                                        }
                                        dataitem(Sales_Invoice_Header; "Sales Invoice Header")
                                        {
                                            DataItemLink = "No." = Value_Entry."Document No.";
                                            column(Ship_to_Code; "Ship-to Code")
                                            {
                                                Caption = 'Ship-to Code';
                                            }
                                            column(Ship_to_Name; "Ship-to Name")
                                            {
                                                Caption = 'Ship-to Name';
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