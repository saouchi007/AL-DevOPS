table 50101 BonusHeader
{
    DataClassification = CustomerContent;
    Caption = 'Bonus Header';
    DrillDownPageId = BonusList;
    LookupPageId = BonusList;

    fields
    {
        field(1; "No."; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';

        }
        field(2; "Customer N0."; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(3; "Starting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Starting Date';
        }
        field(4; "Ending Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Ending Date';
        }
        field(5; "Status"; Enum BonusStatus)
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

}