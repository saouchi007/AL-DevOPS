table 80866 "MICA Flow Buffer"
{
    DataClassification = CustomerContent;
    LookupPageId = "MICA Flow Buffer List";
    DrillDownPageId = "MICA Flow Buffer List";
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
            CalcFormula = lookup("MICA Flow Entry"."Flow Code" where("Entry No." = field("Flow Entry No.")));
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
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Information), "Flow Buffer Entry No." = field("Entry No.")));
        }
        field(60; "Warning Count"; Integer)
        {
            Caption = 'Warning Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Warning), "Flow Buffer Entry No." = field("Entry No.")));
        }
        field(70; "Error Count"; Integer)
        {
            Caption = 'Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Error), "Flow Buffer Entry No." = field("Entry No.")));
        }
        field(80; "Skip Line"; Boolean)
        {
            Caption = 'Skip Line';
            DataClassification = CustomerContent;
        }
        field(90; "Linked Record ID"; RecordID)
        {
            Caption = 'Linked Record ID';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Validate("Linked Record", CopyStr(Format(RecordID()), 1, 250));
            end;
        }
        field(100; "Linked Record"; Text[250])
        {
            Caption = 'Linked Record ID';
            DataClassification = CustomerContent;
        }
        field(110; "Date Time Last Modified"; DateTime)
        {
            Caption = 'Date time Last Modified';
            DataClassification = CustomerContent;
            Editable = false;
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
    var
        MICAFlow: Record "MICA Flow";
    begin
        CalcFields("Flow Code");
        MICAFlow.Get("Flow Code");
        Validate("Skip Line", MICAFlow."Allow Skip Line");
        Validate("Date Time Creation", CurrentDateTime());
    end;

    trigger OnModify()
    begin
        Validate("Date Time Last Modified", CurrentDateTime());
    end;

    procedure AddInformation(Type: Option; Description1: Text; Description2: Text): Integer
    var
        MICAFlowInformation: Record "MICA Flow Information";
    begin
        MICAFlowInformation.Init();
        MICAFlowInformation.Validate("Flow Buffer Entry No.", "Entry No.");
        MICAFlowInformation.Validate("Info Type", Type);
        MICAFlowInformation.Validate(Description, CopyStr(Description1, 1, MaxStrLen(MICAFlowInformation.Description)));
        MICAFlowInformation.Validate("Description 2", CopyStr(Description2, 1, MaxStrLen(MICAFlowInformation."Description 2")));
        MICAFlowInformation.Insert(true);
        exit(MICAFlowInformation."Entry No.");
    end;
}
