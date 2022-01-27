/// <summary>
/// Page Nationality (ID 51395).
/// </summary>
page 52182430 Nationality
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Nationality List',
                FRA = 'Liste des nationalités';
    PageType = Card;
    SourceTable = Nationality;

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
                field("Code nationalité cacobatph"; "Code nationalité cacobatph")
                {
                }
            }
        }
    }

    actions
    {
    }


}

