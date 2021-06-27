pageextension 80064 "MICA Sales Cr.Memo Subform" extends "Sales Cr. Memo Subform"
{
    layout
    {
        modify("Unit Price")
        {
            Editable = IsSalePriceAndCTCChangeable;
        }
        modify("Line Discount %")
        {
            Editable = IsSalePriceAndCTCChangeable;
        }
        addafter(Description)
        {
            field("MICA Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
            }

        }
        addlast(Control1)
        {
            field("MICA Sales Agreement No."; Rec."MICA Sales Agreement No.")
            {
                ApplicationArea = All;
            }
            field("MICA Priority Code"; Rec."MICA Priority Code")
            {
                ApplicationArea = All;
            }
            field("MICA Payment Terms Code"; Rec."MICA Payment Terms Code")
            {
                ApplicationArea = All;
            }
            field("MICA Payment Method Code"; Rec."MICA Payment Method Code")
            {
                ApplicationArea = All;
            }
            field("MICA Item Category Code"; Rec."Item Category Code")
            {
                ApplicationArea = All;
            }
            field("MICA Due Date"; Rec."MICA Due Date")
            {
                ApplicationArea = All;
            }
            field("MICA Exceptional Disc. %"; Rec."MICA Exceptional Disc. %")
            {
                ApplicationArea = All;
            }
            field("MICA Comment"; Rec."MICA Countermark")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("MICA Rebate Pool Entry No."; Rec."MICA Rebate Pool Entry No.")
            {
                ApplicationArea = All;
            }
        }

    }

    actions
    {
        addlast("&Line")
        {
            action("MICA Applied Sales Line Discount")
            {
                Caption = 'Applied Sales Line Disc.';
                Promoted = true;
                PromotedCategory = Category6;
                image = LineDiscount;
                ApplicationArea = All;

                trigger OnAction()
                var
                    AppliedSLDiscount: Record "MICA New Applied SL Discount";
                    PostedAppliedSLDiscount: Record "MICA Posted Applied SL Disc.";
                    AppliedSLDiscountPage: page "MICA Applied SL Discount";
                    PostedAppliedSLDiscountPage: page "MICA Posted Applied SL Disc";
                begin
                    if Rec."Qty. Invoiced (Base)" = 0 then begin
                        AppliedSLDiscount.Reset();
                        AppliedSLDiscount.SetRange("Document Type", Rec."Document Type");
                        AppliedSLDiscount.SetRange("Document No.", Rec."Document No.");
                        AppliedSLDiscount.SetRange("Document Line No.", Rec."Line No.");
                        AppliedSLDiscountPage.SetTableView(AppliedSLDiscount);
                        AppliedSLDiscountPage.Editable := false;
                        AppliedSLDiscountPage.Run();
                    end else begin
                        PostedAppliedSLDiscount.Reset();
                        PostedAppliedSLDiscount.SetRange("Document Type", Rec."Document Type");
                        PostedAppliedSLDiscount.SetRange("Document No.", Rec."Document No.");
                        PostedAppliedSLDiscount.SetRange("Document Line No.", Rec."Line No.");
                        PostedAppliedSLDiscountPage.SetTableView(PostedAppliedSLDiscount);
                        PostedAppliedSLDiscountPage.Run();
                    end;

                end;
            }
        }
    }

    var
        IsSalePriceAndCTCChangeable: Boolean;

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId()) then
            exit;
        IsSalePriceAndCTCChangeable := UserSetup."MICA Allow SalePrice & CTC Upd";
    end;
}