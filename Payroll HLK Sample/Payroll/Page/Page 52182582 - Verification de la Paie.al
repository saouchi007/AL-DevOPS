/// <summary>
/// Page Verification de la Paie (ID 52182582).
/// </summary>
page 52182582 "Verification de la Paie"
{
    // version HALRHPAIEKarim

    PageType = Card;
    SourceTable = "Tab Ventilation Comptable";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("No Rub"; "No Rub")
                {
                }
                field(description; description)
                {
                }
                field(versement; versement)
                {
                }
                field(retenue; retenue)
                {
                }
                field(Nombre; Nombre)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin

        //---01---
        SETFILTER(Nombre, '<>%1', 0);
        //+++01+++
    end;

    var

}

