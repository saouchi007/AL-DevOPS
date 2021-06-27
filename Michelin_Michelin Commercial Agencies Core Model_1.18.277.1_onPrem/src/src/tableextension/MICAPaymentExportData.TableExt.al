tableextension 82040 "MICA Payment Export Data" extends "Payment Export Data"
{
    fields
    {
        field(81551; "MICA Additional Information 1"; Text[35])
        {
            DataClassification = CustomerContent;
            Caption = 'Additional Information 1';
        }
        field(81552; "MICA Additional Information 2"; Text[35])
        {
            DataClassification = CustomerContent;
            Caption = 'Additional Information 2';
        }
        field(81553; "MICA Additional Information 3"; Text[35])
        {
            DataClassification = CustomerContent;
            Caption = 'Additional Information 3';
        }
        field(81554; "MICA Additional Information 4"; Text[35])
        {
            DataClassification = CustomerContent;
            Caption = 'Additional Information 4';
        }
        field(81555; "MICA Payment Priority Code"; Code[4])
        {
            Caption = 'Payment Priority Code';
            DataClassification = CustomerContent;
        }
        field(81556; "MICA Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
            DataClassification = CustomerContent;
        }
        field(82040; "MICA Explanation"; Text[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Explanation';
        }
        field(82041; "MICA Applies-to ID"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Applies-to ID';
        }
        field(82042; "MICA Bank Account Type"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Account Type';
            TableRelation = "MICA Bank Account Type".Code;
        }
        field(82043; "MICA Recipient VAT Reg. No."; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Recipient VAT Registration No.';
        }
        field(82044; "MICA Recipient IBAN"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'IBAN';
        }
    }
}