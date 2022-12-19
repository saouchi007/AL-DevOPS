/// <summary>
/// Codeunit ISA_Tennis (ID 50306) implements Interface ISA_Sports.
/// </summary>
codeunit 50306 ISA_Tennis implements ISA_Sports
{
    /// <summary>
    /// GetEvaluation.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetEvaluation(): Text;
    begin
        exit('Tennis is fun...');
    end;
}