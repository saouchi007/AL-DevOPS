page 52182514 "Sanctions Overview"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Sanction Overview',
                FRA = 'Détail Sanctions';
    PageType = Card;
    SaveValues = true;
    SourceTable = 5200;

    layout
    {
    }

    actions
    {
    }



    var
        Misconduct: Boolean;
        EmployeeMisconducts: Record "Employee Sanction";

}

