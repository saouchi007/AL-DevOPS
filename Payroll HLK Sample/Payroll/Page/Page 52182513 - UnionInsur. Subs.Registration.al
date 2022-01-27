/// <summary>
/// Page Union/Insur. Subs.Registration (ID 52182513).
/// </summary>
page 52182513 "Union/Insur. Subs.Registration" //Saisie des souscription au mutuelle assurance
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Union/Insurances Subscriptions Registration',
                FRA = 'Saisie des souscriptions mutuelles/assurances';
    DelayedInsert = true;
    Editable = true;
    PageType = List;
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

