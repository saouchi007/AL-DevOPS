/// <summary>
/// PageExtension ItemList_Ext (ID 50185) extends Record Item List.
/// </summary>
pageextension 50185 ItemList_Ext extends "Item List"
{
    trigger OnOpenPage()
    var
        Str: Text;
        Where: Text;
        Which: Text;
        NewStr: Text;
        Text000: Label ' Windy West Solution'; // the space leading the string is used in Example05
        Text001: Label '>%1< is tranformed to >%2<';
    begin
        //Example01: The method deletes every W and s that is either the first or last character in String.
        Str := Text000;
        Where := '<>';
        Which := 'Ws';
        //NewStr := DelChr(Str, Where, Which);
        //Message(Text001, Str, NewStr);

        //Example02: The method deletes every s and x from String.
        Str := Text000;
        Where := '=';
        Which := 'sl';
        //NewStr := DelChr(Str, Where, Which);
        //Message(Text001, Str, NewStr);

        //Example03: If T, e, l,y,o or n is the last character in String, the method deletes them.
        Str := Text000;
        Where := '>';
        Which := 'Telyon';
        //NewStr := DelChr(Str, Where, Which);
        //Message(Text001, Str, NewStr);

        //Example04: If T, h, s, i, or space is the first character in String, the method deletes them.
        Str := Text000;
        Where := '<';
        Which := 'West ';
        //NewStr := DelChr(Str, Where, Which);
        //Message(Text001, Str, NewStr);

        //Example05: The method removes any spaces from the start of String.
        Str := Text000;
        Where := '<';
        //NewStr := DelChr(Str, Where);
        //Message(Text001, Str, NewStr);

        //Example06: The method removes all spaces.
        Str := Text000;
        NewStr := DelChr(Str);
        Message(Text001, Str, NewStr);


    end;
}

/*

Remark:

The DELCHR method is case-sensitive.

If you omit the Which parameter, then the method deletes spaces from String based on the contents of the Where parameter as follows:

If Where contains =, then all the spaces are deleted from String.
If Where contains <, then all the spaces at the start of String are deleted.
If Where contains >, then all the spaces at the end of String are deleted.
If Where contains any other character, then an error is returned.
If Where is empty, then String is returned unchanged.
If you use the Where and the Which parameters, then the method deletes from String the characters that are contained in the Which parameter based on the contents of the Where parameter as follows:

If Where contains =, then every occurrence of the characters in Which are deleted from String.
If Where contains <, then the characters in Which are only deleted if they occur at the start of String.
If Where contains >, then the characters in Which are deleted only if they occur at the end of String.
If Where contains any other character, then an error is returned.
If Where is empty, then String is returned unchanged.
If Which is empty, then String is returned unchanged.
The Which parameter contains an array of the characters that you want to delete. The order of the characters is of no significance. 
If String contains a character that is specified in Which, it is deleted from String.

*/
