/// <summary>
/// Page Causes of Relation Termination (ID 52182515).
/// </summary>
page 52182515 "Causes of Relation Termination"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Causes of Relation Termination',
                FRA = 'Motifs de fin de relation';
    PageType = Card;
    SourceTable = 5217;

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

