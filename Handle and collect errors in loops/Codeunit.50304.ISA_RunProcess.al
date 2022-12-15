/// <summary>
/// Codeunit ISA_RunProcess (ID 50304).
/// </summary>
codeunit 50304 ISA_RunProcess
{
    trigger OnRun()
    begin
        ISA_InsertRecord();
    end;

    /// <summary>
    /// ISA_SetsParams.
    /// </summary>
    /// <param name="RandInt">Integer.</param>
    procedure ISA_SetsParams(RandInt: Integer)
    begin
        ISA_RandomInt := RandInt;
    end;


    local procedure ISA_InsertRecord()
    var
        ISA_SimTransact: Record ISA_TransactionSimulator;
    begin
        ISA_SimTransact.Init();
        case ISA_RandomInt of
            1:
                ISA_SimTransact.IsInsert := false;
            2:
                ISA_SimTransact.IsInsert := true;
        end;
        ISA_SimTransact.Insert(true);
    end;


    var
        ISA_RandomInt: Integer;
}