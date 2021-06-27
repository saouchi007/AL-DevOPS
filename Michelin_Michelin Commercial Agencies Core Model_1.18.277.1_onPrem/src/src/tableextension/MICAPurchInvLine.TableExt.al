tableextension 81150 "MICA Purch. Inv. Line" extends "Purch. Inv. Line"
{
    fields
    {
        //Flow Export
        field(80860; "MICA Flow Entry No."; Integer)
        {
            Caption = 'Flow Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MICA Flow Entry";
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80861; "MICA Flow Record Entry No."; Integer)
        {
            Caption = 'Flow Record Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MICA Flow Record";
        }
        field(80862; "MICA Send Last Flow Status"; Option)
        {
            Caption = 'Send Last Flow Status';
            DataClassification = CustomerContent;
            Editable = false;
            OptionMembers = "",Prepared,Sent;
            OptionCaption = ',Prepared,Sent';
        }
        field(80863; "MICA Send Last Flow Entry No."; Integer)
        {
            Caption = 'Send Last Flow Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MICA Flow Entry";
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
        //Flow end
        field(81309; "MICA AL No."; Code[35])
        {
            Caption = 'AL No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(81310; "MICA AL Line No."; Text[30])
        {
            Caption = 'AL Line No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(81311; "MICA SRD"; Date)
        {
            Caption = 'SRD';
            DataClassification = CustomerContent;
        }
        field(81312; "MICA Location-To Code"; Code[10])
        {
            Caption = 'Location-To Code';
            DataClassification = CustomerContent;
            TableRelation = Location where("Use As In-Transit" = filter(false));
        }

        field(81460; "MICA ASN No."; Code[35])
        {
            Caption = 'ASN No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81470; "MICA ASN Line No."; Integer)
        {
            Caption = 'ASN Line No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81471; "MICA Country of Origin"; Code[10])
        {
            Caption = 'Country of Origin';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Country/Region";
        }
        field(81985; "MICA Ctry. ISO Code/O. Manuf."; code[10])
        {
            caption = 'Country ISO code of origin manufacturing';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Country/Region";
        }
        field(82020; "MICA GIS Document Line No."; Integer)
        {
            Caption = 'GIS Document Line No.';
            Description = 'GIS Document Line No.';
            DataClassification = CustomerContent;
            Editable = false;
            BlankNumbers = BlankZero;
        }

        field(82021; "MICA GIS Freight Doc. Line No."; Integer)
        {
            Caption = 'GIS Freight Doc. Line No.';
            Description = 'GIS Freight Doc. Line No.';
            DataClassification = CustomerContent;
            Editable = false;
            BlankNumbers = BlankZero;
        }
        field(82022; "MICA GIS Dest. Country Code"; Code[10])
        {
            Caption = 'GIS Destination Country Code';
            Description = 'GIS Destination Country Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82023; "MICA GIS Country of Origin"; Code[10])
        {
            Caption = 'GIS Country of Origin';
            Description = 'GIS Country of Origin';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82024; "MICA GIS Region of Origin"; Code[10])
        {
            Caption = 'GIS Region of Origin';
            Description = 'GIS Region of Origin';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82025; "MICA GIS Delivery Terms"; Code[10])
        {
            Caption = 'GIS Delivery Terms';
            Description = 'GIS Delivery Terms';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82026; "MICA GIS Commodity Code"; Text[30])
        {
            Caption = 'GIS Commodity Code';
            Description = 'GIS Commodity Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82027; "MICA GIS Net Mass"; Decimal)
        {
            Caption = 'GIS Net Mass';
            Description = 'GIS Net Mass';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82028; "MICA GIS Supplementary Units"; Text[30])
        {
            Caption = 'GIS Supplementary Units';
            Description = 'GIS Supplementary Units';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82029; "MICA GIS Mode of Transport"; Text[30])
        {
            Caption = 'GIS Mode of Transport';
            Description = 'GIS Mode of Transport';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82030; "MICA Freight Line No."; Text[10])
        {
            Caption = 'Freight Line No.';
            Description = 'Freight Line No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82031; "MICA GIS Loading Port"; Code[20])
        {
            Caption = 'GIS Loading Port';
            Description = 'GIS Loading Port';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82032; "MICA GIS Statistic Procedure"; Text[30])
        {
            Caption = 'GIS Statistic Procedure';
            Description = 'GIS Statistic Procedure';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82033; "MICA GIS Statistical Value"; Text[30])
        {
            Caption = 'GIS Statistical Value';
            Description = 'GIS Statistical Value';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82034; "MICA GIS Country of Manuf."; Code[20])
        {
            Caption = 'GIS Country of Manufacture';
            Description = 'GIS Country of Manufacture';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82035; "MICA GIS Container No."; Code[50])
        {
            Caption = 'GIS Container No.';
            Description = 'GIS Container No.';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(82036; "MICA GIS Contrib. PO Shpt No."; Code[30])
        {
            Caption = 'GIS Contributor PO Shipment No.';
            Description = 'GIS Contributor PO Shipment No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82360; "MICA DC14"; code[20])
        {
            Caption = 'DC14';
            DataClassification = CustomerContent;
        }
    }
}