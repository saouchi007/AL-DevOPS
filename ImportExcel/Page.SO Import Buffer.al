page 50100 "Import Worksheet"
{
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "SO Import Buffer";
    AutoSplitKey = true;
    Caption = 'SO Import Worksheet';
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    SaveValues = true;
    SourceTableView = sorting("Batch Name", "Line No.");

    layout
    {
        area(Content)
        {
            field(BatchName; Rec."Batch Name")
            {
                ApplicationArea = All;
                Caption = 'Batch name';

            }
            repeater(Group)
            {
                Editable = false;
                field("Batch Name"; Rec."Batch Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
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
                field("File Name"; Rec."File Name")
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
        area(Processing)
        {
            action("&Import")
            {
                ApplicationArea = All;
                Caption = '&Import';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Import data from Excel';

                trigger OnAction()
                begin
                    if Rec."Batch Name" = '' then
                        Error(BatchISBlankMsg);

                    ReadExcelSheet();
                    ImportExcelData();
                end;
            }
        }
    }

    var
        batchName: Code[10];
        fileName: Text[100];
        sheetName: Text[100];

        tempExcelBuff: Record "Excel Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        BatchISBlankMsg: Label 'Batch name is blank';
        ExcelImportSucess: Label 'Excel is successfully imported.';

    local procedure ReadExcelSheet()
    var
        fileMgmt: Codeunit "File Management";
        Istream: InStream;
        fromFile: Text[100];
    begin
        UploadIntoStream(UploadExcelMsg, '', '', fromFile, Istream);

        if fromFile <> '' then begin
            fileName := fileMgmt.GetFileName(fromFile);
            sheetName := tempExcelBuff.SelectSheetsNameStream(Istream);
        end else
            Error(NoFileFoundMsg);

        tempExcelBuff.Reset();
        tempExcelBuff.DeleteAll();
        tempExcelBuff.OpenBookStream(Istream, sheetName);
        tempExcelBuff.ReadSheet();
    end;

    local procedure ImportExcelData()
    var
        SOImportBuffer: Record "SO Import Buffer";
        rowNumber: Integer;
        ColNumber: Integer;
        LineNumber: Integer;
        MaxRowNumber: Integer;
    begin
        rowNumber := 0;
        ColNumber := 0;
        MaxRowNumber := 0;
        LineNumber := 0;
        SOImportBuffer.Reset();

        if SOImportBuffer.FindLast() then
            Rec."Line No." := SOImportBuffer."Line No.";

        tempExcelBuff.Reset();

        if tempExcelBuff.FindLast() then begin
            MaxRowNumber := tempExcelBuff."Row No."
        end;

    end;

}