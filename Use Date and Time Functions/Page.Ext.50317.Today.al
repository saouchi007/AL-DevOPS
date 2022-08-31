/// <summary>
/// PageExtension ISA_PurchaseOrder_Ext (ID 50317) extends Record MyTargetPage.
/// </summary>
pageextension 50317 ISA_PurchaseOrder_Ext extends "Purchase Order"
{
    trigger OnOpenPage()
    var
        DateMsg: Label 'The current date is : %1';
        TodayDate: Date;
    begin
        TodayDate := Today;
        // Message(DateMsg, TodayDate);

        //Message('%1', ISA_DMY2Date(31, 8, 2022));
        //Message('%1', ISA_DWY2Date(4, 49, 2020));

        //Message('%1', ISA_DT2Time(CurrentDateTime));
        ISA_GoBackToTheFuture(Today);

    end;


    local procedure ISA_DMY2Date(Day: Integer; Month: Integer; Year: Integer): Date
    var
        outputDate: Date;
    begin
        outputDate := DMY2Date(Day, Month, Year);
        exit(outputDate);
    end;

    local procedure ISA_DWY2Date(Day: Integer; Week: Integer; Year: Integer): Date
    var
        outputDate: Date;
    begin
        outputDate := DWY2Date(Day, Week, Year);
        exit(outputDate);
    end;

    local procedure ISA_DT2Time(CTime: DateTime): Time
    var
        output: Time;
    begin
        output := DT2Time(CTime);
        exit(output);
    end;

    local procedure ISA_GoBackToTheFuture(InputDate: Date)
    var
        Yesterday, Tomorrow, FirstDayMonth, LastDayMonth : Date;
        DateMsg: Label 'Yesterday is %1\ Tomorrow is %2\ First day of the month is %3\ Last day is %4';
    begin
        Yesterday := CalcDate('<-1D>', InputDate);
        Tomorrow := CalcDate('<+1D>', InputDate);
        FirstDayMonth := CalcDate('<-CM>', InputDate);
        LastDayMonth := CalcDate('<+CM>', InputDate);

        Message(DateMsg, Yesterday, Tomorrow, FirstDayMonth, LastDayMonth);
    end;
}