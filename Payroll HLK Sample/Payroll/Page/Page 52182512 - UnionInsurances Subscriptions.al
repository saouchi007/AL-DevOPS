/// <summary>
/// Page Union/Insurances Subscriptions (ID 52182512).
/// </summary>
page 52182512 "Union/Insurances Subscriptions"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Union/Insurances Subscriptions',
                FRA = 'Souscriptions mutuelles/assurances';
    Editable = false;
    PageType = Card;
    SourceTable = "Employee Union Subscription";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field("Union/Insurance Code"; "Union/Insurance Code")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field("Subscription Amount"; "Subscription Amount")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
            }
        }
    }

    actions
    {
    }


}

