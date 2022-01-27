/// <summary>
/// Page Diploma Overview (ID 51463).
/// </summary>
page 52182498 "Diploma Overview"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Diploma Overview',
                FRA = 'Détail diplômes';
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
        Diplomed: Boolean;
        EmployeeDiplomas: Record "Employee Diploma";

}

