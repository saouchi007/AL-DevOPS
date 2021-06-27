page 81860 "MICA Sales Orders Query"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Sales Orders Query';
    SourceTable = "MICA Sales Orders Query Table";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec.No_)
                {
                    ApplicationArea = All;
                }
                field("Order Date"; Rec.Order_Date)
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec.Posting_Date)
                {
                    ApplicationArea = All;
                }
                field("Salesperson Code"; Rec.Salesperson_Code)
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer No."; Rec.Sell_to_Customer_No_)
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer Name"; Rec.Sell_to_Customer_Name)
                {
                    ApplicationArea = All;
                }
                field("Sell_To_Territory_Code"; Rec.Sell_To_Territory_Code)
                {
                    ApplicationArea = all;
                }
                field("Bill-to Customer No."; Rec.Bill_to_Customer_No_)
                {
                    ApplicationArea = All;
                }
                field("Bill-to Name"; Rec.Bill_to_Name)
                {
                    ApplicationArea = All;
                }
                field("Bill_To_Territory_Code"; Rec.Bill_To_Territory_Code)
                {
                    ApplicationArea = all;
                }
                field("Ship-to Code"; Rec.Ship_to_Code)
                {
                    ApplicationArea = All;
                }
                field("Ship-to Name"; Rec.Ship_to_Name)
                {
                    ApplicationArea = All;
                }
                field("Ship-to Address"; Rec.Ship_to_Address)
                {
                    ApplicationArea = All;
                }
                field("Ship-to Address 2"; Rec.Ship_to_Address_2)
                {
                    ApplicationArea = All;
                }
                field("Ship-to City"; Rec.Ship_to_City)
                {
                    ApplicationArea = All;
                }
                field("Ship-to County"; Rec.Ship_to_County)
                {
                    ApplicationArea = All;
                }
                field("Ship-to Country/Region Code"; Rec.Ship_to_Country_Region_Code)
                {
                    ApplicationArea = All;
                }
                field("Order Type"; Rec.MICA_Order_Type)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Unique Webshop Document id"; Rec.SC_Unique_Webshop_Document_Id)
                {
                    ApplicationArea = All;
                }
                field("MDMID Sell-to"; Rec."Sell-to Cust. MDMID")
                {
                    ApplicationArea = All;
                }
                field("Sell to Customer County"; Rec.Sell_to_Customer_County)
                {
                    ApplicationArea = All;
                }
                field("MDMID Bill-to"; Rec."Bill-to Cust. MDMID")
                {
                    ApplicationArea = All;
                }
                field("MDMID Ship-to"; Rec.MDMID_Ship_To)
                {
                    ApplicationArea = All;
                }
                field("Item No"; Rec.Item_No)
                {
                    ApplicationArea = All;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Item Category Code"; Rec.Item_Category_Code)
                {
                    ApplicationArea = All;
                }
                field("MICA Status"; Rec.MICA_Status)
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec.Location_Code)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec.Unit_Price)
                {
                    ApplicationArea = All;
                }
                field("Line Amount"; Rec.Line_Amount)
                {
                    ApplicationArea = All;
                }
                field("Line Discount Amount"; Rec.Line_Discount_Amount)
                {
                    ApplicationArea = All;
                }
                field("Line Discount %"; Rec.Line_Discount_Pourcentage)
                {
                    ApplicationArea = All;
                }
                field("Outstanding Amount (LCY)"; Rec.Outstanding_Amount__LCY_)
                {
                    ApplicationArea = All;
                }
                field("Shipped Not Inv. (LCY) No VAT"; Rec.Shipped_Not_Inv___LCY__No_VAT)
                {
                    ApplicationArea = All;
                }
                field("Reserved Quantity"; Rec.Reserved_Quantity)
                {
                    ApplicationArea = All;
                }
                field("Quantity Shipped"; Rec.Quantity_Shipped)
                {
                    ApplicationArea = All;
                }
                field("Qty. Shipped Not Invoiced"; Rec.Qty__Shipped_Not_Invoiced)
                {
                    ApplicationArea = All;
                }
                field("Quantity Invoiced"; Rec.Quantity_Invoiced)
                {
                    ApplicationArea = All;
                }
                field("Requested Delivery Date"; Rec.Requested_Delivery_Date)
                {
                    ApplicationArea = All;
                }
                field("Promised Delivery Date"; Rec.Promised_Delivery_Date)
                {
                    ApplicationArea = All;
                }
                field("Shipment Date"; Rec.Shipment_Date)
                {
                    ApplicationArea = All;
                }
                field("Planned Shipment Date"; Rec.Planned_Shipment_Date)
                {
                    ApplicationArea = All;
                }
                field("Planned Delivery Date"; Rec.Planned_Delivery_Date)
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec.Shortcut_Dimension_1_Code)
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec.Shortcut_Dimension_2_Code)
                {
                    ApplicationArea = All;
                }
                field("Michelin Structure Code"; Rec.Michelin_Structure_Code)
                {
                    ApplicationArea = All;
                }
                field("No.2"; Rec.No__2)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(Brand; Rec.MICA_Brand)
                {
                    ApplicationArea = All;
                }
                field("Product segment"; Rec.MICA_Product_Segment)
                {
                    ApplicationArea = All;
                }
                field("Tire size"; Rec.MICA_Tire_Size)
                {
                    ApplicationArea = All;
                }
                field("Pattern Code"; Rec.MICA_Pattern_Code)
                {
                    ApplicationArea = All;
                }
                field("Product Unit Weight"; Rec.MICA_Product_Weight)
                {
                    ApplicationArea = All;
                }
                field("Product Unit Weight UOM"; Rec.MICA_Product_Weight_UOM)
                {
                    ApplicationArea = All;
                }
                field("Market Code"; Rec.MICA_Market_Code)
                {
                    ApplicationArea = All;
                }
                field("Forecast Code"; Rec.Forecast_Code)
                {
                    ApplicationArea = All;
                }
                field("Rim Diameter"; Rec.MICA_Rim_Diameter)
                {
                    ApplicationArea = All;
                }
                field("Product Volume"; Rec."Product Volume")
                {
                    ApplicationArea = All;
                }
                field("Product Volume UoM"; Rec."Product Volume UoM")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        DimensionValue: Record "Dimension Value";
        GeneralLedgerSetup: Record "General Ledger Setup";
        MICASalesOrders: Query "MICA Sales Orders";
        NumberOfRows: Integer;
    begin
        MICASalesOrders.Open();
        while MICASalesOrders.Read() do begin
            NumberOfRows += 1;
            Rec.ID := NumberOfRows;
            Rec.No_ := format(MICASalesOrders.No_);
            Rec.Order_Date := format(MICASalesOrders.Order_Date);
            Rec.Posting_Date := format(MICASalesOrders.Posting_Date);
            Rec.Salesperson_Code := format(MICASalesOrders.Salesperson_Code);
            Rec.Sell_to_Customer_No_ := format(MICASalesOrders.Sell_to_Customer_No_);
            Rec."Sell-to Cust. MDMID" := Format(MICASalesOrders.Sell_to_Customer_MDMID);
            Rec.Sell_to_Customer_Name := format(MICASalesOrders.Sell_to_Customer_Name);
            Rec.Sell_To_Territory_Code := Format(MICASalesOrders.Sell_To_Territory_Code);
            Rec.Bill_to_Customer_No_ := format(MICASalesOrders.Bill_to_Customer_No_);
            Rec."Bill-to Cust. MDMID" := Format(MICASalesOrders.Bill_to_Customer_MDMID);
            Rec.Bill_to_Name := format(MICASalesOrders.Bill_to_Name);
            Rec.Bill_To_Territory_Code := Format(MICASalesOrders.Bill_To_Territory_Code);
            Rec.Ship_to_Code := format(MICASalesOrders.Ship_to_Code);
            Rec.Ship_to_Name := format(MICASalesOrders.Ship_to_Name);
            Rec.Ship_to_Address := format(MICASalesOrders.Ship_to_Address);
            Rec.Ship_to_Address_2 := format(MICASalesOrders.Ship_to_Address_2);
            Rec.Ship_to_City := format(MICASalesOrders.Ship_to_City);
            Rec.Ship_to_County := format(MICASalesOrders.Ship_to_County);
            Rec.Ship_to_Country_Region_Code := format(MICASalesOrders.Ship_to_Country_Region_Code);
            Rec.MICA_Order_Type := format(MICASalesOrders.MICA_Order_Type);
            Rec.Status := format(MICASalesOrders.Status);
            Rec.SC_Unique_Webshop_Document_Id := format(MICASalesOrders.SC_Unique_Webshop_Document_Id);
            Rec.Sell_to_Customer_County := format(MICASalesOrders.Sell_to_Customer_County);
            Rec.Bill_to_Customer_No_ := format(MICASalesOrders.Bill_to_Customer_No_);
            Rec.MDMID_Ship_To := format(MICASalesOrders.MDMID_Ship_To);
            Rec.Item_No := format(MICASalesOrders.Item_No);
            Rec.Description := Format(MICASalesOrders.Description);
            Rec.Item_Category_Code := format(MICASalesOrders.Item_Category_Code);
            Rec.MICA_Status := format(MICASalesOrders.MICA_Status);
            Rec.Location_Code := format(MICASalesOrders.Location_Code);
            Rec.Quantity := format(MICASalesOrders.Quantity);
            Rec.Unit_Price := format(MICASalesOrders.Unit_Price);
            Rec.Line_Amount := format(MICASalesOrders.Line_Amount);
            Rec.Line_Discount_Amount := format(MICASalesOrders.Line_Discount_Amount);
            Rec.Line_Discount_Pourcentage := format(MICASalesOrders.Line_Discount_Pourcentage);
            Rec.Outstanding_Amount__LCY_ := format(MICASalesOrders.Outstanding_Amount__LCY_);
            Rec.Shipped_Not_Inv___LCY__No_VAT := format(MICASalesOrders.Shipped_Not_Inv___LCY__No_VAT);
            Rec.Reserved_Quantity := format(MICASalesOrders.Reserved_Quantity);
            Rec.Quantity_Shipped := format(MICASalesOrders.Quantity_Shipped);
            Rec.Qty__Shipped_Not_Invoiced := format(MICASalesOrders.Qty__Shipped_Not_Invoiced);
            Rec.Quantity_Invoiced := format(MICASalesOrders.Quantity_Invoiced);
            Rec.Requested_Delivery_Date := format(MICASalesOrders.Requested_Delivery_Date);
            Rec.Promised_Delivery_Date := format(MICASalesOrders.Promised_Delivery_Date);
            Rec.Shipment_Date := format(MICASalesOrders.Shipment_Date);
            Rec.Planned_Shipment_Date := format(MICASalesOrders.Planned_Shipment_Date);
            Rec.Planned_Delivery_Date := format(MICASalesOrders.Planned_Delivery_Date);
            Rec.Shortcut_Dimension_1_Code := format(MICASalesOrders.Shortcut_Dimension_1_Code);
            GeneralLedgerSetup.Get();
            if DimensionValue.Get(GeneralLedgerSetup."Shortcut Dimension 2 Code", MICASalesOrders.Shortcut_Dimension_2_Code) then
                Rec.Shortcut_Dimension_2_Code := DimensionValue."MICA Michelin Code"
            else
                Rec.Shortcut_Dimension_2_Code := '';
            Rec.Michelin_Structure_Code := format(MICASalesOrders.Shortcut_Dimension_2_Code);
            Rec.No__2 := format(MICASalesOrders.No__2);
            Rec.Type := format(MICASalesOrders.Type);
            Rec.MICA_Brand := format(MICASalesOrders.MICA_Brand);
            Rec.MICA_Product_Segment := format(MICASalesOrders.MICA_Product_Segment);
            Rec.MICA_Tire_Size := format(MICASalesOrders.MICA_Tire_Size);
            Rec.MICA_Pattern_Code := format(MICASalesOrders.MICA_Pattern_Code);
            Rec.MICA_Product_Weight := format(MICASalesOrders.MICA_Product_Weight);
            Rec.MICA_Product_Weight_UOM := format(MICASalesOrders.MICA_Product_Weight_UOM);
            Rec.MICA_Market_Code := format(MICASalesOrders.MICA_Market_Code);
            Rec.Forecast_Code := format(MICASalesOrders.Forecast_Code);
            Rec.MICA_Rim_Diameter := format(MICASalesOrders.MICA_Rim_Diameter);
            Rec."Product Volume" := Format(MICASalesOrders.MICA_Product_Volume);
            Rec."Product Volume UoM" := Format(MICASalesOrders.MICA_Product_Volume_UoM);
            Rec.Insert();
        end;
        MICASalesOrders.Close();
        Rec.FindFirst();
    end;
}