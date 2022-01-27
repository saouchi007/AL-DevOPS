/// <summary>
/// Page Payrolls (ID 51536).
/// </summary>
page 52182562 Payrolls
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Payroll List',
                FRA = 'Liste des paies';
    PageType = Card;
    SourceTable = Payroll;

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Company Business Unit Code"; "Company Business Unit Code")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field(Closed; Closed)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin

        IF NOT GestionnairePaie.GET(USERID) THEN
            ERROR(Text01);
        IF GestionnairePaie."Company Business Unit Code" <> '' THEN BEGIN
            FILTERGROUP(2);
            SETRANGE("Company Business Unit Code", GestionnairePaie."Company Business Unit Code");
            FILTERGROUP(0);
        END;
    end;

    var
        GestionnairePaie: Record "Payroll Manager";
        Text01: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';

}

