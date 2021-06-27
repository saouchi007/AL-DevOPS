codeunit 81881 "MICA Rebate Menagement"
{
    trigger OnRun()
    begin

    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;

    procedure DeleteRelatedDetailRebateLedgerEntries(var MICAAccrualSetup: Record "MICA Accrual Setup")
    var
        MICACustDetailAccrEntry: Record "MICA Cust. Detail. Accr. Entry";
        DeleteMICACustDetailAccrEntry: Record "MICA Cust. Detail. Accr. Entry";
        MICACloseDeffered: Codeunit "MICA Close Deffered";
        TotalBlockedCustomers: Integer;
        NonBlockedCustomersFilter: Text;
        BlockedCustomersFilter: Text;
    begin
        TotalBlockedCustomers := 0;
        TotalBlockedCustomers := MICACloseDeffered.CheckBlockedSellToCustomers(MICAAccrualSetup.Code, NonBlockedCustomersFilter, BlockedCustomersFilter);

        MICACustDetailAccrEntry.SetRange(Code, MICAAccrualSetup.Code);
        if TotalBlockedCustomers > 0 then
            MICACustDetailAccrEntry.SetFilter("Customer No.", NonBlockedCustomersFilter);
        if MICACustDetailAccrEntry.FindSet() then begin
            AddExcelHeader(MICACustDetailAccrEntry);
            repeat
                if (MICACustDetailAccrEntry.Quantity <> 0) and (MICACustDetailAccrEntry."Sales Amount" <> 0) then
                    AddExcelLine(MICACustDetailAccrEntry);
                DeleteMICACustDetailAccrEntry := MICACustDetailAccrEntry;
                DeleteMICACustDetailAccrEntry.Delete();
            until MICACustDetailAccrEntry.Next() = 0;
            CreateAndOpenExcel();
        end;
        MICAAccrualSetup.Validate(Closed, true);
        MICAAccrualSetup.Modify();
    end;

    local procedure AddExcelLine(MICACustDetailAccrEntry: Record "MICA Cust. Detail. Accr. Entry")
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Entry No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.Code, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Item No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Customer No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Calculation Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Posting Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(Format(MICACustDetailAccrEntry."Entry Type"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(MICACustDetailAccrEntry."Calculation Type"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Sales Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Discount Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.Quantity, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Accruals %", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Accruals Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Is Deffered", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Customer Accruals Entry No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Global Dimension 1 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Global Dimension 2 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Document No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."User ID", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Accr. Item Group", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Value Entry No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Accr. Customer Group", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Include in Fin. Report", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(MICACustDetailAccrEntry."Value Entry Document Type"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Country-of Sales", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Market Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Forecast Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Intercompany Dimension", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Accruals Dimension", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry."Site Dimension", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure AddExcelHeader(MICACustDetailAccrEntry: Record "MICA Cust. Detail. Accr. Entry")
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Entry No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption(Code), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Item No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Customer No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Calculation Date"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Posting Date"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Entry Type"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Calculation Type"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Sales Amount"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Discount Amount"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption(Quantity), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Accruals %"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Accruals Amount"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Is Deffered"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Customer Accruals Entry No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Global Dimension 1 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Global Dimension 2 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Document No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("User ID"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Accr. Item Group"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Value Entry No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Accr. Customer Group"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Include in Fin. Report"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Value Entry Document Type"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Country-of Sales"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Market Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Forecast Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Intercompany Dimension"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Accruals Dimension"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MICACustDetailAccrEntry.FieldCaption("Site Dimension"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure CreateAndOpenExcel()
    begin
        TempExcelBuffer.CreateNewBook('Entries');
        TempExcelBuffer.WriteSheet('Entries', CompanyName(), UserId());
        TempExcelBuffer.SetFriendlyFilename('ClosedAccruals' + Format(CurrentDateTime(), 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>'));
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.OpenExcel();
    end;

    [EventSubscriber(ObjectType::Table, database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', False, false)]
    local procedure OnBeforeInsertGlobalGLEntry(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        MICAFinancialReportingSetup.Get();
        if DimensionSetEntry.Get(GenJournalLine."Dimension Set ID", MICAFinancialReportingSetup."Accrual Dimension Code") then
            GLEntry."MICA Rebate Code" := DimensionSetEntry."Dimension Value Code";

        GLEntry."MICA Type Of Transaction" := GenJournalLine."MICA Type Of Transaction";
    end;

}