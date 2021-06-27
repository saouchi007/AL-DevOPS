table 82620 "MICA Get Order Portfolios Tab"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'PK';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(4; Quantity; Decimal)
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(5; "Planned Delivery Date"; Date)
        {
            Caption = 'Planned Delivery Date';
            DataClassification = CustomerContent;
        }
        field(6; "Prev. Planned Del. Date"; Date)
        {
            Caption = 'Prev. Planned Del. Date';
            DataClassification = CustomerContent;
        }
        field(7; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
            DataClassification = CustomerContent;
        }
        field(8; "Business Line"; Text[20])
        {
            Caption = 'Business Line';
            DataClassification = CustomerContent;
        }
        field(9; "Ship To Address"; Code[10])
        {
            Caption = 'Ship To Address';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key1; "Planned Delivery Date", "Item No.")
        {

        }
    }

}