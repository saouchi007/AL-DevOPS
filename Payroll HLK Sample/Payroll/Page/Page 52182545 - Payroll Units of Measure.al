/// <summary>
/// Page Payroll Units of Measure (ID 52182545).
/// </summary>
page 52182545 "Payroll Units of Measure"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Payroll Units of Measure',
                FRA = 'Unités de mesure paie';
    PageType = Card;
    SourceTable = "Payroll Unit of Measure";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field(Code; Code)
                {
                }
                field("Qty. per Unit of Measure"; "Qty. per Unit of Measure")
                {
                }
            }
        }
    }

    actions
    {
    }


}

