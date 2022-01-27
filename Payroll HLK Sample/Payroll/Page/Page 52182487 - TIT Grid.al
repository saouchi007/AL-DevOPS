/// <summary>
/// Page TIT Grid (ID 52182487).
/// </summary>
page 52182487 "TIT Grid"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'TIT Grid',
                FRA = 'Barème IRG';
    Editable = true;
    PageType = List;
    SourceTable = "TIT Grid";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field(Basis; Basis)
                {
                }
                field(TIT; TIT)
                {
                }
                field(TIT20; TIT20)
                {
                }
                field(TITR; TITR)
                {
                }
                field(TITGS; TITGS)
                {
                }
            }
        }
    }

    actions
    {
    }


}

