table 82681 "MICA Flow Information Archive"
{
    Caption = 'Flow Information Archive';
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
        }
        field(30; "Flow Entry No."; Integer)
        {
            Caption = 'Flow Entry No.';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow Entry Archive";
        }
        field(50; "Flow Buffer Entry No."; Integer)
        {
            Caption = 'Flow Buffer Entry No.';
            DataClassification = CustomerContent;
        }
        field(60; "Info Type"; Option)
        {
            Caption = 'Info Type';
            DataClassification = CustomerContent;
            OptionMembers = Information,Warning,Error;
            OptionCaption = 'Information,Warning,Error';
        }
        field(70; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(80; "Description 2"; Text[250])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(90; "Created Date"; Date)
        {
            Caption = 'Created Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(100; "Created Date Time"; DateTime)
        {
            Caption = 'Created Date Time ';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(110; "End Date Time"; DateTime)
        {
            Caption = 'End Date Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(120; "Information Duration"; Duration)
        {
            Caption = 'Information Duration';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(130; "Linked Record ID"; RecordID)
        {
            Caption = 'Linked Record ID';
            DataClassification = CustomerContent;
        }
        field(140; "Linked Record"; Text[250])
        {
            Caption = 'Linked Record';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(200; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = " ",Open,InProgress,Closed;
            OptionCaption = ' ,Open,In Progress,Closed';
            DataClassification = CustomerContent;

        }
        field(300; "Modified Date Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(310; "Modified UserID"; Text[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(320; "Additional Text"; Text[200])
        {
            DataClassification = CustomerContent;
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
        key(KEY1; "Flow Code")
        {

        }
        key(KEY2; "Flow Entry No.")
        {

        }
    }

    trigger OnInsert()
    begin
        "Archive Date Time" := CurrentDateTime();
    end;
  
}
