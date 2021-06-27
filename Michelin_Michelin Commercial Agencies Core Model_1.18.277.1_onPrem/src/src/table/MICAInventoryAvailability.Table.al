table 82580 "MICA Inventory Availability"
{
    Caption = 'Inventory Availability';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;

        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(4; CAI; Code[20])
        {
            Caption = 'CAI';
            DataClassification = CustomerContent;
        }
        field(5; "Product Line"; Code[20])
        {
            Caption = 'Product Line';
            DataClassification = CustomerContent;
        }
        field(6; "Business Line"; code[10])
        {
            Caption = 'Business Line';
            DataClassification = CustomerContent;
        }
        field(7; "Market Code"; Code[2])
        {
            Caption = 'Market Code';
            DataClassification = CustomerContent;
        }
        field(8; Brand; Code[10])
        {
            Caption = 'Brand';
            DataClassification = CustomerContent;
        }
        field(9; "User Item Type"; Code[10])
        {
            Caption = 'User Item Type';
            DataClassification = CustomerContent;
        }
        field(10; "Item Class"; Code[30])
        {
            Caption = 'Item Class';
            DataClassification = CustomerContent;
        }
        field(11; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
        }
        field(12; "Calculation Type"; Option)
        {
            Caption = 'Calculation Type';
            DataClassification = CustomerContent;
            OptionMembers = Inventory,"Reserved OnHand","Reserved InTransit","Awaiting Allocation","Sent to Execution","In-Transit";
        }
        field(13; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(14; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(SK1; "Item No.", "Location Code")
        {

        }
    }

}