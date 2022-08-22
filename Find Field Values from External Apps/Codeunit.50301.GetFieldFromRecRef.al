/// <summary>
/// Codeunit ISA_GetFieldFromRecRef (ID 50301).
/// </summary>
codeunit 50301 ISA_GetFieldFromRecRef
{
    trigger OnRun()
    begin

    end;

    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        FieldNo: integer;

    /// <summary>
    /// ISA_SetParameters.
    /// </summary>
    /// <param name="_Recef">VAR RecordRef.</param>
    /// <param name="_FieldNo">integer.</param>
    procedure ISA_SetParameters(var _Recef: RecordRef; _FieldNo: integer);
    begin
        RecRef := _Recef;
        FieldNo := _FieldNo;
    end;

    /// <summary>
    /// ISA_GetFldRec.
    /// </summary>
    /// <param name="_FldRef">VAR FieldRef.</param>
    procedure ISA_GetFldRec(var _FldRef: FieldRef)
    begin
        _FldRef := FldRef;
    end;

    /// <summary>
    /// ISA_GetFldRefValueText.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure ISA_GetFldRefValueText(): Text;
    begin
        exit(Format(FldRef.value));
    end;

    /// <summary>
    /// ISA_SetFldRef.
    /// </summary>
    procedure ISA_SetFldRef()
    begin
        FldRef := RecRef.Field(FieldNo);
    end;


}