page 81780 "MICA Sales Order Lines"
{
    PageType = List;
    Caption = 'Sales Order Lines';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Sales Line";
    SourceTableView = where("Document Type" = const(Order));
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field(Reserve; Rec.Reserve)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = All;
                }
                field("Qty. to Ship"; Rec."Qty. to Ship")
                {
                    ApplicationArea = All;
                }
                field("Reserved Qty. (Base)"; Rec."Reserved Qty. (Base)")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("ShortcutDimCode[3]"; ShortcutDimCode[3])
                {
                    ApplicationArea = All;
                    Caption = 'ShortcutDimCode[3]';
                }
                field("ShortcutDimCode[4]"; ShortcutDimCode[4])
                {
                    ApplicationArea = All;
                    Caption = 'ShortcutDimCode[4]';
                }
                field("ShortcutDimCode[5]"; ShortcutDimCode[5])
                {
                    ApplicationArea = All;
                    Caption = 'ShortcutDimCode[5]';
                }
                field("ShortcutDimCode[6]"; ShortcutDimCode[6])
                {
                    ApplicationArea = All;
                    Caption = 'ShortcutDimCode[6]';
                }
                field("ShortcutDimCode[7]"; ShortcutDimCode[7])
                {
                    ApplicationArea = All;
                    Caption = 'ShortcutDimCode[7]';
                }
                field("ShortcutDimCode[8]"; ShortcutDimCode[8])
                {
                    ApplicationArea = All;
                    Caption = 'ShortcutDimCode[8]';
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = All;
                }

                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = All;
                }
                field("Promised Delivery Date"; Rec."Promised Delivery Date")
                {
                    ApplicationArea = All;
                }
                field("Planned Shipment Date"; Rec."Planned Shipment Date")
                {
                    ApplicationArea = All;
                }
                field("Planned Delivery Date"; Rec."Planned Delivery Date")
                {
                    ApplicationArea = All;
                }
                field("MICA Status"; Rec."MICA Status")
                {
                    ApplicationArea = All;
                }
                field("MICA Cancel. Reason"; Rec."MICA Cancel. Reason")
                {
                    ApplicationArea = All;
                }
                field("MICA Cancelled"; Rec."MICA Cancelled")
                {
                    ApplicationArea = All;
                }
                field("MICA Prev. Planned Del. Date"; Rec."MICA Prev. Planned Del. Date")
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
            action(ShowDocument)
            {
                ApplicationArea = all;
                caption = 'Show Document';
                ToolTip = 'Open the document that the selected line exists on.';
                Image = View;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ShortcutKey = 'Shift+F7';
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    PageManagement: Codeunit "Page Management";
                begin
                    SalesHeader.GET(Rec."Document Type", Rec."Document No.");
                    PageManagement.PageRun(SalesHeader);
                end;
            }
            action(ShowReservationEntries)
            {
                ApplicationArea = Reservation;
                Image = ReservationLedger;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Reservation Entries';
                ToolTip = 'View the entries for every reservation that is made, either manually or automatically.';
                AccessByPermission = tabledata item = r;
                trigger OnAction()
                begin
                    Rec.ShowReservationEntries(TRUE);
                end;
            }
            action(ItemTrackingLines)
            {
                ApplicationArea = ItemTracking;
                Image = ItemTrackingLines;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Item &Tracking Lines';
                ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';
                ShortcutKey = 'Shift+Ctrl+I';
                trigger OnAction()
                begin
                    Rec.OpenItemTrackingLines();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetFilter("Outstanding Qty. (Base)", '>%1', 0);
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        CLEAR(ShortcutDimCode);
    end;

    var
        ShortcutDimCode: array[8] of Code[20];
}