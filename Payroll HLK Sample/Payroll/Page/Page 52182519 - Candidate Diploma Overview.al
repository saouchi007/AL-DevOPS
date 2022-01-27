/// <summary>
/// Page Candidate Diploma Overview (ID 52182519).
/// </summary>
page 52182519 "Candidate Diploma Overview"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Candidate Diploma Overview',
                FRA = 'Détail diplômes candidat';
    PageType = Card;
    SaveValues = true;
    SourceTable = Candidate;

    layout
    {
    }

    actions
    {
    }


    var
        Diplomed: Boolean;
        CandidateDiplomas: Record "Candidate Diploma";

}

