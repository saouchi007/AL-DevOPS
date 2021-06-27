table 82600 "MICA Flow Result"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(10; "MICA Record ID"; RecordId)
        {
            Caption = 'Linked Record ID';
            DataClassification = CustomerContent;
        }

        field(20; "MICA Send Last Flow Entry No."; Integer)
        {
            Caption = 'Send Last Flow Entry No.';
            Editable = false;
            TableRelation = "MICA Flow Entry";
            DataClassification = CustomerContent;
        }
        field(30; "MICA Rcv. Last Flow Entry No."; Integer)
        {
            Caption = 'Receive Last Flow Entry No.';
            Editable = false;
            TableRelation = "MICA Flow Entry";
            DataClassification = CustomerContent;
        }

        field(40; "MICA Send Last Info Count"; Integer)
        {
            Caption = 'Send Last Info Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where ("Info Type" = const (Information), "Flow Entry No." = field ("MICA Send Last Flow Entry No."), "Linked Record ID" = field ("MICA Record ID")));

        }

        field(50; "MICA Send Last Warning Count"; Integer)
        {
            Caption = 'Send Last Warning Count';
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where ("Info Type" = const (Warning), "Flow Entry No." = field ("MICA Send Last Flow Entry No."), "Linked Record ID" = field ("MICA Record ID")));
            Editable = false;
        }

        field(60; "MICA Send Last Error Count"; Integer)
        {
            Caption = 'Send Last Error Count';
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where ("Info Type" = const (Error), "Flow Entry No." = field ("MICA Send Last Flow Entry No."), "Linked Record ID" = field ("MICA Record ID")));
            Editable = false;
        }


        field(70; "MICA Send Last DateTime"; DateTime)
        {
            Caption = 'Send Last DateTime';
            FieldClass = FlowField;
            CalcFormula = lookup ("MICA Flow Entry"."Sent Date Time" where ("Entry No." = field ("MICA Send Last Flow Entry No.")));
            Editable = false;

        }
        field(80; "MICA Receive Last Flow Status"; Option)
        {
            Caption = 'Receive Last Flow Status';
            Editable = false;
            OptionMembers = "",Created,Received,Loaded,Processed,PostProcessed;
            OptionCaption = ',Created,Received,Loaded,Processed,PostProcessed';
            FieldClass = FlowField;
            CalcFormula = lookup ("MICA Flow Entry"."Receive Status" where ("Entry No." = field ("MICA Rcv. Last Flow Entry No.")));

        }
        field(90; "MICA Receive Last DateTime"; DateTime)
        {
            Caption = 'Receive Last DateTime';
            FieldClass = FlowField;
            CalcFormula = lookup ("MICA Flow Entry"."Received Date Time" where ("Entry No." = field ("MICA Rcv. Last Flow Entry No.")));
            Editable = false;
        }
        field(100; "MICA Receive Last Info Count"; Integer)
        {
            Caption = 'Receive Last Info Count';
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where ("Info Type" = const (Information), "Flow Entry No." = field ("MICA Rcv. Last Flow Entry No."), "Linked Record ID" = field ("MICA Record ID")));

        }
        field(110; "MICA Rcv. Last Warning Count"; Integer)
        {
            Caption = 'Receive Last Warning Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where ("Info Type" = const (Warning), "Flow Entry No." = field ("MICA Rcv. Last Flow Entry No."), "Linked Record ID" = field ("MICA Record ID")));

        }
        field(120; "MICA Receive Last Error Count"; Integer)
        {
            Caption = 'Receive Last Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where ("Info Type" = const (Error), "Flow Entry No." = field ("MICA Rcv. Last Flow Entry No."), "Linked Record ID" = field ("MICA Record ID")));

        }
        field(130; "MICA Send Last Flow Status"; Option)
        {
            Caption = 'Send Last Flow Status';
            OptionMembers = " ",Prepared,Sent;
            OptionCaption = ' ,Prepared,Sent';
            FieldClass = FlowField;
            CalcFormula = lookup ("MICA Flow Entry"."Send Status" where ("Entry No." = field ("MICA Send Last Flow Entry No.")));
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {

        }
    }


}