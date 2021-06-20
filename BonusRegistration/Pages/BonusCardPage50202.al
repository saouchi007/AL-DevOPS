page 50202 "BonusCard"
{
    PageType = Document;
    Caption = 'Bonus Card Page';
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = BonusHeader;

    layout
    {
        area(Content)
        {

            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies bonus number';

                }
                field("Customer N0."; "Customer N0.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies bonus customer number';

                }
                field("Starting Date"; "Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bonus staring date';

                }
                field("Ending Date"; "Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bonus ending date';

                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies bonus status';

                }

            }
            part(Lines; BonusSubform)
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
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