page 80026 "MICA Forecaste Cust Code List"
{

    PageType = List;
    SourceTable = "MICA Forecast Customer Code";
    Caption = 'Forecast customer code list';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Customer Code"; Rec."Customer Code")
                {
                    ApplicationArea = All;
                }
                field("Product Line"; Rec."Product Line")
                {
                    ApplicationArea = All;
                }
                field("Forecaste Code"; Rec."Forecast Code")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {

        }
    }
}