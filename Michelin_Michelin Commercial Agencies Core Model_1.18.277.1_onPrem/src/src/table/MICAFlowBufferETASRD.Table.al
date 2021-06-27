table 82440 "MICA Flow Buffer ETA SRD"
{
    DataClassification = CustomerContent;
    Caption = 'Flow Buffer ETA SRD';
    fields
    {

        field(10; "Flow Entry No."; Integer)
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
        field(20; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(30; "Flow Code"; Code[20])
        {
            Caption = 'Flow Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow".Code;
        }

        field(40; "Date Time Creation"; DateTime)
        {
            Caption = 'Date Time Creation';
            DataClassification = CustomerContent;
        }

        field(50; "Last Date Time Modification"; DateTime)
        {
            Caption = 'Last Date Time Modification';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60; "Info Count"; Integer)
        {
            Caption = 'Info Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where ("Info Type" = const (Information), "Flow Buffer Entry No." = field ("Entry No.")));
        }
        field(70; "Warning Count"; Integer)
        {
            Caption = 'Warning Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where ("Info Type" = const (Warning), "Flow Buffer Entry No." = field ("Entry No.")));
        }
        field(80; "Error Count"; Integer)
        {
            Caption = 'Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where ("Flow Entry No." = field ("Flow Entry No."), "Flow Buffer Entry No." = field ("Entry No."), "Info Type" = const (Error)));
        }
        field(90; "Skip Line"; Boolean)
        {
            Caption = 'Skip Line';
            DataClassification = CustomerContent;
        }
        field(100; "Linked Record ID"; RecordID)
        {
            Caption = 'Linked Record ID';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Validate("Linked Record", CopyStr(Format(RecordID()), 1, 250));
            end;
        }

        field(110; "Linked Record"; Text[250])
        {
            Caption = 'Linked Record';
            DataClassification = CustomerContent;
        }
        field(120; "Error"; Boolean)
        {
            Caption = 'Error';
            DataClassification = CustomerContent;
        }

        field(1000; "Tech. Logical ID"; Text[50])
        {
            Caption = 'Tech. Logical ID';
            DataClassification = CustomerContent;
        }
        field(1010; "Tech. Component ID"; Text[50])
        {
            Caption = 'Tech. Component ID';
            DataClassification = CustomerContent;
        }
        field(1020; "Tech. Task ID"; Text[50])
        {
            Caption = 'Tech. Task ID';
            DataClassification = CustomerContent;
        }
        field(1030; "Tech. Reference ID"; Text[50])
        {
            Caption = 'Tech. Reference ID';
            DataClassification = CustomerContent;
        }
        field(1040; "Tech. Creation DateTime Raw"; Text[50])
        {
            Caption = 'Tech. Creation DateTime Raw';
            DataClassification = CustomerContent;
        }
        field(1050; "Tech. Creation DateTime"; DateTime)
        {
            Caption = 'Tech. Creation DateTime';
            DataClassification = CustomerContent;
        }
        field(1060; "Tech. Native ID"; Text[50])
        {
            Caption = 'Tech. Native ID';
            DataClassification = CustomerContent;
        }
        field(1100; "ETA Raw"; Text[50])
        {
            Caption = 'ETA Raw';
            DataClassification = CustomerContent;
        }
        field(1110; ETA; DateTime)
        {
            Caption = 'ETA';
            DataClassification = CustomerContent;
        }
        field(1120; "SRD Raw"; Text[50])
        {
            Caption = 'SRD Raw';
            DataClassification = CustomerContent;
        }
        field(1130; SRD; DateTime)
        {
            Caption = 'SRD';
            DataClassification = CustomerContent;
        }

        field(1140; "ASN No. Raw"; Text[50])
        {
            Caption = 'ASN No. Raw';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(1150; "ASN No."; Code[35])
        {
            Caption = 'ASN No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(1160; "ACK Sent"; Boolean)
        {
            Caption = 'ACK Sent';
            DataClassification = CustomerContent;
            Editable = false;
        }

    }

    keys
    {
        key(PK; "Flow Code", "Flow Entry No.", "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnModify()
    begin
        "Last Date Time Modification" := CreateDateTime(Today(), Time());
    end;
}