page 81881 "MICA Rebate Date Input Page"
{
    PageType = StandardDialog;
    UsageCategory = None;
    SourceTable = Integer;
    SourceTableView = where (number = CONST (1));
    Caption = 'Date Input';


    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Please Enter Calculation Date"; InputDate)
                {
                    Caption = 'Enter a Sales Credit Memo Posting Date';
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnInit()
    begin
        InputDate := Today();
    end;

    var
        InputDate: Date;

    procedure GetCalcDate(var DateToGet: Date)
    begin
        DateToGet := InputDate;
    end;
}