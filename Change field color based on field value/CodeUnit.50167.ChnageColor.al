/// <summary>
/// Codeunit ChangeColour (ID 50167).
/// </summary>
codeunit 50167 ChangeColour
{
    /// <summary>
    /// ChangeCustomeRankColour.
    /// </summary>
    /// <param name="Cust">Record Customer.</param>
    /// <returns>Return value of type Text[50].</returns>
    procedure ChangeCustomeRankColour(Cust: Record Customer): Text[50]
    begin
        with Cust do
            case Rank of
                Rank::Bronze:
                    exit('Unfavorable');
                Rank::Silver:
                    exit('favorable');
                Rank::Gold:
                    exit('strong');
                Rank::Platinum:
                    exit('strongaccent');
            end;
    end;
}