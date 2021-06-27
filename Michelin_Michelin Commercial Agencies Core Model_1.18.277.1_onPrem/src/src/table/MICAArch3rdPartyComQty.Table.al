table 82921 "MICA Arch. 3rd Party Com. Qty."
{
    DataClassification = CustomerContent;
    LookupPageId = "MICA Arch. 3rd Party Com. Qty.";
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
            Editable = false;
            Caption = 'Blanket Purch. Order Doc. No.';
        }
        field(3; "Blanket Purch. Order Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Blanket Purch. Order Line No.';
            Editable = false;
        }
        field(4; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
            Editable = false;
        }
        field(5; "Commited Qty."; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Commited Qty.';
            Editable = false;
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
            Editable = false;
        }
        field(8; "Sales Order Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Order Line No.';
            Editable = false;
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

        }
        key(key3; "Sales Order No.", "Sales Order Line No.")
        {

        }
    }

}