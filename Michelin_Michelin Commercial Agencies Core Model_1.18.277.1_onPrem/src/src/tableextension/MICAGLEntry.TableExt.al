tableextension 80080 "MICA GLEntry" extends "G/L Entry"
{
    fields
    {
        field(80080; "MICA No. 2"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. 2';
        }
        field(81170; "MICA Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
        }

        field(81171; "MICA Amount (FCY)"; Decimal)
        {
            Caption = 'Amount (FCY)';
            DataClassification = CustomerContent;
        }
        field(81172; "MICA Amt. FCY To Be Erased"; Boolean)
        {
            Caption = 'Amount FCY to be Erased';
            DataClassification = CustomerContent;
        }
        field(81173; "MICA Amt. FCY DateTime Mod."; DateTime)
        {
            Caption = 'Amount FCY DateTime Modified';
            DataClassification = CustomerContent;
        }
        field(81174; "MICA Amt. FCY User Modified"; Code[50])
        {
            Caption = 'Amount FCY User Modified';
            DataClassification = CustomerContent;
        }

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
        field(81880; "MICA Rebate Code"; Code[20])
        {
            Caption = 'Rebate Code';
            DataClassification = CustomerContent;
        }
        field(81940; "MICA Type Of Transaction"; Option)
        {
            Caption = 'Type of Transaction';
            DataClassification = CustomerContent;
            OptionMembers = "Manual Adjustment","Rebate Creation","Rebate Reversal";
            OptionCaption = 'Manual Adjustment,Rebate Creation,Rebate Reversal';
        }
    }
    keys
    {
        key(Key1; "MICA No. 2", "MICA Rebate Code")
        {

        }
        key(Key2; "MICA Type Of Transaction")
        {

        }
    }
}