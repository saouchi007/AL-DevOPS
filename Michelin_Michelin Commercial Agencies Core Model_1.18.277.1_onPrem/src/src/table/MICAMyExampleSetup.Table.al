table 80874 "MICA MyExampleSetup"
{
    ObsoleteState = Removed;
    ObsoleteReason = 'Deleted';
    //DrillDownPageId = "MICA MyExampleSetup Card";
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = CustomerContent;
        }

        //You might want to add fields here
        field(2; "Sample Flow Code"; Code[20])
        {
            Caption = 'Sample Flow Code';
            TableRelation = "MICA Flow";
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