/// <summary>
/// Page Overtime Overview by Periods (ID 52182568).
/// </summary>
page 52182568 "Overtime Overview by Periods"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Overtime Overview by Periods',
                FRA = 'Détail heures supp. par période';
    PageType = Card;
    SaveValues = true;
    SourceTable = 5200;

    layout
    {
    }

    actions
    {
    }



    var
        PeriodFormMgt: Codeunit 359;
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        OvertimeType: Option "Balance at Date","Net Change";


    local procedure SetDateFilter();
    begin
    end;
}

