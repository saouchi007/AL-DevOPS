tableextension 81261 "MICA Purch. Inv. Header" extends "Purch. Inv. Header" //MyTargetTableId
{
    fields
    {
        field(81306; "MICA AL No."; Code[35])
        {
            Caption = 'AL No.';
            DataClassification = CustomerContent;
        }
        field(81307; "MICA SRD"; Date)
        {
            Caption = 'SRD';
            DataClassification = CustomerContent;
        }
        field(81308; "MICA Location-To Code"; Code[10])
        {
            Caption = 'Location-To Code';
            DataClassification = CustomerContent;
            TableRelation = Location where("Use As In-Transit" = filter(false));
        }

        field(81260; "MICA Purch. Doc. Creation DT"; DateTime)
        {
            Caption = 'Purchase Document Creation Date/time';
            DataClassification = CustomerContent;
            Editable = false;
        }

        //Flow Send
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
        //Flow send

        field(82022; "MICA RELFAC Code"; Code[10])
        {
            Caption = 'GIS RELFAC Code';
            Description = 'RELFAC Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82023; "MICA Total Inv. Amt.(excl.VAT)"; Decimal)
        {
            Caption = 'GIS Total Invoice Amount (excluded VAT)';
            Description = 'GIS Total Invoice Amount (excluded VAT)';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(82024; "MICA GIS Invoice Doc. No."; Code[20])
        {
            Caption = 'GIS Original Invoice No.';
            Description = 'GIS Original Invoice No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82025; "MICA GIS Invoice Doc. Date"; Date)
        {
            Caption = 'GIS Original Invoice Date';
            Description = 'GIS Original Invoice Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82026; "MICA GIS Rebill Reason Code"; Text[30])
        {
            Caption = 'GIS Rebill Reason Code';
            Description = 'GIS Rebill Reason Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82027; "MICA GIS Ship-to Location"; Code[20])
        {
            Caption = 'GIS Ship-to Location';
            Description = 'GIS Ship-to Location';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82028; "MICA GIS Despatch Country"; Code[10])
        {
            Caption = 'GIS Despatch Country';
            Description = 'GIS Despatch Country';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82029; "MICA GIS DCN No."; Text[30])
        {
            Caption = 'GIS DCN No.';
            Description = 'GIS DCN No.';
            DataClassification = CustomerContent;
            Editable = false;
        }

    }

}
