/// <summary>
/// Report ISA_Customers (ID 50200).
/// </summary>
report 50200 ISA_Customers
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = RLayoutBeta;
    Caption = 'ISA_Customers';

    dataset
    {
        dataitem(Customer; Customer)
        {

            column(No_Customer; "No.")
            {
            }
            column(Name_Customer; Name)
            {
            }
        }
    }



    rendering
    {
        layout(RLayoutAlpha)
        {
            Type = RDLC;
            LayoutFile = 'RLayoutAlpha.rdl';
        }
        layout(RLayoutBeta)
        {
            Type = Word;
            LayoutFile = 'RLayoutBeta.docx';
        }
        layout(RLayoutCharlie)
        {
            Type = Excel;
            LayoutFile = 'RLayoutBeta.xlsx';
        }
    }

}