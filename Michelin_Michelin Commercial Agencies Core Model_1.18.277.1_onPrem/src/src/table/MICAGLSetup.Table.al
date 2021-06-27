table 81283 "MICA GL Setup"
{
    ObsoleteState = Removed;
    ObsoleteReason = 'Deleted';
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(10; "Field Security Enable"; Boolean)
        {
            Caption = 'Field Security Enable';
            DataClassification = CustomerContent;
        }
        field(20; "Madatory Field Enable"; Boolean)
        {
            Caption = 'Madatory Field Enable';
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

    procedure InsertIfNotExists()
    var
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert(true);
        end;
    end;


}