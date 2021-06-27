codeunit 82320 "MICA Import Data Error Mgt"
{
    trigger OnRun()
    begin

    end;

    var
        TempErrorMessage: Record "Error Message" temporary;
        ErrMsgLineNo: Integer;
        IsErrorExist: Boolean;

    procedure ValidDateFormat(InDateText: Text; var OutDate: Date; DateFormat: option "MM/DD/YYYYY","DD/MM/YYYY"): Boolean
    var
        Month: Integer;
        Day: Integer;
        Year: Integer;
        InDate: Text;
    begin
        if InDateText = '' then
            exit(true);
        InDate := DelChr(InDateText, '=', ' ');
        if StrLen(InDate) <> 10 then
            exit(false);
        case DateFormat of
            DateFormat::"MM/DD/YYYYY":
                begin
                    if not Evaluate(Month, CopyStr(InDate, 1, 2)) then
                        exit(false);
                    if not Evaluate(Day, CopyStr(InDate, 4, 2)) then
                        exit(false);
                    if not Evaluate(Year, CopyStr(InDate, 7, 4)) then
                        exit(false);
                end;
            DateFormat::"DD/MM/YYYY":
                begin
                    if not Evaluate(Day, CopyStr(InDate, 1, 2)) then
                        exit(false);
                    if not Evaluate(Month, CopyStr(InDate, 4, 2)) then
                        exit(false);
                    if not Evaluate(Year, CopyStr(InDate, 7, 4)) then
                        exit(false);
                end;
        end;
        if Day > 31 then
            exit(false);
        if Month > 12 then
            exit(false);
        OutDate := DMY2Date(Day, Month, Year);
        exit(true)
    end;

    procedure ValidDecimalSeparator(InDecimalText: Text; var OutDecimal: Decimal; DecimalSeparator: Option Comma,Dot): Boolean
    var
        TextDecimalSeparator: text[1];
        DummyInteger: Integer;
        InDecimal: Text;
    begin
        InDecimal := DelChr(InDecimalText, '=', ' ');
        if StrLen(InDecimal) > 2 then
            case DecimalSeparator of
                DecimalSeparator::Comma:
                    begin
                        TextDecimalSeparator := CopyStr(InDecimal, StrLen(InDecimal) - 2, 1);
                        if not Evaluate(DummyInteger, TextDecimalSeparator) then
                            if TextDecimalSeparator <> ',' then
                                exit(false);
                    end;
                DecimalSeparator::Dot:
                    begin
                        TextDecimalSeparator := CopyStr(InDecimal, StrLen(InDecimal) - 2, 1);
                        if not Evaluate(DummyInteger, TextDecimalSeparator) then
                            if TextDecimalSeparator <> '.' then
                                exit(false);
                    end;
            end;
        if not Evaluate(OutDecimal, InDecimal) then
            exit(false);
        exit(true);
    end;

    procedure InsertErrorMsg(FileLineNo: Integer; FieldName: Text; ErrMsg: Text)
    var
        KeyLbl: Label '"File Line No.":%1 "Field Name":%2';
    begin
        IsErrorExist := true;
        ErrMsgLineNo += 1;
        TempErrorMessage.Init();
        TempErrorMessage.ID := ErrMsgLineNo;
        TempErrorMessage.Description := StrSubstNo(KeyLbl, FileLineNo, FieldName);
        TempErrorMessage."Additional Information" := CopyStr(ErrMsg, 1, 250);
        TempErrorMessage.Insert();
    end;

    procedure ErrorExist(): Boolean
    begin
        exit(IsErrorExist);
    end;

    procedure ExportFileWithErrors(DateFormat: Integer; DecimalSeparator: integer; FileName: Text; ReportSubtitle: Text[30])
    var
        MICAImportDataError: Report "MICA Import Data Error";
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        ErrorInfoMsg: Label 'Number of errors: %1';

    begin
        Message(StrSubstNo(ErrorInfoMsg, TempErrorMessage.Count()));
        TempBlob.CreateOutStream(OutStream);
        MICAImportDataError.SetErrorMessage(TempErrorMessage);
        MICAImportDataError.SetInputData(DateFormat, DecimalSeparator);
        MICAImportDataError.SetReportSubtitle(ReportSubtitle);
        MICAImportDataError.SaveAs('', ReportFormat::Pdf, OutStream);
        FileManagement.BLOBExport(TempBlob, FileName, true);
    end;
}