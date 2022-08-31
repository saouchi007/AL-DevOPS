/// <summary>
/// PageExtension ISA_PurchOrderStats_Ext (ID 50319) extends Record Purchase Order Statistics.
/// </summary>
pageextension 50319 ISA_PurchOrderStats_Ext extends "Purchase Order Statistics"
{
    trigger OnOpenPage()
    var
        Expr1, Expr2, Expr3 : Text[30];
        RefDate, Date1, Date2, Date3 : Date;
        RefDateLbl: Label 'The reference date is %1\';
        Expr1Lbl: Label 'The expression %2 returns %3\';
        Expr2Lbl: Label 'The expression %4 returns %5\';
        Expr3Lbl: Label 'The expression %6 returns %7';
    begin
        // Current quarter + 1 month - 10 days
        Expr1 := '<CQ+1M-10D>';
        // The last weekday n02 (last tuesday)
        Expr2 := '<-WD2>';
        //Current month + 30 days
        Expr3 := '<CM+30D>';

        RefDate := Today;

        Date1 := CalcDate(Expr1, RefDate);
        Date2 := CalcDate(Expr2, RefDate);
        Date3 := CalcDate(Expr3, RefDate);

        Message(RefDateLbl + Expr1Lbl + Expr2Lbl + Expr3Lbl, RefDate, Expr1, Date1, Expr2, Date2, Expr3, Date3);
    end;
}