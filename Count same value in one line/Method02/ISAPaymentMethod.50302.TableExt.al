/// <summary>
/// TableExtension ISA_PaymentMethod (ID 50302) extends Record Payment Method.
/// </summary>
tableextension 50302 ISA_PaymentMethod extends "Payment Method"
{
    fields
    {
        field(50101; "Process Check 01"; Enum ISA_ProcessCheck)
        {
            DataClassification = CustomerContent;
        }
        field(50102; "Process Check 02"; Enum ISA_ProcessCheck)
        {
            DataClassification = CustomerContent;
        }
        field(50103; "Process Check 03"; Enum ISA_ProcessCheck)
        {
            DataClassification = CustomerContent;
        }
        field(50104; "Process Check 04"; Enum ISA_ProcessCheck)
        {
            DataClassification = CustomerContent;
        }
        field(50105; "Process Check 05"; Enum ISA_ProcessCheck)
        {
            DataClassification = CustomerContent;
        }
        field(50106; "Process Check 06"; Enum ISA_ProcessCheck)
        {
            DataClassification = CustomerContent;
        }
        field(50107; "Total No. of Processed"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50108; "Total No. of Pending"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50109; "Total No. of Unprocessed"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
    var
        CountTable: Record ISA_CountTable;

    trigger OnAfterInsert()
    begin
        CountProcessStatus();
    end;

    trigger OnAfterModify()
    begin
        CountProcessStatus();
    end;

    local procedure CountProcessStatus()
    begin
        CountTable.Reset();
        CountTable.DeleteAll();

        InsertCountTable(Rec."Process Check 01");
        InsertCountTable(Rec."Process Check 02");
        InsertCountTable(Rec."Process Check 03");
        InsertCountTable(Rec."Process Check 04");
        InsertCountTable(Rec."Process Check 05");
        InsertCountTable(Rec."Process Check 06");

        CountTable.Reset();
        CountTable.SetRange(ProcessCheck, CountTable.ProcessCheck::Processed);
        Rec."Total No. of Processed" := CountTable.Count;

        CountTable.Reset();
        CountTable.SetRange(ProcessCheck, CountTable.ProcessCheck::Pending);
        Rec."Total No. of Pending" := CountTable.Count;

        CountTable.Reset();
        CountTable.SetRange(ProcessCheck, CountTable.ProcessCheck::Unprocessed);
        Rec."Total No. of Unprocessed" := CountTable.Count;

        Rec.Modify();   
    end;

    local procedure InsertCountTable(var ProcessCheck: Enum ISA_ProcessCheck)
    begin
        CountTable.Init();
        CountTable.EntryNo += 1;
        CountTable.ProcessCheck := ProcessCheck;
        CountTable.Insert();
    end;
}