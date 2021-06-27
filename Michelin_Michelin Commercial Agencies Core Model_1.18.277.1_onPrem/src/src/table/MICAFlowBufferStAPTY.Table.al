table 82840 "MICA Flow Buffer StA PTY"
{
    DataClassification = ToBeClassified;
    Caption = 'Flow Buffer Ship-to Address PTY';
    DrillDownPageId = "MICA Flow Buff. StP PTY List";
    LookupPageId = "MICA Flow Buff. StP PTY List";

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
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Information), "Flow Code" = field("Flow Code"), "Flow Buffer Entry No." = field("Entry No.")));
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


        field(100; "Ship-to Addr. Exec. DateTime"; DateTime)
        {
            Caption = 'Ship-to Address Execution DateTime';
            DataClassification = CustomerContent;
        }
        field(1000; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
        }
        field(1010; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(1020; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(1030; Address; Text[100])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(1040; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = CustomerContent;
        }
        field(1050; City; Text[30])
        {
            Caption = 'City';
            DataClassification = CustomerContent;
        }
        field(1060; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            DataClassification = CustomerContent;
        }
        field(1070; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            DataClassification = CustomerContent;
        }
        field(1080; "MICA Time Zone Raw"; Text[50])
        {
            Caption = 'MICA Time Zone Raw';
            DataClassification = CustomerContent;
        }
        field(1090; "MICA Time Zone"; Integer)
        {
            Caption = 'MICa Time Zone';
            DataClassification = CustomerContent;
        }
        field(1100; "MICA MDM ID"; Code[40])
        {
            Caption = 'MICA MDM ID';
            DataClassification = CustomerContent;
        }
        field(1110; "MICA Status Raw"; Text[50])
        {
            Caption = 'MICA Status Raw';
            DataClassification = CustomerContent;
        }
        field(1120; "MICA Status"; Option)
        {
            Caption = 'MICA Status';
            DataClassification = CustomerContent;
            OptionMembers = Active,Inactive;
        }
        field(1130; "MICA RPL Status"; Code[20])
        {
            Caption = 'MICA Restricted Site';
            DataClassification = CustomerContent;
        }
        field(1140; "MICA MDM Ship-to Use ID"; Code[20])
        {
            Caption = 'MICA MDM Ship-to Site Use ID';
            DataClassification = CustomerContent;
        }
        field(1150; "Ship-to Addr. Nos."; Code[20])
        {
            Caption = 'Ship-to Addr. Nos.';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; "Flow Code", "Flow Entry No.", "Entry No.")
        {
            Clustered = true;
        }
        key(Key1; "Flow Code", "Ship-to Addr. Exec. DateTime")
        {
            MaintainSqlIndex = true;
        }
    }

    trigger OnInsert()
    begin
        GetOrCreateNewFlowEntry();
        "Flow Code" := MICAFlowEntry."Flow Code";
        "Flow Entry No." := MICAFlowEntry."Entry No.";
        "Ship-to Addr. Exec. DateTime" := CurrentDateTime();
        "Entry No." := 1;
    end;

    local procedure GetOrCreateNewFlowEntry()
    var
        MICAFlow: Record "MICA Flow";
        ExistingMICAFlowBufferStAPTY: Record "MICA Flow Buffer StA PTY";
    begin
        MICAFlow.SetFilter(Code, '*SHIPTOADDR_PTY*');
        if MICAFlow.FindFirst() then begin
            ExistingMICAFlowBufferStAPTY.SetRange("Flow Code", MICAFlow.Code);
            ExistingMICAFlowBufferStAPTY.SetRange("Ship-to Addr. Exec. DateTime", "Ship-to Addr. Exec. DateTime");
            if ExistingMICAFlowBufferStAPTY.FindFirst() then
                MICAFlowEntry.Get(ExistingMICAFlowBufferStAPTY."Flow Entry No.")
            else
                MICAFlowEntry.Get(MICAFlow.CreateFlowEntry(MICAFlowEntry."Receive Status"::Loaded));
        end;
    end;

    var
        MICAFlowEntry: Record "MICA Flow Entry";

}