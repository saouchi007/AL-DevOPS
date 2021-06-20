tableextension 50200 CustomerBookExtension extends Customer
{
    fields
    {
        field(50100; "Favorite Book No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Favorite Book No.';

        }
    }

}