page 80188 "MICA OFF Invoice Orders"
{
    Caption = 'OFF Invoice-Orders';
    PageType = List;
    SourceTable = "MICA New Applied SL Discount";
    SourceTableView = WHERE("Document Type" = CONST(Order));
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
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                }

                field("Document Date"; OrderSalesHeader."Order Date")
                {
                    ApplicationArea = All;
                }
                field("Line Number"; Rec."Document Line No.")
                {
                    Caption = 'Line Number';
                    ApplicationArea = All;
                }

                field("Order Number"; Rec."Document No.")
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
                    Caption = 'Customer No.';
                }

                field("Customer Name"; Customer.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
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

                field("Unit Price"; SourceSalesLine."Unit Price")
                {
                    ApplicationArea = All;
                }

                field(Quantity; SourceSalesLine.Quantity)
                {
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
                field("Rebates Type"; Rec."Rebates Type")
                {
                    ApplicationArea = All;
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
                    Caption = 'LB1';
                }

                field(LB2; DimensionValue."MICA Michelin Code")
                {
                    ApplicationArea = All;
                    Caption = 'LB2';
                }

                field(LP; SourceSalesLine."Item Category Code")
                {
                    ApplicationArea = All;
                    Caption = 'LP';
                }

                field("Pattern Code"; item."MICA Pattern Code")
                {
                    ApplicationArea = All;
                    Caption = 'Pattern Code';
                }

                field(COGS; Item."Unit Cost")
                {
                    ApplicationArea = All;
                    Caption = 'COGS';
                }

                field("Location Code"; SourceSalesLine."Location Code")
                {
                    ApplicationArea = All;
                }

                field("Rim Diameter"; Item."MICA Rim Diameter")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
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
    begin
        clear(SourceSalesLine);
        clear(Customer);
        Clear(OrderSalesHeader);
        clear(Item);
        clear(ItemDiscountGroup);
        NetDiscountAmount := 0;
        YourReference := '';

        if SourceSalesLine.get(Rec."Document Type", Rec."Document No.", Rec."Document Line No.") then
            NetDiscountAmount := SourceSalesLine."Unit Price" * SourceSalesLine.Quantity * Rec."Sales Discount %" / 100;

        if OrderSalesHeader.get(Rec."Document Type", Rec."Document No.") then;
        if Customer.get(OrderSalesHeader."Sell-to Customer No.") then;
        if Item.get(SourceSalesLine."No.") then;
        if Rec.Type = Rec.Type::"Item Disc. Group" then
            if ItemDiscountGroup.get(Rec.Code) then;

        GeneralLedgerSetup.Get();
        if DimensionValue.get(GeneralLedgerSetup."Shortcut Dimension 2 Code", SourceSalesLine."Shortcut Dimension 2 Code") then;

        YourReference := OrderSalesHeader."Your Reference";

    end;

    var
        SourceSalesLine: Record "Sales Line";
        OrderSalesHeader: Record "Sales Header";
        Customer: Record Customer;
        Item: Record Item;

        ItemDiscountGroup: Record "Item Discount Group";

        DimensionValue: Record "Dimension Value";

        NetDiscountAmount: Decimal;

        YourReference: Text[35];
}