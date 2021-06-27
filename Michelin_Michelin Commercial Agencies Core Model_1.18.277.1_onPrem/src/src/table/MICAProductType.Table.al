table 81801 "MICA Product Type"
{
    DataClassification = CustomerContent;
    LookupPageId = "MICA Product Types";

    fields
    {
        field(1; "Product Type"; Code[2])
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(2; Description; Code[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }       
    }

    keys
    {
        key(PK; "Product Type")
        {
            Clustered = true;
        }
    }

}