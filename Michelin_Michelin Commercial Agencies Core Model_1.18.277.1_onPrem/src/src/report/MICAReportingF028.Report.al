report 80900 "MICA Reporting F028"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'F028 - Reporting Group - Sales INTRAGROUP';

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            trigger OnPreDataItem()
            var
                ExportF028: XmlPort "MICA Reporting F028";
            begin
                ExportF028.InitPeriod(PeriodValue);
                ExportF028.Run();
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
                action("Export Reporting F028")
                {
                    ApplicationArea = All;
                    image = ExportFile;

                    trigger OnAction()
                    begin
                        Xmlport.Run(Xmlport::"MICA Reporting F028");
                    end;
                }
            }
        }

    }
    var
        PeriodValue: date;
}