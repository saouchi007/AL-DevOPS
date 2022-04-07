tableextension 50215 ISA_SalesHeader_Ext extends "Sales Header"
{
    fields
    {
        field(50215; ISA_LimitedChars; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Limited Chars:';
            //CharAllowed = 'AZ'; //Only uppercase chars
            //CharAllowed = 'ADad15'; //indicates that only the following characters are accepted: A~D, a~d, 1~5.
            CharAllowed = 'AACCWW44'; //indicates that only the following characters are accepted: A, C, W, 4.
        }
    }

    var
        myInt: Integer;
}