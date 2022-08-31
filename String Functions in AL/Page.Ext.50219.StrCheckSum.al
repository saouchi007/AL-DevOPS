/// <summary>
/// PageExtension ISA_Approvals_Ext (ID 50219) extends Record Approvals.
/// </summary>
pageextension 50219 ISA_Approvals_Ext extends Approvals
{
    trigger OnOpenPage()
    var
        StrNumber: Text[60];
        Weight: Text[50];
        Modulus: Integer;
        Checksum: Integer;

        Text001: Label 'The number :%1\';
        Text002: Label 'has the checksum :%2';
    begin
        StrNumber := '7852';
        Weight := '1234';
        Modulus := 7;
        Checksum := StrCheckSum(StrNumber, Weight, Modulus);
        // this is the formula used by the checksum for this specific example : The formula is: (7 – (7×1 + 8×2 + 5×3 + 2×4) MOD 7) MOD 7 = 3
        Message(Text001 + Text002, StrNumber, Checksum);
    end;
}