page 80182 "MICA Applied Sales Line Disc."
{
    // version OFFINVOICE

    Caption = 'Applied Sales Line Disc.';
    Editable = false;
    PageType = List;
    SourceTable = "MICA Applied Sales Line Disc.";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Rebates Type"; Rec."Rebates Type")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Sales Type"; Rec."Sales Type")
                {
                    ApplicationArea = All;
                }
                field("Sales Code"; Rec."Sales Code")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Product Line"; Rec."Product Line")
                {
                    ApplicationArea = All;
                }
                field(Brand; Rec.Brand)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Sales Discount %"; Rec."Sales Discount %")
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                }
                field("Posted Document No."; Rec."Posted Document No.")
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
            action(CalculatePriceAndDisc)
            {
                ApplicationArea = All;
                Caption = 'Re-Calculate Price & Rebates';
                Image = CalculateInvoiceDiscount;
                Promoted = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    AppliedSalesLineDisc: Record "MICA Applied Sales Line Disc.";
                    SalesLine: Record "Sales Line";
                    SalesHeader: Record "Sales Header";
                    TempSalesLine: Record "Sales Line" Temporary;
                    AskRecalcul_Msg: label 'Do you confirm the Re-calculation of price and discount ?';
                    Recalculated_Msg: label 'Price & Discount re-Calculated';
                    NothingToRecalculate_Msg: label 'There is nothing to recalculate.';
                begin
                    if NOT CONFIRM(AskRecalcul_Msg) then
                        exit;

                    AppliedSalesLineDisc.RESET();
                    CurrPage.SetSelectionFilter(AppliedSalesLineDisc);
                    if AppliedSalesLineDisc.FindSet() then Begin
                        repeat
                            if SalesLine.get(AppliedSalesLineDisc."Document Type", AppliedSalesLineDisc."Document No.", AppliedSalesLineDisc."Document Line No.") then
                                if SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.") THEN
                                    if SalesHeader.Status <> SalesHeader.Status::Open then
                                        if (SalesLine."MICA Status" = SalesLine."MICA Status"::"Waiting Allocation") OR (SalesLine."MICA Status" = SalesLine."MICA Status"::Open) then
                                            If NOT TempSalesLine.Get(SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.") then begin
                                                TempSalesLine.init();
                                                TempSalesLine.TransferFields(SalesLine);
                                                TempSalesLine.INSERT();
                                            end;
                        until AppliedSalesLineDisc.next() = 0;

                        if TempSalesLine.Findset() then
                            repeat
                                SalesLine.Reset();
                                if SalesLine.get(TempSalesLine."Document Type", TempSalesLine."Document No.", TempSalesLine."Line No.") then;
                                AppliedSalesLineDisc.reset();
                                AppliedSalesLineDisc.Setrange("Document Type", SalesLine."Document Type");
                                AppliedSalesLineDisc.SetRange("Document No.", SalesLine."Document No.");
                                AppliedSalesLineDisc.SetRange("Document Line No.", SalesLine."Line No.");
                                if NOT AppliedSalesLineDisc.IsEmpty() then begin
                                    AppliedSalesLineDisc.DeleteAll();

                                    if SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.") THEN begin
                                        SalesHeader."Posting Date" := WorkDate();
                                        SalesHeader."Order Date" := WorkDate();
                                        SalesHeader.MODIFY();

                                        SalesLine."System-Created Entry" := true;
                                        SalesLine.Modify();

                                        SalesLine.UpdateUnitPrice(SalesLine.FIELDNO("Posting Date"));
                                        SalesLine."System-Created Entry" := false;
                                        SalesLine.Modify();
                                    end;
                                end;
                            until TempSalesLine.Next() = 0;
                        MESSAGE(Recalculated_Msg);

                    end else
                        message(NothingToRecalculate_Msg);
                end;
            }
        }
    }
}

