/// <summary>
/// PageExtension ISA_EditDimSetEntry_Ext (ID 50218) extends Record Edit Dimension Set Entries.
/// </summary>
pageextension 50218 ISA_EditDimSetEntry_Ext extends "Edit Dimension Set Entries"
{
    trigger OnOpenPage()
    var
        Text000: Label 'ABC abc abc xy';
        Text001: Label 'abc';
        Text002: Label 'The search for substring : %1\\';
        Text003: Label ' in the string : %2\\';
        Text004: Label 'returns the position : %3';

        POS001: Integer;
        POS002: Integer;
        POS003: Integer;
        POS004: Integer;

        String: Text[60];
        SubStr: Text[60];
        POS: Integer;

    begin
        String := Text000;
        SubStr := Text001;
        POS := StrPos(String, SubStr);
        Message(Text002 + Text003 + Text004, SubStr, String, POS);

        POS001 := StrPos('abc', '');
        POS002 := StrPos('abc', 'c');
        POS003 := StrPos('abc', 'bc');
        POS004 := StrPos('abc', 'x');
        Message('POS001 returns : %1.\POS002 returns : %2.\POS003 returns : %3.\POS004 returns : %4', POS001, POS002, POS003, POS004);
    end;
}