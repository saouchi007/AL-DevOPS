/// <summary>
/// PageExtension ISA_PurchaseOrder_Ext (ID 50317) extends Record MyTargetPage.
/// </summary>
pageextension 50318 ISA_PostedPurchaseReceipts_Ext extends "Posted Purchase Receipts"
{
    trigger OnOpenPage()
    begin
        //CurrentTime(Time);
        //CurrentDate(Today);
        //WkDate(WorkDate);
        //CurDateTime(CurrentDateTime);
        //DateFormatwithDate2DMY(Today);
        DateFormatwithDate2DWY(Today);
    end;


    local procedure CurrentTime(CTime: Time)
    var
        TimeMsg: Label 'The current time is : %1';
    begin
        Message(TimeMsg, CTime);
    end;

    local procedure CurrentDate(TodayDate: Date)
    var
        DateMsg: Label 'The current date is : %1';
    begin
        Message(DateMsg, TodayDate);
    end;

    local procedure WkDate(WorkDay: Date)
    var
        DateMsg: Label 'The current date is : %1';
    begin
        Message(DateMsg, WorkDay);
    end;

    local procedure CurDateTime(CDateTime: DateTime)
    begin
        Message(CurDateTimeDateMsg, CDateTime);
    end;

    local procedure DateFormatwithDate2DMY(inputDate: Date)
    var
        Date2DMYDay, Date2DMYMonth, Date2DMYYear : Integer;
        DateMsg: Label 'Today is day %1 of month %2 of the year %3';
    begin
        Date2DMYDay := Date2DMY(inputDate, 1);
        Date2DMYMonth := Date2DMY(inputDate, 2);
        Date2DMYYear := Date2DMY(inputDate, 3);
        /*
        The value 1 corresponds to day
        The value 2 corresponds to month
        The value 3 corresponds to year
        */
        Message(DateMsg, Date2DMYDay, Date2DMYMonth, Date2DMYYear);
    end;

    local procedure DateFormatwithDate2DWY(inputDate: Date)
    var
        Date2DWYDay, Date2DWYMonth, Date2DWYYear : Integer;
        Text000: Label 'The date %1 corresponds to:\';
        Text001: Label 'The day of the week : %2\';
        Text002: Label 'The week number : %3\';
        Text003: Label 'The year : %4';
    begin
        Date2DWYDay := Date2DWY(inputDate, 1);
        Date2DWYMonth := Date2DWY(inputDate, 2);
        Date2DWYYear := Date2DWY(inputDate, 3);
        /*
        The value 1 corresponds to day of the week (1-7, Monday = 1).
        The value 2 corresponds to week number (1-53).
        The value 3 corresponds to year.
        */
        Message(Text000 + Text001 + Text002 + Text003,inputDate,Date2DWYDay,Date2DWYMonth,Date2DWYYear);
    end;

    var
        CurDateTimeDateMsg: Label 'The current date time is %1';
}