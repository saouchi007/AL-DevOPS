/// <summary>
/// Page Misconduct List (ID 52182447).
/// </summary>
page 52182447 "Misconduct List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Misconduct List',
                FRA = 'Liste des fautes';
    PageType = Card;
    SourceTable = Misconduct;

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
                field(Degree; Degree)
                {
                }
            }
        }
    }

    actions
    {
    }


}

