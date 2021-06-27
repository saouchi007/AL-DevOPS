tableextension 81464 "MICA Transfer Shipment Header" extends "Transfer Shipment Header"
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

        field(81460; "MICA ASN No."; Code[35])
        {
            Caption = 'ASN No.';
            DataClassification = CustomerContent;
            Editable = false;
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
        field(81466; "MICA ASN Date"; Date)
        {
            Caption = 'ASN Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81468; "MICA Initial ETA"; Date)
        {
            Caption = 'Inital ETA';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81469; "MICA Initial SRD"; Date)
        {
            Caption = 'Inital SRD';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81470; "MICA Maritime Air Company Name"; Text[50])
        {
            Caption = 'Maritime Air Company Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81471; "MICA Maritime Air Number"; Text[50])
        {
            Caption = 'Maritime Air Number';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81980; "MICA Action From Page"; Boolean)
        {
            Caption = 'Action From Page';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82800; "MICA Vendor Order No."; Code[35])
        {
            Caption = 'Vendor Order No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

}