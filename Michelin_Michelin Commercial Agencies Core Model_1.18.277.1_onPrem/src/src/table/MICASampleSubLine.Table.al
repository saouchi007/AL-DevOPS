table 80876 "MICA Sample Sub Line"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "MICA Sample Sub Line List";

    fields
    {
        field(1; "Line No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
            TableRelation = "MICA Sample Data"."No.";
        }
        // XMLPort Import Complex Field
        field(10; "Logical Id"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Logical Id';
        }
        field(11; "Location Id"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Location Id';
        }
        field(12; "Item Id"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Id';
        }
        field(13; "Attribute Id"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Attribute Id';
        }

    }

    keys
    {
        key(PK; "Line No.", "Item Id")
        {
            Clustered = true;
        }
    }

}