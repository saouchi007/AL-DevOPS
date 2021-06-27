table 81861 "MICA Value Entries Query Table"
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

        field(2; "Item_No_"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
        }
        field(3; "Posting_Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date';
        }
        field(4; "Item_Ledger_Entry_Type"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Ledger Entry Type';
        }
        field(5; "Source_No_"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bill-To';
        }
        field(6; "Location_Code"; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Location Code';
        }
        field(7; "Invoiced_Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Invoiced Quantity';
        }
        field(8; "Sales_Amount__Actual_"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Amount (Actual)';
        }
        field(9; "Discount_Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Discount Amount';
        }
        field(10; "Global_Dimension_1_Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Section Code';
        }
        field(11; "Global_Dimension_2_Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Structure Code';
        }
        field(12; "Source_Type"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Source Type';
        }
        field(13; "Cost_Amount__Actual_"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Cost Amount (Actual)';
        }
        field(14; "Salespers__Purch__Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales pers/Purch. Code';
        }
        field(15; "Document_Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Document Type';
            OptionMembers = " ","Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Transfer Shipment","Transfer Receipt","Service Shipment","Service Invoice","Service Credit Memo","Posted Assembly";
            OptionCaption = ' ,Sales Shipment,Sales Invoice,Sales Return Receipt,Sales Credit Memo,Purchase Receipt,Purchase Invoice,Purchase Return Shipment,Purchase Credit Memo,Transfer Shipment,Transfer Receipt,Service Shipment,Service Invoice,Service Credit Memo,Posted Assembly';
        }
        field(16; "Order_No_"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Order No.';
        }
        field(17; "No__2"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. 2';
        }
        field(18; Type; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Type';
        }
        field(19; "Item_Category_Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Category Code';
        }
        field(20; "MICA_Brand"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Brand';
        }
        field(21; "MICA_Product_Segment"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Product Segment';
        }
        field(22; "MICA_Tire_Size"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Tire Size';
        }
        field(23; "MICA_Pattern_Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Pattern Code';
        }
        field(24; "MICA_Product_Weight"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Product Weight';
        }
        field(25; "MICA_Commercial_Label"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Commercial Label';
        }
        field(26; "MICA_Rim_Diameter"; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Rim Diameter';
        }
        field(27; "Source_No_Item_Ledger_Entry"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-To';
        }
        field(28; "Sell_To_Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-To Name';
        }
        field(29; "MICA_Market_Code"; Code[2])
        {
            DataClassification = CustomerContent;
            Caption = 'Market Code';
        }
        field(30; "Forecast_Code"; Code[5])
        {
            DataClassification = CustomerContent;
            Caption = 'Forecast Code';
        }
        field(31; Name; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Bill-to Name';
        }
        field(32; "Document_No_"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
            TableRelation = if ("Document_Type" = const("Sales Shipment")) "Sales Shipment Line"."Document No."
            else
            if ("Document_Type" = const("Sales Invoice")) "Sales Invoice Header"."No."
            else
            if ("Document_Type" = const("Sales Return Receipt")) "Return Receipt Line"."Document No."
            else
            if ("Document_Type" = const("Sales Credit Memo")) "Sales Line"."Document No." where("Document Type" = const("Credit Memo"))
            else
            if ("Document_Type" = const("Purchase Receipt")) "Purch. Rcpt. Line"."Document No."
            else
            if ("Document_Type" = const("Purchase Invoice")) "Purch. Inv. Line"."Document No."
            else
            if ("Document_Type" = const("Purchase Return Shipment")) "Purchase Line"."Document No." where("Document Type" = const("Return Order"))
            else
            if ("Document_Type" = const("Purchase Credit Memo")) "Purchase Line"."Document No." where("Document Type" = const("Credit Memo"))
            else
            if ("Document_Type" = const("Transfer Shipment")) "Transfer Shipment Line"."Document No."
            else
            if ("Document_Type" = const("Transfer Receipt")) "Transfer Receipt Line"."Document No."
            else
            if ("Document_Type" = const("Service Shipment")) "Service Shipment Line"."Document No."
            else
            if ("Document_Type" = const("Service Invoice")) "Service Invoice Line"."Document No."
            else
            if ("Document_Type" = const("Service Credit Memo")) "Service Cr.Memo Line"."Document No."
            else
            if ("Document_Type" = const("Posted Assembly")) "Posted Assembly Line"."Document No.";

        }
        field(33; "Business_Line"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Business Line';
        }
        field(34; "Territory_Code"; Code[10])
        {
            Caption = 'Territory Code';
            DataClassification = CustomerContent;
        }
        field(35; "Amount_Including_VAT"; Decimal)
        {
            Caption = 'Amount Including VAT';
            DataClassification = CustomerContent;
        }
        field(36; "Item_Description"; Text[100])
        {
            Caption = 'Item Description';
            DataClassification = CustomerContent;
        }
        field(37; "Customer_Disc__Group"; Code[20])
        {
            Caption = 'Customer Disc. Group';
            DataClassification = CustomerContent;
        }
        field(38; "MICA_Item_Class"; Code[30])
        {
            Caption = 'Item Class';
            DataClassification = CustomerContent;
        }
        field(40; "MICA_Item_Charge_No_"; Code[20])
        {
            Caption = 'Item Charge No.';
            DataClassification = CustomerContent;
        }
        field(50; "MICA_Ship_To_Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            DataClassification = CustomerContent;
        }
        field(60; "MICA_Ship_To_Name"; Text[100])
        {
            Caption = 'Ship-to Name';
            DataClassification = CustomerContent;
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