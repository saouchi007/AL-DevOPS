page 50105 BonusEntries
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = BonusEntry;
    Caption = 'Bonus Entries';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Control)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies entry number for the ledger';

                }
                field("Bonus No."; "Bonus No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies bonus number';
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies sales invoice number';
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies item number';
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies posting date';
                }
                field("Bonus amount"; "Bonus amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies calculated bonus amount';
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}