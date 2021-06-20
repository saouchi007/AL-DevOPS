page 50300 CustomerPage
{
    PageType = List;
    SourceTable = CustomerTable;

    layout
    {
        area(Content)
        {
            repeater(Rep)
            {
                field("Customer No."; "Customer No.")
                {
                    ApplicationArea = All;
                }

                field(Name; Name)
                {
                    ApplicationArea = all;
                }
                field("Has sales invoices"; "Has Invoice")
                {
                    ApplicationArea = All;
                }
                field("Invoices Total"; "Invoices Total")
                {
                    ApplicationArea = All;
                }
                field("Invoices Average"; "Invoices Average")
                {
                    ApplicationArea = All;
                }
                field("Invoices Count"; "Invoice Count")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}