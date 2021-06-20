pageextension 50100 CustomerListExt extends "Customer List"
{
    layout
    {
        addlast(Control1)
        {
            field(Bonuses; Bonuses)
            {
                ApplicationArea = All;
                ToolTip = 'Shows number of assigned bonuses to customer';
            }
        }
    }

    actions
    {
        addlast(Navigation)
        {
            action(BonusList)
            {
                Caption = 'Bonuses';
                ApplicationArea = All;
                Image = Discount;
                RunObject = page BonusListPage;
                RunPageLink = "Customer No." = field("No.");
            }
        }
    }

    var
        myInt: Integer;
}