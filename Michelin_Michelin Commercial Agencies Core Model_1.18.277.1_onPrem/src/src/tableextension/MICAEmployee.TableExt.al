tableextension 81552 "MICA Employee" extends Employee //MyTargetTableId
{
    fields
    {
        field(81550; "MICA NCC"; Code[2])
        {
            Caption = 'NCC (National Country Code)';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
        }
        field(81555; "MICA Ctry Credit Agent No."; Text[50])
        {
            Caption = 'Country Credit Agent No.';
            DataClassification = CustomerContent;
        }
        field(81556; "MICA Bank Beneficiary Name"; Text[50])
        {
            Caption = 'Bank Beneficiary Name';
            DataClassification = CustomerContent;
        }
        field(81557; "MICA Bank Account Type"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Account Type';
            TableRelation = "MICA Bank Account Type".Code;
        }

        field(81558; "MICA Employee VAT Reg. No."; Text[20])
        {
            caption='Employee VAT Registration No.';
            DataClassification = CustomerContent;
        }

        field(81559; "MICA Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            DataClassification = CustomerContent;
            TableRelation = "Payment Method";
        }


    }

}