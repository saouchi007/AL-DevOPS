table 82682 "MICA Flow Record Archive"
{
    Caption = 'Flow Record Archive';
    DataClassification = CustomerContent;
    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(20; "Flow Code"; Code[20])
        {
            Caption = 'Flow Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow";
            Editable = false;
        }
        field(30; "Flow Entry No."; Integer)
        {
            Caption = 'Flow Entry No.';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow Entry Archive";

        }
        field(40; "Linked RecordID"; RecordID)
        {
            Caption = 'RecordId';
            DataClassification = CustomerContent;

        }
        field(50; "Linked Record"; Text[250])
        {
            Caption = 'Linked Record';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(90; "Date Time Creation"; DateTime)
        {
            Caption = 'Date Time Creation';
            DataClassification = CustomerContent;
        }
        field(200; "Disable Post-Processed"; Boolean)
        {
            Caption = 'Disable Post-Processed';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82680; "Archive Date Time"; DateTime)
        {
            Caption = 'Archive Date Time';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(KEY1; "Flow Entry No.")
        {
        }
        key(KEY2; "Flow Code")
        {
        }

    }

    trigger OnInsert()
    begin
        "Archive Date Time" := CurrentDateTime();
    end;
}
