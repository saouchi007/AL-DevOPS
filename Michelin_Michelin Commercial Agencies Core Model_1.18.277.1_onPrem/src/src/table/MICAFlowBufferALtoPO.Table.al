table 81261 "MICA Flow Buffer AL to PO"
{

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
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Information), "Flow Buffer Entry No." = field("Entry No.")));
        }
        field(21; "Warning Count"; Integer)
        {
            Caption = 'Warning Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Warning), "Flow Buffer Entry No." = field("Entry No.")));
        }
        field(22; "Error Count"; Integer)
        {
            Caption = 'Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Flow Entry No." = field("Flow Entry No."), "Flow Buffer Entry No." = field("Entry No."), "Info Type" = const(Error)));
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

        // Technical Fields
        field(500; "Logical Id"; code[35])
        {
            Caption = 'Logical Id';
            DataClassification = CustomerContent;
        }
        field(510; "Component Id"; code[250])
        {
            Caption = 'Component Id';
            DataClassification = CustomerContent;
        }
        field(520; "Task Id"; code[35])
        {
            Caption = 'Task Id';
            DataClassification = CustomerContent;
        }
        field(530; "Reference Id"; code[35])
        {
            Caption = 'Reference Id';
            DataClassification = CustomerContent;
        }
        field(540; "Creation Date Time Raw"; Text[250])
        {
            Caption = 'Creation Date Time Raw';
            DataClassification = CustomerContent;
        }
        field(545; "Creation Date Time"; DateTime)
        {
            Caption = 'Creation Date Time';
            DataClassification = CustomerContent;
        }
        field(550; "Native Id"; code[35])
        {
            Caption = 'Native Id';
            DataClassification = CustomerContent;
        }
        // Message Fields
        field(1010; "Document Reference"; code[35])
        {
            Caption = 'Document Reference';
            DataClassification = CustomerContent;
        }
        field(1020; "Document Date Time Raw"; Text[250])
        {
            Caption = 'Document Date Time Raw';
            DataClassification = CustomerContent;
        }
        field(1030; "Document Date Time"; DateTime)
        {
            Caption = 'Document Date Time';
            DataClassification = CustomerContent;
        }
        field(1050; "Buy-From Vendor"; code[20])
        {
            Caption = 'Buy-From Vendor';
            DataClassification = CustomerContent;

        }
        field(1060; "Order Date Time Raw"; Text[250])
        {
            Caption = 'Order Date Time Raw';
            DataClassification = CustomerContent;
        }
        field(1070; "Order Date Time"; DateTime)
        {
            Caption = 'Order Date Time';
            DataClassification = CustomerContent;
        }
        field(1080; "Vendor Order Number"; code[35])
        {
            Caption = 'Vendor Order Number';
            DataClassification = CustomerContent;
        }
        field(1090; "Shipment Method Code"; code[10])
        {
            Caption = 'Shipment Method Code';
            DataClassification = CustomerContent;
        }
        field(1092; "Shipment Instructions"; Text[20])
        {
            Caption = 'Shipment Instructions';
            DataClassification = CustomerContent;
        }
        field(1100; Location; code[10])
        {
            Caption = 'Location';
            DataClassification = CustomerContent;
        }
        field(1110; "Pay-To"; code[20])
        {
            Caption = 'Pay-To';
            DataClassification = CustomerContent;
        }
        field(1120; "Requested Receipt Date Raw"; Text[250])
        {
            Caption = 'Requested Receipt Date Raw';
            DataClassification = CustomerContent;

        }
        field(1130; "Requested Receipt Date"; Date)
        {
            Caption = 'Requested Receipt Date';
            DataClassification = CustomerContent;
        }
        field(1140; "AL Line Number"; text[30])
        {
            Caption = 'AL Line Number';
            DataClassification = CustomerContent;
        }
        field(1150; CAD; code[20])
        {
            Caption = 'CAD';
            DataClassification = CustomerContent;
        }
        field(1160; "Quantity Raw"; Text[100])
        {
            Caption = 'Quantity Raw';
            DataClassification = CustomerContent;
        }
        field(1170; Quantity; Integer)
        {
            Caption = '';
            DataClassification = CustomerContent;
        }
        field(82360; "Ship From Vendor"; Code[20])
        {
            Caption = 'Ship From Vendor';
            DataClassification = CustomerContent;
        }
        field(82361; "MICA DC14"; code[20])
        {
            Caption = 'DC14';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; "Flow Code", "Flow Entry No.", "Entry No.")
        {
            Clustered = true;
        }

        key(KEY1; "Document Reference", "AL Line Number")
        {

        }
    }

}