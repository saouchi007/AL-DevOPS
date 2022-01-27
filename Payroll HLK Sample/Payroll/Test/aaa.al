page 50103 Customers
{
    PageType = Card;
    SourceTable = Customer;
    PromotedActionCategories = 'New,Process,Report,Manage,New Document,Request Approval,Customer,Page';

    actions
    {
        area(Creation)
        {
            group(nounou)
            {
                action("Sales Quote")
                {
                    Promoted = true;
                    PromotedCategory = Category5;  // PromotedActionCategories = New Document
                    PromotedOnly = true;
                    PromotedIsBig = true;
                    Image = NewSalesQuote;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        Message('Create sales quote');
                    end;
                }
                action("Sales Invoice")
                {
                    Promoted = true;
                    PromotedCategory = Category5;  // PromotedActionCategories = New Document
                    Image = SalesInvoice;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                    end;
                }
            }
        }
        area(Processing)
        {
            action("Send Approval Request")
            {
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Category6;  // PromotedActionCategories = Request Approval
                Image = SendApprovalRequest;
                ApplicationArea = All;
                trigger OnAction()
                begin
                end;
            }
            action("Cancel Approval Request")
            {
                Promoted = true;
                PromotedCategory = Category6;  // PromotedActionCategories = Request Approval
                Image = CancelApprovalRequest;
                ApplicationArea = All;
                trigger OnAction()
                begin
                end;
            }
        }
        area(Navigation)
        {
            action(Contact)
            {
                Promoted = true;
                PromotedCategory = Category7;  // PromotedActionCategories = Customer
                PromotedIsBig = true;
                Image = CustomerContact;
                ApplicationArea = All;
                trigger OnAction()
                begin
                end;
            }
            action("Account Details")
            {
                Promoted = true;
                PromotedCategory = Category7;  // PromotedActionCategories = Customer
                Image = Account;
                ApplicationArea = All;
                trigger OnAction()
                begin
                end;
            }
        }
    }
}