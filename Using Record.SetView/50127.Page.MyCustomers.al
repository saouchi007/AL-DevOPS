/// <summary>
/// Page MyCustomers (ID 50127).
/// </summary>
page 50127 MyCustomers
{
    PageType = List;
    SourceTable = Customer;
    SourceTableView = sorting(Name, "No.") order(ascending) where("Balance (LCY)" = filter(>= 40000), "Sales (LCY)" = filter(>= 30000));
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'SAIL';

    layout
    {
        area(Content)
        {
            repeater(MyRepeater)
            {
                field(Name; Rec.Name) { }
                field(Address; Rec.Address) { }
                field("Balance (LCY)"; Rec."Balance (LCY)") { }
                field("Sales (LCY)"; Rec."Sales (LCY)") { }
            }

        }


    }
}