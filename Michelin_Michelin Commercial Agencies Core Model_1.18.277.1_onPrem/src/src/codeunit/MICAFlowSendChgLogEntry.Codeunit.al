codeunit 82720 "MICA Flow Send Chg. Log Entry"
{
    TableNo = "MICA Flow";

    trigger OnRun()
    begin
        SetGlobals();
        ExportChangeLogEntry2CSV(Rec);
    end;

    local procedure SetGlobals()
    var
        FileDateTime: DateTime;
    begin
        Clear(TempBlob);
        ExportedRecordCount := 0;
        FileDateTime := CurrentDateTime();
        FileDate := Format(FileDateTime, 14, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>');
    end;

    local procedure ExportChangeLogEntry2CSV(MICAFlow: Record "MICA Flow")
    var
        ChangeLogEntry: Record "Change Log Entry";
        LastMICAFlowEntry: Record "MICA Flow Entry";
        InStream: InStream;
        OutStream: OutStream;
    begin
        if not MICAFlowEntry.Get(MICAFlow.CreateFlowEntry()) then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, UnableToCreateErr, '');
            exit;
        end;

        CheckAndRetrieveParameters();
        if (ParamValue_FileNaming = '') or (ParamValue_TableNoFilter = '') or (ParamValue_FirstExtractionDate = 0D) then
            exit;

        MICAFlowEntry.Description += '.csv';
        MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StartPreparingMsg, ''));

        ChangeLogEntry.SetAutoCalcFields("Table Caption", "Field Caption", "Primary Key Field 1 Caption",
                                        "Primary Key Field 2 Caption", "Primary Key Field 3 Caption");
        ChangeLogEntry.SetFilter("Table No.", ParamValue_TableNoFilter);
        if not FindLastFlowEntry(LastMICAFlowEntry, MICAFlow.Code) then
            ChangeLogEntry.SetFilter("Date and Time", '>=%1', CreateDateTime(ParamValue_FirstExtractionDate, 0T))
        else
            ChangeLogEntry.SetFilter("Date and Time", '>%1', LastMICAFlowEntry."Prepared Date Time");
        if ChangeLogEntry.FindSet(false) then begin
            TempBlob.CreateOutStream(OutStream);
            OutStream.WriteText(FormatChangeLogEntryCaptions(ChangeLogEntry));
            OutStream.WriteText(MICAFlow.GetCRLF());
            repeat
                OutStream.WriteText(FormatChangeLogEntry(ChangeLogEntry));
                OutStream.WriteText(MICAFlow.GetCRLF());
                ExportedRecordCount += 1;
            until ChangeLogEntry.Next() = 0;
        end;

        clear(OutStream);
        clear(InStream);
        MICAFlowEntry.Blob.CreateOutStream(OutStream);
        TempBlob.CreateInStream(InStream);
        CopyStream(OutStream, InStream);
        MICAFlowEntry.Validate(Blob);
        MICAFlowEntry.Modify(true);
        MICAFlowEntry.Description := StrSubstNo(ParamValue_FileNaming, FileDate);
        MICAFlowEntry.Modify(true);

        MICAFlowEntry.CalcFields("Error Count");
        if ExportedRecordCount > 0 then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, DataPrepLbl, StrSubstNo(ExportedRecordCountLbl, ExportedRecordCount));
            MICAFlowEntry.PrepareToSend();
        end else
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ErrorFoundLbl, MICAFlowEntry.FieldCaption("Send Status"), MICAFlowEntry."Send Status"::Prepared, MICAFlowEntry."Error Count"), '');

        MICAFlowInformation.Update('', '');
    end;

    local procedure FindLastFlowEntry(var NewLastMICAFlowEntry: Record "MICA Flow Entry"; FlowCode: Code[20]): Boolean
    begin
        NewLastMICAFlowEntry.SetFilter("Flow Code", FlowCode);
        NewLastMICAFlowEntry.SetRange("Send Status", NewLastMICAFlowEntry."Send Status"::Sent);
        NewLastMICAFlowEntry.SetFilter("Error Count", '%1', 0);
        if NewLastMICAFlowEntry.FindLast() then
            exit(true)
        else
            exit(false);
    end;

    local procedure FormatChangeLogEntryCaptions(NewChangeLogEntry: Record "Change Log Entry") FormatedText: Text
    var
        FieldSeparatorLbl: Label ';', Locked = true;
        FullNameTxt: Label 'User Name';
        OldValueLocalTxt: Label 'Old Value (Local)';
        NewValueLocalTxt: Label 'New Value (Local)';
    begin
        FormatedText := NewChangeLogEntry.FieldCaption("Date and Time") + FieldSeparatorLbl;
        FormatedText += NewChangeLogEntry.FieldCaption("User ID") + FieldSeparatorLbl;
        FormatedText += FullNameTxt + FieldSeparatorLbl;
        FormatedText += NewChangeLogEntry.FieldCaption("Table Caption") + FieldSeparatorLbl;
        FormatedText += NewChangeLogEntry.FieldCaption("Primary Key Field 1 Caption") + FieldSeparatorLbl;
        FormatedText += NewChangeLogEntry.FieldCaption("Primary Key Field 1 Value") + FieldSeparatorLbl;
        FormatedText += NewChangeLogEntry.FieldCaption("Primary Key Field 2 Value") + FieldSeparatorLbl;
        FormatedText += NewChangeLogEntry.FieldCaption("Primary Key Field 3 Value") + FieldSeparatorLbl;
        FormatedText += NewChangeLogEntry.FieldCaption("Field Caption") + FieldSeparatorLbl;
        FormatedText += NewChangeLogEntry.FieldCaption("Type of Change") + FieldSeparatorLbl;
        FormatedText += NewChangeLogEntry.FieldCaption("Old Value") + FieldSeparatorLbl;
        FormatedText += OldValueLocalTxt + FieldSeparatorLbl;
        FormatedText += NewChangeLogEntry.FieldCaption("New Value") + FieldSeparatorLbl;
        FormatedText += NewValueLocalTxt + FieldSeparatorLbl;
    end;

    local procedure FormatChangeLogEntry(NewChangeLogEntry: Record "Change Log Entry") FormatedText: Text
    var
        FieldSeparatorLbl: Label ';', Locked = true;
    begin
        FormatedText := Format(NewChangeLogEntry."Date and Time", 0, '<Month,2>/<Day,2>/<Year4> <Hours24,2>:<Minutes,2>') + FieldSeparatorLbl;
        FormatedText += NewChangeLogEntry."User ID" + FieldSeparatorLbl;
        GetUser(NewChangeLogEntry."User ID");
        FormatedText += User."Full Name" + FieldSeparatorLbl;
        FormatedText += NewChangeLogEntry."Table Caption" + FieldSeparatorLbl;
        FormatedText += NewChangeLogEntry."Primary Key Field 1 Caption" + FieldSeparatorLbl;
        FormatedText += NewChangeLogEntry."Primary Key Field 1 Value" + FieldSeparatorLbl;
        FormatedText += NewChangeLogEntry."Primary Key Field 2 Value" + FieldSeparatorLbl;
        FormatedText += NewChangeLogEntry."Primary Key Field 3 Value" + FieldSeparatorLbl;
        FormatedText += NewChangeLogEntry."Field Caption" + FieldSeparatorLbl;
        FormatedText += Format(NewChangeLogEntry."Type of Change") + FieldSeparatorLbl;
        FormatedText += NewChangeLogEntry."Old Value" + FieldSeparatorLbl;
        FormatedText += NewChangeLogEntry.GetLocalOldValue() + FieldSeparatorLbl;
        FormatedText += NewChangeLogEntry."New Value" + FieldSeparatorLbl;
        FormatedText += NewChangeLogEntry.GetLocalNewValue() + FieldSeparatorLbl;
    end;

    local procedure GetUser(UserID: Code[50])
    begin
        if User."User Name" <> UserID then begin
            User.SetRange("User Name", UserID);
            if not User.FindFirst() then
                Clear(User);
        end;
    end;

    local procedure CheckAndRetrieveParameters()
    begin
        CheckPrerequisitesAndRetrieveParametersTxt(Param_FileNamingTxt, ParamValue_FileNaming);
        CheckPrerequisitesAndRetrieveParametersTxt(Param_TableNoFilterTxt, ParamValue_TableNoFilter);
        CheckPrerequisitesAndRetrieveParametersDate(Param_FirstExtractionDateTxt, ParamValue_FirstExtractionDate);
    end;

    local procedure CheckPrerequisitesAndRetrieveParametersTxt(Param: Text[20]; var ParamValueTxt: Text)
    begin
        if not ParamMICAFlowSetup.CheckIfParamExist(MICAFlowEntry."Flow Code", Param) then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamMsg, Param), '');
            exit;
        end;

        ParamValueTxt := ParamMICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", Param);
        if ParamValueTxt = '' then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamMsg, Param), '');
    end;

    local procedure CheckPrerequisitesAndRetrieveParametersDate(Param: Text[20]; var ParamValueDate: Date)
    begin
        if not ParamMICAFlowSetup.CheckIfParamExist(MICAFlowEntry."Flow Code", Param) then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamMsg, Param), '');
            exit;
        end;

        ParamValueDate := ParamMICAFlowSetup.GetFlowDateParam(MICAFlowEntry."Flow Code", Param);
        if ParamValueDate = 0D then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamMsg, Param), '');
    end;

    var
        MICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowInformation: Record "MICA Flow Information";
        ParamMICAFlowSetup: Record "MICA Flow Setup";
        User: Record User;
        TempBlob: Codeunit "Temp Blob";
        ExportedRecordCount: Integer;
        ParamValue_FileNaming: Text;
        ParamValue_TableNoFilter: Text;
        FileDate: Text[14];
        ParamValue_FirstExtractionDate: Date;
        Param_FileNamingTxt: Label 'FILENAMING', Locked = true;
        Param_FirstExtractionDateTxt: Label 'FIRSTEXTRACTIONDATE', Locked = true;
        Param_TableNoFilterTxt: Label 'TABLENOFILTER', Locked = true;
        MissingParamMsg: Label 'Missing parameter %1 in Flow Parameters';
        UnableToCreateErr: Label 'Unable to create Flow Entry';
        StartPreparingMsg: Label 'Start Preparing Data';
        DataPrepLbl: Label 'Data Preparation Executed';
        ExportedRecordCountLbl: Label '%1 Records Exported';
        ErrorFoundLbl: Label '%1 not updated to %2 (%3 errors found)';
}