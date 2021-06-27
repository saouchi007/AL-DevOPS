report 80640 "MICA F300 Export"
{
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;
    UseRequestPage = true;
    Caption = 'Export F300';

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            trigger OnPreDataItem()
            var
                ExportF300: XmlPort "MICA F300 Export";
            begin
                ExportF300.InitPeriod(PeriodValue);
                ExportF300.Run();
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
                action("Export F300")
                {
                    ApplicationArea = All;
                    image = ExportFile;

                    trigger OnAction()
                    begin
                        Xmlport.Run(Xmlport::"MICA F300 Export");
                    end;
                }
            }
        }

    }
    var
        PeriodValue: date;
}