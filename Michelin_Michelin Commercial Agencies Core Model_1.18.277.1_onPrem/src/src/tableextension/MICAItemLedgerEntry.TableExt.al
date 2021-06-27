tableextension 81360 "MICA Item Ledger Entry" extends "Item Ledger Entry" //MyTargetTableId
{
    fields
    {
        field(80640; "MICA User Item Type"; Code[10])
        {
            Caption = 'User Item Type';
            FieldClass = FlowField;
            CalcFormula = Lookup (item."MICA User Item Type" WHERE("No." = FIELD("Item No.")));
            Editable = false;
        }

        //Flow Export
        field(80860; "MICA Send Last Flow Entry No."; Integer)
        {
            Caption = 'Send Last Flow Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MICA Flow Entry";
        }
        field(80862; "MICA Send Last Flow Status"; Option)
        {
            Caption = 'Send Last Flow Status';
            DataClassification = CustomerContent;
            Editable = false;
            OptionMembers = "",Prepared,Sent;
            OptionCaption = ',Prepared,Sent';
        }
        field(80864; "MICA Send Last DateTime"; DateTime)
        {
            Caption = 'Send Last DateTime';
            Editable = false;
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80865; "MICA Send Last DateTime2"; DateTime)
        {
            Caption = 'Send Last DateTime';
            FieldClass = FlowField;
            CalcFormula = lookup ("MICA Flow Entry"."Sent Date Time" where("Entry No." = field("MICA Send Last Flow Entry No.")));
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80866; "MICA Send Last Info Count"; Integer)
        {
            Caption = 'Send Last Info Count';
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Information), "Flow Entry No." = field("MICA Send Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80867; "MICA Send Last Warning Count"; Integer)
        {
            Caption = 'Send Last Warning Count';
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Warning), "Flow Entry No." = field("MICA Send Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80868; "MICA Send Last Error Count"; Integer)
        {
            Caption = 'Send Last Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Error), "Flow Entry No." = field("MICA Send Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';

        }
        field(80869; "MICA Send Ack. Received"; Boolean)
        {
            Caption = 'Send Ack. Received';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(80870; "MICA Rcv. Last Flow Entry No."; Integer)
        {
            Caption = 'Receive Last Flow Entry No.';
            Editable = false;
            TableRelation = "MICA Flow Entry";
            DataClassification = CustomerContent;
        }
        field(80872; "MICA Receive Last Flow Status"; Option)
        {
            Caption = 'Receive Last Flow Status';
            DataClassification = CustomerContent;
            Editable = false;
            OptionMembers = "",Created,Received,Loaded,Processed,PostProcessed;
            OptionCaption = ',Created,Received,Loaded,Processed,PostProcessed';
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80873; "MICA Receive Last Flow Status2"; Option)
        {
            Caption = 'Receive Last Flow Status';
            Editable = false;
            OptionMembers = "",Created,Received,Loaded,Processed,PostProcessed;
            OptionCaption = ',Created,Received,Loaded,Processed,PostProcessed';
            FieldClass = FlowField;
            CalcFormula = lookup ("MICA Flow Entry"."Receive Status" where("Entry No." = field("MICA Rcv. Last Flow Entry No.")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80874; "MICA Receive Last DateTime"; DateTime)
        {
            Caption = 'Receive Last DateTime';
            DataClassification = CustomerContent;
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80875; "MICA Receive Last DateTime2"; DateTime)
        {
            Caption = 'Receive Last DateTime';
            FieldClass = FlowField;
            CalcFormula = lookup ("MICA Flow Entry"."Received Date Time" where("Entry No." = field("MICA Rcv. Last Flow Entry No.")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80876; "MICA Receive Last Info Count"; Integer)
        {
            Caption = 'Receive Last Info Count';
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Information), "Flow Entry No." = field("MICA Rcv. Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80877; "MICA Rcv. Last Warning Count"; Integer)
        {
            Caption = 'Receive Last Warning Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Warning), "Flow Entry No." = field("MICA Rcv. Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80878; "MICA Receive Last Error Count"; Integer)
        {
            Caption = 'Receive Last Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Error), "Flow Entry No." = field("MICA Rcv. Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80879; "MICA Record ID"; RecordId)
        {
            Caption = 'Record ID';
            DataClassification = CustomerContent;
        }
        //Flow end
        field(82200; "MICA Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            DataClassification = CustomerContent;
        }
    }
}