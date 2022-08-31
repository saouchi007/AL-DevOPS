/// <summary>
/// TableExtension ISa_Customer_Ext (ID 50316) extends Record Customer.
/// </summary>
tableextension 50316 ISa_Customer_Ext extends Customer
{
    fields
    {
        modify(Name)
        {
            trigger OnBeforeValidate()
            begin
                //ISA_CheckSpecialCharsWithStrPos(Rec.Name);
                ISA_CheckSpecialCharsWithDelChr(Rec.Name);
            end;
        }
    }

    local procedure ISA_CheckSpecialCharsWithStrPos(var CustName: Text[100])
    var
        POS001: Integer;
        POS002: Integer;
        POS003: Integer;
    begin
        Clear(POS001);
        Clear(POS002);
        Clear(POS003);

        POS001 := StrPos(CustName, '*');
        POS002 := StrPos(CustName, '@');
        POS003 := StrPos(CustName, '&');

        If (POS001 > 0) or (POS002 > 0) or (POS003 > 0) then
            Error(SpecialCharsError);

    end;

    local procedure ISA_CheckSpecialCharsWithDelChr(var CustName: Text[100])
    var
        SpecialChars: Label '!|@|#|$|%|&|*|(|)|_|-|+|=|?';
        Len: Integer;
    begin
        Clear(Len);
        Len := StrLen(DelChr(CustName, '=', DelChr(CustName, '=', SpecialChars)));
        if Len > 0 then
            Error(SpecialCharsError);
        /*
        If Where contains =, then all the spaces are deleted from String.
        If Where contains <, then all the spaces at the start of String are deleted.
        If Where contains >, then all the spaces at the end of String are deleted.
        If Where contains any other character, then an error is returned.
        If Where is empty, then String is returned unchanged.
        */
    end;

    var
        SpecialCharsError: Label 'You cannot enter a special character !';

}