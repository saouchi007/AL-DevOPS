tableextension 82120 "MICA Vendor Bank Account" extends "Vendor Bank Account"
{
    fields
    {
        field(82120; "MICA Blocked"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Blocked';
        }
        field(81550; "MICA Bank Account Type"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Account Type';
            TableRelation = "MICA Bank Account Type".Code;
        }
    }

}