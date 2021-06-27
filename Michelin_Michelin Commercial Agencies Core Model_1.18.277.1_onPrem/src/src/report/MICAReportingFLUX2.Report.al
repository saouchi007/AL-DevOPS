report 80660 "MICA Reporting FLUX2"
{
    ProcessingOnly = true;
    UseRequestPage = true;
    Caption = 'Export FLUX2';
    UsageCategory = None;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            trigger OnPreDataItem()
            var
            //ExportFLUX2: XmlPort "MICA Reporting FLUX2";
            begin
                //ExportFLUX2.InitPeriod(Period);
                //ExportFLUX2.Run();
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
                action("Export FLUX2")
                {
                    ApplicationArea = All;
                    image = ExportFile;

                    trigger OnAction()
                    begin
                        Xmlport.Run(Xmlport::"MICA Reporting FLUX2");
                    end;
                }
            }
        }

    }
    var
        PeriodValue: date;
}