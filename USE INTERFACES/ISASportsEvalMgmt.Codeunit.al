/// <summary>
/// Codeunit ISA_SportsEvaluationMgmt (ID 50308).
/// </summary>
codeunit 50308 ISA_SportsEvaluationMgmt
{
    /// <summary>
    /// GetHandler.
    /// </summary>
    /// <param name="SportsEval">VAR Interface ISA_Sports.</param>
    procedure GetHandler(var SportsEval: Interface ISA_Sports)
    var
        SportsEvalSetup: Record ISA_SportsEvaluationSetup;
        SoprtsEvalProvider: Enum ISA_Provider;
    begin
        SportsEvalSetup.Reset();
        if (SportsEvalSetup.FindFirst()) then begin
            SportsEval := SportsEvalSetup.Handler;
        end else begin
            SportsEval := SoprtsEvalProvider::Default;
        end;
    end;
}