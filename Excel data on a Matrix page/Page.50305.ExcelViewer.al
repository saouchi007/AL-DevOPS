/// <summary>
/// Page ISA_ExcelViewer (ID 50305).
/// </summary>
page 50305 ISA_ExcelViewer
{
    PageType = List;
    Caption = 'Excel Viewer';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Integer;
    SourceTableView = where(Number = filter(1 ..));
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Rep)
            {
                field(Number; Rec.Number)
                {
                    ApplicationArea = All;

                }
                field(Col1; GetExcelCell(Rec.Number, LeftMostColumn))
                {
                    //Caption = 'A';
                    CaptionClass = '3,' + GetColumnHeading(LeftMostColumn);
                    ApplicationArea = All;

                }
                field(Col2; GetExcelCell(Rec.Number, LeftMostColumn + 1))
                {
                    CaptionClass = '3,' + GetColumnHeading(LeftMostColumn + 1);
                    ApplicationArea = All;

                }
                field(Col3; GetExcelCell(Rec.Number, LeftMostColumn + 2))
                {
                    CaptionClass = '3,' + GetColumnHeading(LeftMostColumn + 2);
                    ApplicationArea = All;

                }
            }

        }
    }


    actions
    {
        area(Processing)
        {
            action(Load)
            {
                ApplicationArea = All;
                Caption = 'Load';
                Image = FiledPosted;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    FileName: Text;
                    InS: Instream;
                begin
                    if UploadIntoStream('Excel File', '', '', FileName, InS) then begin
                        ExcelBuffer.DeleteAll();
                        ExcelBuffer.OpenBookStream(Ins, 'Sheet1'); // no way to query excel to get a sheet name so it needs to be hardcoded
                        ExcelBuffer.ReadSheet();// the excel workbook needs to be saved under .xlsx format 
                        LeftMostColumn := 1;
                    end;
                end;
            }
            action(Right)
            {
                ApplicationArea = All;
                Caption = 'Scroll Right';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    LeftMostColumn += 1;
                end;
            }

            action(Left)
            {
                ApplicationArea = All;
                Caption = 'Scroll Left';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    if LeftMostColumn > 1 then
                        LeftMostColumn -= 1;
                end;
            }
        }
    }

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        LeftMostColumn: Integer;

    local procedure GetExcelCell(row: Integer; column: Integer): Text
    begin
        if ExcelBuffer.Get(row, column) then
            exit(ExcelBuffer."Cell Value as Text");

    end;

    local procedure GetColumnHeading(columnNumber: Integer): Text
    var
        dividend: Integer;
        columnName: Text;
        modulo: Integer;
        c: Char;
    begin
        dividend := columnNumber;
        while (dividend > 0) do begin
            modulo := (dividend - 1) mod 26;
            c := 65 + modulo;
            columnName := Format(c) + columnName;
            dividend := (dividend - modulo) div 26;
        end;
        exit(columnName);
    end;

    trigger OnOpenPage()
    begin
        leftmostcolumn := 1;
    end;
}