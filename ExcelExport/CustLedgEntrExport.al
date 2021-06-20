pageextension 50100 CustEntrExpor extends "Customer Ledger Entries"
{
    actions
    {
        addafter("F&unctions")
        {
            action(ExportToExcel)
            {
                Caption = 'Export to Excel';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Export;

                trigger OnAction()
                var
                begin
                    ExportCustLedger(Rec);
                end;

            }
        }
    }

    local procedure ExportCustLedger(var CustLedgEntRec: Record "Cust. Ledger Entry")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        CustLedgEntrLbl: Label 'Customer Ledger Entries';
        ExcelFileName: Label 'Customer Ledger Entry_%1_%2';
    begin
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(CustLedgEntRec.FieldCaption("Entry No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgEntRec.FieldCaption("Posting Date"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgEntRec.FieldCaption("Document Type"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgEntRec.FieldCaption("Document No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgEntRec.FieldCaption("Customer No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgEntRec.FieldCaption("Customer Name"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CustLedgEntRec.FieldCaption("Amount (LCY)"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

        if CustLedgEntRec.FindSet() then
            repeat
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(CustLedgEntRec."Entry No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustLedgEntRec."Posting Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustLedgEntRec."Document Type", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustLedgEntRec."Document No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustLedgEntRec."Customer No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustLedgEntRec."Customer Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustLedgEntRec."Amount (LCY)", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            until CustLedgEntRec.Next() = 0;

        TempExcelBuffer.CreateNewBook(CustLedgEntrLbl);
        TempExcelBuffer.WriteSheet(CustLedgEntrLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(StrSubstNo(ExcelFileName, CurrentDateTime, UserId));
        TempExcelBuffer.OpenExcel();
    end;
}