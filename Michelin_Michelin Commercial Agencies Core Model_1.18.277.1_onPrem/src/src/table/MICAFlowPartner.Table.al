table 80860 "MICA Flow Partner"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "MICA Flow Partner List";
    LookupPageId = "MICA Flow Partner List";

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(20; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(30; "Flow Count"; Integer)
        {
            Caption = 'Flow Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow" where ("Partner Code" = field (Code)));
        }
        field(40; "Count of Entry"; Integer)
        {
            Caption = 'Count of Entry';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Entry" where ("Partner Code" = field (Code)));
        }
        field(50; "Count of Archived File"; Integer)
        {
            Caption = 'Count of Archived File';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70; "Last Modified User ID"; Code[50])
        {
            Caption = 'Last Modified User ID';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User."User Name";
        }

        field(100; "EndPoint Substitute Value 1"; Text[100])
        {
            caption = 'EndPoint Substitute Value 1';
            DataClassification = CustomerContent;

        }

        field(101; "EndPoint Substitute Value 2"; Text[100])
        {
            caption = 'EndPoint Substitute Value 2';
            DataClassification = CustomerContent;

        }

        field(102; "EndPoint Substitute Value 3"; Text[100])
        {
            caption = 'EndPoint Substitute Value 3';
            DataClassification = CustomerContent;

        }
        field(103; "EndPoint Substitute Value 4"; Text[100])
        {
            caption = 'EndPoint Substitute Value 4';
            DataClassification = CustomerContent;

        }

        field(104; "EndPoint Substitute Value 5"; Text[100])
        {
            caption = 'EndPoint Substitute Value 5';
            DataClassification = CustomerContent;

        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        Validate("Last Modified Date Time", CurrentDateTime());
        Validate("Last Modified User ID", UserId());
    end;

    trigger OnModify()
    begin
        Validate("Last Modified Date Time", CurrentDateTime());
        Validate("Last Modified User ID", UserId());
    end;

}