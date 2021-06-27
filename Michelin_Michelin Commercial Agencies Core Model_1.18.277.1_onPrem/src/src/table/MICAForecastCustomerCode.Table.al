table 80026 "MICA Forecast Customer Code"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "MICA Forecaste Cust Code List";
    LookupPageId = "MICA Forecaste Cust Code List";

    fields
    {
        field(1; "Customer Code"; Code[20])
        {
            Caption = 'Customer Code';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
        }

        field(2; "Product Line"; Code[20])
        {
            Caption = 'Product Line';
            DataClassification = CustomerContent;
            TableRelation = "Item Category";
        }

        field(3; "Forecast Code"; Code[5])
        {
            Caption = 'Forecast Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Forecast Code2";
        }

    }

    keys
    {
        key(PK; "Customer Code", "Product Line")
        {
            Clustered = true;
        }
    }

}