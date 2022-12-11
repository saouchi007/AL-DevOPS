/// <summary>
/// Codeunit ISA_Codeunit (ID 50302).
/// </summary>
codeunit 50302 ISA_Codeunit
{
    /// <summary>
    /// GetText.
    /// </summary>
    /// <param name="Buffer">Temporary VAR Record "Excel Buffer".</param>
    /// <param name="Col">Integer.</param>
    /// <param name="Row">Integer.</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetText(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Text
    var
    begin
        if Buffer.Get(Row, Col) then
            exit(Buffer."Cell Value as Text");
    end;

    /// <summary>
    /// GetDate.
    /// </summary>
    /// <param name="Buffer">Temporary VAR Record "Excel Buffer".</param>
    /// <param name="Col">Integer.</param>
    /// <param name="Row">Integer.</param>
    /// <returns>Return value of type Date.</returns>
    procedure GetDate(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Date
    var
        ISA_Date: Date;
    begin
        if (Buffer.Get(Row, Col)) then
            Evaluate(ISA_Date, Buffer."Cell Value as Text");
        exit(ISA_Date);
    end;

    /// <summary>
    /// GetDecimal.
    /// </summary>
    /// <param name="Buffer">Temporary VAR Record "Excel Buffer".</param>
    /// <param name="Col">Integer.</param>
    /// <param name="Row">Integer.</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetDecimal(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Decimal
    var
        ISA_Decimal: Decimal;
    begin
        if (Buffer.Get(Row, Col)) then
            Evaluate(ISA_Decimal, Buffer."Cell Value as Text");
        exit(ISA_Decimal);
    end;

    /// <summary>
    /// GetColumnNumber.
    /// </summary>
    /// <param name="ColmnNumber">Text.</param>
    /// <returns>Return value of type Integer.</returns>
    procedure GetColumnNumber(ColmnNumber: Text): Integer
    var
    begin

    end;
}