table 50103 BonusEntry
{
    DataClassification = CustomerContent;
    Caption = 'Bonus Entry';


    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
            Editable = false;

        }
        field(2; "Bonus No."; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Bonus No.';
            Editable = false;
            TableRelation = BonusHeaderTable;

        }
        field(3; "Document No."; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
            Editable = false;
            TableRelation = "Sales Invoice Header";
        }
        field(4; "Item No."; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
            Editable = false;
            TableRelation = Item;
        }
        field(5; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date';
            Editable = false;
        }
        field(6; "Bonus amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Bonus Amount';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
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