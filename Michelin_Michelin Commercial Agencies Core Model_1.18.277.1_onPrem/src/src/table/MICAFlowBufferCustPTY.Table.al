table 82820 "MICA Flow Buffer Cust. PTY"
{
    Caption = 'Flow Buffer Customer PTY';
    DataClassification = ToBeClassified;
    DrillDownPageId = "MICA Flow Buff. Cust. PTY List";
    LookupPageId = "MICA Flow Buff. Cust. PTY List";

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
        field(100; "Cust. PTY Execution DateTime"; DateTime)
        {
            Caption = 'Customer PTY Execution DateTime';
            DataClassification = CustomerContent;
        }
        field(1000; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(1010; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(1020; Address; Text[100])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(1030; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = CustomerContent;
        }
        field(1040; City; Text[30])
        {
            Caption = 'City';
            DataClassification = CustomerContent;
        }
        field(1050; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
        }
        field(1060; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            DataClassification = CustomerContent;
        }
        field(1070; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            DataClassification = CustomerContent;
        }
        field(1080; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            DataClassification = CustomerContent;
        }
        field(1090; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
            DataClassification = CustomerContent;
        }
        field(1100; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            DataClassification = CustomerContent;
        }
        field(1110; County; Text[30])
        {
            Caption = 'County';
            DataClassification = CustomerContent;
        }
        field(1120; "MICA Type Raw"; Text[30])
        {
            Caption = 'MICA Type Raw';
            DataClassification = CustomerContent;
        }
        field(1130; "MICA Type"; Option)
        {
            Caption = 'MICA Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Direct,Indirect';
            OptionMembers = Direct,Indirect;
        }
        field(1140; "MICA Status Raw"; Text[30])
        {
            Caption = 'MICA Status Raw';
            DataClassification = CustomerContent;
        }
        field(1150; "MICA Status"; Option)
        {
            Caption = 'MICA Status';
            DataClassification = CustomerContent;
            OptionCaption = 'Active,Inactive';
            OptionMembers = Active,Inactive;
        }
        field(1160; "MICA Market Code"; Code[2])
        {
            Caption = 'MICA Market Code';
            DataClassification = CustomerContent;
        }
        field(1170; "MICA English Name"; Text[100])
        {
            Caption = 'MICA English Name';
            DataClassification = CustomerContent;
        }
        field(1180; "MICA Party Ownership Raw"; Text[20])
        {
            Caption = 'MICA Party Ownership Raw';
            DataClassification = CustomerContent;
        }
        field(1190; "MICA Party Ownership"; Option)
        {
            Caption = 'MICA Party Ownership';
            DataClassification = CustomerContent;
            OptionCaption = 'Non-Group,Group,Group Network,Internal';
            OptionMembers = "Non Group",Group,"Group Network",Internal;
        }
        field(1200; "MICA Channel"; Code[10])
        {
            Caption = 'MICA Channel';
            DataClassification = CustomerContent;
        }
        field(1210; "MICA Business Orientation"; Code[10])
        {
            Caption = 'MICA Business Orientation';
            DataClassification = CustomerContent;
        }
        field(1220; "MICA Partnership"; Code[10])
        {
            Caption = 'MICA Partnership';
            DataClassification = CustomerContent;
        }
        field(1230; "MICA MDM ID LE"; Code[40])
        {
            Caption = 'MICA MDM ID LE';
            DataClassification = CustomerContent;
        }
        field(1240; "MICA TimeZone Raw"; Text[20])
        {
            Caption = 'MICA TimeZone Raw';
            DataClassification = CustomerContent;
        }
        field(1250; "MICA TimeZone"; Integer)
        {
            Caption = 'MICA TimeZone';
            DataClassification = CustomerContent;
        }
        field(1260; "MICA MDM ID BT"; Code[40])
        {
            Caption = 'MICA MDM ID BT';
            DataClassification = CustomerContent;
        }
        field(1270; "MICA RPL Status"; Code[20])
        {
            Caption = 'MICA Restricted Site';
            DataClassification = CustomerContent;
        }
        field(1280; "MICA MDM Bill-to Site Use ID"; Code[20])
        {
            Caption = 'MICA MDM Bill-to Site Use ID';
            DataClassification = CustomerContent;
        }
        field(1290; "MICA Customer Type Raw"; Text[20])
        {
            Caption = 'MICA Customer Type Raw';
            DataClassification = CustomerContent;
        }
        field(1300; "MICA Segmentation"; Option)
        {
            Caption = 'MICA Segmentation';
            OptionMembers = DEALER,AVIATION,LEASER,OEM,PROF_END_USER;
            OptionCaption = 'DEALER,AVIATION,LEASER,OEM,PROF_END_USER';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Replaced by "MICA Segmentation Code" field';
        }
        field(1310; "MICA Segmentation Code"; Code[20])
        {
            Caption = 'Segmentation';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(CustSegment), Blocked = const(false));
        }
    }

    keys
    {
        key(PK; "Flow Code", "Flow Entry No.", "Entry No.")
        {
            Clustered = true;
        }
        key(Key1; "Flow Code", "Cust. PTY Execution DateTime")
        {
            MaintainSqlIndex = true;
        }
    }

    trigger OnInsert()
    begin
        GetOrCreateNewFlowEntry();
        "Flow Code" := MICAFlowEntry."Flow Code";
        "Flow Entry No." := MICAFlowEntry."Entry No.";
        "Cust. PTY Execution DateTime" := CurrentDateTime();
        "Entry No." := 1;
    end;

    local procedure GetOrCreateNewFlowEntry()
    var
        MICAFlow: Record "MICA Flow";
        ExistingMICAFlowBufferCustPTY: Record "MICA Flow Buffer Cust. PTY";
    begin
        MICAFlow.SetFilter(Code, '*CUSTOMER_PTY*');
        if MICAFlow.FindFirst() then begin
            ExistingMICAFlowBufferCustPTY.SetRange("Flow Code", MICAFlow.Code);
            ExistingMICAFlowBufferCustPTY.SetRange("Cust. PTY Execution DateTime", "Cust. PTY Execution DateTime");
            if ExistingMICAFlowBufferCustPTY.FindFirst() then
                MICAFlowEntry.Get(ExistingMICAFlowBufferCustPTY."Flow Entry No.")
            else
                MICAFlowEntry.Get(MICAFlow.CreateFlowEntry(MICAFlowEntry."Receive Status"::Loaded));
        end;
    end;

    var
        MICAFlowEntry: Record "MICA Flow Entry";
}