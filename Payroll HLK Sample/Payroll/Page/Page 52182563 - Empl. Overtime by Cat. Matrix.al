/// <summary>
/// Page Empl. Overtime by Cat. Matrix (ID 52182563).
/// </summary>
page 52182563 "Empl. Overtime by Cat. Matrix"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Empl. Overtimes by Cat. Matrix',
                FRA = 'Heures supp. salariés par matrice cat.';
    PageType = ListPart;
    SourceTable = 2000000007;

    layout
    {
    }

    actions
    {
    }



    var
        EmployeeOvertime: Record "Employee Overtime";
        PeriodFormMgt: Codeunit 359;
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        OvertimeType: Option "Balance at Date","Net Change";
        EmployeeNoFilter: Text[250];


    procedure MatrixUpdate(NewOvertimeType: Option "Overtime to Date","Overtime at Date"; NewPeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period"; NewEmployeeNoFilter: Text[250]);
    begin
    end;
}

