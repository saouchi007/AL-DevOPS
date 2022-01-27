/// <summary>
/// Page Contract Overview (ID 52182516).
/// </summary>
page 52182516 "Contract Overview"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employment Contracts Overview',
                FRA = 'Détail contrats de travail';
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
        HasContract: Boolean;
        EmployeeContracts: Record "Employee Contract";
}

