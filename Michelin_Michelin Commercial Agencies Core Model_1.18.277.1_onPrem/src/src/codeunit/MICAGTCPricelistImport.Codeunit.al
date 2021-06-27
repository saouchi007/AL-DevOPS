codeunit 80941 "MICA GTCPricelistImport"
{
    TableNo = "Data Exch.";

    var
        DataExchDef: Record "Data Exch. Def";
        ImportCompleteMsg: Label 'Import is complete.';

    trigger OnRun()
    var
        ReadInStream: InStream;
        ReadText: Text;
        ReadLen: Integer;
        LineNo: Integer;
        SkippedLineNo: Integer;
    begin
        Rec."File Content".CREATEINSTREAM(ReadInStream);
        DataExchDef.GET(Rec."Data Exch. Def Code");
        LineNo := 1;
        REPEAT
            ReadLen := ReadInStream.READTEXT(ReadText);
            IF ReadLen > 0 THEN
                ParseLine(ReadText, Rec, LineNo, SkippedLineNo);
        UNTIL ReadLen = 0;
        Message(ImportCompleteMsg);
    end;

    local procedure ParseLine(Line: Text; DataExch: Record "Data Exch."; VAR LineNo: Integer; VAR SkippedLineNo: Integer)
    var
        DataExchLineDef: Record "Data Exch. Line Def";
        DataExchColumnDef: Record "Data Exch. Column Def";
        DataExchField: Record "Data Exch. Field";
        StartPosition: Integer;
    begin
        DataExchLineDef.SETRANGE("Data Exch. Def Code", DataExch."Data Exch. Def Code");
        DataExchLineDef.SETRANGE("Data Line Tag", CopyStr(Line, 1, 1));
        DataExchLineDef.FINDFIRST();

        IF ((LineNo + SkippedLineNo) <= DataExchDef."Header Lines") OR
           ((DataExchLineDef."Data Line Tag" <> '') AND (STRPOS(Line, DataExchLineDef."Data Line Tag") <> 1))
        THEN BEGIN
            SkippedLineNo += 1;
            EXIT;
        END;

        DataExchColumnDef.SETRANGE("Data Exch. Def Code", DataExch."Data Exch. Def Code");
        DataExchColumnDef.SETRANGE("Data Exch. Line Def Code", DataExchLineDef.Code);
        DataExchColumnDef.FINDSET();

        StartPosition := 1;
        REPEAT
            DataExchField.InsertRecXMLField(DataExch."Entry No.", LineNo, DataExchColumnDef."Column No.", '',
              COPYSTR(Line, StartPosition, DataExchColumnDef.Length), DataExchLineDef.Code);
            StartPosition += DataExchColumnDef.Length;
        UNTIL DataExchColumnDef.NEXT() = 0;
        LineNo += 1;
    end;

}