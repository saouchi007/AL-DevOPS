pageextension 80140 "MICA Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        modify("Unit Price")
        {
            Editable = EnableEditSalesPriceAndCTC;
        }
        modify("Line Discount %")
        {
            Editable = EnableEditSalesPriceAndCTC;
        }
        modify("Invoice Discount Amount")
        {
            Editable = EnableEditSalesPriceAndCTC;
        }
        modify("Invoice Disc. Pct.")
        {
            Editable = EnableEditSalesPriceAndCTC;
        }
        modify("Prepayment %")
        {
            Visible = true;
            Editable = EnableEditSalesPriceAndCTC;
        }
        modify("Unit Cost (LCY)")
        {
            Visible = true;
            Editable = EnableEditSalesPriceAndCTC;
        }
        modify("Prepmt. Line Amount")
        {
            Visible = true;
            Editable = EnableEditSalesPriceAndCTC;
        }
        modify("Prepmt Amt to Deduct")
        {
            Visible = true;
            Editable = EnableEditSalesPriceAndCTC;
        }
        modify("Prepmt Amt Deducted")
        {
            Visible = true;
            Editable = EnableEditSalesPriceAndCTC;
        }
        modify("Line Discount Amount")
        {
            Visible = true;
            Editable = EnableEditSalesPriceAndCTC;
        }
        modify("Line Amount")
        {
            Visible = true;
            Editable = EnableEditSalesPriceAndCTC;
        }
        addlast(Control1)
        {
            field("MICA Splitted Line"; Rec."MICA Splitted Line")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("MICA Sales Agreement No."; Rec."MICA Sales Agreement No.")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("MICA Priority Code"; Rec."MICA Priority Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("MICA Payment Terms Code"; Rec."MICA Payment Terms Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("MICA Payment Method Code"; Rec."MICA Payment Method Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("MICA Item Category Code"; Rec."Item Category Code")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
            }
            field("MICA Due Date"; Rec."MICA Due Date")
            {
                ApplicationArea = All;
                Visible = false;
            }

            field("MICA 3PL Country Of Origin"; Rec."MICA 3PL Country Of Origin")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
            }
            field("MICA 3PL DOT Value"; Rec."MICA 3PL DOT Value")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
            }

            field("MICA Delivery Date Modified"; Rec."MICA Delivery Date Modified")
            {
                ApplicationArea = All;
                Visible = false;
            }

            field("MICA Cancelled"; Rec."MICA Cancelled")
            {
                ApplicationArea = All;
                Visible = false;
            }

            field("MICA Inv. Discrepancy"; Rec."MICA Inv. Discrepancy")
            {
                ApplicationArea = All;
            }

            field("MICA Source Line Commit Date"; Rec."MICA Source Line Commit Date")
            {
                ApplicationArea = All;
            }
            field("MICA Reserve"; Rec."Reserve")
            {
                ApplicationArea = All;
                Visible = false;
                trigger OnValidate()
                var
                    SalesReceivablesSetup: Record "Sales & Receivables Setup";
                    CommitmentOverCommitmentPeriodErr: Label 'The commitment is over the commitment Period';
                begin
                    SalesReceivablesSetup.Get();
                    if format(SalesReceivablesSetup."MICA Commitment Period") <> '' then
                        if (xRec.Reserve = xRec.Reserve::Optional) and (Rec.Reserve <> Rec.Reserve::Optional) and (Rec."Requested Delivery Date" > CalcDate(SalesReceivablesSetup."MICA Commitment Period", WorkDate())) then
                            Error(CommitmentOverCommitmentPeriodErr);

                end;
            }
            field("MICA Requested Receipt Date"; Rec."MICA Requested Receipt Date")
            {
                ApplicationArea = All;
                Visible = false;
            }

            field("MICA Promised Receipt Date"; Rec."MICA Promised Receipt Date")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("MICA Prev. Planned Del. Date"; Rec."MICA Prev. Planned Del. Date")
            {
                ApplicationArea = All;
                Visible = false;
                Editable = false;
            }

            field("MICA Courntermark"; Rec."MICA Countermark")
            {
                ApplicationArea = all;
            }
            field("MICA 3PL Whse Shpt. Comment"; Rec."MICA 3PL Whse Shpt. Comment")
            {
                ApplicationArea = All;
            }

            field("MICA Cancel. Reason"; Rec."MICA Cancel. Reason")
            {
                ApplicationArea = All;
            }
            field("MICA Last Date Update Status"; Rec."MICA Last Date Update Status")
            {
                ApplicationArea = All;
            }
            field("MICA Transport Instruction"; Rec."MICA Transport Instruction")
            {
                ApplicationArea = All;
                Editable = TransportInstructionIsEditable;
            }
        }

        modify("Cross-Reference No.")
        {
            ApplicationArea = All;
            Visible = false;
        }

        modify("Planned Delivery Date")
        {
            Visible = false;
            Editable = EnableEditDatesSOlines;
        }
        addafter("No.")
        {
            field("MICA Catalog Item No."; Rec."MICA Catalog Item No.")
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                    MICACustomerAssortment: codeunit "MICA CustomerAssortment";
                begin
                    MICACustomerAssortment.OnAssistEditMICACatalogItemNo(Rec);
                end;
            }
        }

        addafter(Description)
        {
            field("MICA Status"; Rec."MICA Status")
            {
                ApplicationArea = All;
            }
            field("MICA Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
            }
        }

        addafter("Line Discount %")
        {
            field("MICA Exceptional Disc. %"; Rec."MICA Exceptional Disc. %")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    DeltaUpdateTotals();
                end;
            }
            field("MICA Except. Rebate Reason"; Rec."MICA Except. Rebate Reason")
            {
                ApplicationArea = All;
            }


        }

        modify("Unit of Measure Code")
        {
            Visible = false;
        }
        modify("Qty. to Ship")
        {
            Visible = false;
        }
        modify("Qty. to Invoice")
        {
            Visible = false;
        }
        modify("Quantity Shipped")
        {
            Visible = false;
        }
        modify("Quantity Invoiced")
        {
            Visible = false;
        }
        modify("Qty. to Assign")
        {
            Visible = false;
        }
        modify("Qty. Assigned")
        {
            Visible = false;
        }
        modify("Shipment Date")
        {
            Visible = false;
            Editable = EnableEditDatesSOlines;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = false;
        }

        modify(ShortcutDimCode3)
        {
            Visible = false;
        }

        modify(ShortcutDimCode4)
        {
            Visible = false;
        }

        modify(ShortcutDimCode5)
        {
            Visible = false;
        }

        modify(ShortcutDimCode6)
        {
            Visible = false;
        }

        modify(ShortcutDimCode7)
        {
            Visible = false;
        }

        modify(ShortcutDimCode8)
        {
            Visible = false;
        }

        modify("Qty. to Assemble to Order")
        {
            Visible = false;
        }

        modify("Drop Shipment")
        {
            Visible = false;
        }

        modify("Purchasing Code")
        {
            Visible = false;
        }
        modify("Requested Delivery Date")
        {
            Editable = EnableEditDatesSOlines;
        }
        modify("Planned Shipment Date")
        {
            Editable = EnableEditDatesSOlines;
        }

        moveafter(Description; Quantity)
        moveafter(Quantity; "Reserved Quantity")
        addafter("MICA Status")
        {
            field("MICA Promised Delivery Date"; Rec."Promised Delivery Date")
            {
                ApplicationArea = All;
                Editable = EnableEditDatesSOlines;
            }
        }
        moveafter("MICA Promised Delivery Date"; "Planned Shipment Date")
        moveafter("Line Amount"; "Location Code")

        addafter("MICA 3PL Whse Shpt. Comment")
        {
            field("MICA Exempt from 3PL Ant. Chk."; Rec."MICA Exempt from 3PL Ant. Chk.")
            {
                ApplicationArea = All;
            }
        }
        modify("Promised Delivery Date")
        {
            Editable = EnableEditDatesSOlines;
        }
    }

    actions
    {
        addbefore("&Line")
        {
            action("MICA SplitLine")
            {
                Caption = 'Commit';
                Image = Delivery;
                ShortCutKey = 'Ctrl+F12';
                ApplicationArea = All;
                trigger OnAction()
                var
                    SplitLineManagement: Codeunit "MICA Split Line Management";
                begin
                    SplitLineManagement.SplitLine(Rec, false, false, false);
                    CurrPage.UPDATE(FALSE);
                end;
            }
        }
        addlast("Related Information")
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
        addlast("F&unctions")
        {
            action("MICA Split Manually")
            {
                ApplicationArea = All;
                Caption = 'Split Manually';
                Image = Splitlines;
                trigger OnAction()
                var
                    MICASplitSalesLn: Codeunit "MICA SplitSalesLine";
                    MICASelQty: Page "MICA Select Quantity";
                    myQuantity: Decimal;
                    myKeepCommitment: Boolean;
                    myReallocateQuantity: Boolean;
                begin
                    MICASelQty.LookupMode(true);
                    if MICASelQty.RunModal() = Action::LookupOK then begin
                        myQuantity := MICASelQty.GetQuantity();
                        myKeepCommitment := MICASelQty.GetKeepCommitment();
                        myReallocateQuantity := MICASelQty.GetReallocateQuantity();

                        MICASplitSalesLn.SplitSalesLineUI(Rec, myKeepCommitment, myReallocateQuantity, myQuantity);
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId()) then
            exit;
        EnableEditSalesPriceAndCTC := UserSetup."MICA Allow SalePrice & CTC Upd";
        EnableEditDatesSOlines := UserSetup."MICA Allow Dates SO lines";

    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateTransportInstructionEditable();
    end;

    local procedure UpdateTransportInstructionEditable()
    var
        SalesHeader: Record "Sales Header";
    begin
        if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then
            TransportInstructionIsEditable := not ((SalesHeader.Status = SalesHeader.Status::Released) or (SalesHeader.Status = SalesHeader.Status::"Pending Approval"));
    end;

    var
        EnableEditSalesPriceAndCTC: Boolean;
        EnableEditDatesSOlines: Boolean;
        TransportInstructionIsEditable: Boolean;
}