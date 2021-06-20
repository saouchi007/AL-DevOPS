report 50100 ItemsList
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'ItemsList_report.rdl';


    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.";

            column(Inventory; Inventory)
            {

            }
            column(Description; Description)
            {

            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        myInt: Integer;
}