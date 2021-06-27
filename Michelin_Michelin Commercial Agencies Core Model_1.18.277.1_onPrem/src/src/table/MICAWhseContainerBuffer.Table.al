table 81380 "MICA Whse Container Buffer"
{
    DataClassification = CustomerContent;
    ReplicateData = false;
    Caption = 'Warehouse Container Buffer';

    fields
    {
        field(81462; "MICA Container ID"; Code[50])
        {
            Caption = 'Container ID';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(10; "Whse Receipt Header No."; Code[20])
        {
            Caption = 'Warehouse Receipt Header No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "MICA Container ID")
        {
            Clustered = true;
        }
    }
}