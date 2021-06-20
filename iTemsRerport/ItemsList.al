report 50100 ItemsList
{
    //UsageCategory = Documents;
    //ApplicationArea = All;
    Caption = 'Items Report';
    DefaultLayout = Word;
    WordLayout = 'ItemsReport.docx';
    RDLCLayout = 'ItemsReport.rdlc';




    dataset
    {
        dataitem(DataItemName; Item)
        {
            column(Id; "ID")
            {

            }
            column(Description; "Description")
            {

            }



        }
    }
}