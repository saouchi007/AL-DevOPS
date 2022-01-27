/// <summary>
/// Page Recovery Overview by Periods (ID 52182522).
/// </summary>
page 52182522 "Recovery Overview by Periods"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Recovery Overview by Periods',
                FRA = 'Détail récupérations par période';
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
        RecoveryType: Option "Balance at Date","Net Change";


    local procedure SetDateFilter();
    begin
    end;
}

