table 80863 "MICA Flow Entry"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "MICA Flow Entry List";
    LookupPageId = "MICA Flow Entry List";
    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
            Editable = false;
        }
        field(20; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(30; "Flow Code"; Code[20])
        {
            Caption = 'Flow Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow";
            NotBlank = true;
            Editable = false;
            trigger OnValidate()
            var
                MICAFlowRec: Record "MICA Flow Record";
            begin
                MICAFlowRec.SetCurrentKey("Flow Entry No.");
                MICAFlowRec.SetRange("Flow Entry No.", "Entry No.");
                if MICAFlowRec.FindSet() then
                    repeat
                        MICAFlowRec.Validate("Flow Code", "Flow Code");
                    until MICAFlowRec.Next() = 0;
            end;
        }
        field(40; Direction; Option)
        {
            Caption = 'Direction';
            DataClassification = CustomerContent;
            OptionMembers = " ",Send,Receive;
            OptionCaption = ' ,Send,Receive';
        }

        field(50; "Send Status"; Option)
        {
            Caption = 'Send Status';
            DataClassification = CustomerContent;
            OptionMembers = " ",Prepared,Sent;
            OptionCaption = ' ,Prepared,Sent';
            Editable = false;
            trigger OnValidate()
            begin
                if "Send Status" <> xRec."Send Status" then
                    case "Send Status" of
                        "Send Status"::Prepared:
                            Validate("Prepared Date Time", CurrentDateTime());
                        "Send Status"::Sent:
                            Validate("Sent Date Time", CurrentDateTime());
                    end;
            end;
        }
        field(60; "Receive Status"; Option)
        {
            Caption = 'Receive Status';
            DataClassification = CustomerContent;
            OptionMembers = " ",Created,Received,Loaded,Processed,PostProcessed;
            OptionCaption = ' ,Created,Received,Loaded,Processed,Post Processed';
            Editable = false;
            trigger OnValidate()
            begin
                if "Receive Status" <> xRec."Receive Status" then
                    case "Receive Status" of
                        "Receive Status"::Created:
                            Validate("Created Date Time", CurrentDateTime());
                        "Receive Status"::Loaded:
                            Validate("Loaded Date Time", CurrentDateTime());
                        "Receive Status"::Processed:
                            Validate("Processed Date Time", CurrentDateTime());
                        "Receive Status"::PostProcessed:
                            Validate("PostProcessed Date Time", CurrentDateTime());
                        "Receive Status"::Received:
                            Validate("Received Date Time", CurrentDateTime());
                    end;
            end;
        }
        field(70; "Blob"; Blob)
        {
            Caption = 'Blob';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Validate("Blob Length", Blob.Length());
            end;
        }
        field(72; "Initial Blob"; Blob)
        {
            Caption = 'Initial Blob';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Validate("Initial Blob Length", "Initial Blob".Length());
            end;
        }

        field(80; "Blob Length"; Integer)
        {
            Caption = 'Blob Length';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82; "Initial Blob Length"; Integer)
        {
            Caption = 'Initial Blob Length';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(90; "Data Exch. Entry No."; Integer)
        {
            Caption = 'Data Exch. Entry No.';
            DataClassification = CustomerContent;
            TableRelation = "Data Exch."."Entry No.";
            Editable = false;
        }
        field(100; "Partner Code"; Code[20])
        {
            Caption = 'Partner Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow Partner".Code;
        }
        field(110; "Partner Name"; Text[50])
        {
            Caption = 'Partner Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("MICA Flow Partner".Name where(Code = field("Partner Code")));
        }
        field(120; "EndPoint Type"; Option)
        {
            Caption = 'EndPoint Type';
            DataClassification = CustomerContent;
            OptionMembers = " ",Blob,MQ,SMTP;
            OptionCaption = ' ,Blob,MQ,SMTP';
            Editable = false;
            trigger OnValidate()
            begin
                if "EndPoint Type" <> xRec."EndPoint Type" then
                    Validate("EndPoint Code", '');
            end;
        }
        field(130; "EndPoint Code"; Code[20])
        {
            Caption = 'EndPoint Code';
            DataClassification = CustomerContent;
            TableRelation = if ("EndPoint Type" = const(Blob)) "MICA Flow EndPoint".Code where("EndPoint Type" = const(Blob))
            else
            if ("EndPoint Type" = const(MQ)) "MICA Flow EndPoint".Code where("EndPoint Type" = const(MQ));
            Editable = false;
        }

        field(135; "EndPoint Recipients"; Text[250])
        {
            caption = 'EndPoint Recipients';
            DataClassification = CustomerContent;
            Editable = false;
            ExtendedDatatype = EMail;
        }
        field(140; "Blob Container"; Text[250])
        {
            Caption = 'Blob Container';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("MICA Flow"."Blob Container" where(Code = field("Flow Code")));
        }
        field(150; "MQ URL"; Text[250])
        {
            Caption = 'MQ URL';
            ExtendedDatatype = URL;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("MICA Flow EndPoint"."MQ URL" where(Code = field("EndPoint Code")));
        }
        field(160; "MQ Sub URL"; Text[250])
        {
            Caption = 'MQ Sub URL';
            ExtendedDatatype = URL;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("MICA Flow"."MQ Sub URL" where(Code = field("Flow Code")));
        }
        field(170; "Buffer Count"; Integer)
        {
            Caption = 'Buffer Count';
            Editable = false;
            BlankZero = true;
            DataClassification = CustomerContent;
        }
        field(180; "Record Count"; Integer)
        {
            Caption = 'Record Count';
            Editable = false;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Record" where("Flow Entry No." = field("Entry No.")));
        }
        field(190; "Info Count"; Integer)
        {
            Caption = 'Info Count';
            Editable = false;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where
                ("Flow Entry No." = field("Entry No."),
                "Info Type" = const(Information)));
        }
        field(200; "Warning Count"; Integer)
        {
            Caption = 'Warning Count';
            Editable = false;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where
                ("Flow Entry No." = field("Entry No."),
                "Info Type" = const(Warning)));
        }
        field(210; "Error Count"; Integer)
        {
            Caption = 'Error Count';
            Editable = false;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where
                ("Flow Entry No." = field("Entry No."),
                "Info Type" = const(Error)));
        }
        field(212; "Open Error Count"; Integer)
        {
            Caption = 'Open Error Count';
            Editable = false;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where
                ("Flow Entry No." = field("Entry No."),
                "Info Type" = const(Error),
                Status = const(Open)));
        }
        field(213; "In Progress Error Count"; Integer)
        {
            Caption = 'In Progress Error Count';
            Editable = false;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where
                ("Flow Entry No." = field("Entry No."),
                "Info Type" = const(Error),
                Status = const(InProgress)));
        }
        field(214; "Closed Error Count"; Integer)
        {
            Caption = 'Closed Error Count';
            Editable = false;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where
                ("Flow Entry No." = field("Entry No."),
                "Info Type" = const(Error),
                Status = const(Closed)));
        }

        field(220; "Created Date Time"; DateTime)
        {
            Caption = 'Created Date Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(230; "Received Date Time"; DateTime)
        {
            Caption = 'Received Date Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(240; "Processed Date Time"; DateTime)
        {
            Caption = 'Processed Date Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(250; "Prepared Date Time"; DateTime)
        {
            Caption = 'Prepared Date Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(260; "Sent Date Time"; DateTime)
        {
            Caption = 'Sent Date Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(270; "Loaded Date Time"; DateTime)
        {
            Caption = 'Loaded Date Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(280; "PostProcessed Date Time"; DateTime)
        {
            Caption = 'PostProcessed Date Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(290; "Logical ID"; Text[250])
        {
            Caption = 'Logical ID';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(300; "Component ID"; Text[250])
        {
            Caption = 'Component ID';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(310; "Task ID"; Text[250])
        {
            Caption = 'Task ID';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(320; "Reference ID"; Text[250])
        {
            Caption = 'Reference ID';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(330; "Creation Date Time"; DateTime)
        {
            Caption = 'Creation Date Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(340; Sender; Text[250])
        {
            Caption = 'Sender';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(350; Receiver; Text[250])
        {
            Caption = 'Receiver';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(360; "Receiver Type"; Text[250])
        {
            Caption = 'Receiver Type';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(370; "Reference Key"; Text[250])
        {
            Caption = 'Reference Key';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(380; "Message Type"; Text[250])
        {
            Caption = 'Message Type';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(390; "Sender Application Code"; Text[250])
        {
            Caption = 'Sender Application Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(400; Uploaded; Boolean)
        {
            Caption = 'Uploaded';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(410; "Skip this Entry"; Boolean)
        {
            Caption = 'Skip this Entry';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(500; "Copied from Entry No."; Integer)
        {
            Caption = 'Copied from Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(600; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            Caption = 'Date Filter';
        }
        field(700; "ACK from Flow Entry ID"; Integer)
        {
            Caption = 'ACK from Flow Entry ID';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow Entry";
            Editable = false;
        }
        field(710; "ACK Flow Entry Count"; Integer)
        {
            Caption = 'Flow Entry ACK Count';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "MICA Flow Entry";
            CalcFormula = count("MICA Flow Entry" where("ACK from Flow Entry ID" = field("Entry No.")));
        }
        field(800; "Use Encryption"; Boolean)
        {
            Caption = 'Use Encryption';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(810; "Source Entry No."; Integer)
        {
            Caption = 'Source Entry No.';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow Entry"."Entry No.";
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(KEY1; "Partner Code")
        {
        }
        key(KEY2; "EndPoint Type", "EndPoint Code")
        {
        }
        key(KEY3; Direction)
        {
        }
        key(KEY4; "Flow Code", "Send Status", "Skip this Entry")
        { }
        key(KEY5; "Flow Code", "Receive Status", "Skip this Entry")
        { }
    }

    trigger OnInsert()
    var
        MICAFlow: Record "MICA Flow";
    begin
        if "Created Date Time" = 0DT then
            Validate("Created Date Time", CurrentDateTime());
        if MICAFlow.Get("Flow Code") then begin
            Validate("Partner Code", MICAFlow."Partner Code");
            Validate("EndPoint Type", MICAFlow."EndPoint Type");
            Validate("EndPoint Code", MICAFlow."EndPoint Code");
            Validate("EndPoint Recipients", MICAFlow."EndPoint Recipients");
        end;
    end;

    trigger OnModify()
    begin
        UpdateNameWithPrefix();
    end;

    trigger OnDelete()
    var
        MICAFlowInformation: record "MICA Flow Information";
    begin
        MICAFlowInformation.SetCurrentKey("Flow Entry No.", "Info Type");
        MICAFlowInformation.SetRange("Flow Entry No.", "Entry No.");
        MICAFlowInformation.DeleteAll(true);

        DeleteRelatedBufferEntries();
    end;


    procedure PrepareToSend(TempBlob: Codeunit "Temp Blob")
    var
        OutStream: OutStream;
        InStream: InStream;
    begin
        Clear(InStream);
        Clear(OutStream);
        TempBlob.CreateInStream(InStream);
        Blob.CreateOutStream(OutStream);
        CopyStream(OutStream, InStream);
        Validate(Blob);
        Modify(true);
        PrepareToSend();
    end;

    procedure PrepareToSend()
    var
        MICAFlow: record "MICA Flow";
        EncryptedMICAFlowEntry: Record "MICA Flow Entry";
        MICAEncryptionMgt: Codeunit "MICA Encryption Mgt";
    begin
        MICAFlow.get("Flow Code");
        if MICAFlow."Set Prepared manually" then
            exit;

        Validate("Prepared Date Time", CurrentDateTime());
        Validate("Send Status", "Send Status"::Prepared);
        UpdateNameWithPrefix();
        Modify(true);
        If MICAFlow."Use Encryption" then begin
            EncryptedMICAFlowEntry.get("Entry No.");
            EncryptedMICAFlowEntry.SetRecFilter();
            MICAEncryptionMgt.EncryptBlob(EncryptedMICAFlowEntry, false);
        end;
    end;

    procedure ManuallyPrepareToSend()
    var
        MICAFlow: record "MICA Flow";
    begin
        MICAFlow.get("Flow Code");
        MICAFlow.testfield("Set Prepared manually");
        Testfield("Send Status", "Send Status"::" ");
        Testfield(Direction, Direction::Send);
        TestField("Skip this Entry", false);
        Validate("Prepared Date Time", CurrentDateTime());
        Validate("Send Status", "Send Status"::Prepared);
        UpdateNameWithPrefix();
        Modify(true);
    end;

    procedure SetSkipEntry(var FromMICAFlowEntry: record "MICA Flow Entry")
    var
        Selection: Integer;
        NoOfRecordsUpdated: Integer;
        SelectionQst: Label 'Set skip entry = YES,Set skip entry = NO';
        BoxDialog: Dialog;
        DialogTxt: Label 'Process Entry: #1##########\\Skip value: #2##########';
        NoOfEntriesUpdatedMsg: Label '%1 record(s) modified with Skip Entry = %2';
    begin
        Selection := StrMenu(SelectionQst, 1);
        if Selection = 0 then
            exit;
        if FromMICAFlowEntry.FindSet(true, false) then begin
            BoxDialog.Open(DialogTxt);
            BoxDialog.Update(2, (Selection = 1));
            repeat
                BoxDialog.Update(1, FromMICAFlowEntry."Entry No.");
                FromMICAFlowEntry."Skip this Entry" := (Selection = 1);
                NoOfRecordsUpdated += 1;
                FromMICAFlowEntry.Modify(true);
            until FromMICAFlowEntry.Next() = 0;
            BoxDialog.Close();
            Message(StrSubstNo(NoOfEntriesUpdatedMsg, NoOfRecordsUpdated, FromMICAFlowEntry."Skip this Entry"));
        end;
    end;

    procedure UpdateNameWithPrefix()
    var
        MICAFlow: Record "MICA Flow";
    begin
        if not MICAFlow.get("Flow Code") then
            exit;
        if MICAFlow."Blob Prefix" = '' then
            exit;
        if strpos(Description, MICAFlow."Blob Prefix") = 0 then
            Description := CopyStr(MICAFlow."Blob Prefix" + '/' + Description, 1, 250);
    end;

    procedure SetStatusToSent()
    var
        MICAFlowRecord: Record "MICA Flow Record";
    begin
        MICAFlowRecord.SetRange("Flow Entry No.", "Entry No.");
        if MICAFlowRecord.FindSet() then
            repeat
                MICAFlowRecord.UpdateSendRecord("Entry No.", MICAFlowRecord."Linked RecordID", "Send Status");
            until MICAFlowRecord.Next() = 0;
        Validate("Send Status", "Send Status"::Sent);
        Modify(true);
        UpdateFlowEntryDescription();
    end;

    procedure DowloadData()
    var
        MICAFlow: Record "MICA Flow";
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        DefaultFlowDescriptionLbl: Label 'FlowEntry %1 - Entry No %2';
    begin
        if MICAFlow.Get("Flow Code") then begin
            MICAFlow.TestField("Allow Download by User", true);
            CalcFields(Blob);
            TempBlob.FromRecord(Rec, Rec.FieldNo(Blob));
            // TempBlob.Blob := Blob;
            if Description = '' then
                Description := StrSubstNo(DefaultFlowDescriptionLbl, "Flow Code", "Entry No.");
            FileManagement.BLOBExport(TempBlob, Description, true);
        end;
    end;

    procedure DowloadInitialData()
    var
        MICAFlow: Record "MICA Flow";
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
    begin
        if MICAFlow.Get("Flow Code") then begin
            MICAFlow.TestField("Allow Download by User", true);
            CalcFields("Initial Blob");
            TempBlob.FromRecord(Rec, Rec.FieldNo("Initial Blob"));
            // TempBlob.Blob := "Initial Blob";
            TestField(Description);
            FileManagement.BLOBExport(TempBlob, Description, true)
        end;
    end;

    procedure AddInformation(Type: Option; FlowBufferEntryNo: Integer; Description1: Text; Description2: Text): Integer
    var
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFlowBuffer: Record "MICA Flow Buffer";
    begin
        MICAFlowInformation.Init();
        MICAFlowInformation.Validate("Flow Buffer Entry No.", FlowBufferEntryNo);
        MICAFlowInformation.Validate("Flow Entry No.", "Entry No.");
        MICAFlowInformation.Validate("Info Type", Type);
        MICAFlowInformation.Validate(Description, CopyStr(Description1, 1, MaxStrLen(MICAFlowInformation.Description)));
        MICAFlowInformation.Validate("Description 2", CopyStr(Description2, 1, MaxStrLen(MICAFlowInformation."Description 2")));
        MICAFlowBuffer.SetRange("Entry No.", FlowBufferEntryNo);
        if MICAFlowBuffer.FindFirst() then
            if Format(MICAFlowBuffer."Linked Record ID") <> '' then
                AddInformation(Type, MICAFlowBuffer."Linked Record ID", Description1, Description2);
        MICAFlowInformation.Insert(true);
        exit(MICAFlowInformation."Entry No.");
    end;

    procedure AddInformation(Type: Option; LinkedRecordID: RecordId; Description1: Text; Description2: Text): Integer
    var
        MICAFlowInformation: Record "MICA Flow Information";
    begin
        MICAFlowInformation.Init();
        MICAFlowInformation.Validate("Flow Entry No.", "Entry No.");
        MICAFlowInformation.Validate("Info Type", Type);
        MICAFlowInformation.Validate(Description, CopyStr(Description1, 1, MaxStrLen(MICAFlowInformation.Description)));
        MICAFlowInformation.Validate("Description 2", CopyStr(Description2, 1, MaxStrLen(MICAFlowInformation."Description 2")));
        MICAFlowInformation.Validate("Linked Record ID", LinkedRecordID);
        MICAFlowInformation.Insert(true);
        exit(MICAFlowInformation."Entry No.");
    end;

    procedure AddInformation(Type: Option; Description1: Text; Description2: Text): Integer
    var
        MICAFlowInformation: Record "MICA Flow Information";
    begin
        MICAFlowInformation.Init();
        MICAFlowInformation.Validate("Flow Entry No.", "Entry No.");
        MICAFlowInformation.Validate("Info Type", Type);
        MICAFlowInformation.Validate(Description, CopyStr(Description1, 1, MaxStrLen(MICAFlowInformation.Description)));
        MICAFlowInformation.Validate("Description 2", CopyStr(Description2, 1, MaxStrLen(MICAFlowInformation."Description 2")));
        MICAFlowInformation.Insert(true);
        exit(MICAFlowInformation."Entry No.");
    end;

    procedure OpenBuffer()
    var
        MICAFlow: Record "MICA Flow";
        TableMetadata: Record "Table Metadata";
        PageMetadata: Record "Page Metadata";
        TableField: Record Field;
        MyRecordRef: RecordRef;
        MyFieldRef: FieldRef;
        MyRecordRefVariant: Variant;
    begin
        if MICAFlow.Get("Flow Code") then
            if PageMetadata.Get(MICAFlow."Flow Buffer Page ID") then
                if TableMetadata.Get(PageMetadata.SourceTable) then begin
                    TableField.SetRange(TableNo, PageMetadata.SourceTable);
                    TableField.SetRange(FieldName, 'Flow Entry No.');
                    if TableField.FindFirst() then begin
                        MyRecordRef.Open(PageMetadata.SourceTable);
                        MyFieldRef := MyRecordRef.Field(TableField."No.");
                        MyFieldRef.SetRange("Entry No.");
                        MyRecordRefVariant := MyRecordRef;
                        Page.Run(MICAFlow."Flow Buffer Page ID", MyRecordRefVariant);
                    end;
                end;
    end;

    procedure Extract()
    var
        MICAFlow: Record "MICA Flow";
        CodeUnitMetadata: Record "CodeUnit Metadata";
        MICAFlowInformation: Record "MICA Flow Information";
        OpeningMICAFlowInformation: Record "MICA Flow Information";
        ExtractMessage: Text;
        xInfoCount: Integer;
        xWarningCount: Integer;
        xErrorCount: Integer;
    begin
        if MICAFlow.Get("Flow Code") then begin
            MICAFlow.TestField(Status, MICAFlow.Status::Released);
            TestField("Receive Status", "Receive Status"::Received);
            TestField("Skip this Entry", false);
            CalcFields("Info Count", "Warning Count", "Error Count");
            xInfoCount := "Info Count";
            xWarningCount := "Warning Count";
            xErrorCount := "Error Count";
            OpeningMICAFlowInformation.Get(AddInformation(OpeningMICAFlowInformation."Info Type"::Information, StartExtractingTxt, ''));
            if MICAFlow."Data Exch. Def. Code" <> '' then
                CodeUnitMetadata.Get(Codeunit::"MICA Flow Extract")
            else
                CodeUnitMetadata.Get(MICAFlow."Extract Codeunit ID");
            UpdateFlowEntryDescription();
            Commit();
            if Codeunit.Run(CodeUnitMetadata.ID, Rec) then
                Modify(true)
            else
                AddInformation(MICAFlowInformation."Info Type"::Error, ProcessErrorTxt, CopyStr(GetLastErrorText(), 1, 250));
            OpeningMICAFlowInformation.Update('', '');
            if GuiAllowed() then begin
                CalcFields("Info Count", "Warning Count", "Error Count");
                ExtractMessage := StrSubstNo(TerminatedWithInformationMessagesTxt, "Entry No.", Description, ExtractTxt, "Info Count" + "Warning Count" + "Error Count" - xInfoCount - xWarningCount - xErrorCount);
                if ("Warning Count" - xWarningCount > 0) or ("Error Count" - xErrorCount > 0) then begin
                    ExtractMessage += ' ' + IncludingTxt + ' ';
                    if "Warning Count" - xWarningCount > 0 then begin
                        ExtractMessage += StrSubstNo(WarningsTxt, "Warning Count" - xWarningCount);
                        if "Error Count" - xErrorCount > 0 then
                            ExtractMessage += ' ' + AndTxt + ' ';
                    end;
                    if "Error Count" > 0 then
                        ExtractMessage += StrSubstNo(ErrorTxt, "Error Count" - xErrorCount);
                end;
                Message(ExtractMessage);
            end;
        end;
        SendACK();
    end;

    procedure Process(isManual: Boolean)
    var
        MICAFlow: Record "MICA Flow";
        MICAFlowInformation: Record "MICA Flow Information";
        ProcessMessage: Text;
    begin
        if MICAFlow.Get("Flow Code") then begin
            MICAFlow.TestField(Status, MICAFlow.Status::Released);
            TestField("Skip this Entry", false);
            if "Receive Status" = "Receive Status"::Loaded then
                RunProcess()
            else
                if ("Receive Status" = "Receive Status"::Processed) and isManual then begin
                    MICAFlow.TestField("Allow Reprocessing");
                    CopyAndProcessFlowEntry();
                end
                else begin
                    AddInformation(MICAFlowInformation."Info Type"::Error, CantProcessErr, CopyStr(GetLastErrorText(), 1, 250));
                    if GuiAllowed() then begin
                        CalcFields("Info Count", "Warning Count", "Error Count");
                        ProcessMessage := StrSubstNo(TerminatedWithInformationMessagesTxt, "Entry No.", Description, ProcessTxt, "Info Count" + "Warning Count" + "Error Count");
                        if ("Warning Count" > 0) or ("Error Count" > 0) then begin
                            ProcessMessage += ' ' + IncludingTxt + ' ';
                            if "Warning Count" > 0 then begin
                                ProcessMessage += StrSubstNo(WarningsTxt, "Warning Count");
                                if "Error Count" > 0 then
                                    ProcessMessage += ' ' + AndTxt + ' ';
                            end;
                            if "Error Count" > 0 then
                                ProcessMessage += StrSubstNo(ErrorTxt, "Error Count");
                        end;
                        Message(ProcessMessage);
                    end;
                end;
        end;
    end;

    local procedure CopyAndProcessFlowEntry()
    var
        NewMICAFlowEntry: Record "MICA Flow Entry";
        MICAFlow: Record "MICA Flow";
        MICAFlowInformation: Record "MICA Flow Information";
        PageMetadata: Record "Page Metadata";
        TableMetadata: Record "Table Metadata";
        FromTableField: Record Field;
        ToTableField: Record Field;
        FromRecordRef: RecordRef;
        ToRecordRef: RecordRef;
        FromMyFieldRef: FieldRef;
        SetFromMyFieldRef: FieldRef;
        ToMyFieldRef: FieldRef;
        EntryCopyFromLbl: label 'New entry created by reprocessing of entry no. %1';
    begin
        MICAFlow.Get("Flow Code");
        CalcFields(Blob, "Initial Blob");
        NewMICAFlowEntry.TransferFields(Rec);
        NewMICAFlowEntry."Entry No." := 0;
        NewMICAFlowEntry."Processed Date Time" := 0DT;
        NewMICAFlowEntry.Insert(true);
        NewMICAFlowEntry."Copied from Entry No." := "Entry No.";
        NewMICAFlowEntry."Skip this Entry" := false;
        NewMICAFlowEntry.Modify(true);
        NewMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(EntryCopyFromLbl, "Entry No."), '');

        PageMetadata.SetRange(ID, MICAFlow."Flow Buffer Page ID");
        if not PageMetadata.FindFirst() then
            exit;
        TableMetadata.SetRange(ID, PageMetadata.SourceTable);
        TableMetadata.SetRange(ObsoleteState, TableMetadata.ObsoleteState::No, TableMetadata.ObsoleteState::Pending);
        if TableMetadata.FindSet() then
            repeat
                FromTableField.SetRange(TableNo, TableMetadata.ID);
                FromTableField.SetRange(FieldName, 'Flow Entry No.');
                FromTableField.SetRange(ObsoleteState, FromTableField.ObsoleteState::No, FromTableField.ObsoleteState::Pending);
                if FromTableField.FindFirst() then begin
                    FromRecordRef.Close();
                    FromRecordRef.Open(TableMetadata.ID);
                    FromMyFieldRef := FromRecordRef.Field(FromTableField."No.");
                    FromMyFieldRef.SetRange("Entry No.");
                    if FromRecordRef.FindSet() then
                        repeat
                            ToRecordRef.Close();
                            ToRecordRef.Open(TableMetadata.ID);
                            ToTableField.SetRange(TableNo, TableMetadata.ID);
                            ToTableField.SetRange(FieldName);
                            if ToTableField.FindSet() then
                                repeat
                                    ToMyFieldRef := ToRecordRef.Field(ToTableField."No.");
                                    SetFromMyFieldRef := FromRecordRef.Field(ToTableField."No.");
                                    ToMyFieldRef.Value(SetFromMyFieldRef.Value());
                                until ToTableField.Next() = 0;
                            // Set New Flow Entry
                            ToTableField.SetRange(FieldName, 'Flow Entry No.');
                            if ToTableField.FindFirst() then begin
                                ToMyFieldRef := ToRecordRef.Field(ToTableField."No.");
                                ToMyFieldRef.Value(NewMICAFlowEntry."Entry No.");
                            end;
                            ToRecordRef.Insert(true);
                        until FromRecordRef.Next() = 0;
                end;
            until TableMetadata.Next() = 0;
        NewMICAFlowEntry.Validate("Receive Status", "Receive Status"::Loaded);
        NewMICAFlowEntry.Modify(true);
        Commit();
        NewMICAFlowEntry.Process(false);
    end;

    procedure RunProcess()
    var
        MICAFlow: Record "MICA Flow";
        MICAFlowInformation: Record "MICA Flow Information";
        ProcessMessage: Text;
    begin
        if MICAFlow.Get("Flow Code") then
            if MICAFlow."Process Codeunit ID" <> 0 then begin
                Commit();
                if Codeunit.Run(MICAFlow."Process Codeunit ID", Rec) then begin
                    Validate("Receive Status", "Receive Status"::Processed);
                    Modify(true);
                    commit();
                end else
                    AddInformation(MICAFlowInformation."Info Type"::Error, ProcessErrorTxt, CopyStr(GetLastErrorText(), 1, 250));
            end;
        if GuiAllowed() then begin
            CalcFields("Info Count", "Warning Count", "Error Count");
            ProcessMessage := StrSubstNo(TerminatedWithInformationMessagesTxt, "Entry No.", Description, ProcessTxt, "Info Count" + "Warning Count" + "Error Count");
            if ("Warning Count" > 0) or ("Error Count" > 0) then begin
                ProcessMessage += ' ' + IncludingTxt + ' ';
                if "Warning Count" > 0 then begin
                    ProcessMessage += StrSubstNo(WarningsTxt, "Warning Count");
                    if "Error Count" > 0 then
                        ProcessMessage += ' ' + AndTxt + ' ';
                end;
                if "Error Count" > 0 then
                    ProcessMessage += StrSubstNo(ErrorTxt, "Error Count");
            end;
            Message(ProcessMessage);
        end;
        SendACK();
    end;

    procedure PostProcess()
    var
        MICAFlow: Record "MICA Flow";
        MICAFlowInformation: Record "MICA Flow Information";
        OpeningMICAFlowInformation: Record "MICA Flow Information";
        PostProcessMessage: Text;
    begin
        if MICAFlow.Get("Flow Code") then begin
            MICAFlow.TestField(Status, MICAFlow.Status::Released);
            TestField("Receive Status", "Receive Status"::Processed);
            TestField("Skip this Entry", false);
            if MICAFlow."Post Process Codeunit ID" <> 0 then begin
                OpeningMICAFlowInformation.Get(AddInformation(OpeningMICAFlowInformation."Info Type"::Information, StartPostProcessingTxt, ''));
                Commit();
                if Codeunit.Run(MICAFlow."Post Process Codeunit ID", Rec) then begin
                    Validate("Receive Status", "Receive Status"::PostProcessed);
                    Modify(true);
                    Commit();
                end else
                    AddInformation(MICAFlowInformation."Info Type"::Error, ProcessErrorTxt, CopyStr(GetLastErrorText(), 1, 250));
                OpeningMICAFlowInformation.Update('', '');
                if GuiAllowed() then begin
                    CalcFields("Info Count", "Warning Count", "Error Count");
                    PostProcessMessage := StrSubstNo(TerminatedWithInformationMessagesTxt, "Entry No.", Description, PostProcessTxt, "Info Count" + "Warning Count" + "Error Count");
                    if ("Warning Count" > 0) or ("Error Count" > 0) then begin
                        PostProcessMessage += ' ' + IncludingTxt + ' ';
                        if "Warning Count" > 0 then begin
                            PostProcessMessage += StrSubstNo(WarningsTxt, "Warning Count");
                            if "Error Count" > 0 then
                                PostProcessMessage += ' ' + AndTxt + ' ';
                        end;
                        if "Error Count" > 0 then
                            PostProcessMessage += StrSubstNo(ErrorTxt, "Error Count");
                    end;
                    Message(PostProcessMessage);
                end;
            end;
            SendACK();
        end;
    end;


    procedure UpdateTechnicalData(
        ParamLogicalID: Text;
        ParamComponentID: Text;
        ParamTaskID: Text;
        ParamReferenceID: Text;
        ParamCreationDateTime: DateTime;
        ParamSender: Text;
        ParamReceiver: Text;
        ParamReceiverType: Text;
        ParamReferenceKey: Text;
        ParamMessageType: Text;
        ParamSenderApplicationCode: Text)
    begin
        Validate("Logical ID", CopyStr(ParamLogicalID, 1, MaxStrLen("Logical ID")));
        Validate("Component ID", CopyStr(ParamComponentID, 1, MaxStrLen("Component ID")));
        Validate("Task ID", CopyStr(ParamTaskID, 1, MaxStrLen("Task ID")));
        Validate("Reference ID", CopyStr(ParamReferenceID, 1, MaxStrLen("Reference ID")));
        Validate("Creation Date time", ParamCreationDateTime);
        Validate("Sender", CopyStr(ParamSender, 1, MaxStrLen("Sender")));
        Validate("Receiver", CopyStr(ParamReceiver, 1, MaxStrLen("Receiver")));
        Validate("Receiver Type", CopyStr(ParamReceiverType, 1, MaxStrLen("Receiver Type")));
        Validate("Reference Key", CopyStr(ParamReferenceKey, 1, MaxStrLen("Reference Key")));
        Validate("Message Type", CopyStr(ParamMessageType, 1, MaxStrLen("Message Type")));
        Validate("Sender Application Code", CopyStr(ParamSenderApplicationCode, 1, MaxStrLen("Sender Application Code")));
    end;

    procedure AddRecord(a: RecordId): Integer
    begin

    end;

    procedure GetCurrentDateTimeWithTimeZoneOffset() Res_TimeZoneOffset: Text[30]
    var
        TimeZone: record "Time Zone";
        UserPersonalization: record "User Personalization";
    begin
        Res_TimeZoneOffset := FORMAT(CurrentDateTime(), 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>') + '+00:00';
        UserPersonalization.SETRANGE("User ID", UserId());
        If UserPersonalization.FindFirst() Then begin
            TimeZone.SETRANGE(ID, UserPersonalization."Time Zone");
            IF TimeZone.FindFirst() THEN
                Res_TimeZoneOffset := FORMAT(CurrentDateTime(), 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>') + COPYSTR(TimeZone."Display Name", 5, 6);
        End;
    end;

    procedure TranslateCharacters(TextToTranslate: Text): Text
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.Get();
        Exit(
            ConvertStr(
                TextToTranslate,
                GeneralLedgerSetup."MICA Special Characters",
                GeneralLedgerSetup."MICA Translated Characters"));
    end;

    procedure FormatDateTimeWithTimeZoneOffset(FromDateTime: datetime) Res_TimeZoneOffset: Text[30]
    var
        TimeZone: record "Time Zone";
        UserPersonalization: record "User Personalization";
    begin
        IF FromDateTime = 0DT then
            Res_TimeZoneOffset := ''
        else begin
            Res_TimeZoneOffset := FORMAT(FromDateTime, 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>') + '+00:00';
            UserPersonalization.SETRANGE("User ID", UserId());
            If UserPersonalization.FindFirst() Then begin
                TimeZone.SETRANGE(ID, UserPersonalization."Time Zone");
                IF TimeZone.FindFirst() THEN
                    Res_TimeZoneOffset := FORMAT(FromDateTime, 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>') + COPYSTR(TimeZone."Display Name", 5, 6);
            End;
        end;
    end;

    procedure RemoveNameSpaces()
    var
        XMLDOMManagement: Codeunit "XML DOM Management";
        InStream: InStream;
        OutStream: OutStream;
        XMLText: Text;
        i: Integer;
    begin

        if not blob.HasValue() then
            exit;
        CalcFields(Blob);
        validate("Initial Blob", Blob);

        Blob.CreateInStream(InStream);
        InStream.Read(XMLText);

        XMLText := XMLDOMManagement.RemoveNamespaces(XMLText); //Remove NameSpaces

        clear(Blob);
        Blob.CreateOutStream(OutStream);
        for i := 1 to strlen(XMLText) do
            if XMLText[i] > 0 then //Remove 00 char (null) character (at EOS)
                OutStream.Write(XMLText[i]);

        validate(Blob); //Update BLob Lengthh
        Modify(true);
    end;

    procedure GetFlowACKCode() FlowCode: Code[20];
    var
        MICAFlow: Record "MICA Flow";
    begin
        if MICAFlow.Get("Flow Code") then
            FlowCode := MICAFlow."ACK Flow Code";
    end;

    local procedure SendACK()
    var
        ReceiveMICAFlow: Record "Mica Flow";
        SendMICAFlow: Record "Mica Flow";
    begin
        Commit();
        if ReceiveMICAFlow.Get("Flow Code") then
            if SendMICAFlow.Get(ReceiveMICAFlow."ACK Flow Code") then
                SendMICAFlow.ExecuteSendACKCodeunit(Rec);
    end;

    procedure UpdateFlowEntryDescription()
    var
        MICAFlow: Record "MICA Flow";
        MICAFlowInformation: Record "MICA Flow Information";
        XmlDoc: XmlDocument;
        InStream: InStream;
        NotXMLErr: Label 'File is not in XML format.';
    begin
        MICAFlow.Get("Flow Code");
        if MICAFlow."Disable Calc. Descripton" then
            exit;

        CalcFields(Blob);
        if not Blob.HasValue() then
            exit;
        Blob.CreateInStream(InStream);
        if not XmlDocument.ReadFrom(InStream, xmlDoc) then begin
            AddInformation(MICAFlowInformation."Info Type"::Error, NotXMLErr, '');
            exit;
        end;

        CalcFlowEntryDescription(XmlDoc);
    end;

    procedure CalcFlowEntryDescription(XmlDoc: XmlDocument)
    var
        DescriptionParam: Text;
    begin
        DescriptionParam := GetParameter(Param_CalcDescriptionLbl, true);
        if DescriptionParam = '' then
            exit;

        Description := RecalculateStringDescription(XmlDoc, DescriptionParam);
        Modify(true);
    end;

    procedure GetParameter(Param: Text[20]; Mandatory: Boolean): Text
    var
        ParamMICAFlowSetup: Record "MICA Flow Setup";
        XPath: Text;
        MissingParamMsg: Label 'Missing parameter %1 in Flow Parameters';
        MissingXPathMsg: Label 'Missing XPath for parameter %1';
    begin
        if not ParamMICAFlowSetup.CheckIfParamExist("Flow Code", Param) then begin
            GenerateInformation(Param, MissingParamMsg, Mandatory);
            exit;
        end;

        XPath := ParamMICAFlowSetup.GetFlowTextParam("Flow Code", Param);
        if XPath = '' then
            GenerateInformation(Param, MissingXPathMsg, Mandatory);

        exit(XPath);
    end;

    procedure GenerateInformation(Param: Text[20]; MissingParamMsg: Text; Mandatory: Boolean)
    var
        MICAFlowInformation: Record "MICA Flow Information";
    begin
        if Mandatory then
            AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamMsg, Param), '')
        else
            AddInformation(MICAFlowInformation."Info Type"::Warning, StrSubstNo(MissingParamMsg, Param), '');
    End;

    local procedure GetNodeValue(xmlDoc: XmlDocument; XPath: Text): Text
    var
        xmlNodeInfo: XmlNode;
        NodeValue: Text;
    begin
        if XPath = '' then
            exit('');

        if not xmlDoc.SelectSingleNode(XPath, xmlNodeInfo) then
            exit('');

        NodeValue := xmlNodeInfo.AsXmlElement().InnerText();
        exit(NodeValue);
    end;

    local procedure ReplaceString(OrigStr: Text; FindWhat: Text; ReplaceWith: Text) NewString: Text
    var
        FindPos: Integer;
    begin
        FindPos := STRPOS(OrigStr, FindWhat);
        while FindPos > 0 do begin
            NewString += DelStr(OrigStr, FindPos) + ReplaceWith;
            OrigStr := CopyStr(OrigStr, FindPos + STRLEN(FindWhat));
            FindPos := StrPos(OrigStr, FindWhat);
        end;
        NewString += OrigStr;
    end;

    local procedure RecalculateStringDescription(XmlDoc: XmlDocument; DescriptionParam: Text): Text[250]
    var
        NoOfExpectedParams: Integer;
        i: Integer;
        ParamValue: Text;
        NodeValue: Text;
        DescWithParams: Text;
        ParamValueLbl: Label '%1_%2', Comment = '%1%2', Locked = true;
        DescWithParamsLbl: Label '%%1', Comment = '%1', Locked = true;
    begin
        ParamValue := DescriptionParam;
        NoOfExpectedParams := STRLEN(DELCHR(ParamValue, '=', DELCHR(ParamValue, '=', '%')));
        for i := 1 to StrLen(DescriptionParam) - 1 do
            if DescriptionParam[i] = '%' then
                if not (DescriptionParam[i + 1] in ['1' .. '9']) then
                    NoOfExpectedParams -= 1;

        DescWithParams := DescriptionParam;

        for i := NoOfExpectedParams downto 1 do begin
            ParamValue := GetParameter(StrSubstNo(ParamValueLbl, Param_CalcDescriptionLbl, i), false);
            NodeValue := GetNodeValue(XmlDoc, ParamValue);
            DescWithParams := ReplaceString(DescWithParams, StrSubstNo(DescWithParamsLbl, i), NodeValue);
        end;

        exit(CopyStr(DescWithParams, 1, MaxStrLen(Description)));
    end;

    local procedure DeleteRelatedBufferEntries()
    var
        MICAFlow: Record "MICA Flow";
        PageMetadata: Record "Page Metadata";
        MICAIntMonitoringSetup: Record "MICA Int. Monitoring Setup";
        BufferRecordRef: RecordRef;
        BufferFieldRef: FieldRef;
        DeleteConfirm: Boolean;
        DeleteFlowBufferEntryQst: Label 'Do you also want to delete existing Buffer Entry(ies)?';
    begin
        MICAIntMonitoringSetup.Get();
        if not MICAFlow.Get("Flow Code") then
            exit;
        if not PageMetadata.Get(MICAFlow."Flow Buffer Page ID") then
            exit;

        if MICAIntMonitoringSetup."Confirm Buffer Record Deletion" then
            DeleteConfirm := Confirm(DeleteFlowBufferEntryQst)
        else
            DeleteConfirm := true;

        if not DeleteConfirm then
            exit;

        BufferRecordRef.Open(PageMetadata.SourceTable);

        BufferFieldRef := BufferRecordRef.Field(2);
        BufferFieldRef.SetRange("Entry No.");
        BufferRecordRef.DeleteAll(false);
        BufferRecordRef.Close();
    end;

    var
        StartExtractingTxt: Label 'Start extracting data';
        StartPostProcessingTxt: Label 'Start post processing data';
        ExtractTxt: Label 'extract';
        ProcessTxt: Label 'process';
        PostProcessTxt: Label 'post procces';
        TerminatedWithInformationMessagesTxt: Label 'Flow entry %1 (%2) %3 terminated with %4 information message(s)';
        IncludingTxt: Label 'including';
        AndTxt: Label 'and';
        WarningsTxt: Label '%1 warning(s)';
        ErrorTxt: Label '%1 error(s)';
        ProcessErrorTxt: Label 'Process Error';
        CantProcessErr: Label 'You can Process only if Received Status is equal to Loaded or if Received Status is equal to Processed and ';
        Param_CalcDescriptionLbl: Label 'CALCDESCRIPTION', Locked = true;
}
