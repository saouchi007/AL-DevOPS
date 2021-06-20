table 50100 BonusSetupTable
{
    DataClassification = CustomerContent;
    Caption = 'Bonus Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Primary Key';

        }
        field(2; "Bonus Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bonus Nos.';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}