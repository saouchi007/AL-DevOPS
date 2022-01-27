/// <summary>
/// Page Candidate Quest. (ID 51453).
/// </summary>
page 52182488 "Candidate Quest."
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Candidate Quest.',
                FRA = 'Questionnaires candidat';
    PageType = Card;
    SourceTable = "Candidate Quest.Header";

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
                field(Type; Type)
                {
                }
                field(Priority; Priority)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Relative")
            {
                CaptionML = ENU = '&Relative',
                            FRA = 'Détails';
                Image = Relatives;
                action("Lignes Questionnaire")
                {
                    Image = QuestionaireSetup;
                    RunObject = Page 52182489;
                }
            }
        }
    }


}

