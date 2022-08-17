/// <summary>
/// Codeunit SalesTreePanelFunctions (ID 50309).
/// </summary>
codeunit 50309 "SalesTreePanelFunctions"
{
    /// <summary>
    /// CreateOrderEntries.
    /// </summary>
    /// <param name="rlSalesTree">VAR Record "ISA_SalesTree".</param>
    procedure CreateOrderEntries(var rlSalesTree: Record "ISA_SalesTree")
    var
        SalesHeader: Record "Sales Header";
    begin
        rlSalesTree.DeleteAll();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        if SalesHeader.FindSet() then begin
            repeat
                CreateLevel0(SalesHeader, rlSalesTree);
                CreateLevel1(SalesHeader, rlSalesTree);
            until SalesHeader.Next() = 0;
        end;
    end;

    /// <summary>
    /// CreateInvoiceEntries.
    /// </summary>
    /// <param name="rlSalesTree">VAR Record "ISA_SalesTree".</param>
    procedure CreateInvoiceEntries(var rlSalesTree: Record "ISA_SalesTree")
    var
        SalesHeader: Record "Sales Header";
    begin
        rlSalesTree.DeleteAll();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
        if SalesHeader.FindSet() then begin
            repeat
                CreateLevel0(SalesHeader, rlSalesTree);
                CreateLevel1(SalesHeader, rlSalesTree);
            until SalesHeader.Next() = 0;
        end;
    end;

    /// <summary>
    /// CreateCrMemoEntries.
    /// </summary>
    /// <param name="rlSalesTree">VAR Record "ISA_SalesTree".</param>
    procedure CreateCrMemoEntries(var rlSalesTree: Record "ISA_SalesTree")
    var
        SalesHeader: Record "Sales Header";
    begin
        rlSalesTree.DeleteAll();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
        if SalesHeader.FindSet() then begin
            repeat
                CreateLevel0(SalesHeader, rlSalesTree);
                CreateLevel1(SalesHeader, rlSalesTree);
            until SalesHeader.Next() = 0;
        end;
    end;

    /// <summary>
    /// CreateQuoteEntries.
    /// </summary>
    /// <param name="rlSalesTree">VAR Record "ISA_SalesTree".</param>
    procedure CreateQuoteEntries(var rlSalesTree: Record "ISA_SalesTree")
    var
        SalesHeader: Record "Sales Header";
    begin
        rlSalesTree.DeleteAll();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
        if SalesHeader.FindSet() then begin
            repeat
                CreateLevel0(SalesHeader, rlSalesTree);
                CreateLevel1(SalesHeader, rlSalesTree);
            until SalesHeader.Next() = 0;
        end;
    end;

    local procedure CreateLevel0(SalesHeader: Record "Sales Header"; var rlSalesTree: Record "ISA_SalesTree")
    begin
        rlSalesTree.Init();
        rlSalesTree."Entry No." := EntryNo;
        rlSalesTree.Indentation := 0;
        rlSalesTree."Document No." := SalesHeader."No.";
        rlSalesTree."Document Type" := SalesHeader."Document Type";
        rlSalesTree."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
        rlSalesTree.Date := SalesHeader."Document Date";
        rlSalesTree.Insert();
        EntryNo += 1;
    end;

    local procedure CreateLevel1(SalesHeader: Record "Sales Header"; var rlSalesTree: Record "ISA_SalesTree")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        if SalesLine.FindSet() then begin
            repeat
                rlSalesTree.Init();
                rlSalesTree."Entry No." := EntryNo;
                rlSalesTree.Indentation := 1;
                rlSalesTree."Document No." := SalesHeader."No.";
                rlSalesTree."Document Type" := SalesHeader."Document Type";
                rlSalesTree."No." := SalesLine."No.";
                rlSalesTree.Description := SalesLine.Description;
                rlSalesTree.Quantity := SalesLine.Quantity;
                rlSalesTree."Line No" := SalesLine."Line No.";
                rlSalesTree.Type := SalesLine.Type;
                rlSalesTree.Insert();
                EntryNo += 1;
            until SalesLine.Next() = 0;
        end;
    end;

    var
        EntryNo: Integer;
}



