table 80873 "MICA MyExampleTable"
{
    DataClassification = ToBeClassified;
    ObsoleteState = Removed;
    ObsoleteReason = 'Deleted';
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(11; "Inventory Posting Group"; Code[20])
        {
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
            DataClassification = CustomerContent;
        }
        field(21; "Costing Method"; Option)
        {
            Caption = 'Costing Method';
            OptionMembers = FIFO,LIFO,Specific,Average,Standard;
            OptionCaption = 'FIFO,LIFO,Specific,Average,Standard';
            DataClassification = CustomerContent;
        }
        field(22; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            DataClassification = CustomerContent;
        }
        field(29; "Cost Is Adjusted"; Boolean)
        {
            Caption = 'Cost Is Adjusted';
            DataClassification = CustomerContent;
        }
        field(33; "Lead Time Calculation"; DateFormula)
        {
            Caption = 'Lead Time Calculation';
            DataClassification = CustomerContent;
        }
        field(61; "Last Date Time Modified"; DateTime)
        {
            Caption = 'Last Date Time Modified';
            DataClassification = CustomerContent;
        }
        field(62; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            DataClassification = CustomerContent;
        }
        field(63; "Last Time Modified"; Time)
        {
            Caption = 'Last Time Modified';
            DataClassification = CustomerContent;
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
            CalcFormula = lookup ("MICA Flow Entry"."Sent Date Time" where("Entry No." = field("MICA Send Last Flow Entry No.")));
            Editable = false;
        }
        field(80866; "MICA Send Last Info Count"; Integer)
        {
            Caption = 'Send Last Info Count';
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Information), "Flow Entry No." = field("MICA Send Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
        }
        field(80867; "MICA Send Last Warning Count"; Integer)
        {
            Caption = 'Send Last Warning Count';
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Warning), "Flow Entry No." = field("MICA Send Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
        }
        field(80868; "MICA Send Last Error Count"; Integer)
        {
            Caption = 'Send Last Error Count';
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Error), "Flow Entry No." = field("MICA Send Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
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
            CalcFormula = lookup ("MICA Flow Entry"."Receive Status" where("Entry No." = field("MICA Rcv. Last Flow Entry No.")));
            Editable = false;
        }
        field(80874; "MICA Receive Last DateTime"; DateTime)
        {
            Caption = 'Receive Last DateTime ';
            FieldClass = FlowField;
            CalcFormula = lookup ("MICA Flow Entry"."Received Date Time" where("Entry No." = field("MICA Rcv. Last Flow Entry No.")));
            Editable = false;
        }
        field(80876; "MICA Receive Last Info Count"; Integer)
        {
            Caption = 'Receive Last Info Count';
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Information), "Flow Entry No." = field("MICA Rcv. Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
        }
        field(80877; "MICA Rcv. Last Warning Count"; Integer)
        {
            Caption = 'Receive Last Warning Count';
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Warning), "Flow Entry No." = field("MICA Rcv. Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
        }
        field(80878; "MICA Receive Last Error Count"; Integer)
        {
            Caption = 'Receive Last Error Count';
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Error), "Flow Entry No." = field("MICA Rcv. Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
        }
        field(80789; "MICA Record ID"; RecordId)
        {
            Caption = 'Record ID';
            DataClassification = CustomerContent;
            Editable = false;
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