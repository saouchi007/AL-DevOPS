table 82900 "MICA Off-Inv. Item Sel. Setup"
{
    Caption = 'Off-Invoice Item Selection Setup';
    DataClassification = CustomerContent;
    LookupPageId = "MICA Off-Inv. Item Sel. List";
    DrillDownPageId = "MICA Off-Inv. Item Sel. List";

    fields
    {
        field(1; "Item Discount Group Code"; Code[20])
        {
            Caption = 'Item Discount Group Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Discount Group";

        }
        field(2; "Item Code"; Code[1024])
        {
            Caption = 'Item Code';
            DataClassification = CustomerContent;
        }
        field(3; "Item Category Code"; Text[80])
        {
            Caption = 'Item Category Code';
            DataClassification = CustomerContent;
        }
        field(4; Brand; Code[100])
        {
            Caption = 'Brand';
            DataClassification = CustomerContent;
        }
        field(5; "Rim Diametar"; Text[250])
        {
            Caption = 'Rim Diameter';
            DataClassification = CustomerContent;
        }
        field(6; Pattern; Code[250])
        {
            Caption = 'Pattern';
            DataClassification = CustomerContent;
        }
        field(7; "Commercial Label"; Text[250])
        {
            Caption = 'Commercial Label';
            DataClassification = CustomerContent;
        }
        field(8; "Market Code"; Code[20])
        {
            Caption = 'Market Code';
            DataClassification = CustomerContent;
        }
        field(9; "Item Class"; Code[30])
        {
            Caption = 'Item Class';
            DataClassification = CustomerContent;
        }
        field(10; "Product Nature"; Code[30])
        {
            Caption = 'Product Nature';
            DataClassification = CustomerContent;
        }
        field(11; "LPR Category"; Code[40])
        {
            Caption = 'LPR Category';
            DataClassification = CustomerContent;
        }
        field(12; "Section Width"; Text[50])
        {
            Caption = 'Section Width';
            DataClassification = CustomerContent;
        }
        field(13; "Aspect Ratio"; Code[40])
        {
            Caption = 'Aspect Ratio';
            DataClassification = CustomerContent;
        }
        field(14; "CCID Code"; Code[30])
        {
            Caption = 'CCID Code';
            DataClassification = CustomerContent;
        }
        field(15; "Business Line"; Code[50])
        {
            Caption = 'Business Line';
            DataClassification = CustomerContent;
        }
        field(16; "Item Discount Group Desc."; Text[30])
        {
            Caption = 'Item Discount Group Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Item Discount Group Code")
        {
            Clustered = true;
        }
    }
}