table 81360 "MICA Order Shipped MIMS Buffer"
{
    DataClassification = CustomerContent;
    caption = 'Order Shipped MIMS Buffer';

    fields
    {
        field(10; CAI; Code[6])
        {
            DataClassification = CustomerContent;
        }


        field(20; "Market Code"; Text[2])
        {
            DataClassification = CustomerContent;
        }
        field(30; "Client Code"; Text[6])
        {
            DataClassification = CustomerContent;
        }

        field(50; TotalQtyOfSales; Decimal)
        {
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; CAI, "Client Code", "Market Code")
        {
            Clustered = true;
        }
    }
}