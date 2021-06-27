page 81861 "MICA Value Entries Query"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Value Entries Query';
    SourceTable = "MICA Value Entries Query Table";
    SourceTableTemporary = true;
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Item No."; Rec.Item_No_)
                {
                    ApplicationArea = All;
                }
                field("MICA_Item_Class"; Rec.MICA_Item_Class)
                {
                    ApplicationArea = All;
                }
                field("Item_Description"; Rec.Item_Description)
                {
                    ApplicationArea = All;
                }

                field("Posting Date"; Rec.Posting_Date)
                {
                    ApplicationArea = All;
                }
                field("Item Ledger Entry Type"; Rec.Item_Ledger_Entry_Type)
                {
                    ApplicationArea = All;
                }
                field("Bill-To"; Rec.Source_No_)
                {
                    ApplicationArea = All;
                }
                field("Bill-To Name"; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Location Page"; Rec.Location_Code)
                {
                    ApplicationArea = All;
                }
                field("Invoiced Quantity"; Rec.Invoiced_Quantity)
                {
                    ApplicationArea = All;
                }
                field("Sales Amount (Actual)"; Rec.Sales_Amount__Actual_)
                {
                    ApplicationArea = All;
                }
                field("Amount Including VAT"; Rec.Amount_Including_VAT)
                {
                    ApplicationArea = All;
                }
                field("Discount Amount"; Rec.Discount_Amount)
                {
                    ApplicationArea = All;
                }
                field("Section Code"; Rec.Global_Dimension_1_Code)
                {
                    ApplicationArea = All;
                }
                field("Structure Code"; Rec.Global_Dimension_2_Code)
                {
                    ApplicationArea = All;
                }
                field("Business Line"; Rec.Business_Line)
                {
                    ApplicationArea = All;
                }
                field("Source Type"; Rec.Source_Type)
                {
                    ApplicationArea = All;
                }
                field("Cost Amount (Actual)"; Rec.Cost_Amount__Actual_)
                {
                    ApplicationArea = All;
                }
                field("Sales pers/Purch. Code"; Rec.Salespers__Purch__Code)
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec.Document_Type)
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec.Document_No_)
                {
                    ApplicationArea = All;
                }
                field("Order No."; Rec.Order_No_)
                {
                    ApplicationArea = All;
                }
                field("No. 2"; Rec.No__2)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Item Category Code"; Rec.Item_Category_Code)
                {
                    ApplicationArea = All;
                }
                field(Brand; Rec.MICA_Brand)
                {
                    ApplicationArea = All;
                }
                field("Product segment"; Rec.MICA_Product_Segment)
                {
                    ApplicationArea = All;
                }
                field("Tire Size"; Rec.MICA_Tire_Size)
                {
                    ApplicationArea = All;
                }
                field("Pattern Code"; Rec.MICA_Pattern_Code)
                {
                    ApplicationArea = All;
                }
                field("Product Unit Weight"; Rec.MICA_Product_Weight)
                {
                    ApplicationArea = All;
                }
                field("Commercial Label"; Rec.MICA_Commercial_Label)
                {
                    ApplicationArea = All;
                }
                field("Rim Diameter"; Rec.MICA_Rim_Diameter)
                {
                    ApplicationArea = All;
                }
                field("Sell-To"; Rec.Source_No_Item_Ledger_Entry)
                {
                    ApplicationArea = All;
                }
                field("Sell-To Name"; Rec.Sell_To_Name)
                {
                    ApplicationArea = All;
                }
                field("Market Code"; Rec.MICA_Market_Code)
                {
                    ApplicationArea = All;
                }
                field("Territory Code"; Rec."Territory_Code")
                {
                    ApplicationArea = All;
                }
                field("Customer Disc. Group"; Rec.Customer_Disc__Group)
                {
                    ApplicationArea = All;
                }
                field("Forecast Code"; Rec.Forecast_Code)
                {
                    ApplicationArea = All;
                }
                field("MICA_Item_Charge_No_"; Rec.MICA_Item_Charge_No_)
                {
                    ApplicationArea = All;
                }
                field("MICA_Ship_To_Code"; Rec.MICA_Ship_To_Code)
                {
                    ApplicationArea = All;
                }
                field("MICA_Ship_To_Name"; Rec.MICA_Ship_To_Name)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        MICAValueEntries: Query "MICA Value Entries";
        NumberOfRows: Integer;
        MyDateFormula: Text;
        MyDateFormulaLbl: Label '<-CM-%1M>', Comment = '%1', Locked = true;
    begin
        if (MICAFinancialReportingSetup.Get()) and (MICAFinancialReportingSetup."Value Entries Parameter" <> 0) then
            MyDateFormula := StrSubstNo(MyDateFormulaLbl, MICAFinancialReportingSetup."Value Entries Parameter" - 1)
        else
            MyDateFormula := '<-CM>';
        MICAValueEntries.SetFilter(MICAValueEntries.Posting_Date, '>=%1', CalcDate(MyDateFormula, WorkDate()));
        MICAValueEntries.Open();
        while MICAValueEntries.Read() do begin
            NumberOfRows += 1;
            Rec.Amount_Including_VAT := 0;
            Rec.ID := NumberOfRows;
            Rec.Item_No_ := MICAValueEntries.Item_No_;
            Rec.Posting_Date := MICAValueEntries.Posting_Date;
            Rec.Item_Ledger_Entry_Type := format(MICAValueEntries.Item_Ledger_Entry_Type);
            Rec.Source_No_ := MICAValueEntries.Source_No_;
            Rec.Name := MICAValueEntries.Name;
            Rec.Location_Code := MICAValueEntries.Location_Code;
            Rec.Invoiced_Quantity := MICAValueEntries.Invoiced_Quantity;
            Rec.Sales_Amount__Actual_ := MICAValueEntries.Sales_Amount__Actual_;
            Rec.Discount_Amount := MICAValueEntries.Discount_Amount;
            Rec.Global_Dimension_1_Code := MICAValueEntries.Global_Dimension_1_Code;
            Rec.Global_Dimension_2_Code := MICAValueEntries.Global_Dimension_2_Code;
            Rec.Business_Line := MICAValueEntries.Business_Line;
            Rec.Source_Type := format(MICAValueEntries.Source_Type);
            Rec.Cost_Amount__Actual_ := MICAValueEntries.Cost_Amount__Actual_;
            Rec.Salespers__Purch__Code := MICAValueEntries.Salespers__Purch__Code;
            Rec.Document_Type := MICAValueEntries.Document_Type.AsInteger();
            Rec.Document_No_ := MICAValueEntries.Document_No_;
            Rec.Order_No_ := MICAValueEntries.Order_No_;
            Rec.No__2 := MICAValueEntries.No__2;
            Rec.Type := Format(MICAValueEntries.Type);
            Rec.Item_Category_Code := MICAValueEntries.Item_Category_Code;
            Rec.MICA_Brand := MICAValueEntries.MICA_Brand;
            Rec.MICA_Product_Segment := MICAValueEntries.MICA_Product_Segment;
            Rec.MICA_Tire_Size := MICAValueEntries.MICA_Tire_Size;
            Rec.MICA_Pattern_Code := MICAValueEntries.MICA_Pattern_Code;
            Rec.MICA_Product_Weight := MICAValueEntries.MICA_Product_Weight;
            Rec.MICA_Commercial_Label := MICAValueEntries.MICA_Commercial_Label;
            Rec.MICA_Rim_Diameter := MICAValueEntries.MICA_Rim_Diameter;
            Rec.Source_No_Item_Ledger_Entry := MICAValueEntries.Source_No_Item_Ledger_Entry;
            Rec.Sell_To_Name := MICAValueEntries.Sell_To_Name;
            Rec.MICA_Market_Code := MICAValueEntries.MICA_Market_Code;
            Rec."Territory_Code" := MICAValueEntries.Territory_Code;
            Rec.Forecast_Code := MICAValueEntries.Forecast_Code;

            if Rec.Document_Type = Rec.Document_Type::"Sales Credit Memo" then begin
                if SalesCrMemoLine.Get(Rec.Document_No_, MICAValueEntries.Document_Line_No) then begin
                    Rec.Amount_Including_VAT := CheckInvoicedQty(Rec.Invoiced_Quantity, -SalesCrMemoLine."Amount Including VAT");
                    if SalesCrMemoHeader.Get(SalesCrMemoLine."Document No.") then begin
                        Rec.MICA_Ship_To_Code := SalesCrMemoHeader."Ship-to Code";
                        Rec.MICA_Ship_To_Name := SalesCrMemoHeader."Ship-to Name";
                    end;
                end
            end else begin
                Rec.Amount_Including_VAT := CheckInvoicedQty(Rec.Invoiced_Quantity, MICAValueEntries.Amount_Including_VAT);
                if SalesInvoiceHeader.Get(MICAValueEntries.Document_No_) then begin
                    Rec.MICA_Ship_To_Code := SalesInvoiceHeader."Ship-to Code";
                    Rec.MICA_Ship_To_Name := SalesInvoiceHeader."Ship-to Name";
                end;
            end;

            Rec.Item_Description := MICAValueEntries.Description;
            Rec.Customer_Disc__Group := MICAValueEntries.Customer_Disc__Group;
            Rec.MICA_Item_Class := MICAValueEntries.MICA_Item_Class;
            Rec.MICA_Item_Charge_No_ := MICAValueEntries.Item_Charge_No_;
            Rec.Insert();
        end;
        MICAValueEntries.Close();
        //FindFirst();
    end;

    local procedure CheckInvoicedQty(InvoicedQty: Decimal; DocumentAmountIncludingVAT: Decimal): Decimal
    begin
        if InvoicedQty <> 0 then
            exit(DocumentAmountIncludingVAT)
        else
            exit(0);
    end;
}