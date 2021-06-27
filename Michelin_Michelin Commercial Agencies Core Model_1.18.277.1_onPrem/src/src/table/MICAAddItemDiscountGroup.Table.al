table 80183 "MICA Add. Item Discount Group"
{
    // version OFFINVOICE
    DataClassification = CustomerContent;
    Caption = 'Additional Item Discount Group';
    LookupPageID = "MICA Add. Item Disc. Groups";
    DrillDownPageId = "MICA Add. Item Disc. Groups";

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(2; "Item Discount Group Code"; Code[20])
        {
            Caption = 'Item Discount Group Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Discount Group";
        }
        field(3; "Item Discount Group Desc."; Text[50])
        {
            CalcFormula = Lookup ("Item Discount Group".Description WHERE (Code = FIELD ("Item Discount Group Code")));
            Caption = 'Item Discount Group Desc.';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Item No.", "Item Discount Group Code")
        {
        }
    }

    fieldgroups
    {
    }
}

