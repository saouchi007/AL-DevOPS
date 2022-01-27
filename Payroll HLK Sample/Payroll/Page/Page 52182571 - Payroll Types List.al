/// <summary>
/// Page Payroll Types List (ID 51547).
/// </summary>
page 52182571 "Payroll Types List"
{
    // version HALRHPAIE.6.1.01

    Caption = 'Types de paie';
    PageType = Card;
    SourceTable = "Payroll Type";

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
                field("SS Deduction"; "SS Deduction")
                {
                }
                field("IRG %"; "IRG %")
                {
                }
            }
        }
    }

    actions
    {
    }


}

