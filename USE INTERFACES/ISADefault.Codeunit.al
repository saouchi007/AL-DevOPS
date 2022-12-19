/// <summary>
/// Codeunit ISA_Basketball (ID 50305) implements Interface ISA_Sports.
/// </summary>
codeunit 50307 ISA_Default implements ISA_Sports
{
    /// <summary>
    /// GetEvaluation.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetEvaluation(): Text;
    begin
        exit('Any sport is fine , make your peace with it !');
    end;
}