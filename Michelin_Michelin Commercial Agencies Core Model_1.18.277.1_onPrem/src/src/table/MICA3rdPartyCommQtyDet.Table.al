table 82920 "MICA 3rd Party Comm. Qty. Det."
{
    DataClassification = CustomerContent;
    LookupPageId = "MICA 3rd Party Comm. Qty. Det.";
    DrillDownPageId = "MICA 3rd Party Comm. Qty. Det.";
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Blanket Purch. Order Doc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Purchase Header"."No." where("Document Type" = const("Blanket Order"));
            Caption = 'Blanket Purch. Order Doc. No.';
        }
        field(3; "Blanket Purch. Order Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Blanket Purch. Order Line No.';
            TableRelation = "Purchase Line"."Line No." where("Document Type" = const("Blanket Order"), "Document No." = field("Blanket Purch. Order Doc. No."));
        }
        field(4; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
            TableRelation = Item."No.";

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if Item.Get("Item No.") then
                    Validate(CAI, Item."No. 2");
            end;
        }
        field(5; "Commited Qty."; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Commited Qty.';
        }
        field(6; "Commitment DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Commitment DateTime';
            Editable = false;
        }
        field(7; "Sales Order No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Order No.';
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
        }
        field(8; "Sales Order Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Order Line No.';
            TableRelation = "Sales Line"."Line No." where("Document Type" = const(Order), "Document No." = field("Sales Order No."));
        }
        field(9; CAI; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'CAI';
            Editable = false;
        }
        field(10; "Original Line"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(key2; "Blanket Purch. Order Doc. No.", "Blanket Purch. Order Line No.")
        {
            SumIndexFields = "Commited Qty.";
        }
        key(key3; "Sales Order No.", "Sales Order Line No.")
        {

        }
    }
    trigger OnInsert()
    begin
        Rec.Validate("Commitment DateTime", CurrentDateTime());
    end;
}