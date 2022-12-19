/// <summary>
/// Codeunit ISA_Basketball (ID 50305) implements Interface ISA_Sports.
/// </summary>
codeunit 50305 ISA_Basketball implements ISA_Sports
{
    /// <summary>
    /// GetEvaluation.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetEvaluation(): Text;
    begin
        exit('Basketball is lit !');
    end;
}