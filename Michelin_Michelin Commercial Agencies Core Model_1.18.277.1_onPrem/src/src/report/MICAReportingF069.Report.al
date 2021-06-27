report 80680 "MICA Reporting F069"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'F069 - Purchase Outside Group by CAI';

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            trigger OnPreDataItem()
            var
                ExportF069: XmlPort "MICA Reporting F069";
            begin
                ExportF069.InitPeriod(PeriodValue);
                ExportF069.Run();
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Option")
                {
                    field(Period; PeriodValue)
                    {
                        ApplicationArea = All;
                        Caption = 'Period';
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action("Export Reporting F069")
                {
                    ApplicationArea = All;
                    image = ExportFile;

                    trigger OnAction()
                    begin
                        Xmlport.Run(Xmlport::"MICA Reporting F069");
                    end;
                }
            }
        }

    }
    var
        PeriodValue: date;
}