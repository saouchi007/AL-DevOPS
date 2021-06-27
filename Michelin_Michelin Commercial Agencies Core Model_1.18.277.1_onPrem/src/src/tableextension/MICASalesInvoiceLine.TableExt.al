tableextension 80401 "MICA Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        field(80400; "MICA Countermark"; Text[250])
        {
            Caption = 'Countermark';
            DataClassification = CustomerContent;
        }
        field(80420; "MICA Webshop Comment"; Text[250])
        {
            Caption = 'Webshop Comment';
            DataClassification = CustomerContent;
            ObsoleteState = Pending;
            ObsoleteReason = 'MICA Countermark is used for Webshop comment';
        }
        field(80960; "MICA 3PL Whse Shpt. Comment"; Text[50])
        {
            Caption = '3PL Warehouse Shipment Comment';
            DataClassification = CustomerContent;
            Description = 'Comment for 3PL system';
        }
        field(81194; "MICA 3PL Country Of Origin"; Code[2])
        {
            Caption = '3PL Country Of Origin';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81195; "MICA 3PL DOT Value"; Code[10])
        {
            Caption = '3PL DOT Value';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81800; "MICA Product Type Code"; Code[2])
        {
            Caption = 'Product Type Code';
            DataClassification = CustomerContent;
        }
        field(81822; "MICA Inv. Discrepancy"; Boolean)
        {
            Caption = 'Inv. Discrepancy';
            DataClassification = CustomerContent;
        }

        field(82941; "MICA Whse Ship. No."; code[20])
        {
            Caption = 'Whse Shipment No.';
            DataClassification = CustomerContent;
        }
        field(82942; "MICA Whse Ship. Line No."; Integer)
        {
            Caption = 'Whse Shipment Line No.';
            DataClassification = CustomerContent;
        }
    }
}