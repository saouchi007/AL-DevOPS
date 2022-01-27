/// <summary>
/// Page Candidate Qualif. Overview (ID 52182518).
/// </summary>
page 52182518 "Candidate Qualif. Overview"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Candidate Qualif. Overview',
                FRA = 'Détail qualification candidat';
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
        Qualified: Boolean;
        CandidateQualification: Record "Candidate Qualification";

}

