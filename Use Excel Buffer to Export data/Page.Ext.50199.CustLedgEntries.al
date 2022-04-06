/// <summary>
/// PageExtension ISA_CustLedgEntries (ID 50199) extends Record Customer Ledger Entries.
/// </summary>
pageextension 50199 ISA_CustLedgEntries extends "Customer Ledger Entries"
{
    actions
    {
        addafter("F&unctions")
        {
            action(ISAExportToExcel)
            {
                Caption = 'ISA_Export to Excel';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Excel;

                trigger OnAction()
                begin
                    ExportCustLedgerEntries(Rec);
                end;
            }
        }
    }

    var
        myInt: Integer;

    local procedure ExportCustLedgerEntries(var CustLedgerEntryRec: Record "Cust. Ledger Entry")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        CustLedgerEntriesLbl: Label 'Customer Ledger Entries';
        ExcelFileName: Label 'CustomerLedgerEntries_%1_%2';
    begin
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.NewRow(); //Start adding new row in Excel.
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption("Entry No."), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);// Start adding new Column
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption("Posting Date"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption("Document Type"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption("Document No."), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption("Customer No."), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption("Customer Name"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption(Description), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption("Currency Code"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption("Original Amount"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption(Amount), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption("Amount (LCY)"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption("Remaining Amount"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption("Remaining Amt. (LCY)"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgerEntryRec.FieldCaption(Open), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        if CustLedgerEntryRec.FindSet() then
            repeat
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(CustLedgerEntryRec."Entry No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec."Posting Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec."Document Type", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec."Document No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec."Customer No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec."Customer Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec."Currency Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec."Original Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec.Amount, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec."Amount (LCY)", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec."Remaining Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec."Remaining Amt. (LCY)", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(CustLedgerEntryRec.Open, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            until CustLedgerEntryRec.Next() = 0;
        TempExcelBuffer.CreateNewBook(CustLedgerEntriesLbl);
        TempExcelBuffer.WriteSheet(CustLedgerEntriesLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(StrSubstNo(ExcelFileName, CurrentDateTime, UserId));
        TempExcelBuffer.OpenExcel();
    end;
}