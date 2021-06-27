
report 81171 "MICA Update Amt. FCY"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Permissions = tabledata "G/L Entry" = rm;
    ProcessingOnly = true;
    Caption = 'Update Amount FCY';

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ChooseExcelFileName; ExcelFileName)
                    {
                        Caption = 'Choose Excel File:';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            ValidateExcelFile(ExcelFileName, ExcelSheetName);
                        end;

                        trigger OnAssistEdit()
                        begin
                            ExcelFileName := GetExcelFile();
                            ExcelSheetName := GetExcelFileSheetName(ExcelFileName);
                        end;
                    }
                    field(SelectedExcelSheetName; ExcelSheetName)
                    {
                        Caption = 'Excel Sheet Name';
                        ApplicationArea = All;
                        Editable = false;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId());
        if not UserSetup."MICA Allow Amt.FCY Era.Process" then
            exit;

        AnalyzeAndImportData();
    end;

    local procedure GetExcelFile(): Text
    var
        ExcelFileExtensionLbl: Label '.xlsx', locked = true;
        ImportExcelFileLbl: Label 'Import Excel File', locked = true;
    begin
#if OnPremise
        if ExcelFileName <> '' then
            SelectedExcelFileName := FileManagement.UploadFile(ImportExcelFileLbl, ExcelFileName)
        else
            SelectedExcelFileName := FileManagement.UploadFile(ImportExcelFileLbl, ExcelFileExtensionLbl);
#else
        Error('TODO for Cloud');//TODO
#endif

        ValidateExcelFile(SelectedExcelFileName, '');
        exit(FileManagement.GetFileName(SelectedExcelFileName));
    end;

    local procedure GetExcelFileSheetName(ExcelFileName: Text): Text;
    begin
#if not OnPremise
        Error('TODO for Cloud');//TODO
#else
        if ExcelFileName = '' then
            ExcelFileName := GetExcelFile();

        exit(TempExcelBuffer.SelectSheetsName(ExcelFileName));
#endif
    end;

    local procedure ValidateExcelFile(FileName: Text; ExcelSheetName: Text)
    var
        EmptyExcelFileLbl: Label 'There is no Excel file to import.';
    begin
        if FileName = '' then begin
            ExcelFileName := '';
            ExcelSheetName := '';
            Error(EmptyExcelFileLbl);
        end;
    end;

    local procedure AnalyzeAndImportData()
    var
        RowNo: Integer;
        EntryNo: Integer;
        ProcessedEntries: Integer;
        AmountFCYFromExcel: Decimal;
        ProgressEntriesLbl: Label 'Processing entries       #1################';
        GLEntriesToUpdateLbl: Label 'Total number of GL Entries that will be corrected is: %1. Do you want to continue?';
        GLEntriesUpdatedLbl: Label 'General Ledger Entries updated.';
    begin
        if not TempExcelBuffer.IsTemporary() then
            exit;

        TempExcelBuffer.LockTable();
#if OnPremise
        TempExcelBuffer.OpenBook(SelectedExcelFileName, ExcelSheetName);
#else
        Error('TODO for Cloud');//TODO
#endif
        TempExcelBuffer.ReadSheet();

        TempExcelBuffer.SetFilter("Row No.", '>%1', 1);
        TotalExcelRecords := TempExcelBuffer.Count();
        if TotalExcelRecords = 0 then
            exit;

        if not Confirm(StrSubStno(GLEntriesToUpdateLbl, TotalExcelRecords / 2)) then
            exit;

        Window.Open(ProgressEntriesLbl);

        if TempExcelBuffer.FindSet() then
            repeat
                RowNo += 1;
                ProcessedEntries := Round(RowNo / (TotalExcelRecords / 2) * 100, 1);
                Window.Update(1, ProcessedEntries);

                case TempExcelBuffer."Column No." of
                    1:
                        Evaluate(EntryNo, TempExcelBuffer."Cell Value as Text");
                    2:
                        begin
                            Evaluate(AmountFCYFromExcel, TempExcelBuffer."Cell Value as Text");
                            UpdateAmountFCYInGLEntry(EntryNo, AmountFCYFromExcel);
                        end;
                end
            until TempExcelBuffer.Next() = 0;

        Window.Close();
        if ProcessedEntries > 0 then
            Message(GLEntriesUpdatedLbl);
    end;

    local procedure UpdateAmountFCYInGLEntry(EntryNoFromExcel: Integer; ToUpdateAmountFCY: Decimal)
    var
        GLEntry: Record "G/L Entry";
    begin
        if not GLEntry.Get(EntryNoFromExcel) then
            exit;

        GLEntry.Validate("MICA Amount (FCY)", ToUpdateAmountFCY);
        GLEntry."MICA Amt. FCY To Be Erased" := false;
        GLEntry."MICA Amt. FCY DateTime Mod." := CurrentDateTime();
        GLEntry."MICA Amt. FCY User Modified" := UserId();
        GLEntry.Modify();
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FileManagement: Codeunit "File Management";
        TotalExcelRecords: Integer;
        SelectedExcelFileName: Text;
        ExcelFileName: Text;
        ExcelSheetName: Text;
        Window: Dialog;
}