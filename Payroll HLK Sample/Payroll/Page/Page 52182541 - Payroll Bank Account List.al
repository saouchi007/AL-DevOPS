/// <summary>
/// Page Payroll Bank Account List (ID 52182541).
/// </summary>
page 52182541 "Payroll Bank Account List"
{
    // version HALRHPAIE.6.1.02

    CaptionML = ENU = 'Payroll Bank Account List',
                FRA = 'Liste comptes bancaires paie';
    Editable = false;
    PageType = Card;
    SourceTable = "Payroll Bank Account";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field(Code; Code)
                {
                }
                field(Name; Name)
                {
                }
                field("Name 2"; "Name 2")
                {
                }
                field("Phone No."; "Phone No.")
                {
                    Visible = false;
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    Visible = false;
                }
                field("Bank Branch No."; "Bank Branch No.")
                {
                }
                field("Fax No."; "Fax No.")
                {
                    Visible = false;
                }
                field("Telex No."; "Telex No.")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                    Visible = false;
                }
                field("No. of Domiciliated Employees"; "No. of Domiciliated Employees")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Bank Acc.")
            {
                CaptionML = ENU = '&Bank Acc.',
                            FRA = '&Banque';
                Image = Bank;
                action(Card)
                {
                    CaptionML = ENU = 'Card',
                                FRA = 'Fiche';
                    Image = EditLines;
                    RunObject = Page "Payroll Bank Account Card";
                    RunPageLink = Name = FIELD(Name);
                    ShortCutKey = 'Shift+F5';
                }
            }
        }
    }


}

