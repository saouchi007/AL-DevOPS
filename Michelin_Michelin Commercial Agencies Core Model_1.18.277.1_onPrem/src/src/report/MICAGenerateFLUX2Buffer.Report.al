report 80661 "MICA Generate FLUX2 Buffer"
{
    ProcessingOnly = true;
    UseRequestPage = true;
    Caption = 'Generate FLUX2 Buffer';
    UsageCategory = None;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            var
                Flux2Buffer: Record "MICA FLUX2 Buffer2";
            begin
                Flux2Buffer.InitPeriod(PeriodValue);
                Flux2Buffer.InsertFluxBuffer();
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
    }
    var
        PeriodValue: date;
}