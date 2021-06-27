table 80184 "MICA Additional Item Discount"
{
    // version OFFINVOICE
    DataClassification = CustomerContent;
    Caption = 'Additional Item Discount';
    DrillDownPageID = "MICA Additional Item Discounts";
    LookupPageID = "MICA Additional Item Discounts";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            TableRelation = "Sales Line"."Document No.";
        }
        field(2; "Document Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            TableRelation = "Sales Line"."Line No." WHERE ("Document No." = FIELD ("Document No."));
        }
        field(3; "Add. Item Discount Group Code"; Code[20])
        {
            Caption = 'Add. Item Discount Group Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Add. Item Discount Group"."Item Discount Group Code" WHERE ("Item No." = FIELD ("Item No."));
        }
        field(4; "Discount %"; Decimal)
        {
            Caption = 'Discount %';
            DataClassification = CustomerContent;
            MaxValue = 100;
            MinValue = 0;
            DecimalPlaces = 0 : 5;
        }
        field(5; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item."No.";
        }
    }

    keys
    {
        key(Key1; "Document No.", "Document Line No.", "Add. Item Discount Group Code")
        {
        }
        key(Key2; "Document No.", "Document Line No.", "Item No.")
        {
        }
    }
}

