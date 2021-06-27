table 81190 "MICA FlowBuff Shipped Confirm."
{
    DataClassification = CustomerContent;
    DrillDownPageId = "MICA FlowBuff Shipped Confirm.";
    LookupPageId = "MICA FlowBuff Shipped Confirm.";
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

        //Shipment Confirmation (in) Fields
        field(81190; "Logical ID"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(81191; "Creation DateTime"; Text[19])
        {
            DataClassification = CustomerContent;
        }
        field(81192; "Driver Info"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(81193; "License Plate"; Text[15])
        {
            DataClassification = CustomerContent;
        }
        field(81194; "RAW Actual Ship DateTime"; Text[25])
        {
            DataClassification = CustomerContent;
        }
        field(81195; "Actual Ship DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(81196; "RAW Shipped Quantity"; Text[15])
        {
            DataClassification = CustomerContent;
        }
        field(81197; "Shipped Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
        }

        field(81198; "Document ID"; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(81199; "RAW Document Line Number"; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(81200; "Document Line Number"; Integer)
        {
            DataClassification = CustomerContent;
        }

        field(81201; "RAW Planned Ship Quantity"; Text[15])
        {
            DataClassification = CustomerContent;
        }
        field(81202; "Planned Ship Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(81203; "License Plate Type"; Text[30])
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