/// <summary>
/// PageExtension Default Dimensions-MultipleE (ID 50542) extends Record 542.
/// </summary>
pageextension 52182426 "Default Dimensions-MultipleE" extends 542
{
    /// <summary>
    /// SetMultiRespCenter.
    /// </summary>
    /// <param name="RespCenter">VAR Record 5714.</param>
    procedure SetMultiRespCenter(var RespCenter: Record 5714);
    begin
        TempDefaultDim2.DELETEALL;
        WITH RespCenter DO
            IF FIND('-') THEN
                REPEAT
                    CopyDefaultDimToDefaultDim(DATABASE::"Responsibility Center", Code);
                UNTIL NEXT = 0;
    end;

    local procedure CopyDefaultDimToDefaultDim(TableID: Integer; No: Code[20]);
    var
        DefaultDim: Record 352;
    begin
        TotalRecNo := TotalRecNo + 1;
        TempDefaultDim3."Table ID" := TableID;
        TempDefaultDim3."No." := No;
        TempDefaultDim3.INSERT;

        DefaultDim.SETRANGE("Table ID", TableID);
        DefaultDim.SETRANGE("No.", No);
        IF DefaultDim.FIND('-') THEN
            REPEAT
                TempDefaultDim2 := DefaultDim;
                TempDefaultDim2.INSERT;
            UNTIL DefaultDim.NEXT = 0;
    end;

    var
        TempDefaultDim2: Record 352 temporary;

        TempDefaultDim3: Record 352 temporary;
        TotalRecNo: Integer;

}

