table 82941 "MICA Sorting Line2"
{
    DataClassification = CustomerContent;

    fields
    {
        field(10; "Document No."; Code[20])
        {
            Caption = 'Field 1';
            DataClassification = CustomerContent;
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(30; "Field 3"; Text[2048])
        {
            Caption = 'Field 3';
            DataClassification = CustomerContent;
        }
        field(40; "Field 4"; Text[2048])
        {
            Caption = 'Field 4';
            DataClassification = CustomerContent;
        }
        field(50; "Field 5"; Text[2048])
        {
            Caption = 'Field 5';
            DataClassification = CustomerContent;
        }
        field(60; "Field 6"; Text[2048])
        {
            Caption = 'Field 6';
            DataClassification = CustomerContent;
        }
        field(70; "Field 7"; Text[2048])
        {
            Caption = 'Field 7';
            DataClassification = CustomerContent;
        }
        field(80; "Field 8"; Text[2048])
        {
            Caption = 'Field 8';
            DataClassification = CustomerContent;
        }
        field(90; "Field 9"; Text[2048])
        {
            Caption = 'Field 9';
            DataClassification = CustomerContent;
        }
        field(100; "Field 10"; Text[2048])
        {
            Caption = 'Field 10';
            DataClassification = CustomerContent;
        }
        field(110; "Field 11"; Text[2048])
        {
            Caption = 'Field 11';
            DataClassification = CustomerContent;
        }
        field(120; "Field 12"; Text[2048])
        {
            Caption = 'Field 12';
            DataClassification = CustomerContent;
        }
        field(130; "Field 13"; Text[2048])
        {
            Caption = 'Field 13';
            DataClassification = CustomerContent;
        }
        field(140; "Field 14"; Text[2048])
        {
            Caption = 'Field 14';
            DataClassification = CustomerContent;
        }
        field(150; "Field 15"; Text[2048])
        {
            Caption = 'Field 15';
            DataClassification = CustomerContent;
        }
        field(160; "Field 16"; Text[2048])
        {
            Caption = 'Field 16';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(SK1; "Field 3", "Field 4", "Field 5", "Field 6", "Field 7", "Field 8", "Field 9", "Field 10", "Field 11", "Field 12", "Field 13", "Field 14", "Field 15", "Field 16", "Document No.", "Line No.")
        {

        }
    }

}