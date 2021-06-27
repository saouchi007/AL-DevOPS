tableextension 82741 "MICA Cust. Ledger Entry" extends "Cust. Ledger Entry"
{
    fields
    {
        field(82740; "MICA Due Date (Buffer)"; Date)
        {
            Caption = 'Due Date (Buffer)';
            DataClassification = CustomerContent;
            Editable = false;

        }
    }

    procedure DrillDownOnEntriesDueBuffer(var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.Reset();
        DetailedCustLedgEntry.CopyFilter("Customer No.", CustLedgerEntry."Customer No.");
        DetailedCustLedgEntry.CopyFilter("Currency Code", CustLedgerEntry."Currency Code");
        DetailedCustLedgEntry.CopyFilter("Initial Entry Global Dim. 1", CustLedgerEntry."Global Dimension 1 Code");
        DetailedCustLedgEntry.CopyFilter("Initial Entry Global Dim. 2", CustLedgerEntry."Global Dimension 2 Code");
        DetailedCustLedgEntry.CopyFilter("MICA Initial Due Date (Buffer)", CustLedgerEntry."MICA Due Date (Buffer)");
        CustLedgerEntry.SetCurrentKey("Customer No.", "Posting Date");
        CustLedgerEntry.SetRange(Open, TRUE);
        Page.Run(0, CustLedgerEntry);
    end;

}