page 50103 BonusCardPage
{
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = BonusHeaderTable;
    Caption = 'Bonus Card';

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
                    ToolTip = 'Specicifes bonus number';
                }
                field("Customer No."; "Customer No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies customer number';
                }
                field("Starting Date"; "Starting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies bonus starting date';
                }
                field("Ending Date"; "Ending Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies bonus ending date';
                }
                field(Status; Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies bonus status';
                }

            }
            part(Lines; BonusSubformPage)
            {
                ApplicationArea = all;
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
                ApplicationArea = all;
                Caption = 'Customer Card';
                Image = Customer;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Customer Card";
                RunPageLink = "No." = field("Customer No.");
                ToolTip = 'Opens customer card';
            }
            action(BonusEntries)
            {
                ApplicationArea = All;
                Caption = 'Bonus Entries';
                Image = Entry;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page BonusEntries;
                RunPageLink = "Bonus No." = field("No.");
                ToolTip = 'Open Bonus Entries';
            }
        }
    }
}