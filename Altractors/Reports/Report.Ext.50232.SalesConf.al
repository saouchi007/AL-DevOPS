/// <summary>
/// Unknown ISA_SalesConf (ID 50232) extends Record Standard Sales - Order Conf..
/// </summary>
reportextension 50232 ISA_SalesConf extends "Standard Sales - Order Conf."
{
    RDLCLayout = './Reports/ISA_SalesConf.rdlc';
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