/// <summary>
/// Codeunit cod direction (ID 52182447).
/// </summary>
codeunit 52182447 "cod direction"
//codeunit 39108420 "cod direction"
{
    // version HALRHPAIE.6.1.01


    trigger OnRun();
    begin
        MESSAGE(direction());
    end;

    var
        userSetup: Record 91;

    /// <summary>
    /// direction.
    /// </summary>
    /// <returns>Return variable dir of type Code[10].</returns>
    procedure direction() dir: Code[10];
    begin
        userSetup.GET(USERID);
        dir := userSetup."Company Business Unit";
    end;
}

