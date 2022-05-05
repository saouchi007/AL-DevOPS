/// <summary>
/// Unknown ISA_SalesInvoice (ID 50233) extends Record Sales - Invoice GB.
/// </summary>
reportextension 50233 ISA_SalesInvoice extends "Standard Sales - Invoice"
{
    dataset
    {
        add(Header)
        {
            column(ISA_StampDuty; ISA_StampDuty)
            {

            }
        }
    }




}