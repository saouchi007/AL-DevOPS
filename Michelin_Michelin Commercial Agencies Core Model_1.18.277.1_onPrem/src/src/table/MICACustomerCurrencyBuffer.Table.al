table 81800 "MICA Customer Currency Buffer"
{
    Caption = 'Customer Currency Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
            DataClassification = CustomerContent;
        }
        field(2; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(3; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Customer No.", "Currency Code")
        {
            Clustered = true;
        }
    }
}