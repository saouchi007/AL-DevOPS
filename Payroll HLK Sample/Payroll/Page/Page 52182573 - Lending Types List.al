/// <summary>
/// Page Lending Types List (ID 52182573).
/// </summary>
page 52182573 "Lending Types List"
{
    // version HALRHPAIE.6.1.01

    Caption = 'Types de prêts';
    PageType = List;
    SourceTable = "Lending Type";

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
                field("Lending Deduction (Capital)"; "Lending Deduction (Capital)")
                {
                }
                field("Lending Deduction (Interest)"; "Lending Deduction (Interest)")
                {
                }
            }
        }
    }

    actions
    {
    }




}

