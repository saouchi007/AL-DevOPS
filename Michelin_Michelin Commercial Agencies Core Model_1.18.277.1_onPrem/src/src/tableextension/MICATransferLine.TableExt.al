tableextension 81463 "MICA Transfer Line" extends "Transfer Line"
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
            trigger OnValidate()
            var
                WhseRcptLn: Record "Warehouse Receipt Line";
            begin
                WhseRcptLn.SetRange("Source Type", Database::"Transfer Line");
                WhseRcptLn.SetRange("Source Subtype", 1);
                WhseRcptLn.SetRange("Source No.", "Document No.");
                WhseRcptLn.SetRange("Source Line No.", "Line No.");
                if WhseRcptLn.FindSet() then
                    repeat
                        WhseRcptLn.Validate("MICA SRD", "MICA SRD");
                        WhseRcptLn.Modify(true);
                    until WhseRcptLn.Next() = 0;
            end;
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
            trigger OnValidate()
            var
                WhseRcptLn: Record "Warehouse Receipt Line";
            begin
                WhseRcptLn.SetRange("Source Type", Database::"Transfer Line");
                WhseRcptLn.SetRange("Source Subtype", 1);
                WhseRcptLn.SetRange("Source No.", "Document No.");
                WhseRcptLn.SetRange("Source Line No.", "Line No.");
                if WhseRcptLn.FindSet() then
                    repeat
                        WhseRcptLn.Validate("MICA ETA", "MICA ETA");
                        WhseRcptLn.Modify(true);
                    until WhseRcptLn.Next() = 0;
            end;
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
            Caption = 'Initial ETA';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81469; "MICA Initial SRD"; Date)
        {
            Caption = 'Initial SRD';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81310; "MICA AL Line No."; Text[30])
        {
            Caption = 'AL Line No.';
            DataClassification = CustomerContent;
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
        field(81985; "MICA Ctry. ISO Code/O. Manuf."; code[10])
        {
            caption = 'Country ISO code of origin manufacturing';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
        }
        field(82100; "MICA Whse. Receipt No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Whse. Receipt No.';
            TableRelation = "Warehouse Receipt Header";
        }
        field(82360; "MICA DC14"; code[20])
        {
            Caption = 'DC14';
            DataClassification = CustomerContent;
        }
        field(82363; "MICA Ship From Vendor"; Code[20])
        {
            Caption = 'Ship From Vendor';
            DataClassification = CustomerContent;
        }
        field(82364; "MICA Shipment Line Num"; Integer)
        {
            Caption = 'Shipment Line Num';
            DataClassification = CustomerContent;
        }
        field(82365; "MICA Initial Shipment Date"; Date)
        {
            Caption = 'Initial Shipment Date';
            DataClassification = CustomerContent;
        }
    }
}