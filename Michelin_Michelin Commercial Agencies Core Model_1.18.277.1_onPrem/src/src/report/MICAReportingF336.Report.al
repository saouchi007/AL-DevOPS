report 81940 "MICA Reporting F336"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'F336 - Reporting Group - Sales NoneGroup';
    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            trigger OnPreDataItem()
            begin
                ExportMICAReportingF336.InitPeriod(PeriodValue);
                ExportMICAReportingF336.InitType(TypeValue);
                ExportMICAReportingF336.Run();
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
                    field(Type; TypeValue)
                    {
                        ApplicationArea = All;
                        OptionCaption = 'VAL 0 Bis,VAL 2';
                    }
                    field(ShowF336Buffer; ShowF336BufferValue)
                    {
                        Caption = 'Show F336 Buffer';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action("Export Reporting F336")
                {
                    ApplicationArea = All;
                    image = ExportFile;

                    trigger OnAction()
                    begin
                        Xmlport.Run(Xmlport::"MICA Reporting F336");
                    end;
                }
            }
        }
    }

    trigger OnPostReport()
    var
        TempMICAF336Buffer: Record "MICA F336 Buffer" temporary;
        PageMICAF336Buffer: Page "MICA F336 Buffer";
        BufferOpeningLbl: Label 'Extract finished.';
    begin
        IF ShowF336BufferValue then begin
            Message(BufferOpeningLbl); // mandatory to trigger buffer display
            ExportMICAReportingF336.GetF336Buffer(TempMICAF336Buffer);
            PageMICAF336Buffer.SetF336Buffer(TempMICAF336Buffer);
            PageMICAF336Buffer.Run();
        end;
    end;

    var
        ExportMICAReportingF336: XmlPort "MICA Reporting F336";
        PeriodValue: date;
        TypeValue: Option "VAL0","VAL2";
        ShowF336BufferValue: Boolean;
}