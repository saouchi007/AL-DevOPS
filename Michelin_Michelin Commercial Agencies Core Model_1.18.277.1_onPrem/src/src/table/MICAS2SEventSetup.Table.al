table 82861 "MICA S2S Event Setup"
{
    Caption = 'S2S Event Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "Event Count On Refresh"; Integer)
        {
            Caption = 'Event Count On Refresh';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(3; "Keep Events For"; DateFormula)
        {
            Caption = 'Keep Events For';
            DataClassification = CustomerContent;
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
