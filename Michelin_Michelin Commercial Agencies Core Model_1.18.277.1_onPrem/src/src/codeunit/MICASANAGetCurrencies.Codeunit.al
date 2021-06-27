codeunit 80560 "MICA SANA GetCurrencies"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Settings Functions", 'OnRunSettingsFunctions', '', false, false)]
    local procedure OnRunSettingsFunctions(var Rec: Record "SC - Operation"; var RequestBuff: Record "SC - XML Buffer (dotNET)"; var ResponseBuff: Record "SC - XML Buffer (dotNET)")
    var
        TempCurrencySCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
        Currency: Record Currency;
        GeneralLedgerSetup: Record "General Ledger Setup";
        CurrencyCode: Code[20];
        DecimalPoints: Text[10];
    begin
        ResponseBuff.SelectNodes('//Currency', TempCurrencySCXMLBufferdotNET);
        while TempCurrencySCXMLBufferdotNET.NextNode() do begin
            CurrencyCode := CopyStr(TempCurrencySCXMLBufferdotNET.ReadFieldValueByName('Id'), 1, 20);
            IF Currency.GET(CurrencyCode) then
                Case true of
                    Strpos(format(Currency."Amount Decimal Places"), ':') = 0:
                        DecimalPoints := format(Currency."Amount Decimal Places");
                    else
                        DecimalPoints := CopyStr(format(Currency."Amount Decimal Places"), 3, 1);
                end
            else begin
                GeneralLedgerSetup.Get();
                if CurrencyCode = GeneralLedgerSetup."LCY Code" then
                    Case true of
                        Strpos(format(GeneralLedgerSetup."Unit-Amount Decimal Places"), ':') = 0:
                            DecimalPoints := format(GeneralLedgerSetup."Unit-Amount Decimal Places");
                        else
                            DecimalPoints := CopyStr(format(GeneralLedgerSetup."Amount Decimal Places"), 3, 1);
                    end;
            end;
            TempCurrencySCXMLBufferdotNET.AddFieldElement('DecimalPoints', DecimalPoints);
        end;
    end;
}