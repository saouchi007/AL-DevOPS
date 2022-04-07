/// <summary>
/// TableExtension SalesHeader_Ext (ID 50215) extends Record Sales Header.
/// </summary>
tableextension 50215 SalesHeader_Ext extends "Sales Header"
{
    fields
    {
        field(50215; ISA_LimitedChars; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Uppercase Chars Allowed:';
            //CharAllowed = 'AZ'; //only uppercase chars are allowed
            //CharAllowed = 'ADad15'; // indicates that only the following characters are accepted: A~D, a~d, 1~5.
            CharAllowed = 'AACCWW44'; // indicates that only the following characters are accepted: A, C, W, 4.
        }
    }
}