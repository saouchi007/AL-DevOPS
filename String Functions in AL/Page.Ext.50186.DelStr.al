/// <summary>
/// PageExtension FixedAssetList_Ext (ID 50186) extends Record Fixed Asset List;.
/// </summary>
pageextension 50186 FixedAssetList_Ext extends "Fixed Asset List"
{
    trigger OnOpenPage()
    var
        Str: Text[30];
        Position: Integer;
        Length: Integer;
        NewStr: Text[30];
        Text000: Label 'Adjusting prices - Please wait';
        Text001: Label 'The original string is : >%1<. \\The original modified : >%2<';
    begin
        Str := Text000;
        Position := 11; // remove the word "prices " and a blank from Text000
        Length := 7;
        NewStr := DelStr(Str, Position, Length);
        Message(Text001, Str, NewStr);
    end;
}

/*
Remark:

If you omit Length, all the characters starting with Position are deleted until the end of the string.

If you omit Length and Position is less than 1, then an error is returned.

If you omit Length and Position is greater than the length of String, then String is returned unchanged.
*/
