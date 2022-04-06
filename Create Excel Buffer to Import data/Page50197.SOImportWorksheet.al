/// <summary>
/// Page ISA_SalesOrdersImportWorksheet (ID 50197).
/// </summary>
page 50197 ISA_SalesOrdersImportWorksheet
{
    AutoSplitKey = true;
    Caption = 'SO Import Worksheet';
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = ISA_SOImportBuffer;
    SourceTableView = sorting(BatchName, LineNo);
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(BatchName; Rec.BatchName)
            {
                Caption = 'Batch Name';
                ApplicationArea = All;
            }
            repeater(Group)
            {
                Editable = false;
                field("Batch Name"; Rec.BatchName)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Line No."; Rec.LineNo)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field("File Name"; Rec.FileName)
                {
                    ApplicationArea = All;
                }
                field("Sheet Name"; Rec."Sheet Name")
                {
                    ApplicationArea = All;
                }
                field("Imported Date"; Rec."Imported Date")
                {
                    ApplicationArea = All;
                }
                field("Imported Time"; Rec."Imported Time")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Import")
            {
                Caption = '&Import';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                ToolTip = 'Import data from excel.';

                trigger OnAction()
                var
                begin
                    if Rec.BatchName = '' then
                        Error(BatchISBlankMsg);
                    ReadExcelSheet();
                    ImportExcelData();
                end;
            }

        }
    }

    var
        BatchName: Code[10];
        FileName: Text[100];
        SheetName: Text[100];

        TempExcelBuffer: Record "Excel Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        BatchISBlankMsg: Label 'Batch name is blank';
        ExcelImportSucess: Label 'Excel is successfully imported.';


    local procedure ReadExcelSheet()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[100];
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            Rec.FileName := FileMgt.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(IStream, SheetName);
        TempExcelBuffer.ReadSheet();
    end;

    local procedure ImportExcelData()
    var
        SOImportBuffer: Record ISA_SOImportBuffer;
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRowNo: Integer;
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        LineNo := 0;
        SOImportBuffer.Reset();
        if SOImportBuffer.FindLast() then
            LineNo := SOImportBuffer.LineNo;
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRowNo := TempExcelBuffer."Row No.";
        end;

        for RowNo := 2 to MaxRowNo do begin
            LineNo := LineNo + 10000;
            SOImportBuffer.Init();
            Evaluate(SOImportBuffer.BatchName, Rec.BatchName);
            SOImportBuffer.LineNo := LineNo;
            Evaluate(SOImportBuffer."Document No.", GetValueAtCell(RowNo, 1));
            Evaluate(SOImportBuffer."Sell-to Customer No.", GetValueAtCell(RowNo, 2));
            Evaluate(SOImportBuffer."Posting Date", GetValueAtCell(RowNo, 3));
            Evaluate(SOImportBuffer."Currency Code", GetValueAtCell(RowNo, 4));
            Evaluate(SOImportBuffer."Document Date", GetValueAtCell(RowNo, 5));
            Evaluate(SOImportBuffer."External Document No.", GetValueAtCell(RowNo, 6));
            Evaluate(SOImportBuffer.Type, GetValueAtCell(RowNo, 7));
            Evaluate(SOImportBuffer."No.", GetValueAtCell(RowNo, 8));
            Evaluate(SOImportBuffer.Quantity, GetValueAtCell(RowNo, 9));
            Evaluate(SOImportBuffer."Unit Price", GetValueAtCell(RowNo, 10));
            SOImportBuffer."Sheet Name" := SheetName;
            SOImportBuffer.FileName := Rec.FileName;
            SOImportBuffer."Imported Date" := Today;
            SOImportBuffer."Imported Time" := Time;
            SOImportBuffer.Insert();
        end;
        Message(ExcelImportSucess);
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin

        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;
}