tableextension 80402 "MICA Sales Cr.Memo Line" extends "Sales Cr.Memo Line"
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
        field(83001; "MICA Rebate Pool Entry No."; Integer)
        {
            Caption = 'Rebate Pool Entry No.';
            DataClassification = CustomerContent;
        }
    }
}