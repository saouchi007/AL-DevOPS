table 80875 "MICA Sample Data"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "MICA Sample Data List";

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
            NotBlank = true;
        }
        field(3; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(11; "Inventory Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }
        field(21; "Costing Method"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Costing Method';
            OptionMembers = FIFO,LIFO,Specific,Average,Standard;
            OptionCaption = 'FIFO,LIFO,Specific,Average,Standard';
        }
        field(22; "Unit Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Unit Cost';
        }
        field(29; "Cost Is Adjusted"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Cost Is Adjusted';
        }
        field(33; "Lead Time Calculation"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Lead Time Calculation';
        }
        field(61; "Last Date Time Modified"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Last Date Time Modified';
        }
        field(62; "Last Date Modified"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Last Date Modified';
        }
        field(63; "Last Time Modified"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Last Time Modified';
        }
        field(80860; "MICA Send Last Flow Entry No."; Integer)
        {
            Caption = 'Send Last Flow Entry No.';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow Entry";
            Editable = false;
        }
        field(80862; "MICA Send Last Flow Status"; Option)
        {
            Caption = 'Send Last Flow Status';
            OptionMembers = " ",Prepared,Sent;
            OptionCaption = ' ,Prepared,Sent';
            DataClassification = CustomerContent; //TODO
            //FieldClass = FlowField;
            //CalcFormula = lookup ("MICA Flow Entry"."Send Status" where ("Entry No." = field ("MICA Send Last Flow Entry No.")));
            Editable = true; //TODO
        }
        field(80864; "MICA Send Last DateTime"; DateTime)
        {
            Caption = 'Send Last DateTime ';
            FieldClass = FlowField;
            CalcFormula = lookup ("MICA Flow Entry"."Sent Date Time" where ("Entry No." = field ("MICA Send Last Flow Entry No.")));
            Editable = false;
        }
        field(80866; "MICA Send Last Info Count"; Integer)
        {
            Caption = 'Send Last Info Count';
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where ("Info Type" = const (Information), "Flow Entry No." = field ("MICA Send Last Flow Entry No."), "Linked Record ID" = field ("MICA Record ID")));
        }
        field(80867; "MICA Send Last Warning Count"; Integer)
        {
            Caption = 'Send Last Warning Count';
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where ("Info Type" = const (Warning), "Flow Entry No." = field ("MICA Send Last Flow Entry No."), "Linked Record ID" = field ("MICA Record ID")));
        }
        field(80868; "MICA Send Last Error Count"; Integer)
        {
            Caption = 'Send Last Error Count';
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where ("Info Type" = const (Error), "Flow Entry No." = field ("MICA Send Last Flow Entry No."), "Linked Record ID" = field ("MICA Record ID")));
        }
        field(80870; "MICA Rcv. Last Flow Entry No."; Integer)
        {
            Caption = 'Receive Last Flow Entry No.';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow Entry";
            Editable = false;
        }
        field(80872; "MICA Receive Last Flow Status"; Option)
        {
            Caption = 'Receive Last Flow Status';
            OptionMembers = " ",Created,Received,Loaded,Processed,PostProcessed;
            OptionCaption = ' ,Created,Received,Loaded,Processed,PostProcessed';
            FieldClass = FlowField;
            CalcFormula = lookup ("MICA Flow Entry"."Receive Status" where ("Entry No." = field ("MICA Rcv. Last Flow Entry No.")));
            Editable = false;
        }
        field(80874; "MICA Receive Last DateTime"; DateTime)
        {
            Caption = 'Receive Last DateTime ';
            FieldClass = FlowField;
            CalcFormula = lookup ("MICA Flow Entry"."Received Date Time" where ("Entry No." = field ("MICA Rcv. Last Flow Entry No.")));
            Editable = false;
        }
        field(80876; "MICA Receive Last Info Count"; Integer)
        {
            Caption = 'Receive Last Info Count';
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where ("Info Type" = const (Information), "Flow Entry No." = field ("MICA Rcv. Last Flow Entry No."), "Linked Record ID" = field ("MICA Record ID")));
        }
        field(80877; "MICA Rcv. Last Warning Count"; Integer)
        {
            Caption = 'Receive Last Warning Count';
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where ("Info Type" = const (Warning), "Flow Entry No." = field ("MICA Rcv. Last Flow Entry No."), "Linked Record ID" = field ("MICA Record ID")));
        }
        field(80878; "MICA Receive Last Error Count"; Integer)
        {
            Caption = 'Receive Last Error Count';
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where ("Info Type" = const (Error), "Flow Entry No." = field ("MICA Rcv. Last Flow Entry No."), "Linked Record ID" = field ("MICA Record ID")));
        }
        field(80879; "MICA Record ID"; RecordId)
        {
            Caption = 'Record ID';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80880; SubLineCount; Integer)
        {
            Caption = 'SubLines Count';
            FieldClass = FlowField;
            CalcFormula = Count ("MICA Sample Sub Line" WHERE ("Line No." = FIELD ("No.")));
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

}