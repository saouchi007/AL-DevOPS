/// <summary>
/// Page Advance Overview by Periods (ID 52182565).
/// </summary>
page 52182565 "Advance Overview by Periods"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Advance Overview by Periods',
                FRA = 'Détail avances par période';
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
        AdvanceAmountType: Option "Balance at Date","Net Change";


    local procedure SetDateFilter();
    begin
    end;
}

