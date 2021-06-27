page 82928 "MICA 3PTY SO Exec. List"
{
    UsageCategory = Lists;
    ApplicationArea = All;
    Caption = '3rd Party Sales Orders Execution List';
    PageType = List;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = const(Order), Status = const(Released));
    CardPageId = "MICA 3PTY SO Exec. Card";
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
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
                    Caption = 'Document Date';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                }
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
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        Rec.SetRange("MICA 3rd Party Vendor No.", UserSetup."MICA 3rd Party Vendor No.");
    end;

    var
        NavigateAfterPost: Option "Posted Document","New Document","Do Nothing";
}
