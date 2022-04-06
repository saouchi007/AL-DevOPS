/// <summary>
/// PageExtension VendorList_Ext (ID 50184) extends Record Vendor List.
/// </summary>
pageextension 50184 VendorList_Ext extends "Vendor List"
{
    trigger OnOpenPage()
    var
        Str: Text[30];
        Position: Integer;
        Length: Integer;
        NewStr: Text[30];
        Text000: Label 'Using the CopyStr method';
        Text001: Label 'The original string is : >%1<. \\Start position is %2. \\Length is %3. \\The copied string is : >%4<.';
    begin
        Str := Text000;
        Position := 7;
        Length := 8;
        NewStr := CopyStr(Str, Position, Length);
        Message(Text001, Str, Position, Length, NewStr);
    end;
}

/*
Remark:

If Position combined with Length exceeds the length of the string, all the characters from Position to the end of the string are returned.
*/
