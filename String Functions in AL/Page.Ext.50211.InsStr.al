/// <summary>
/// PageExtension SalesOrdersList_Ext (ID 50211) extends Record Sales Order List.
/// </summary>
pageextension 50211 SalesOrdersList_Ext extends "Sales Order List"
{
    trigger OnOpenPage()
    var
        Str: Text[30];
        SubString: Text[60];
        NewString: Text[60];
        Text000: Label 'Press ENTER to continue';
        Text001: Label ' or ESC ';
        Text002: Label 'The test string before INSSTR is called : >%1<';
        Text003: Label 'The resulting string after INSSTR is called : >%1<';
    begin
        Str := Text000;
        SubString := Text001;
        Message(Text002, Str);
        NewString := InsStr(Str, SubString, 13);
        Message(Text003, NewString);
    end;
}

/*

Remarks:

If SubString is empty, then String is returned unchanged.

If Position is less than 1, an error is returned.

If Position is greater than the length of String, SubString is added at the end of String. 
For example, INSSTR("Thomas","AAA",999) returns ‘ThomasAAA’.
*/
