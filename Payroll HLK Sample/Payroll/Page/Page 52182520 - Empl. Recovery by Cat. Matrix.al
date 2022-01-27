/// <summary>
/// Page Empl. Recovery by Cat. Matrix (ID 52182520).
/// </summary>
page 52182520 "Empl. Recovery by Cat. Matrix"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Empl. Recoveries by Cat. Matrix',
                FRA = 'Récupérations salariés par matrice cat.';
    PageType = ListPart;
    SourceTable = 2000000007;

    layout
    {
    }

    actions
    {
    }



    var
        EmployeeRecovery: Record "Employee Recovery";
        PeriodFormMgt: Codeunit 359;
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        RecoveryAmountType: Option "Balance at Date","Net Change";
        EmployeeNoFilter: Text[250];


    procedure MatrixUpdate(NewRecoveryType: Option "Recovery to Date","Recovery at Date"; NewPeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period"; NewEmployeeNoFilter: Text[250]);
    begin
    end;
}

