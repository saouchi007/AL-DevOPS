codeunit 80460 "MICA SANA Get Balance Info"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Customer Functions", 'OnGetBalanceInfo', '', false, false)]
    local procedure OnGetBalanceInfo(var XMLNodeBuff: Record "SC - XML Buffer (dotNET)"; var Customer: Record Customer; var Params: Record "SC - Parameters Collection")
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        SCCustomerHelper: Codeunit "SC - Customer Helper";
        RemainingAmtLCY: Decimal;
    begin
        CustLedgerEntry.SetRange("Customer No.", Customer."No.");
        CustLedgerEntry.SetFilter("Due Date", '<' + Format(WorkDate()));
        CustLedgerEntry.SetFilter("Remaining Amt. (LCY)", '<>0');
        if CustLedgerEntry.FindSet() then
            repeat
                CustLedgerEntry.CalcFields("Remaining Amt. (LCY)");
                RemainingAmtLCY += CustLedgerEntry."Remaining Amt. (LCY)";
            until CustLedgerEntry.Next() = 0;
        RemainingAmtLCY := SCCustomerHelper.ConvertToFCY(RemainingAmtLCY, Params.CurrentCurrencyId);
        XMLNodeBuff.AddFieldElement('OverdueBalance', CopyStr(Format(RemainingAmtLCY), 1, 1024));
    end;
}