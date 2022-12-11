/// <summary>
/// Page ISAExcel (ID 50302).
/// </summary>
page 50302 ISAExcel
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ISAExcel;

    layout
    {
        area(Content)
        {
            repeater(rep)
            {

                field(Primary; Rec.Primary)
                {
                    ToolTip = 'Specifies the value of the Primary field.';
                }
                field(Text_Data; Rec.Text_Data)
                {
                    ToolTip = 'Specifies the value of the Text Data field.';
                }
                field(Date_Data; Rec.Date_Data)
                {
                    ToolTip = 'Specifies the value of the Date Data field.';
                }
                field(Decimal_Data; Rec.Decimal_Data)
                {
                    ToolTip = 'Specifies the value of the Decimal Data field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Import)
            {
                ApplicationArea = All;
                Caption = 'Excel Import';
                Image = ImportDatabase;
                InFooterBar = true;

                trigger OnAction()
                var
                    Buffer: Record "Excel Buffer" temporary;
                    Data: Record ISAExcel;
                    Ins: InStream;
                    FileName: Text;
                    Row: Integer;
                    LastRow: Integer;
                    ExcelTools: Codeunit ISA_Codeunit;
                begin
                    Data.DeleteAll();
                    if UploadIntoStream('Hand over the excel file !', '', '', FileName, Ins) then begin
                        Buffer.OpenBookStream(Ins, 'Sheet1');
                        Buffer.ReadSheet();
                        Buffer.SetRange("Column No.", 4);
                        Buffer.FindLast();
                        LastRow := Buffer."Row No.";
                        Buffer.Reset();

                        for Row := 9 to LastRow do begin
                            Data.Init();
                            Data.Primary := ExcelTools.GetText(Buffer, 4, Row);
                            Data.Text_Data := ExcelTools.GetText(Buffer, 5, Row);
                            Data.Date_Data := ExcelTools.GetDate(Buffer, 6, Row);
                            Data.Decimal_Data := ExcelTools.GetDecimal(Buffer, 7, Row);
                            Data.Insert();
                        end;
                    end;
                end;
            }
        }
    }

}
