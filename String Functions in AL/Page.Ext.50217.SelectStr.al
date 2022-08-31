/// <summary>
/// PageExtension ISA_SalesOrderStats_Ext (ID 502017) extends Record Sales Order Statistics.
/// </summary>
pageextension 50217 ISA_SalesOrderStats_Ext extends "Sales Statistics"
{
    trigger OnOpenPage()
    var
        Text000: Label 'This, is a comma, separated, string';
        Text001: Label 'The calls to SELECTSTR returns : \\';
        Text002: Label '11,"22,33",,55,,,';
        CommaStrAlpha: Text[60];
        CommaStrBeta: Text[60];
        SubStr1: Text[60];
        SubStr2: Text[60];
        SubStr3: Text[60];
        SubStr4: Text[60];
    begin
        CommaStrAlpha := Text000;
        CommaStrBeta := Text002;

        SubStr1 := SelectStr(2, CommaStrAlpha);
        SubStr2 := SelectStr(4, CommaStrAlpha);

        SubStr3 := SelectStr(1, CommaStrBeta);
        SubStr4 := SelectStr(2, CommaStrBeta);

        Message(Text001 + '%1\' + '%2\' + '%3\' + '%4\', SubStr1, SubStr2, SubStr3, SubStr4);
    end;
}