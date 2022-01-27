/// <summary>
/// Page Empl. Advances by Cat. Matrix (ID 51539).
/// </summary>
page 52182564 "Empl. Advances by Cat. Matrix"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Empl. Advances by Cat. Matrix',
                FRA = 'Avances salariés par matrice cat.';
    PageType = ListPart;
    SourceTable = 2000000007;

    layout
    {
    }

    actions
    {
    }



    var
        EmployeeAdvance: Record "Employee Advance";
        PeriodFormMgt: Codeunit 359;
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        AdvanceAmountType: Option "Balance at Date","Net Change";
        EmployeeNoFilter: Text[250];


    procedure MatrixUpdate(NewAdvanceType: Option "Advance to Date","Advance at Date"; NewPeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period"; NewEmployeeNoFilter: Text[250]);
    begin
    end;
}

