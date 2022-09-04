/// <summary>
/// PageExtension ISA_VendorList_Ext (ID 50322) extends Record Vendor List.
/// </summary>
pageextension 50322 ISA_VendorList_Ext extends "Vendor List"
{
    trigger OnOpenPage()
    var
        String: Text[50];
        NewString: Text[50];
    begin
        String := 'NEW YORK';
        NewString := UpperCase(CopyStr(String, 1, 1)) + LowerCase(CopyStr(String, 1, 1));
        Message('String is %1.\New String is %2.\%3\%4', String, NewString, UpperCase(CopyStr(String, 1, 1)), LowerCase(CopyStr(String, 1, 1)));
    end;
}