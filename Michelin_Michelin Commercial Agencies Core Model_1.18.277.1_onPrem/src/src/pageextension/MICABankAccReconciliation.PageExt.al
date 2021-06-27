pageextension 80920 "MICA BankAccReconciliation" extends "Bank Acc. Reconciliation"
{
    layout
    {
        addafter(StatementEndingBalance)
        {
            field("MICA Statement Entry No."; Rec."MICA Statement Entry No.")
            {
                ApplicationArea = All;
            }
        }

    }
}