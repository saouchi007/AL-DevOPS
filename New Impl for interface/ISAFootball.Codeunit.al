/// <summary>
/// Codeunit ISA_Football (ID 50309) implements Interface ISA_Sports.
/// </summary>
codeunit 50309 ISA_Football implements ISA_Sports
{
    /// <summary>
    /// GetEvaluation.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetEvaluation(): Text;
    begin
        exit('Football is mint !');
    end;
}