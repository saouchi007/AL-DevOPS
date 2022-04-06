/// <summary>
/// PageExtension PostedSalesInvoice_Ext (ID 50215) extends Record Posted Sales Invoice.
/// </summary>
pageextension 50215 PostedSalesInvoice_Ext extends "Posted Sales Invoice"
{
    trigger OnOpenPage()
    var
        Str1: Text[30];
        Str2: Text[30];
        Len1: Integer;
        Len2: Integer;
        Text000: Label '13 characters';
        Text001: Label 'Four';
        Text002: Label 'Before PADSTR is called :\\';
        Text003: Label '>%1< has the length %2\\';
        Text004: Label '>%3< has the length %4\\';
        Text005: Label 'After PADSTR is called:\\';
    begin

        Str1 := Text000;
        Str2 := Text001;
        Len1 := StrLen(Str1);
        Len2 := StrLen(Str2);
        Message(Text002 + Text003 + Text004, Str1, Len1, Str2, Len2);
        Str1 := PadStr(Str1, 5); // Truncate the length to 5
        Str2 := PadStr(Str2, 15, 'w'); // Concatenate w until the length = 15
        Len1 := StrLen(Str1);
        Len2 := StrLen(Str2);
        Message(Text005 + Text003 + Text004, Str1, Len1, Str2, Len2);
    end;
}

/*

Remark:

If you omit FillCharacter and String is shorter than Length, then spaces are added at the end of String to match Length.

If you omit FillCharacter and String is longer than Length, then String is truncated.

*/
