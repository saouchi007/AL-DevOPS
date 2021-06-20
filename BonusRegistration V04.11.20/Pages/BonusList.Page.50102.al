page 50102 BonusListPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = BonusHeaderTable;
    Caption = 'Bonuses';
    Editable = false;
    CardPageId = BonusCardPage;

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
                field("Customer No."; "Customer No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the customer number';
                }
                field("Starting Date"; "Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the starting date';
                }
                field("Ending Date"; "Ending Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the ending date';
                }
                field(Status; Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the bonus status';
                }
            }
        }
        area(Factboxes)
        {

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
                RunPageLink = "No." = field("Customer No.");
                ToolTip = 'Open customer card';



            }
        }
    }
}