/// <summary>
/// PageExtension SalesInvoicesList_Ext (ID 50212) extends Record Sales Invoice List.
/// </summary>
pageextension 50212 SalesInvoicesList_Ext extends "Sales Invoice List"
{
    trigger OnOpenPage()
    var
        Str: Text[50];
        Lower: Text[50];
        Upper: Text[50];
        Text000: Label 'The Entries Are Sorted by Name';
        Text001: Label 'The string before LOWERCASE is : >%1<\\The string after LOWERCASE is : >%2<';
        Text002: Label 'The string before UPPERCASE is called : >%1<\\The string after UPPERCASE is called : >%2<';
    begin
        Str := Text000;
        Lower := LowerCase(Str);
        Message(Text001, Str, Lower);
        Upper := UpperCase(Str);
        Message(Text002, Str, Upper);
    end;
}