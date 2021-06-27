tableextension 81100 "MICA Warehouse Shipment Header" extends "Warehouse Shipment Header"
{
    fields
    {
        field(81100; "MICA Customer Transport"; Boolean)
        {
            Caption = 'Customer Transport';
            DataClassification = CustomerContent;
        }
        field(81060; "MICA Ship-to Address"; Text[100])
        {
            Caption = 'Ship-to Address';
            DataClassification = CustomerContent;

        }
        field(81061; "MICA Ship to City"; Text[30])
        {
            Caption = 'Ship to City';
            DataClassification = CustomerContent;

        }
        field(81062; "MICA Ship to Name"; Text[100])
        {
            Caption = 'Ship to Name';
            DataClassification = CustomerContent;

        }
        field(81063; "MICA Ship to code"; Code[10])
        {
            Caption = 'Ship to code';
            DataClassification = CustomerContent;
        }
        field(81220; "MICA 3PL Error"; Boolean)
        {
            Caption = '3PL Error';
            DataClassification = CustomerContent;
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Non-compliant with interface monitoring features';
        }
        field(80978; "MICA 3PL Export Status"; Option)
        {
            Caption = '3PL Export Status';
            OptionMembers = " ",Created,Prepared,Sent;
            OptionCaption = ' ,Created,Prepared,Sent';
            DataClassification = CustomerContent;
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Non-compliant with interface monitoring features';
        }
        field(81191; "MICA 3PL Update Status"; Option)
        {
            Caption = '3PL Update Status';
            OptionMembers = " ","Shipped Confimation";
            OptionCaption = ' ,Shipped Confimation';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81192; "MICA 3PL Status Change Date"; Date)
        {
            Caption = '3PL Status Change Date';
            DataClassification = CustomerContent;
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Non-compliant with interface monitoring features';
        }

        field(81620; "MICA Shipment Date in SO"; Date)
        {
            Caption = 'Shipment Date in SO';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Warehouse Shipment Line"."MICA Shipment Date in SO" where("No." = field("No.")));
        }
        field(81621; "MICA Planed Shipm. Date in SO"; Date)
        {
            Caption = 'Planned Shipment Date in SO';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Warehouse Shipment Line"."MICA Planed Shipm. Date in SO" where("No." = field("No.")));
        }
        field(81622; "MICA Planned Deliv. Date in SO"; Date)
        {
            Caption = 'Planned Delivery Date in SO';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Warehouse Shipment Line"."MICA Planned Deliv. Date in SO" where("No." = field("No.")));
        }
        field(81623; "MICA Skip 3PL Message"; Boolean)
        {
            Caption = 'Skip 3PL Message';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81624; "MICA Truck Driver Info"; Text[50])
        {
            Caption = 'Truck Driver Info';
            DataClassification = CustomerContent;
        }
        field(81625; "MICA Truck License Plate"; Text[50])
        {
            Caption = 'Truck License Plate';
            DataClassification = CustomerContent;
        }

        //Flow 
        field(80879; "MICA Record ID"; RecordId)
        {
            Caption = 'Record ID';
            Editable = false;
            DataClassification = CustomerContent;
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
            OptionMembers = " ",Prepared,Sent;
            OptionCaption = ' ,Prepared,Sent';
            FieldClass = FlowField;
            CalcFormula = lookup("MICA Flow Entry"."Send Status" where("Entry No." = field("MICA Send Last Flow Entry No.")));
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80864; "MICA Send Last DateTime"; DateTime)
        {
            Caption = 'Send Last DateTime';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("MICA Flow Entry"."Sent Date Time" where("Entry No." = field("MICA Send Last Flow Entry No.")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80866; "MICA Send Last Info Count"; Integer)
        {
            Caption = 'Send Last Info Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Information),
                                                                "Flow Entry No." = field("MICA Send Last Flow Entry No."),
                                                                "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80867; "MICA Send Last Warning Count"; Integer)
        {
            Caption = 'Send Last Warning Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Warning),
                                                                "Flow Entry No." = field("MICA Send Last Flow Entry No."),
                                                                "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80868; "MICA Send Last Error Count"; Integer)
        {
            Caption = 'Send Last Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Error),
                                                                "Flow Entry No." = field("MICA Send Last Flow Entry No."),
                                                                "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80869; "MICA Send Ack. Received"; Boolean)
        {
            Caption = 'Send Ack. Received';
            Editable = false;
            DataClassification = CustomerContent;
        }

        //Flow Receive
        field(80870; "MICA Rcv. Last Flow Entry No."; Integer)
        {
            Caption = 'Receive Last Flow Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MICA Flow Entry";
        }
        field(80872; "MICA Receive Last Flow Status"; Option)
        {
            Caption = 'Receive Last Flow Status';
            OptionMembers = " ",Created,Received,Loaded,Processed,PostProcessed;
            OptionCaption = ' ,Created,Received,Loaded,Processed,PostProcessed';
            FieldClass = FlowField;
            CalcFormula = lookup("MICA Flow Entry"."Receive Status" where("Entry No." = field("MICA Rcv. Last Flow Entry No.")));
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80874; "MICA Receive Last DateTime"; DateTime)
        {
            Caption = 'Receive Last DateTime';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("MICA Flow Entry"."Received Date Time" where("Entry No." = field("MICA Rcv. Last Flow Entry No.")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80876; "MICA Receive Last Info Count"; Integer)
        {
            Caption = 'Receive Last Info Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Information),
                                                                "Flow Entry No." = field("MICA Rcv. Last Flow Entry No."),
                                                                "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80877; "MICA Rcv. Last Warning Count"; Integer)
        {
            Caption = 'Receive Last Warning Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Warning),
                                                                "Flow Entry No." = field("MICA Rcv. Last Flow Entry No."),
                                                                "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80878; "MICA Receive Last Error Count"; Integer)
        {
            Caption = 'Receive Last Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Error),
                                                                "Flow Entry No." = field("MICA Rcv. Last Flow Entry No."),
                                                                "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(82460; "MICA Shipping Advice"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Shipping Advice';
            Editable = false;
            OptionCaption = 'Partial,Complete';
            OptionMembers = Partial,Complete;
        }
    }
    trigger OnInsert()
    begin
        "MICA Record ID" := RecordId();
    end;

    trigger OnRename()
    begin
        "MICA Record ID" := RecordId();
    end;
}