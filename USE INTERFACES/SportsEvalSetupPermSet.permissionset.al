/// <summary>
/// Unknown SportsEvalPermSet (ID 50300).
/// </summary>
permissionset 50300 SportsEvalPermSet
{
    Assignable = true;
    Permissions = tabledata ISA_SportsEvaluationSetup=RIMD,
        table ISA_SportsEvaluationSetup=X,
        codeunit ISA_Basketball=X,
        codeunit ISA_Default=X,
        codeunit ISA_Tennis=X,
        page ISA_SportEvaluationSetup=X;
}