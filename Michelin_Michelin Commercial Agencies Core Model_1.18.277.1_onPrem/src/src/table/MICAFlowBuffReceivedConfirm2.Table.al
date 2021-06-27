table 81211 "MICA FlowBuff ReceivedConfirm2"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "MICA FlowBuff Received Confirm";
    LookupPageId = "MICA FlowBuff Received Confirm";

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
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Information), "Flow Buffer Entry No." = field("Entry No."),
                                                                "Flow Entry No." = field("Flow Entry No.")));
        }
        field(60; "Warning Count"; Integer)
        {
            Caption = 'Warning Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Warning), "Flow Buffer Entry No." = field("Entry No."),
                                                                "Flow Entry No." = field("Flow Entry No.")));
        }
        field(70; "Error Count"; Integer)
        {
            Caption = 'Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Error),
                                                                "Flow Buffer Entry No." = field("Entry No."), "Flow Entry No." = field("Flow Entry No.")));
        }
        field(80; "Skip Line"; Boolean)
        {
            Caption = 'Skip Line';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                Flow: Record "MICA Flow";
            begin
                Flow.Get("Flow Code");
                Flow.TestField("Allow Skip Line", true);
            end;
        }
        field(90; "Linked Record ID"; RecordId)
        {
            Caption = 'Linked Record ID';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                Validate("Linked Record", CopyStr(Format(RecordID()), 1, 250));
            end;
        }
        field(100; "Error"; Boolean)
        {
            Caption = 'Error';
            DataClassification = CustomerContent;
        }
        field(110; "Linked Record"; Text[250])
        {
            Caption = 'Linked Record ID';
            DataClassification = CustomerContent;
        }
        field(120; "Date Time Last Modified"; DateTime)
        {
            Caption = 'Date time Last Modified';
            DataClassification = CustomerContent;
            Editable = false;
        }

        //Receive Confirmation (in) Fields
        field(81212; "RAW Actual Delivery DateTime"; Text[25])
        {
            DataClassification = CustomerContent;
        }
        field(81213; "Actual Delivery DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(81214; "RAW Received Quantity"; Text[15])
        {
            DataClassification = CustomerContent;
        }
        field(81215; "Received Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
        }

        field(81216; "Document ID"; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(81217; "RAW Document Line Number"; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(81218; "Document Line Number"; Integer)
        {
            DataClassification = CustomerContent;
        }

        field(81201; "RAW Expected Quantity"; Text[15])
        {
            DataClassification = CustomerContent;
        }
        field(81202; "Expected Quantity"; Decimal)
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