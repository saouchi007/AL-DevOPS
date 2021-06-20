table 50101 GLSourceName
{
    Caption = 'GLSourceName';
    DataClassification = CustomerContent;

    fields
    {
        field(1; SourceType; Enum "Gen. Journal Source Type")
        {
            Caption = 'SourceType';
            DataClassification = CustomerContent;
        }
        field(2; "SourceNo."; Code[20])
        {
            Caption = 'SourceNo.';
            DataClassification = CustomerContent;
            TableRelation = if (SourceType = const(Customer)) Customer
            else
            if (SourceType = const(Vendor)) Vendor
            else
            if (SourceType = const("Fixed Asset")) "Fixed Asset";
        }
        field(3; SourceName; Text[100])
        {
            Caption = 'SourceName';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; SourceType, "SourceNo.")
        {
            Clustered = true;
        }
    }

}
