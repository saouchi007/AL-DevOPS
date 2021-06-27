page 82926 "MICA 3PTY SO Exec. Card"
{
    UsageCategory = None;
    Caption = '3rd Party Sales Orders Execution';
    PageType = Card;
    SourceTable = "Sales Header";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
            part("3PTYSOExecPart"; "MICA 3PTY SO Exec. Part")
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Post)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    var
                        SalesOrder: Page "Sales Order";
                    begin
                        SalesOrder.SetRecord(Rec);
                        SalesOrder.PostDocument(CODEUNIT::"Sales-Post (Yes/No)", NavigateAfterPost::"Posted Document");
                    end;
                }
            }
            action("Autofill Qty. to Ship")
            {
                ApplicationArea = Warehouse;
                Caption = 'Autofill Qty. to Ship';
                Image = AutofillQtyToHandle;
                ToolTip = 'Have the system enter the outstanding quantity in the Qty. to Ship field.';

                trigger OnAction()
                begin
                    Rec.AutofillQtyToHandle();
                end;
            }
        }
    }

    var
        NavigateAfterPost: Option "Posted Document","New Document","Do Nothing";
}
