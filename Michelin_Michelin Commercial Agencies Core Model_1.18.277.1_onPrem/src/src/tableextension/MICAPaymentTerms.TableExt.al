tableextension 80180 "MICA Payment Terms" extends "Payment Terms"
{
    fields
    {
        field(80000; "MICA Payment Terms Line Disc. %"; Decimal)
        {
            Caption = 'Payment Terms Line Disc. %';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(82020; "MICA GIS Payment Term Code"; Code[15])
        {
            Caption = 'GIS Payment Term Code';
            DataClassification = CustomerContent;
        }
    }

}