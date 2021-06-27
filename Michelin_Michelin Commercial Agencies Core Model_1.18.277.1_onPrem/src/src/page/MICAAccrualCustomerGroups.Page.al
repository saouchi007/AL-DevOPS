page 80764 "MICA Accrual Customer Groups"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "MICA Accrual Customer Group";
    Caption = 'Rebate Customer Groups';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;

                }
                field(Description; Rec."Description")
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    procedure SetSelection(var MICAAccrualCustomerGroup: Record "MICA Accrual Customer Group")
    begin
        CurrPage.SetSelectionFilter(MICAAccrualCustomerGroup);
    end;
}