table 50102 BonusLine
{
    DataClassification = CustomerContent;
    Caption = 'Bonus Line';

    fields
    {
        field(1; "Document No."; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Document No.';
            TableRelation = BonusHeader;

        }
        field(2; Type; Enum BonusType)
        {
            DataClassification = ToBeClassified;
            Caption = 'Type';
        }
        field(3; "Item No."; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Item';
            TableRelation = Item;
        }
        field(4; "Bonus Perc"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Bonus Perc';
            MinValue = 0;
            MaxValue = 100;
        }
    }

    keys
    {
        key(PK; "Document No.", Type, "Item No.")
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