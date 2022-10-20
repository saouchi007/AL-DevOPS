/// <summary>
/// PageExtension ISA_SalesQuotes_Ext (ID 50301) extends Record Sales Quotes.
/// </summary>
pageextension 50301 ISA_SalesQuotes_Ext extends "Sales Quotes"
{
    trigger OnOpenPage()
    var
        Check: Report ISA_Check;
        AmountIntoLetters: Text;
        NoText: array[2] of Text[400];
    begin
        Check.InitTextVariable();
        Check.FormatNoTextFR(NoText, Round(2331718, 0.01), '');
        AmountIntoLetters := NoText[1] + ' ' + NoText[2];
        Message(AmountIntoLetters);
    end;
}