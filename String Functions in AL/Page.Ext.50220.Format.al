/// <summary>
/// PageExtension ISA_SalesCommentSheet_Ext (ID 50220) extends Record Sales Comment Sheet.
/// </summary>
pageextension 50220 ISA_SalesCommentSheet_Ext extends "Sales Comment Sheet"
{
    trigger OnOpenPage()
    var
        Text001: Label 'The formatted value is : %1';
        Text000: Label 'Today is %1';
    begin
        Message(Text001, Format(-123456.78, 12, 3));
        Message('<Standard Format,3> %1', Format(-123456.78, 12, '<Standard Format,3>'));
        Message('<Sign><Integer Thousand><Decimals> %1', Format(-123456.78, 12, '<Sign><Integer Thousand><Decimals>'));
        Message('<Sign><Integer><Decimals> %1', Format(-123456.78, 12, '<Sign><Integer><Decimals>'));
        Message('<Sign><Integer><Decimals><Comma,.> %1', Format(-123456.78, 12, '<Sign><Integer><Decimals><Comma,.>'));
        Message('<Integer Thousand><Decimals><Sign,1> %1', Format(-123456.78, 12, '<Integer Thousand><Decimals><Sign,1>'));
        Message('<Integer><Decimals><Sign,1> %1', Format(-123456.78, 12, '<Integer><Decimals><Sign,1>'));

        //Message(Text000, Format(Today, 0, '<Month Text> <Days>')); // does not return anything
    end;
}