tableextension 81121 "MICA Warehouse Receipt Header" extends "Warehouse Receipt Header"
{
    fields
    {
        field(81120; "MICA Return Order With Collect"; Boolean)
        {
            Caption = 'Return Order With Collect';
            DataClassification = CustomerContent;
        }
        field(81240; "MICA 3PL Error"; Boolean)
        {
            Caption = '3PL Error';
            DataClassification = CustomerContent;
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Non-compliant with interface monitoring features';
        }
        field(81211; "MICA 3PL Update Status"; Option)
        {
            Caption = '3PL Update Status';
            OptionMembers = " ","Receipt Confimation";
            OptionCaption = ' ,Receipt Confimation';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81212; "MICA 3PL Status Change Date"; Date)
        {
            Caption = '3PL Status Change Date';
            DataClassification = CustomerContent;
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Non-compliant with interface monitoring features';
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
            CalcFormula = lookup ("MICA Flow Entry"."Send Status" where("Entry No." = field("MICA Send Last Flow Entry No.")));
            Editable = false;
            //ObsoleteState = Removed;
        }
        field(80864; "MICA Send Last DateTime"; DateTime)
        {
            Caption = 'Send Last DateTime';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup ("MICA Flow Entry"."Sent Date Time" where("Entry No." = field("MICA Send Last Flow Entry No.")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80866; "MICA Send Last Info Count"; Integer)
        {
            Caption = 'Send Last Info Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Information),
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
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Warning),
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
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Error),
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

        field(81461; "MICA ETA"; Date)
        {
            Caption = 'ETA';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81462; "MICA Container ID"; Code[50])
        {
            Caption = 'Container ID';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81463; "MICA Seal No."; Code[20])
        {
            Caption = 'Seal No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81464; "MICA Port of Arrival"; Code[20])
        {
            Caption = 'Port of Arrival';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81465; "MICA Carrier Doc. No."; Code[20])
        {
            Caption = 'Carrier Doc. No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81466; "MICA Maritime Air Company Name"; Text[50])
        {
            Caption = 'Maritime Air Company Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81467; "MICA Maritime Air Number"; Text[50])
        {
            Caption = 'Maritime Air Number';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81307; "MICA SRD"; Date)
        {
            Caption = 'SRD';
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
            CalcFormula = lookup ("MICA Flow Entry"."Receive Status" where("Entry No." = field("MICA Rcv. Last Flow Entry No.")));
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80874; "MICA Receive Last DateTime"; DateTime)
        {
            Caption = 'Receive Last DateTime';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup ("MICA Flow Entry"."Received Date Time" where("Entry No." = field("MICA Rcv. Last Flow Entry No.")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80876; "MICA Receive Last Info Count"; Integer)
        {
            Caption = 'Receive Last Info Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Information),
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
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Warning),
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
            CalcFormula = count ("MICA Flow Information" where("Info Type" = const(Error),
                                                                "Flow Entry No." = field("MICA Rcv. Last Flow Entry No."),
                                                                "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(81570; "MICA Retrieve-From Address"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Retrieve-From Address';
            Editable = false;
            Description = 'Contains ship-to address where goods to return can be retrieved.';
        }

        field(81571; "MICA Retrieve-From Addr. Code"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Retrieve-From Address Code';
            Editable = false;
            Description = 'Contains ship-to address code where goods to return can be retrieved.';
        }
        field(81980; "MICA Status"; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            OptionMembers = "Open","Released";
            OptionCaption = 'Open,Released';
            Description = 'Status of warehouse receipt header';
            Editable = false;
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

    procedure NotClientTypeExcepted(): Boolean;
    begin
        if (CurrentClientType() = ClientType::Background)
            or (CurrentClientType() = ClientType::NAS)
            or (CurrentClientType() = ClientType::OData)
            or (CurrentClientType() = ClientType::SOAP)
            or (CurrentClientType() = ClientType::ODataV4)
            or (CurrentClientType() = ClientType::Api)
            then
            exit(false);
        exit(true);
    end;


}
