/// <summary>
/// PageExtension ItemList_Ext (ID 50140) extends Record Item List.
/// </summary>
pageextension 50140 ItemList_Ext extends "Item List"
{
    trigger OnOpenPage()
    var
        // - Version 1
        Today: Label 'Today is %1\\';
        PrevMonth: Label 'Previous Month, from %1 To %2\\';
        ThisMonth: Label 'This month, from %1 To %2\\';
        NextMonth: Label 'Next month, from %1 To %2\\';
        Next2Months: Label 'Next 2 months, from %1 To %2\\';
        MessageTxt: Text;
        //---------------------------
        // - Version 2
        Calendar: Record Date;
        PeriodPageMgmnt: Codeunit PeriodPageManagement;
    begin
        // - Version 1
        MessageTxt := StrSubstNo(Today, Today());
        /* MessageTxt += StrSubstNo(PrevMonth, CalcDate('<-CM-1M>', Today()), CalcDate('<CM-1M', Today()));
         MessageTxt += StrSubstNo(ThisMonth, CalcDate('<-CM>', Today()), CalcDate('<CM>', Today()));
         MessageTxt += StrSubstNo(NextMonth, CalcDate('<-CM+1M>', Today()), CalcDate('<CM+1M>', Today()));
         MessageTxt += StrSubstNo(Next2Months, CalcDate('<-CM+2M>', Today()), CalcDate('<CM+2M>'), Today());
         Message(MessageTxt);
         ---------------------------
         // - Version 2*/
        Calendar."Period Start" := CalcDate('<CM-1M', Today());
        PeriodPageMgmnt.FindDate('<', Calendar, Enum::"Analysis Period Type"::Month);
        MessageTxt := StrSubstNo(PrevMonth, Calendar."Period Start", Calendar."Period End");

        Calendar."Period Start" := CalcDate('<CM>', Today());
        PeriodPageMgmnt.FindDate('<', Calendar, Enum::"Analysis Period Type"::Month);
        MessageTxt += StrSubstNo(ThisMonth, Calendar."Period Start", Calendar."Period End");

        Calendar."Period Start" := CalcDate('<CM+1M>', Today());
        PeriodPageMgmnt.FindDate('<', Calendar, Enum::"Analysis Period Type"::Month);
        MessageTxt += StrSubstNo(NextMonth, Calendar."Period Start", Calendar."Period End");

        Calendar."Period Start" := CalcDate('<CM+2M>', Today());
        PeriodPageMgmnt.FindDate('<', Calendar, Enum::"Analysis Period Type"::Month);
        MessageTxt += StrSubstNo(Next2Months, Calendar."Period Start", Calendar."Period End");


        Message(MessageTxt);
    end;
}