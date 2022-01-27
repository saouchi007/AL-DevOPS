/// <summary>
/// Page Employer Card (ID 51414).
/// </summary>
page 52182449 "Employer Card"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employer Card',
                FRA = 'Fiche employeur';
    PageType = Card;
    SourceTable = Employer;

    layout
    {
        area(content)
        {
            group("Général")
            {
                Caption = 'Général';
                field("No."; "No.")
                {

                    trigger OnAssistEdit();
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Employer)
            {
                CaptionML = ENU = '&Employer',
                            FRA = '&Employeur';
                Image = Employee;
                action("&Salariés")
                {
                    Caption = '&Salariés';
                    Image = SalutationFormula;
                    RunObject = Page "Fulfilled Function List";
                    RunPageLink = "Employer No." = FIELD("No.");
                }
            }
        }
    }


}

