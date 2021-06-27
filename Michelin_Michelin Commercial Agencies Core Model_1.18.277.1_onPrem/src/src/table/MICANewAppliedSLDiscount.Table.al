table 80186 "MICA New Applied SL Discount"
{
    // version OFFINVOICE
    DataClassification = CustomerContent;
    Caption = 'Applied Sales Line Disc.';
    LookupPageId = "MICA Applied SL Discount";
    DrillDownPageId = "MICA Applied SL Discount";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }

        field(10; "Rebates Type"; Option)
        {
            Caption = 'Rebates Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Rebate,Payment Terms,Exceptional';
            OptionMembers = Rebate,"Payment Terms",Exceptional;
        }
        field(20; "Document Type"; Option)
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(30; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(40; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = CustomerContent;
        }

        field(60; "Sales Type"; Option)
        {
            Caption = 'Sales Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Customer,Customer Disc. Group,All Customers,Campaign';
            OptionMembers = Customer,"Customer Disc. Group","All Customers",Campaign;
        }
        field(70; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            DataClassification = CustomerContent;
            TableRelation = IF ("Sales Type" = CONST("Customer Disc. Group")) "Customer Discount Group"
            ELSE
            IF ("Sales Type" = CONST(Customer)) Customer
            ELSE
            IF ("Sales Type" = CONST(Campaign)) Campaign;
        }
        field(80; Type; Option)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Item,Item Disc. Group,Payment Term Disc.,Exceptional Disc.';
            OptionMembers = Item,"Item Disc. Group","Payment Term Disc.","Exceptional Disc.";
        }
        field(90; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST("Item Disc. Group")) "Item Discount Group";
        }
        field(100; "Product Line"; Code[10])
        {
            Caption = 'Product Line';
            DataClassification = CustomerContent;
        }
        field(110; Brand; Code[10])
        {
            Caption = 'Brand';
            DataClassification = CustomerContent;
        }
        field(120; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = CustomerContent;
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("Code"));
        }
        field(130; "Sales Discount %"; Decimal)
        {
            Caption = 'Sales Discount %';
            DataClassification = CustomerContent;
            MaxValue = 100;
            MinValue = 0;
            DecimalPlaces = 0 : 5;
        }
        field(140; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
        field(150; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = CustomerContent;
        }
        field(160; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }

        field(300; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Open,"Reserve OnHand","Reserve InTransit","Waiting Allocation","Send to Execution",Closed;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."MICA Status" WHERE("Document Type" = FIELD("Document Type"), "Document No." = field("Document No."), "Line No." = field("Document Line No.")));
            Editable = false;
        }
        field(310; "Order Date"; Date)
        {
            Caption = 'Order Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Order Date" WHERE("Document Type" = FIELD("Document Type"), "No." = field("Document No.")));
            Editable = false;
        }

        field(330; "MICA Except. Rebate Reason"; code[20])
        {
            Caption = 'Except. Rebate Reason';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(SalesLineExceptRebateReason), Blocked = const(false));
        }
        field(340; "MICA Source Document No."; Code[20])
        {
            Caption = 'Source Document No.';
            DataClassification = CustomerContent;
        }
        field(350; "MICA Source Doc. Line No."; Integer)
        {
            Caption = 'Source Document Line No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {

        }
        key(Key2; "Document Type", "Document No.", "Document Line No.", "Rebates Type", Code)
        {
        }
        key(Key3; "Document Type", "Document No.", "Document Line No.", "Sales Discount %")
        {
        }


    }
}

