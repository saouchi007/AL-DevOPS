/// <summary>
/// Page ISA_SOImportWorkSheet (ID 50321).
/// </summary>
page 50321 ISA_SOImportWorkSheet
{
    AutoSplitKey = true;
    Caption = 'SO Import Worksheet';
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "ISA_SOImportBuffer";
    SourceTableView = sorting("Batch Name", "Line No.");
    UsageCategory = Tasks;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            field(BatchName; BatchName)
            {
                Caption = 'Batch Name';
                ApplicationArea = All;
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
        area(processing)
        {
            action("&Import")
            {
                Caption = 'Import Excel';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                ToolTip = 'Import data from excel.';
                trigger OnAction()
                begin
                    if BatchName = '' then
                        Error(BatchISBlankMsg);
                    ImportFromZip := false;
                    ReadExcelSheet();
                    ImportExcelData();
                end;
            }
            action(ImportZipFile)
            {
                Caption = 'Import Zip File';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Import;
                ToolTip = 'Import Attachments from Zip';

                trigger OnAction()
                var
                    FileMgt: Codeunit "File Management";
                    DataCompression: Codeunit "Data Compression";
                    TempBlob: Codeunit "Temp Blob";
                    EntryList: List of [Text];
                    EntryListKey: Text;
                    ZipFileName: Text;
                    FileName: Text;
                    FileExtension: Text;
                    InStream: InStream;
                    EntryOutStream: OutStream;
                    EntryInStream: InStream;
                    Length: Integer;
                    SelectZIPFileMsg: Label 'Select ZIP File';
                    FileCount: Integer;
                    ImportedMsg: Label '%1 excel Imported successfully.';
                    FromFile: Text[100];
                begin
                    if BatchName = '' then
                        Error(BatchISBlankMsg);

                    if not UploadIntoStream(SelectZIPFileMsg, '', 'Zip Files|*.zip', ZipFileName, InStream) then
                        Error('');

                    ImportFromZip := true;

                    //Extract zip file and store files to list type
                    DataCompression.OpenZipArchive(InStream, false);
                    DataCompression.GetEntryList(EntryList);

                    FileCount := 0;

                    //Loop files from the list type
                    foreach EntryListKey in EntryList do begin
                        FileName := CopyStr(FileMgt.GetFileNameWithoutExtension(EntryListKey), 1, MaxStrLen(FileName));
                        FileExtension := CopyStr(FileMgt.GetExtension(EntryListKey), 1, MaxStrLen(FileExtension));
                        TempBlob.CreateOutStream(EntryOutStream);
                        DataCompression.ExtractEntry(EntryListKey, EntryOutStream, Length);
                        TempBlob.CreateInStream(EntryInStream);

                        SheetName := TempExcelBuffer.SelectSheetsNameStream(EntryInStream);
                        TempExcelBuffer.Reset();
                        TempExcelBuffer.DeleteAll();
                        TempExcelBuffer.OpenBookStream(EntryInStream, SheetName);
                        TempExcelBuffer.ReadSheet();
                        ImportExcelData();

                        FileCount += 1;
                    end;

                    //Close the zip file
                    DataCompression.CloseZipArchive();

                    if FileCount > 0 then
                        Message(ImportedMsg, FileCount);
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
        ImportFromZip: Boolean;

    trigger OnOpenPage()
    begin
        BatchName := 'Test';
    end;

    local procedure ReadExcelSheet()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[100];
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
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
        SOImportBuffer: Record "ISA_SOImportBuffer";
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
            LineNo := SOImportBuffer."Line No.";
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRowNo := TempExcelBuffer."Row No.";
        end;
        for RowNo := 2 to MaxRowNo do begin
            LineNo := LineNo + 10000;
            SOImportBuffer.Init();
            Evaluate(SOImportBuffer."Batch Name", BatchName);
            SOImportBuffer."Line No." := LineNo;
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
            SOImportBuffer."File Name" := FileName;
            SOImportBuffer."Imported Date" := Today;
            SOImportBuffer."Imported Time" := Time;
            SOImportBuffer.Insert();
        end;
        if not ImportFromZip then
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