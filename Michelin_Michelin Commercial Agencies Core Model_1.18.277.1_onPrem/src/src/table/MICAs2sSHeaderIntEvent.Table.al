table 82862 "MICA S2S S.Header Int. Event"
{
    Caption = 'S2S S.Header Int. Event';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Event Date Time"; DateTime)
        {
            Caption = 'Event Date Time';
            DataClassification = CustomerContent;
        }
        field(3; "Source Event Type"; Option)
        {
            Caption = 'Source Event Type ';
            DataClassification = CustomerContent;
            OptionMembers = Created,Updated,Deleted;
            OptionCaption = 'Created,Updated,Deleted';
        }
        field(4; "Source Record ID"; Guid)
        {
            Caption = 'Source Record ID';
            DataClassification = CustomerContent;
        }
        field(5; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(7; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

}
