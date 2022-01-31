/// <summary>
/// PageExtension CustomerList_Ext (ID 50132) extends Record Customer List.
/// </summary>
pageextension 50132 CustomerList_Ext extends "Customer List"
{
    layout
    {
        addafter("No.")
        {
            field(LedgEntr; LedgEntr)
            {
                ApplicationArea = all;
                ShowCaption = false;
                Style = Unfavorable;

                trigger OnDrillDown()
                var
                    LedgEntry: Record "Cust. Ledger Entry";
                begin
                    LedgEntry.SetCurrentKey("Customer No.");
                    LedgEntry.SetAscending("Customer No.", false);
                    LedgEntry.SetRange("Customer No.", Rec."No.");
                    Page.Run(Page::"Customer Ledger Entries", LedgEntry);
                    ;
                end;
            }
            field(Prices; Prices)
            {
                ApplicationArea = all;
                ShowCaption = false;
                Style = Favorable;

                trigger OnDrillDown()
                var
                    Prices: Record "Sales Price";
                begin
                    Prices.SetCurrentKey("Sales Code");
                    Prices.SetAscending("Sales Code", false);
                    Prices."Sales Code" := Rec."No.";
                    Message(Rec."No.");
                    Page.Run(Page::"Sales Prices", Prices);
                end;
            }
            field(NewOrder; NewOrder)
            {
                ApplicationArea = all;
            }

        }
    }

    actions
    {
        addafter(PaymentRegistration)
        {
            action("Run Message")
            {
                Caption = 'Run Message';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = ExecuteBatch;
                RunObject = page "Sales Orders";
                Scope = Repeater;
            }
        }
    }
    var
        LedgEntr: Label 'Ledg. Entries';
        Prices: Label 'Prices';
        NewOrder: Label 'New Order';
}

