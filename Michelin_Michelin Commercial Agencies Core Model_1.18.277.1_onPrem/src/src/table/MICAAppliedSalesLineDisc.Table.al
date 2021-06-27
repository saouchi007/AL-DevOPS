table 80185 "MICA Applied Sales Line Disc."
{
    // version OFFINVOICE
    DataClassification = CustomerContent;
    Caption = 'Applied Sales Line Disc.';
    LookupPageId = "MICA Applied Sales Line Disc.";
    DrillDownPageId = "MICA Applied Sales Line Disc.";


    fields
    {
        field(1; "Rebates Type"; Option)
        {
            Caption = 'Rebates Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Rebate,Payment Terms,Exceptional';
            OptionMembers = Rebate,"Payment Terms",Exceptional;
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(4; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = CustomerContent;
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(6; "Sales Type"; Option)
        {
            Caption = 'Sales Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Customer,Customer Disc. Group,All Customers,Campaign';
            OptionMembers = Customer,"Customer Disc. Group","All Customers",Campaign;
        }
        field(7; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            DataClassification = CustomerContent;
            TableRelation = IF ("Sales Type" = CONST ("Customer Disc. Group")) "Customer Discount Group"
            ELSE
            IF ("Sales Type" = CONST (Customer)) Customer
            ELSE
            IF ("Sales Type" = CONST (Campaign)) Campaign;
        }
        field(8; Type; Option)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Item,Item Disc. Group,Payment Term Disc.,Exceptional Disc.';
            OptionMembers = Item,"Item Disc. Group","Payment Term Disc.","Exceptional Disc.";
        }
        field(9; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = IF (Type = CONST (Item)) Item
            ELSE
            IF (Type = CONST ("Item Disc. Group")) "Item Discount Group";
        }
        field(10; "Product Line"; Code[10])
        {
            Caption = 'Product Line';
            DataClassification = CustomerContent;
        }
        field(11; Brand; Code[10])
        {
            Caption = 'Brand';
            DataClassification = CustomerContent;
        }
        field(12; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = CustomerContent;
            TableRelation = IF (Type = CONST (Item)) "Item Unit of Measure".Code WHERE ("Item No." = FIELD ("Code"));
        }
        field(13; "Sales Discount %"; Decimal)
        {
            Caption = 'Sales Discount %';
            DataClassification = CustomerContent;
            MaxValue = 100;
            MinValue = 0;
        }
        field(14; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
        field(15; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = CustomerContent;
        }
        field(16; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(20; "Posted Document No."; Code[20])
        {
            Caption = 'Posted Document No.';
            DataClassification = CustomerContent;
        }
        field(30; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Open,"Reserve OnHand","Reserve InTransit","Waiting Allocation","Send to Execution",Closed;
            FieldClass = FlowField;
            CalcFormula = lookup ("Sales Line"."MICA Status" WHERE ("Document Type" = FIELD ("Document Type"), "Document No." = field ("Document No."), "Line No." = field ("Document Line No.")));
            Editable = false;
        }
        field(31; "Order Date"; Date)
        {
            Caption = 'Order Date';
            FieldClass = FlowField;
            CalcFormula = lookup ("Sales Header"."Order Date" WHERE ("Document Type" = FIELD ("Document Type"), "No." = field ("Document No.")));
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Rebates Type", "Document Type", "Document No.", "Document Line No.", "Line No.")
        {
        }
        key(Key2; "Document Type", "Document No.", "Document Line No.", "Sales Discount %", "Posted Document No.")
        {
        }
        key(Key3; "Line No.")
        {
        }
        key(Key5; "Rebates Type", "Document Type", "Document No.", "Document Line No.", Code)
        {
        }


    }
}

