/// <summary>
/// TableExtension ISA_Currencies_Ext (ID 50303) extends Record MyTargetTable.
/// </summary>
tableextension 50303 ISA_Currencies_Ext extends Currency
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
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        FldRec: Record Field;
    begin
        TotalPending := 0;
        TotalProcessed := 0;
        TotalUnprocessed := 0;

        Clear(RecRef);
        Clear(FldRef);
        RecRef.Open(Rec.RecordId.TableNo);
        RecRef.Get(Rec.RecordId);
        FldRec.Reset();
        FldRec.SetRange(TableNo, Rec.RecordId.TableNo);
        FldRec.SetRange(Enabled, true);
        FldRec.SetRange(Class, FldRec.Class::Normal);
        if FldRec.FindSet() then
            repeat
                FldRef := RecRef.Field(FldRec."No.");
                case Format(FldRef.Value) of
                    Format(Enum::ISA_ProcessCheck::Processed):
                        TotalProcessed += 1;
                    Format(Enum::ISA_ProcessCheck::Pending):
                        TotalPending += 1;
                    Format(Enum::ISA_ProcessCheck::Unprocessed):
                        TotalUnprocessed += 1;
                end;
            until FldRec.Next() = 0;
        Rec."Total No. of Pending" := TotalPending;
        Rec."Total No. of Processed" := TotalProcessed;
        Rec."Total No. of Unprocessed" := TotalUnprocessed;
        Rec.Modify();
    end;
}