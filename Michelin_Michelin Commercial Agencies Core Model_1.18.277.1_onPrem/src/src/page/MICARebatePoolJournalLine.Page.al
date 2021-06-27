page 83003 "MICA Rebate Pool Journal Line"
{
    AdditionalSearchTerms = 'rebate pool, pool journal, pool worksheet';
    Caption = 'Rebate Pool Journal Line';
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "MICA Rebate Pool Journal Line";
    DelayedInsert = true;
    SaveValues = true;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Document No.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line No.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Posting Date.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Entry Type.';
                }
                field("Rebate Code"; Rec."Rebate Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Document No. for which Rebate Pool will be created.';
                }
                field("Customer Description"; Rec."Customer Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description from Rebate Setup for appropriate Rebate Code.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Customer No for which Rebate Pool will be created.';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Product Line.';
                }
                field("Business Line"; Rec."Business Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Business Line.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Business Line.';
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                    ApplicationArea = All;
                    Editable = EditRebatePoolJournalFields; //temporary for internal testing, to be removed
                    ToolTip = 'Specifies the Posted Document No.';
                }
                field("Posted Document Line No."; Rec."Posted Document Line No.")
                {
                    ApplicationArea = All;
                    Editable = EditRebatePoolJournalFields; //temporary for internal testing, to be removed
                    ToolTip = 'Specifies the Posted Document Line No.';
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    Editable = EditRebatePoolJournalFields; //temporary for internal testing, to be removed
                    ToolTip = 'Specifies the Order No.';
                }
                field("Order Line No."; Rec."Order Line No.")
                {
                    ApplicationArea = All;
                    Editable = EditRebatePoolJournalFields; //temporary for internal testing, to be removed
                    ToolTip = 'Specifies the Order Line No.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Create Rebate Pool Entries")
            {
                ApplicationArea = All;
                Caption = 'Post';
                Ellipsis = true;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Scope = Repeater;
                ToolTip = 'Create Rebate Pool Entries and Rebate Pool Detail Entries.';

                trigger OnAction()
                begin
                    MICARebatePoolMgt.CreateManuallyRebatePoolJournal();
                end;
            }
        }
    }

    var
        MICARebatePoolMgt: Codeunit "MICA Rebate Pool Mgt.";
        EditRebatePoolJournalFields: Boolean;

    //temporary for internal testing, to be removed
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId()) then
            exit;

        EditRebatePoolJournalFields := UserSetup."MICA Allow Edit Reb. Pool Jnl.";
    end;
}