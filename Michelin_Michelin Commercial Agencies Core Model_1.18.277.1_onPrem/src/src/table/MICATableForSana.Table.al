table 80239 "MICA TableForSana"
{
    DataClassification = CustomerContent;
    //ObsoleteState = Pending;
    fields
    {
        field(1; DateSana; Date)
        {
            Caption = 'DateSana';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; DateSana)
        {
            Clustered = true;
        }
    }

}