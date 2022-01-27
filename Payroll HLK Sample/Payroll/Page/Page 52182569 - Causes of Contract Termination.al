/// <summary>
/// Page Causes of Contract Termination (ID 51544).
/// </summary>
page 52182569 "Causes of Contract Termination"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Causes of Contract Termination',
                FRA = 'Motifs de fin de contrat';
    PageType = Card;
    SourceTable = "Cause of Contract Termination";

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
            }
        }
    }

    actions
    {
    }


}

