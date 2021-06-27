page 80763 "MICA Accrual Item Groups"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "MICA Accrual Item Group";
    Caption = 'Rebate Item Groups';

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
    procedure SetSelection(var MICAAccrualItemGroup: Record "MICA Accrual Item Group")
    begin
        CurrPage.SetSelectionFilter(MICAAccrualItemGroup);
    end;
}