/// <summary>
/// PageExtension SalesQuotesList_Ext (ID 50213) extends Record Sales Quotes.
/// </summary>
pageextension 50213 SalesQuotesList_Ext extends "Sales Quotes"
{
    trigger OnOpenPage()
    var
        City: Text[50];
        MaxLength: Integer;
        Length: Integer;
        Text000: Label 'Vedbaek';
        Text001: Label 'The MaxStrLen method returns %1, \\';
        Text002: Label 'whereas the StrLen method returns %2';
    begin
        City := Text000;
        MaxLength := MaxStrLen(City);
        Length := StrLen(City);
        Message(Text001 + Text002, MaxLength, Length);

    end;
}

/*
Remark:

If you call this method on a Variant, it returns an error.

The difference between the STRLEN method and the MAXSTRLEN Method is that the STRLEN returns the actual number of characters in the input string, 
whereas MAXSTRLEN returns the maximum defined length of the input string.

In Dynamics 365 Business Central, if you call STRLEN on a Variant, then you get an error that the contents of the
 parameter are not valid. In earlier versions of Dynamics 365, if you call STRLEN on a Variant, then 0 is returned.
*/
