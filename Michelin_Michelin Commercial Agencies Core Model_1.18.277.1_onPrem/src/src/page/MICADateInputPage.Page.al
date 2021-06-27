page 80771 "MICA Date Input Page"
{
    PageType = StandardDialog;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Integer;
    SourceTableView = where(number = CONST(1));
    Caption = 'Date Input';


    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Please Enter Calculation Date"; InputDate)
                {
                    ApplicationArea = All;
                    Caption = 'Please Enter Calculation Date';
                    trigger OnValidate()
                    var
                        FinReportSetup: Record "MICA Financial Reporting Setup";
                        DateAfterLastDateErr: Label 'Calculation Date must be after the last Calculation Date (%1)';
                    begin
                        FinReportSetup.Get();
                        if FinReportSetup."Accr. Last Date Calculation" <> 0D then
                            if FinReportSetup."Accr. Last Date Calculation" > InputDate then
                                Error(DateAfterLastDateErr, FinReportSetup."Accr. Last Date Calculation");
                    end;
                }
            }
        }
    }

    var
        InputDate: Date;

    procedure GetCalcDate(var DateToGet: Date)
    begin
        DateToGet := InputDate;
    end;
}