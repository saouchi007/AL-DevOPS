tableextension 50104 CustCardExt extends Customer
{
    fields
    {
        field(50100; "Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = "-","Car","Motorcycle","Bicycle ";
            DataClassification = CustomerContent;

        }

    }

}