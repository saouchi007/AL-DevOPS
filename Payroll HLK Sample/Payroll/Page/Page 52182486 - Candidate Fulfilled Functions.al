/// <summary>
/// Page Candidate Fulfilled Functions (ID 52182486).
/// </summary>
page 52182486 "Candidate Fulfilled Functions"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Candidate Fulfilled Functions',
                FRA = 'Fonctions occupées par le candidat';
    PageType = Card;
    SourceTable = "Candidate Fulfilled Function";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Candidate No."; "Candidate No.")
                {
                }
                field("Employer No."; "Employer No.")
                {
                }
                field("Function"; "Function")
                {
                }
                field("From Date"; "From Date")
                {
                }
                field("To Date"; "To Date")
                {
                }
            }
        }
    }

    actions
    {
    }


}

