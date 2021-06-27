page 83000 "MICA Rebate Pool Entries"
{
    AdditionalSearchTerms = 'rebate pool entries, pool entries';
    ApplicationArea = All;
    Caption = 'Rebate Pool Entries';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    SourceTable = "MICA Rebate Pool Entry";
    PageType = List;
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Entry Pool No.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry creation date';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Sell-to Customer No.';
                }
                field("Rebate Code"; Rec."Rebate Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Rebate Code from which Rebate Pool has been created.';
                }
                field("Customer Description"; Rec."Customer Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Customer Description.';
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
                field("Original Amount"; Rec."Original Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Original Amount.';
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Remaining Amount of Rebate Pool Entry.';
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Open Rebate Pool Entry.';
                }
                field("Closed By"; Rec."Closed By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the User who closed Rebate Pool Entry.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("Rebate Pool Dtld. Entries")
            {
                ApplicationArea = All;
                Caption = 'Rebate Pool Detail Entries';
                Image = ViewDetails;
                PromotedCategory = Process;
                Promoted = true;
                PromotedOnly = true;
                RunObject = Page "MICA Rebate Pool Dtld. Entries";
                RunPageLink = "Rebate Pool Entry No." = field("Entry No.");
            }
        }
    }


    procedure GetSelectionFilter(var MICARebatePoolEntry: Record "MICA Rebate Pool Entry"): Text
    var
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
    begin
        CurrPage.SetSelectionFilter(MICARebatePoolEntry);
        RecRef.GetTable(MICARebatePoolEntry);
        exit(SelectionFilterManagement.GetSelectionFilter(RecRef, 1))
    end;
}