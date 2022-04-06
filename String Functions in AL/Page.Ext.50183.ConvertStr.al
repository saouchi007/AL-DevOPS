/// <summary>
/// PageExtension CustomerList_Ext (ID 50182) extends Record Customer List.
/// </summary>
pageextension 50182 CustomerList_Ext extends "Customer List"
{
   trigger OnOpenPage()
   var
        OriginalString : Text[50];
        FromChars : Text[50];
        ToChars :Text[50];
        NewString : Text[50];
        Text000 : Label 'Do you want to leave without saving ?';
        Text001 : Label 'dylws';
        Text002 : Label 'DYLWS';
        Text003 : Label 'The original sentence is : \\ %1. \\The sentence is converted to:\\ %2';
   begin
       OriginalString := Text000;
       FromChars := Text001;
       ToChars := Text002;
       NewString := ConvertStr(OriginalString,FromChars,ToChars);
       Message(Text003, OriginalString,NewString);
   end;
}
 

/*
Remark:

The characters in the FromCharacters parameter are replaced by the characters in the ToCharacters parameter.

If the lengths of the FromCharacters and ToCharacters strings are not equal, then a run-time error occurs.

If either the FromCharacters or the ToCharacters strings are empty, then the source is returned unchanged.
*/