table 80877 "MICA Flow Buffer Sample Data"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "MICA Flow Buffer Spl Data List";

    fields
    {
        field(1; "Flow Code"; Code[20])
        {
            Caption = 'Flow Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow".Code;
        }
        field(2; "Flow Entry No."; Integer)
        {
            Caption = 'Flow Entry No.';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow Entry"."Entry No.";

            trigger OnValidate()
            var
                FlowEntry: Record "MICA Flow Entry";
            begin
                if FlowEntry.Get("Flow Entry No.") then
                    Validate("Flow Code", FlowEntry."Flow Code");
            end;

        }
        field(3; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(10; "Date Time Creation"; DateTime)
        {
            Caption = 'Date Time Creation';
            DataClassification = CustomerContent;
        }
        field(12; "Date Time Last Modified"; DateTime)
        {
            Caption = 'Date time Last Modified';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(20; "Info Count"; Integer)
        {
            Caption = 'Info Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where ("Info Type" = const (Information), "Flow Buffer Entry No." = field ("Entry No.")));
        }
        field(21; "Warning Count"; Integer)
        {
            Caption = 'Warning Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where ("Info Type" = const (Warning), "Flow Buffer Entry No." = field ("Entry No.")));
        }
        field(22; "Error Count"; Integer)
        {
            Caption = 'Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where ("Flow Entry No." = field ("Flow Entry No."), "Flow Buffer Entry No." = field ("Entry No."), "Info Type" = const (Error)));
        }
        field(30; "Skip Line"; Boolean)
        {
            Caption = 'Skip Line';
            DataClassification = CustomerContent;
        }
        field(40; "Linked Record ID"; RecordID)
        {
            Caption = 'Linked Record ID';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Validate("Linked Record", CopyStr(Format(RecordID()), 1, 250));
            end;
        }

        field(41; "Linked Record"; Text[250])
        {
            Caption = 'Linked Record ID';
            DataClassification = CustomerContent;
        }

        // MESSAGE FIELDS
        field(1000; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
        field(1020; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(1030; "Inventory Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Inventory Posting Group';
        }
        field(1050; "Costing Method Raw"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Costing Method Raw';
        }
        field(1060; "Costing Method"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Costing Method';
            OptionMembers = FIFO,LIFO,Specific,Average,Standard;
            OptionCaption = 'FIFO,LIFO,Specific,Average,Standard';
        }
        field(1070; "Unit Cost Raw"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Unit Cost Raw';
        }
        field(1080; "Unit Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Unit Cost';
        }
        field(1090; "Cost Is Adjusted Raw"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Cost Is Adjusted Raw';
        }
        field(1100; "Cost Is Adjusted"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Cost Is Adjusted';
        }
        field(1110; "Lead Time Calculation Raw"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Lead Time Calculation Raw';
        }
        field(1120; "Lead Time Calculation"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Lead Time Calculation';
        }
        field(1130; "Last Date Time Modified Raw"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Last Date Time Modified Raw';
        }
        field(1140; "Last Date Time Modified"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Last Date Time Modified';
        }
        field(1150; "Last Date Modified Raw"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Last Date Modified Raw';
        }
        field(1160; "Last Date Modified"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Last Date Modified';
        }
        field(1170; "Last Time Modified Raw"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Last Time Modified Raw';
        }
        field(1180; "Last Time Modified"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Last Time Modified';
        }
        field(1190; "Logical Id"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Logical Id';
        }
        field(1200; "Location Id"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Location Id';
        }
        field(1210; "Item Id"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Id';
        }
        field(1220; "Attribute Id"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Attribute Id';
        }


    }

    keys
    {
        key(PK; "Flow Code", "Flow Entry No.", "Entry No.")
        {
            Clustered = true;
        }
    }
}