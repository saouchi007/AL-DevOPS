/// <summary>
/// TableExtension CustomerList_Ext (ID 50151) extends Record Customer.
/// </summary>
tableextension 50151 CustomerList_Ext extends Customer
{
    fields
    {
        modify(Name)
        {
            trigger OnBeforeValidate()
            begin
                CheckSpecialChars(Rec.Name);
            end;
        }
    }


    local procedure CheckSpecialChars(var CustName: Text[50])
    var
        PosAlpha: Integer;
        PosBeta: Integer;
        PosCharlie: Integer;
        SpecialChars: Label '!|@|#|$|%|&|*|(|)|_|-|+|=|?';
        Len: Integer;
    begin
        /* method 1 : hard coding characters
         Clear(PosAlpha);
         Clear(PosBeta);
         Clear(PosCharlie);

         PosAlpha := StrPos(CustName, '*');
         PosBeta := StrPos(CustName, '@');
         PosCharlie := StrPos(CustName, '&');

         if (PosAlpha > 0) or (PosBeta > 0) or (PosCharlie > 0) then
             Error(SpecialCharsErrorMsg);*/
        Clear(Len);
        Len := StrLen(DelChr(CustName, '=', DelChr(CustName, '=', SpecialChars)));
        if Len > 0 then
            Error(SpecialCharsErrorMsg);
    end;

    var
        SpecialCharsErrorMsg: Label 'Special characters are not allowed !';
}