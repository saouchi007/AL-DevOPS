tableextension 81420 "MICA Posted Whse. Receipt Line" extends "Posted Whse. Receipt Line"
{
    fields
    {
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

        field(81306; "MICA AL No."; Code[35])
        {
            Caption = 'AL No.';
            DataClassification = CustomerContent;
        }
        field(81310; "MICA AL Line No."; Text[30])
        {
            Caption = 'AL Line No.';
            DataClassification = CustomerContent;
        }

        field(81434; "MICA Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Purchase Header"."No." where ("Document Type" = filter (Order));
        }

        field(81435; "MICA Purchase Order Line No."; Integer)
        {
            Caption = 'Purchase Order Line No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Purchase Line"."Line No." where ("Document Type" = filter (Order), "Document No." = field ("MICA Purchase Order No."));
        }

        field(81462; "MICA Container ID"; Code[50])
        {
            Caption = 'Container ID';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(81461; "MICA ETA"; Date)
        {
            Caption = 'ETA';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(81307; "MICA SRD"; Date)
        {
            Caption = 'SRD';
            DataClassification = CustomerContent;
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

        field(81213; "MICA 3PL Qty. To Receive"; Decimal)
        {
            Caption = '3PL Qty. To Receive';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

}