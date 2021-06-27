table 81160 "MICA Purchasing Data Exports"
{
    DataClassification = CustomerContent;
    ObsoleteState = Removed;
    ObsoleteReason = 'Deleted';

    fields
    {
        field(10; "Primary Key"; Code[20])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(20; "Export Date"; Date)
        {
            Caption = 'Export Date';
            DataClassification = CustomerContent;
        }
        field(22; "Sequence No."; Integer)
        {
            Caption = 'Sequence No.';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 99;
        }

        field(30; "Flow Code"; Code[20])
        {
            Caption = 'Flow Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow";
        }

    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

}