/// <summary>
/// Page Employee Cotisations (ID 52182586).
/// </summary>
page 52182586 "Employee Cotisations"
{
    // version HALRHPAIE.6.2.00

    Caption = 'Cotisations du salarié';
    PageType = Card;
    SourceTable = "Employee Cotisation";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Employee No."; "Employee No.")
                {
                    Caption = 'Salarié';
                    Visible = false;
                }
                field("Cotisation Type"; "Cotisation Type")
                {
                }
            }
        }
    }

    actions
    {
    }


}

