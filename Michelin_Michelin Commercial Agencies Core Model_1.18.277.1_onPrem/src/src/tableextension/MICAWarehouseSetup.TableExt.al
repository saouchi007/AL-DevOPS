tableextension 81220 "MICA Warehouse Setup" extends "Warehouse Setup"
{
    fields
    {
        field(80960; "MICA 3PL Pick Req. FlowCode"; Code[20])
        {
            Caption = '3PL Pick Request Flow Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow";
        }

        field(81190; "MICA 3PL Shp. Conf. Flow Code"; Code[20])
        {
            Caption = '3PL Shipped Confirmation Flow Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow";
        }

        field(81210; "MICA 3PL Recv. Conf. Flow Code"; Code[20])
        {
            Caption = '3PL Received Confirmation Flow Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow";
        }

        field(81220; "MICA 3PL Pick Ack. Flow Code"; Code[20])
        {
            Caption = '3PL Pick Request Ack. Flow Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow";
        }
        field(81222; "MICA 3PLAck.File maximum delay"; Integer)
        {
            Caption = '3PL Pick Request Ack. File maximum delay';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(81223; "MICA 3PL Pick Ack. MaxDelay"; Integer)
        {
            Caption = '3PL Shipment Pick Ack. Maximum Delay min.';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(81240; "MICA 3PL Receipt Ack. FlowCode"; Code[20])
        {
            Caption = '3PL Receipt Receive Instruction Ack. Flow Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow";
        }
        field(81242; "MICA 3PL Receipt Ack. MaxDelay"; Integer)
        {
            Caption = '3PL Receipt Receive Ack. File Maximum Delay min.';
            DataClassification = CustomerContent;
            MinValue = 0;
        }

        field(81980; "MICA 3PL Rec. instr. flow code"; Code[20])
        {
            Caption = '3PL Receive instruction flow code';
            Description = '3PL Receive instruction flow code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow".Code;
        }
        field(81420; "MICA 3PL Transp.Event FlowCode"; Code[20])
        {
            Caption = '3PL Transport Event FlowCode';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow";
            Description = 'ITG-003: Transport event message integration';
        }
        field(81960; "MICA Received Ack. Flow Code"; Code[20])
        {
            Caption = 'Received Acknowledge Flow Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow".Code;
        }
        field(82460; "MICA 3PL Weight UoM"; Code[10])
        {
            Caption = '3PL Weight UoM';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
        }
        field(82461; "MICA 3PL to PS9 Weight Factor"; Decimal)
        {
            Caption = '3PL to PS9 Weight Factor';
            DataClassification = CustomerContent;
        }
        field(82462; "MICA 3PL Volume UoM"; Code[10])
        {
            Caption = '3PL Volume UoM';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
        }
        field(82463; "MICA 3PL to PS9 Volume Factor"; Decimal)
        {
            Caption = '3PL to PS9 Volume Factor';
            DataClassification = CustomerContent;
        }
        field(82521; "MICA Acceptance Note"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Acceptance Note';
        }
        field(82522; "MICA Cross Reference Separator"; Text[5])
        {
            DataClassification = CustomerContent;
            Caption = 'Cross Reference Separator';
        }

    }
}