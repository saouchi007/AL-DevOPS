/// <summary>
/// TableExtension ISA_PaymentTerms_Ext (ID 50301) extends Record Payment Terms.
/// </summary>
tableextension 50301 ISA_PaymentTerms_Ext extends "Payment Terms"
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
        TotalPending, TotalProcessed, TotalUnprocessed : Integer;

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
        TotalPending := 0;
        TotalProcessed := 0;
        TotalUnprocessed := 0;

        CheckProcessStatus(Rec."Process Check 01");
        CheckProcessStatus(Rec."Process Check 02");
        CheckProcessStatus(Rec."Process Check 03");
        CheckProcessStatus(Rec."Process Check 04");
        CheckProcessStatus(Rec."Process Check 05");
        CheckProcessStatus(Rec."Process Check 06");

        Rec."Total No. of Pending" := TotalPending;
        Rec."Total No. of Processed" := TotalProcessed;
        Rec."Total No. of Unprocessed" := TotalUnprocessed;

        Rec.Modify();

    end;

    local procedure CheckProcessStatus(var ProcessCeck: Enum ISA_ProcessCheck)
    begin
        case ProcessCeck of
            ProcessCeck::Pending:
                TotalPending += 1;
            ProcessCeck::Processed:
                TotalProcessed += 1;
            ProcessCeck::Unprocessed:
                TotalUnprocessed += 1;

        end;
    end;
}