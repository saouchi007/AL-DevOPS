table 80920 "MICA Flow Buffer MT940"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "MICA Flow Buffer MT940 List";
    LookupPageId = "MICA Flow Buffer MT940 List";
    ObsoleteState = Removed;
    ObsoleteReason = 'Deleted';
    fields
    {
        field(10; "Flow Entry No."; Integer)
        {
            Caption = 'Flow Entry No.';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow Entry";
        }
        field(20; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(30; "Flow Code"; Code[20])
        {
            Caption = 'Flow Code';
            FieldClass = FlowField;
            CalcFormula = lookup ("MICA Flow Entry"."Flow Code" where("Entry No." = field("Flow Entry No.")));
        }
        field(40; "Date Time Creation"; DateTime)
        {
            Caption = 'Date Time Creation';
            DataClassification = CustomerContent;
        }
        field(50; "Info Count"; Integer)
        {
            Caption = 'Info Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Information), "Flow Buffer Entry No." = field("Entry No.")));
        }
        field(60; "Warning Count"; Integer)
        {
            Caption = 'Warning Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Warning), "Flow Buffer Entry No." = field("Entry No.")));
        }
        field(70; "Error Count"; Integer)
        {
            Caption = 'Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Error), "Flow Buffer Entry No." = field("Entry No.")));
        }

        field(100; "Conversion Error"; Boolean)
        {
            DataClassification = CustomerContent;
        }

        //MT940 Fields
        field(80920; "Bank Account No."; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(80921; "Currency Code"; Code[3])
        {
            DataClassification = CustomerContent;
        }
        field(80922; "Statement No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(80923; "Raw Closing Balance Date"; Text[6])
        {
            DataClassification = CustomerContent;
        }
        field(80924; "Closing Balance Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(80925; "Raw Closing Balance Amount"; Text[15])
        {
            DataClassification = CustomerContent;
        }
        field(80926; "Closing Balance Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(80927; "Raw Line Date"; Text[6])
        {
            DataClassification = CustomerContent;
        }

        field(80928; "Line Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(80929; "Raw Line Entry Date"; Text[6])
        {
            DataClassification = CustomerContent;
        }
        field(80930; "Line Entry Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(80931; "Raw Line Amount"; Text[15])
        {
            DataClassification = CustomerContent;
        }
        field(80932; "Line Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(80933; "Transaction Text"; Text[140])
        {
            DataClassification = CustomerContent;
        }
        field(80934; "Additional Transaction Info"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(80935; "Closing Balance D/C"; Text[1])
        {
            DataClassification = CustomerContent;
        }
        field(80936; "Line Amount D/C"; Text[2])
        {
            DataClassification = CustomerContent;
        }
        field(80937; "Header Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(80938; "Raw Open Balance Amount"; Text[15])
        {
            DataClassification = CustomerContent;
        }
        field(80939; "Open Balance Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(80940; "Open Balance D/C"; Text[1])
        {
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; "Flow Entry No.", "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        Validate("Date Time Creation", CurrentDateTime());
    end;

}