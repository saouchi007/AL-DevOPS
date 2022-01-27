/// <summary>
/// Page Payroll Constatation Warnings (ID 52182557).
/// </summary>
page 52182557 "Payroll Constatation Warnings"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Payroll Constatation Warnings',
                FRA = 'Avertissements constatation de paie';
    PageType = Card;
    SourceTable = "Payroll Constatation Warning";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field(Field; Field)
                {
                }
                field(Name; Name)
                {
                }
            }
        }
    }

    actions
    {
    }


}

