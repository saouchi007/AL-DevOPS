page 80189 "MICA OFF Invoice Invoices"
{
    Caption = 'OFF Invoice-Invoices';
    PageType = List;
    SourceTable = "MICA Posted Applied SL Disc.";
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'CAD';
                }

                field(Description; Item.Description)
                {
                    ApplicationArea = All;
                }
                field("Document Type"; DocType)
                {
                    ApplicationArea = All;
                    OptionCaption = 'Invoice,Credit Memo';
                    Caption = 'Document Type';
                }

                field("Document No."; Rec."Posted Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                }

                field("Document Date"; DocDate)
                {
                    ApplicationArea = All;
                    Caption = 'Document Date';
                }

                field("Line Number"; Rec."Posted Document Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Line Number';

                }

                field("Order No."; OrderNo)
                {
                    Caption = 'Order No.';
                    ApplicationArea = All;

                }

                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                }

                field("Customer No."; Customer."No.")
                {
                    ApplicationArea = All;
                }

                field("Customer Name"; Customer.Name)
                {
                    ApplicationArea = All;

                }
                field(YourReference; YourReference)
                {
                    ApplicationArea = All;
                    Caption = 'Your reference';
                }

                field("Cust. Discount Group"; Customer."Customer Disc. Group")
                {

                    ApplicationArea = All;
                }

                field("Unit Price"; UnitPrice)
                {
                    Caption = 'Unit Price';
                    ApplicationArea = All;
                }

                field(Quantity; Qty)
                {
                    Caption = 'Quantity';
                    ApplicationArea = All;
                }

                field("Item Discount Group Code"; ItemDiscountGroup.Code)
                {
                    ApplicationArea = All;

                }

                field("Item Discount Group Description"; ItemDiscountGroup.Description)
                {
                    ApplicationArea = All;
                }
                field("Rebates Type"; RebatesType)
                {
                    ApplicationArea = All;
                    Caption = 'Rebates Type';
                    OptionCaption = 'Rebate,Payment Terms,Exceptional, ';
                }

                field("Exceptional Discount Reason"; Rec."MICA Except. Rebate Reason")
                {
                    ApplicationArea = All;
                }

                field("Sales Discount %"; Rec."Sales Discount %")
                {
                    ApplicationArea = All;
                    Caption = 'Discount %';
                }

                field("Net Discount Amount"; NetDiscountAmount)
                {
                    Caption = 'Net Discount Amount';
                    ApplicationArea = All;
                }


                field(LB1; DimensionValue.Code)
                {
                    ApplicationArea = All;
                }

                field(LB2; DimensionValue."MICA Michelin Code")
                {
                    ApplicationArea = All;
                }

                field(LP; ItemCategoryCode)
                {
                    Caption = 'LP';
                    ApplicationArea = All;
                }

                field("Pattern Code"; item."MICA Pattern Code")
                {
                    ApplicationArea = All;
                }

                field(COGS; Item."Unit Cost")
                {
                    ApplicationArea = All;
                }

                field("Location Code"; LocationCode)
                {
                    Caption = 'Location Code';
                    ApplicationArea = All;
                }

                field("Rim Diameter"; Item."MICA Rim Diameter")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec."MICA Status")
                {
                    ApplicationArea = All;
                }
                field("MICA Source Document No."; Rec."MICA Source Document No.")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    trigger OnAfterGetRecord()
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        SalesInvLine: Record "Sales Invoice Line";
    begin
        clear(SalesInvoiceLine);
        clear(SalesCrMemoLine);
        clear(Customer);
        clear(Item);
        clear(ItemDiscountGroup);
        NetDiscountAmount := 0;
        clear(DocType);
        clear(RebatesType);
        clear(Qty);
        clear(ItemCategoryCode);
        clear(LocationCode);
        clear(OrderNo);
        YourReference := '';

        GeneralLedgerSetup.Get();
        case Rec."Posted Document Type" of
            Rec."Posted Document Type"::Invoice:
                begin
                    OrderNo := Rec."Document No.";
                    if SalesInvoiceLine.get(Rec."Posted Document No.", Rec."Posted Document Line No.") then begin
                        DocType := DocType::Invoice;
                        DocDate := SalesInvoiceLine."Posting Date";
                        UnitPrice := SalesInvoiceLine."Unit Price";
                        RebatesType := Rec."Rebates Type";
                        Qty := SalesInvoiceLine.Quantity;
                        ItemCategoryCode := SalesInvoiceLine."Item Category Code";
                        LocationCode := SalesInvoiceLine."Location Code";

                        NetDiscountAmount := SalesInvoiceLine."Unit Price" * SalesInvoiceLine.Quantity * Rec."Sales Discount %" / 100;


                        if Customer.get(SalesInvoiceLine."Sell-to Customer No.") then;
                        if Item.get(SalesInvoiceLine."No.") then;

                        if DimensionValue.get(GeneralLedgerSetup."Shortcut Dimension 2 Code", SalesInvoiceLine."Shortcut Dimension 2 Code") then;
                        if SalesInvoiceHeader.get(Rec."Posted Document No.") then
                            YourReference := SalesInvoiceHeader."Your Reference";
                    end;
                end;
            Rec."Posted Document Type"::"Credit Memo":
                begin
                    if Rec."MICA Source Document No." <> '' then
                        if SalesInvLine.get(Rec."MICA Source Document No.", Rec."MICA Source Doc. Line No.") then
                            OrderNo := SalesInvLine."Order No.";

                    if SalesCrMemoLine.get(Rec."Posted Document No.", Rec."Posted Document Line No.") then begin
                        DocType := DocType::"Credit Memo";
                        DocDate := SalesCrMemoLine."Posting Date";
                        UnitPrice := SalesCrMemoLine."Unit Price";
                        RebatesType := Rec."Rebates Type";
                        Qty := SalesCrMemoLine.Quantity;
                        ItemCategoryCode := SalesCrMemoLine."Item Category Code";
                        LocationCode := SalesCrMemoLine."Location Code";

                        NetDiscountAmount := SalesCrMemoLine."Unit Price" * SalesCrMemoLine.Quantity * Rec."Sales Discount %" / 100;


                        if Customer.get(SalesCrMemoLine."Sell-to Customer No.") then;
                        if Item.get(SalesCrMemoLine."No.") then;

                        if DimensionValue.get(GeneralLedgerSetup."Shortcut Dimension 2 Code", SalesInvoiceLine."Shortcut Dimension 2 Code") then;

                        if SalesCrMemoHeader.get(Rec."Posted Document No.") then
                            YourReference := SalesCrMemoHeader."Your Reference";
                    end;
                end;
        end;
        if Rec.Type = Rec.Type::"Item Disc. Group" then
            if ItemDiscountGroup.get(Rec.Code) then;



    end;

    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        Customer: Record Customer;
        Item: Record Item;
        ItemDiscountGroup: Record "Item Discount Group";
        DimensionValue: Record "Dimension Value";
        NetDiscountAmount: Decimal;
        DocType: Option Invoice,"Credit Memo";
        DocDate: Date;
        UnitPrice: Decimal;
        RebatesType: Option Rebate,"Payment Terms",Exceptional," ";
        Qty: Decimal;
        ItemCategoryCode: Code[20];
        LocationCode: Code[10];
        OrderNo: Code[20];
        YourReference: Text[35];

}