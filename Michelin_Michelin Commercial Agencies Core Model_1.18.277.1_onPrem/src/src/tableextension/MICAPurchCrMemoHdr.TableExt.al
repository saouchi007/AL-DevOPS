tableextension 81262 "MICA Purch. Cr. Memo Hdr." extends "Purch. Cr. Memo Hdr." //TargetTableId
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
            TableRelation = Location where ("Use As In-Transit" = filter (false));
        }

        field(81260; "MICA Purch. Doc. Creation DT"; DateTime)
        {
            Caption = 'Purchase Document Creation Date/time';
            DataClassification = CustomerContent;
            Editable = false;
        }

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
