page 50201 BonusList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = BonusHeader;
    Caption = 'Bonus List Page';
    Editable = false;
    CardPageId = BonusCard;

    layout
    {
        area(Content)
        {
            repeater(Control)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bonus number';

                }
                field("Customer N0."; "Customer N0.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer number';

                }
                field("Starting Date"; "Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the staring date';

                }
                field("Ending Date"; "Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ending date';

                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status';

                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(CustomerCard)
            {
                ApplicationArea = All;
                Caption = 'Customer Card';
                Image = Customer;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Customer Card";
                RunPageLink = "No." = field("Customer N0.");
                ToolTip = 'Opens customer card';

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}