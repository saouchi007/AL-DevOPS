/// <summary>
/// Page IEP Grid (ID 52182537).
/// </summary>
page 52182537 "IEP Grid"
{
    // version HALRHPAIE.6.1.01

    Caption = 'Barème IEP';
    PageType = Card;
    SourceTable = "IEP Grid";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Starting period"; "Starting period")
                {
                }
                field("Ending Period"; "Ending Period")
                {
                }
                field(Rate; Rate)
                {
                }
            }
        }
    }

    actions
    {
    }


}

