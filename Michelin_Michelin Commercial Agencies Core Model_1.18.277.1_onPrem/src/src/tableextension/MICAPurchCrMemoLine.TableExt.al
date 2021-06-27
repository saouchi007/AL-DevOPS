tableextension 81266 "MICA Purch. Cr. Memo Line" extends "Purch. Cr. Memo Line"
{
    fields
    {
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
            TableRelation = Location where ("Use As In-Transit" = filter (false));
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
    }

}