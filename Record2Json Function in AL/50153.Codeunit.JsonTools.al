/// <summary>
/// Codeunit JsonTools (ID 50153).
/// </summary>
codeunit 50153 JsonTools
{
    /// <summary>
    /// Rec2Json.
    /// </summary>
    /// <param name="Rec">Variant.</param>
    /// <returns>Return value of type JsonObject.</returns>
    procedure Rec2Json(Rec: Variant): JsonObject
    var
        Ref: RecordRef;
        i: Integer;
        FRef: FieldRef;
        Out: JsonObject;
    begin
        if not Rec.IsRecord then
            Error('Parameter Rec is not a record !');
        Ref.GetTable(Rec);
        for i := 1 to Ref.FieldCount() do begin
            FRef := Ref.FieldIndex(i);
            Out.Add('F' + Format(FRef.Number(), 0, 9), FieldRef2JsonValue(FRef))
        end;
    end;

    local procedure FieldRef2JsonValue(FRef: FieldRef): JsonValue
    var
        Val: JsonValue;
        DT: Date;
    begin
        case FRef.Type() of
            FieldType::Date:
                begin
                    DT := FRef.Value;
                    Val.SetValue(DT);
                end;
            else
                Val.SetValue(Format(FRef.Value, 0, 9));
        end;
        exit(Val);
    end;
}