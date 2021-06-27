tableextension 80920 "MICA BankAccReconciliation" extends "Bank Acc. Reconciliation"
{
    fields
    {
        field(80920; "MICA Statement Entry No."; Integer)
        {
            Caption = 'Statement Entry No.';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow Entry";
            Editable = false;
        }
    }
}