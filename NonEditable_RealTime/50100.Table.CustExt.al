tableextension 50100 CustExt extends Customer
{
    fields
    {
        field(50100; Locked; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Locked';
        }
    }

}