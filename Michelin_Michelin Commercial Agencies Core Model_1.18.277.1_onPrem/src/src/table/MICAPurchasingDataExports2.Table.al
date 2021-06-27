table 81161 "MICA Purchasing Data Exports2"
{
    DataClassification = CustomerContent;
    LookupPageId = "MICA Purchasing Data Exports";
    DrillDownPageId = "MICA Purchasing Data Exports";
    fields
    {
        field(10; "Flow Code"; Code[20])
        {
            Caption = 'Flow Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow";
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

    }

    keys
    {
        key(PK; "Flow Code")
        {
            Clustered = true;
        }
    }

}