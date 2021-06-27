tableextension 81800 "MICA Gen. Prod. Posting Group" extends "Gen. Product Posting Group"
{
    fields
    {
        field(81800; "MICA Product Type"; Code[22])
        {
            Caption = 'Product Type';
            TableRelation = "MICA Product Type";
            DataClassification = CustomerContent;
        }
    }
}