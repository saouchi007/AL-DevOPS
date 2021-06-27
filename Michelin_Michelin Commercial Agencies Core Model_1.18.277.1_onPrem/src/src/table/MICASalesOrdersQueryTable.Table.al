table 81860 "MICA Sales Orders Query Table"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "No_"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
        field(3; "Order_Date"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Order Date';
        }
        field(4; "Posting_Date"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date';
        }
        field(5; "Salesperson_Code"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Saleperson Code';
        }

        field(6; "Sell_to_Customer_No_"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Customer No.';
        }
        field(7; "Sell_to_Customer_Name"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Customer Name';
        }
        field(8; "Ship_to_Code"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Code';
        }
        field(9; "Ship_to_Name"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Name';
        }
        field(10; "Ship_to_Address"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Address';
        }
        field(11; "Ship_to_Address_2"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Address 2';
        }
        field(12; "Ship_to_City"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to City';
        }
        field(13; "Ship_to_County"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to County';
        }
        field(14; "Ship_to_Country_Region_Code"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Country/Region Code';
        }
        field(15; "MICA_Order_Type"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Order Type';
        }
        field(16; Status; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
        }
        field(17; "SC_Unique_Webshop_Document_Id"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'SC Unique Webshop Document Id';
        }
        field(18; "Bill_to_Customer_No_"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Bill-to Customer No.';
        }
        field(19; "Bill_to_Name"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Bill-to Name';
        }
        field(20; "Sell_to_Customer_County"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Customer County';
        }
        field(21; "MICA_Market_Code"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Market Code';
        }
        field(22; "Bill_to_Customer_County"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Bill-to Customer County';
        }
        field(23; "MDMID_Ship_To"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'MDMID Ship-to';
        }
        field(24; "Item_No"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
        }
        field(25; "Item_Category_Code"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Category Code';
        }
        field(26; "MICA_Status"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
        }
        field(27; "Location_Code"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Location Code';
        }
        field(28; Quantity; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
        }
        field(29; "Unit_Price"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Unit Price';
        }
        field(30; "Line_Amount"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Line Amount';

        }
        field(31; "Line_Discount_Amount"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Line Discount Amount';
        }
        field(32; "Line_Discount_Pourcentage"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Line Discount %';
        }
        field(33; "Outstanding_Amount__LCY_"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Outstanding Amount (LCY)';
        }
        field(34; "Shipped_Not_Inv___LCY__No_VAT"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Shipped Not Inv. (LCY) No VAT';
        }
        field(35; "Reserved_Quantity"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Reserved Quantity';
        }
        field(36; "Quantity_Shipped"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity Shipped';
        }
        field(37; "Qty__Shipped_Not_Invoiced"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. Shipped Not Invoiced';
        }
        field(38; "Quantity_Invoiced"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity Invoiced';
        }
        field(39; "Requested_Delivery_Date"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Requested Delivery Date';
        }
        field(40; "Promised_Delivery_Date"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Promised Delivery Date';
        }
        field(41; "Shipment_Date"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Shipment Date';
        }
        field(42; "Planned_Shipment_Date"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Planned Shipment Date';
        }
        field(43; "Planned_Delivery_Date"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Planned Delivery Date';
        }
        field(44; "Shortcut_Dimension_1_Code"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 1 Code';
        }
        field(45; "Shortcut_Dimension_2_Code"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 2 Code';
        }
        field(46; "No__2"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'No. 2';
        }
        field(47; Type; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Type';
        }
        field(48; "MICA_Brand"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Brand';
        }
        field(49; "MICA_Product_Segment"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Product Segment';
        }
        field(50; "MICA_Tire_Size"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Tire Size';
        }
        field(51; "MICA_Pattern_Code"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Pattern Code';
        }
        field(52; "MICA_Product_Weight"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Product Weight';
        }
        field(53; "MICA_Product_Weight_UOM"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Product Weight UOM';
        }
        field(54; "MICA_Rim_Diameter"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Rim Diameter';
        }
        field(55; "Forecast_Code"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Forecast Code';
        }
        field(56; "Product Volume"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Product Volume';
        }
        field(57; "Product Volume UoM"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Product Volume UoM';
        }
        field(58; "Sell-to Cust. MDMID"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Customer MDM-ID';
        }
        field(59; "Bill-to Cust. MDMID"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Bill-to Customer MDM-ID';
        }
        field(60; "Michelin_Structure_Code"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Michelin Structure Code';
        }
        field(61; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(62; "Sell_To_Territory_Code"; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Cust. Territory Code';
        }
        field(63; "Bill_To_Territory_Code"; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Bill-to Cust. Territory Code';
        }
    }
    keys
    {
        key(PK; "ID")
        {
            Clustered = true;
        }
    }

}