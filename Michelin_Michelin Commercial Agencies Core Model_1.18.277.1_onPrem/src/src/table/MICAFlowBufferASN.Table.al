table 81721 "MICA Flow Buffer ASN"
{
    DataClassification = ToBeClassified;
    Caption = 'Flow Buffer ASN';
    DrillDownPageId = "MICA Flow Buffer ASN List";
    LookupPageId = "MICA Flow Buffer ASN List";
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
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Information), "Flow Buffer Entry No." = field("Entry No.")));
        }
        field(21; "Warning Count"; Integer)
        {
            Caption = 'Warning Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Warning), "Flow Buffer Entry No." = field("Entry No.")));
        }
        field(22; "Error Count"; Integer)
        {
            Caption = 'Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Flow Entry No." = field("Flow Entry No."), "Flow Buffer Entry No." = field("Entry No."), "Info Type" = const(Error)));
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
            Caption = 'Linked Record';
            DataClassification = CustomerContent;
        }

        field(1000; "Tech. Logical ID"; Text[250])
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
        field(1070; "Doc. Type"; Text[50])
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(1080; "Doc. ID"; Text[50])
        {
            Caption = 'Doc. ID';
            DataClassification = CustomerContent;
        }
        field(1090; "Alt. Doc. ID"; Text[50])
        {
            Caption = 'Alt. Doc. ID';
            DataClassification = CustomerContent;
        }
        field(1100; "ETA Raw"; Text[50])
        {
            Caption = 'ETA Raw';
            DataClassification = CustomerContent;
        }
        field(1110; ETA; Date)
        {
            Caption = 'ETA';
            DataClassification = CustomerContent;
        }
        field(1120; "SRD Raw"; Text[50])
        {
            Caption = 'SRD Raw';
            DataClassification = CustomerContent;
        }
        field(1130; SRD; Date)
        {
            Caption = 'SRD';
            DataClassification = CustomerContent;
        }
        field(1140; "Ship. From"; Text[50])
        {
            Caption = 'Ship. From';
            DataClassification = CustomerContent;
        }

        field(1150; "Arrival Port"; Text[50])
        {
            Caption = 'Arrival Port';
            DataClassification = CustomerContent;
        }
        field(1160; "Container ID"; Text[50])
        {
            Caption = 'Container ID';
            DataClassification = CustomerContent;
        }
        field(1165; "Container ID Raw"; Text[50])
        {
            Caption = 'Container ID Raw';
            DataClassification = CustomerContent;
        }

        field(1170; "AL No."; Text[50])
        {
            Caption = 'AL No.';
            DataClassification = CustomerContent;
        }
        field(1171; "AL No. Raw"; Text[50])
        {
            Caption = 'AL No. Raw';
            DataClassification = CustomerContent;
        }
        field(1180; "AL Line No."; Text[50])
        {
            Caption = 'AL Line No.';
            DataClassification = CustomerContent;
        }
        field(1190; CAI; Text[20])
        {
            Caption = 'CAI';
            DataClassification = CustomerContent;
        }
        field(1200; CCI; Text[20])
        {
            Caption = 'CCI';
            DataClassification = CustomerContent;
        }
        field(1210; CST; Text[20])
        {
            Caption = 'CST';
            DataClassification = CustomerContent;
        }
        field(1220; CCID; Text[20])
        {
            Caption = 'CCID';
            DataClassification = CustomerContent;
        }
        field(1230; "Market Code"; Text[20])
        {
            Caption = 'Market Code';
            DataClassification = CustomerContent;
        }
        field(1240; "Seal Number"; Text[50])
        {
            Caption = 'Seal Number';
            DataClassification = CustomerContent;
        }
        field(1250; "Quantity Raw"; Text[20])
        {
            Caption = 'Quantity Raw';
            DataClassification = CustomerContent;
        }
        field(1260; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }

        field(1270; "Actual Ship DateTime Raw"; Text[50])
        {
            Caption = 'Actual Ship DateTime Raw';
            DataClassification = CustomerContent;
        }

        field(1280; "Actual Ship DateTime"; DateTime)
        {
            Caption = 'Actual Ship DateTime';
            DataClassification = CustomerContent;
        }

        field(1290; "Country Code"; Text[20])
        {
            Caption = 'Country Code';
            DataClassification = CustomerContent;
        }
        field(1300; "Carrier Doc. No."; Text[50])
        {
            Caption = 'Carrier Doc. No.';
            DataClassification = CustomerContent;
        }

        field(1310; "ASN Line Number Raw"; Text[50])
        {
            Caption = 'ASN Line Number Raw';
            DataClassification = CustomerContent;
        }

        field(1320; "ASN Line Number"; Integer)
        {
            Caption = 'ASN Line Number';
            DataClassification = CustomerContent;
        }
        field(1330; "Maritime Air Company Name"; Text[50])
        {
            Caption = 'Maritime Air Company Name';
            DataClassification = CustomerContent;
        }
        field(1340; "Maritime Air Number"; Text[50])
        {
            Caption = 'Maritime Air Number';
            DataClassification = CustomerContent;
        }
        field(1350; "Ctry. ISO Code Of Orig. Manuf."; Text[20])
        {
            caption = 'Country ISO code of origin manufacturing';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
        }
    }

    keys
    {
        key(PK; "Flow Code", "Flow Entry No.", "Entry No.")
        {
            Clustered = true;
        }

        key(Key01; "Container ID", "Container ID Raw") { }
    }
}