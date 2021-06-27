table 81221 "MICA FlowBuff Pick Req.Ack."
{
    DataClassification = CustomerContent;
    DrillDownPageId = "MICA Flow Buffer Pick Req.Ack.";
    LookupPageId = "MICA Flow Buffer Pick Req.Ack.";
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
                "Linked Record" := Format("Linked Record ID");
            end;
        }
        field(91; "Linked Record"; Text[250])
        {
            Caption = 'Linked Record';
            DataClassification = CustomerContent;
        }
        field(100; "Conversion Error"; Boolean)
        {
            Caption = 'Conversion Error';
            DataClassification = CustomerContent;
        }

        //Pick request acknowledgement (in) Fields
        field(81220; MichReferencekey; Text[200])
        {
            DataClassification = CustomerContent;
        }
        field(81221; COMPONENT; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(81222; TASK; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(81223; "RAW REFERENCEID"; Text[41])
        {
            DataClassification = CustomerContent;
        }
        field(81224; "Shipment No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(81225; "Time Stamp"; DateTime)
        {
            DataClassification = CustomerContent;
        }

        field(81226; "RAW CREATION_DATE_TIME"; Text[23])
        {
            DataClassification = CustomerContent;
        }
        field(81230; MichEnvironment; Text[10])
        {
            DataClassification = CustomerContent;
        }
        field(81231; MichSender; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(81232; MichMessageType; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(81240; STATUSLVL; Text[10])
        {
            DataClassification = CustomerContent;
        }
        field(81241; DESCRIPTN; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(81242; ORIGREF; Text[100])
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