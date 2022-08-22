/// <summary>
/// PageExtension ISA_CustomerCard (ID 50301) extends Record Customer Card.
/// </summary>
pageextension 50301 ISA_CustomerCard extends "Customer Card"
{

    trigger OnOpenPage()
    var
        Cust: Record Customer;
    begin
        if Cust.Get(Rec."No.") then begin
            Message(FindFieldValueByTextName(Cust, 'ISA_FiscalID'));
        end;
    end;

    local procedure FindFieldValueByTextName(RecVar: Variant; FieldName: Text[30]): Text
    var
        DataTypeManagement: Codeunit "Data Type Management";
        RecRef: RecordRef;
        FldRef: FieldRef;
    begin
        if DataTypeManagement.GetRecordRef(RecVar, RecRef) then
            if DataTypeManagement.FindFieldByName(RecRef, FldRef, FieldName) then
                exit(FldRef.Value);
    end;

    // ISA_GetFieldFromExtension is generating a runtime error used with CU50301, FindFieldValueByTextName seems to work fine
    /// <summary>
    /// ISA_GetFieldFromExtension.
    /// </summary>
    /// <param name="TheFieldNo">Integer.</param>
    /// <returns>Return value of type Text.</returns>
    /*procedure ISA_GetFieldFromExtension(TheFieldNo: Integer): Text
    var
        GetFieldFromRecRef: Codeunit ISA_GetFieldFromRecRef;
        RecRef: RecordRef;
        TheFieldValue: Text;
    begin
        TheFieldValue := '';

        RecRef.Open(Database::Customer);
        RecRef.GetTable(Rec);
        RecRef.SetRecFilter();
        GetFieldFromRecRef.ISA_SetParameters(RecRef, 50228);

        if GetFieldFromRecRef.Run() then
            TheFieldValue := GetFieldFromRecRef.ISA_GetFldRefValueText();
        exit(TheFieldValue);

    end;*/
}