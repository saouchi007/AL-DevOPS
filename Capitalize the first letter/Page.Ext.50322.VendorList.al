/// <summary>
/// PageExtension ISA_VendorList_Ext (ID 50322) extends Record Vendor List.
/// </summary>
pageextension 50322 ISA_VendorList_Ext extends "Vendor List"
{
    trigger OnOpenPage()
    var
        InputString: Text[1024];
        SringList: List of [Text];
        OutputString: Text[1024];
        I: Integer;
    begin
        Clear(I);
        InputString := 'NEW YORK ABC CAD BDF RED BLUE YELLOW';
        Message('InputString is %1', InputString);
        SringList := InputString.Split(' ');

        for I := 1 to SringList.Count do begin
            OutputString := OutputString + ' ' + UpperCase(CopyStr(SringList.Get(i), 1, 1)) + LowerCase(CopyStr(SringList.Get(I), 2));
        end;
        Message('OutputString is %1', OutputString);
    end;
}