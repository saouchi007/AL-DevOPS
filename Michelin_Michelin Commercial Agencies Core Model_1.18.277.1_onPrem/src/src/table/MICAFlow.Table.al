table 80862 "MICA Flow"
{
    DataClassification = CustomerContent;
    LookupPageId = "MICA Flow List";
    DrillDownPageId = "MICA Flow List";
    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(20; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(30; "Partner Code"; Code[20])
        {
            Caption = 'Partner Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow Partner";
            trigger OnValidate()
            var
                FlowEntry: Record "MICA Flow Entry";
            begin
                if Rec."Partner Code" = xRec."Partner Code" then
                    exit;
                FlowEntry.Reset();
                FlowEntry.SetCurrentKey("Flow Code");
                FlowEntry.SetRange("Flow Code", Code);
                FlowEntry.ModifyAll("Partner Code", "Partner Code");
            end;
        }
        field(40; Status; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            Editable = false;
            OptionMembers = Open,Released;
            OptionCaption = 'Open,Released';
        }
        field(50; Direction; Option)
        {
            Caption = 'Direction';
            DataClassification = CustomerContent;
            OptionMembers = " ",Send,Receive;
            OptionCaption = ' ,Send,Receive';
        }
        field(60; "Send Codeunit ID"; Integer)
        {
            Caption = 'Send Codeunit ID';
            DataClassification = CustomerContent;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Codeunit), "Object ID" = filter(80000 .. 99999), "Object Name" = filter('*Flow Send*'));
        }
        field(70; "Send Codeunit Name"; Text[50])
        {
            Caption = 'Send Codeunit Name';
            FieldClass = FlowField;
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Codeunit), "Object ID" = field("Send Codeunit ID")));
        }
        field(74; "Set Prepared manually"; Boolean)
        {
            Caption = 'Set Prepared manually';
            DataClassification = CustomerContent;

        }

        field(80; "Data Exch. Def. Code"; Code[20])
        {
            Caption = 'Data Exch. Def. Code';
            DataClassification = CustomerContent;
            TableRelation = "Data Exch. Def";
        }
        field(90; "Extract Codeunit ID"; Integer)
        {
            Caption = 'Extract Codeunit ID';
            DataClassification = CustomerContent;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Codeunit), "Object ID" = filter(80000 .. 99999), "Object Caption" = filter('*Flow Extract*'));
        }
        field(100; "Extract Codeunit Name"; Text[50])
        {
            Caption = 'Extract Codeunit Name';
            FieldClass = FlowField;
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Codeunit), "Object ID" = field("Extract Codeunit ID")));
        }
        field(110; "Process Codeunit ID"; Integer)
        {
            Caption = 'Process Codeunit ID';
            DataClassification = CustomerContent;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Codeunit), "Object ID" = filter(80000 .. 99999), "Object Caption" = filter('*Flow Process*'));
        }
        field(120; "Process Codeunit Name"; Text[50])
        {
            Caption = 'Process Codeunit Name';
            FieldClass = FlowField;
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Codeunit), "Object ID" = field("Process Codeunit ID")));
        }
        field(130; "Flow Buffer Page ID"; Integer)
        {
            Caption = 'Flow Buffer Page ID';
            DataClassification = CustomerContent;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Page), "Object ID" = filter(80000 .. 99999), "Object Caption" = filter('*Flow Buffer*'));
        }
        field(140; "Flow Buffer Page Name"; Text[50])
        {
            Caption = 'Flow Buffer Page Name';
            FieldClass = FlowField;
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Page), "Object ID" = field("Flow Buffer Page ID")));
        }
        field(150; "EndPoint Type"; Option)
        {
            Caption = 'EndPoint Type';
            DataClassification = CustomerContent;
            OptionMembers = " ",Blob,MQ,SMTP;
            OptionCaption = ' ,Blob,MQ,SMTP';
            trigger OnValidate()
            begin
                if "EndPoint Type" <> xRec."EndPoint Type" then
                    Validate("EndPoint Code", '');
                if "EndPoint Type" = "EndPoint Type"::SMTP then
                    TestField(Direction, Direction::Send)
                else
                    "EndPoint Recipients" := '';
            end;
        }
        field(160; "EndPoint Code"; Code[20])
        {
            Caption = 'EndPoint Code';
            DataClassification = CustomerContent;
            TableRelation = if ("EndPoint Type" = const(Blob)) "MICA Flow EndPoint".Code where("EndPoint Type" = const(Blob))
            else
            if ("EndPoint Type" = const(MQ)) "MICA Flow EndPoint".Code where("EndPoint Type" = const(MQ));
            trigger OnValidate()
            var
                FlowEntry: Record "MICA Flow Entry";
            begin
                FlowEntry.SetCurrentKey("EndPoint Type", "EndPoint Code");
                FlowEntry.SetRange("EndPoint Type", xRec."EndPoint Type");
                FlowEntry.SetRange("EndPoint Code", xRec."EndPoint Code");
                if FlowEntry.FindSet() then
                    repeat
                        FlowEntry.Validate("EndPoint Type", "EndPoint Type");
                        FlowEntry.Validate("EndPoint Code", "EndPoint Code");
                        FlowEntry.Modify(true);
                    until FlowEntry.Next() = 0;
            end;
        }

        field(165; "EndPoint Recipients"; Text[250])
        {
            caption = 'EndPoint Recipients';
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;
            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "EndPoint Recipients" = '' then
                    exit;
                MailManagement.CheckValidEmailAddresses("EndPoint Recipients");
            end;
        }
        field(170; "Blob Container"; Text[250])
        {
            Caption = 'Blob Container';
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                TempMICAMMEBlobStorageCntr: Record "MICA MME BlobStorage Container" temporary;
                FlowEndPoint: Record "MICA Flow EndPoint";
                InterfaceMonitoring: Codeunit "MICA Interface Monitoring";
                MICABlobStorCntrLt: Page "MICA BlobStor. Container List";
            begin
                FlowEndpoint.Get("EndPoint Code");
                if not InterfaceMonitoring.ListContainers(TempMICAMMEBlobStorageCntr, copystr(FlowEndpoint.SubstituteParameters(FlowEndpoint."Blob Storage"), 1, 100), FlowEndpoint."Blob SSAS Signature") then
                    Error(GetLastErrorText());

                Clear(MICABlobStorCntrLt);
                MICABlobStorCntrLt.InsertTemp(TempMICAMMEBlobStorageCntr);
                MICABlobStorCntrLt.SetRecord(TempMICAMMEBlobStorageCntr);
                MICABlobStorCntrLt.LookupMode(true);
                if MICABlobStorCntrLt.RunModal() = Action::LookupOK then begin
                    MICABlobStorCntrLt.GetRecord(TempMICAMMEBlobStorageCntr);
                    Validate("Blob Container", TempMICAMMEBlobStorageCntr.Name);
                end;
            end;
        }
        field(172; "Blob Prefix"; Text[250])
        {
            Caption = 'Blob Prefix';
            DataClassification = CustomerContent;
        }
        field(180; "MQ Sub URL"; Text[250])
        {
            Caption = 'MQ Sub URL';
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;
        }
        field(190; "Allow Upload by User"; Boolean)
        {
            Caption = 'Allow Upload by User';
            DataClassification = CustomerContent;
        }
        field(200; "Allow Download by User"; Boolean)
        {
            Caption = 'Allow Download by User';
            DataClassification = CustomerContent;
        }
        field(210; "Allow Partial Processing"; Boolean)
        {
            Caption = 'Allow Partial Processing';
            DataClassification = CustomerContent;
        }
        field(220; "Allow Reprocessing"; Boolean)
        {
            Caption = 'Allow Reprocessing';
            DataClassification = CustomerContent;
        }
        field(230; "Allow Skip Line"; Boolean)
        {
            Caption = 'Allow Skip Line';
            DataClassification = CustomerContent;
        }

        field(240; "Count of Entry"; Integer)
        {
            Caption = 'Count of Entry';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Entry" where("Flow Code" = field(Code)));
            BlankZero = true;
        }
        field(250; "Count of Archived Entry"; Integer)
        {
            Caption = 'Count of Archived Entry';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Entry Archive" where("Flow Code" = field(Code)));
            BlankZero = true;
        }
        field(260; "Info Count"; Integer)
        {
            Caption = 'Info Count';
            Editable = false;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Information), "Flow Code" = field("Code")));
        }
        field(270; "Warning Count"; Integer)
        {
            Caption = 'Warning Count';
            Editable = false;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Warning), "Flow Code" = field("Code")));
        }
        field(280; "Error Count"; Integer)
        {
            Caption = 'Error Count';
            Editable = false;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Error), "Flow Code" = field("Code")));
        }
        field(282; "Open Error Count"; Integer)
        {
            Caption = 'Open Error Count';
            Editable = false;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where
                ("Flow Code" = field(Code),
                "Info Type" = const(Error),
                Status = const(Open),
                "Created Date" = field("Date Filter")));
        }
        field(283; "In Progress Error Count"; Integer)
        {
            Caption = 'In Progress Error Count';
            Editable = false;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where
                ("Flow Code" = field(Code),
                "Info Type" = const(Error),
                Status = const(InProgress),
                "Created Date" = field("Date Filter")));
        }
        field(284; "Closed Error Count"; Integer)
        {
            Caption = 'Closed Error Count';
            Editable = false;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where
                ("Flow Code" = field(Code),
                "Info Type" = const(Error),
                Status = const(Closed),
                "Created Date" = field("Date Filter")));
            ;
        }
        field(290; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            Caption = 'Date Filter';
        }
        field(300; "Last Executed Date Time"; DateTime)
        {
            Caption = 'Last Executed Date Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(310; "Last Executed Duration"; Duration)
        {
            Caption = 'Last Executed Duration';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(320; "Archive Data After"; DateFormula)
        {
            Caption = 'Archive Data After';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if WorkDate() > CalcDate("Archive Data After", WorkDate()) then
                    Error(DateFormulaMustBePositiveErr);
            end;
        }
        field(330; "Delete Archived Data After"; DateFormula)
        {
            Caption = 'Delete Archived Data After';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if WorkDate() > CalcDate("Delete Archived Data After", WorkDate()) then
                    Error(DateFormulaMustBePositiveErr);
            end;
        }
        field(340; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(350; "Last Modified User ID"; Code[50])
        {
            Caption = 'Last Modified User ID';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User."User Name";
        }
        field(360; "Delete After Receive"; Boolean)
        {
            Caption = 'Delete After Receive';
            DataClassification = CustomerContent;
        }
        field(370; "Post Process Codeunit ID"; Integer)
        {
            Caption = 'Post Process Codeunit ID';
            DataClassification = CustomerContent;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Codeunit), "Object ID" = filter(80000 .. 99999), "Object Caption" = filter('*Flow*Post*'));

        }
        field(380; "Post Process Codeunit Name"; Text[50])
        {
            Caption = 'Post Process Codeunit Name';
            FieldClass = FlowField;
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Codeunit), "Object ID" = field("Post Process Codeunit ID")));
        }
        field(390; "Remove XML NameSpaces"; Boolean)
        {
            Caption = 'Remove XML NameSpaces';
            DataClassification = CustomerContent;
        }
        field(400; "ACK Flow Code"; Code[20])
        {
            Caption = 'ACK Flow Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow" where("Is ACK" = const(true), Direction = const(Send));
        }
        field(410; "Is ACK"; Boolean)
        {
            Caption = 'Is ACK';
            DataClassification = CustomerContent;
        }
        field(420; "Disable Calc. Descripton"; Boolean)
        {
            Caption = 'Disable Calc. Descripton';
            DataClassification = CustomerContent;
        }
        field(500; "Use Encryption"; Boolean)
        {
            Caption = 'Use OnPremise Encryption';
            DataClassification = CustomerContent;
        }
        field(510; "Public Key Filepath"; Text[250])
        {
            Caption = 'Public Key Filepath';
            DataClassification = CustomerContent;
        }
        field(520; "Use SaaS Encryption"; Boolean)
        {
            Caption = 'Use SaaS Encryption';
            DataClassification = CustomerContent;
        }
        field(530; "Public Key File Name"; Text[250])
        {
            Caption = 'Public Key File Name';
            DataClassification = CustomerContent;
        }
        field(540; "Public Key Blob"; Blob)
        {
            Caption = 'Public Key Blob';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    var
        DirectionMustNotBeBlankErr: Label 'Direction must not be blank';
        DateFormulaMustBePositiveErr: Label 'DateFormula must be positive';
        ImportTxt: Label 'Import';
        AllFilesDescriptionTxt: Label 'All Files (*.*)|*.*';
        AllFilesFilterTxt: Label '*.*';
        StartSendFlowTxt: Label 'Send Flow Entry %1';
        StartReceiveFlowEntryTxt: Label 'Receive Flow Entry %1';
        YouHaveMessageErrorErr: Label 'You have a message error : check Flow Entry No. %1';
        EndPointNotFoundWarningMsg: label 'No EndPoint found.';

        EndPointRecipientsEmptyErr: label '%1 is empty.';

    trigger OnInsert()
    begin
        Validate("Last Modified Date Time", CurrentDateTime());
        Validate("Last Modified User ID", UserId());
    end;

    trigger OnModify()
    begin
        Validate("Last Modified Date Time", CurrentDateTime());
        Validate("Last Modified User ID", UserId());
    end;

    trigger OnDelete()
    var
        MICAFlowSetup: Record "MICA Flow Setup";
    begin
        MICAFlowSetup.SetRange(Flow, Code);
        MICAFlowSetup.DeleteAll(true);
    end;

    procedure Release()
    var
        MICAIntMonitoringSetup: Record "MICA Int. Monitoring Setup";
    begin

        TestField(Status, Status::Open);
        TestField(Description);
        TestField("Partner Code");
        if Direction = Direction::" " then
            Error(DirectionMustNotBeBlankErr);
        case "EndPoint Type" of
            "EndPoint Type"::Blob:
                begin
                    TestField("Blob Container");
                    if not MICAIntMonitoringSetup.get() then;
                    if not MICAIntMonitoringSetup."Disable Blob Prefix Control" then
                        TestField("Blob Prefix");
                end;
            "EndPoint Type"::SMTP:
                TestField("EndPoint Recipients");
        end;
        if "Use Encryption" then
            TestField("Public Key Filepath");
        Validate(Status, Status::Released);
        Modify(true);
    end;

    procedure Open()
    begin
        Validate(Status, Status::Open);
        Modify(true);
    end;

    procedure CreateFlowEntry(): Integer
    var
        MICAFlowEntry: Record "MICA Flow Entry";
        FlowEntryDescLbl: Label '%1-EntryNo%2-%3';
    begin
        TestField(Status, Status::Released);
        MICAFlowEntry.Init();
        MICAFlowEntry.Validate("Flow Code", Code);
        MICAFlowEntry.Validate("Direction", Direction);
        if MICAFlowEntry.Direction = MICAFlowEntry.Direction::Receive then
            MICAFlowEntry.Validate("Receive Status", MICAFlowEntry."Receive Status"::Created);
        MICAFlowEntry.Insert(true);
        MICAFlowEntry.Description := StrSubstNo(FlowEntryDescLbl, Code, MICAFlowEntry."Entry No.", DelChr(format(CurrentDateTime(), 0, 9), '=', '.:-/\'));
        MICAFlowEntry.Modify(true);
        exit(MICAFlowEntry."Entry No.");
    end;

    procedure CreateFlowEntry(Upload: Boolean): Integer
    var
        FlowEntryNo: Integer;
    begin
        FlowEntryNo := CreateFlowEntry();
        //if FlowEntryNo <> 0 then begin
        //    Validate("EndPoint Type", "EndPoint Type"::Uploaded);
        //    Validate("EndPoint Code", '');
        //    Modify(true);
        //end;
        exit(FlowEntryNo);
    end;

    procedure CreateFlowEntry(ForcedStatus: Integer): Integer
    var
        MICAFlowEntry: Record "MICA Flow Entry";
        FlowEntryNo: Integer;
    begin
        FlowEntryNo := CreateFlowEntry();
        if MICAFlowEntry.Get(FlowEntryNo) then begin
            MICAFlowEntry.Validate("Receive Status", ForcedStatus);
            MICAFlowEntry.Modify(true);
        end;
        exit(FlowEntryNo);
    end;

    procedure UploadData()
    var
        MICAFlow: Record "MICA Flow";
        MICAFlowEntry: Record "MICA Flow Entry";
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        FlowEntryRecordRef: RecordRef;
        FileName: Text;
        CopyStrStart: Integer;
        OutStream: OutStream;
        InStream: InStream;
    begin
        TestField(Status, Status::Released);
        TestField("Allow Upload by User", true);
        FileName := FileManagement.BLOBImportWithFilter(TempBlob, ImportTxt, FileName, AllFilesDescriptionTxt, AllFilesFilterTxt);
        if FileName = '' then
            exit;
        if MICAFlowEntry.Get(CreateFlowEntry(true)) then begin
            if Direction = Direction::Send then begin
                MICAFlow.Get(MICAFlowEntry."Flow Code");
                if not MICAFlow."Set Prepared manually" then
                    MICAFlowEntry.Validate("Send Status", MICAFlowEntry."Send Status"::Prepared)
            end else
                if Direction = Direction::Receive then
                    MICAFlowEntry.Validate("Receive Status", MICAFlowEntry."Receive Status"::Received);
            //CopyStr()
            FlowEntryRecordRef.Open(Database::"MICA Flow Entry");
            CopyStrStart := StrLen(FileName) - FlowEntryRecordRef.Field(MICAFlowEntry.FieldNo(Description)).Length() + 1;
            if CopyStrStart < 1 then
                CopyStrStart := 1;
            MICAFlowEntry.Validate(Description, "Blob Prefix" + '/' + CopyStr(FileName, CopyStrStart, 250));

            Clear(InStream);
            Clear(OutStream);
            TempBlob.CreateInStream(InStream);
            MICAFlowEntry.Blob.CreateOutStream(OutStream);
            CopyStream(OutStream, InStream);
            MICAFlowEntry.Validate(Blob);

            MICAFlowEntry.Validate(Uploaded, true);
            MICAFlowEntry.Modify(true);
            if "Remove XML NameSpaces" then
                MICAFlowEntry.RemoveNameSpaces();
            MICAFlowEntry.UpdateFlowEntryDescription();
        end;
    end;

    procedure SendData()
    var
        MICAFlowEndPoint: Record "MICA Flow EndPoint";
        MICAFlowEntry: Record "MICA Flow Entry";
        UpdatedMICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowInformation: Record "MICA Flow Information";
        ErrorMICAFlowInformation: Record "MICA Flow Information";
        MICAInterfaceMonitoring: Codeunit "MICA Interface Monitoring";
        ErrorMsgID: Text;
        ErrorMsg: Text;
        ErrorExplanation: Text;
        ErrorAction: Text;
        MyInStream: InStream;
    begin
        TestField(Status, Status::Released);

        ClearLastError();

        case "EndPoint Type" of
            "EndPoint Type"::SMTP:
                if "EndPoint Recipients" = '' then begin
                    AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(EndPointRecipientsEmptyErr, FieldCaption("EndPoint Recipients")), '');
                    exit;
                end;
            else
                if not MICAFlowEndPoint.Get("EndPoint Code") then begin
                    AddInformation(MICAFlowInformation."Info Type"::Warning, EndPointNotFoundWarningMsg, '');
                    exit;
                end;
        end;

        MICAFlowEntry.Reset();
        MICAFlowEntry.SetCurrentKey("Flow Code", "Send Status", "Skip this Entry");
        MICAFlowEntry.SetRange("Flow Code", Code);
        MICAFlowEntry.SetRange("Send Status", MICAFlowEntry."Send Status"::Prepared);
        MICAFlowEntry.SetRange("Skip this Entry", false);
        if MICAFlowEntry.FindSet() then
            repeat
                UpdatedMICAFlowEntry.get(MICAFlowEntry."Entry No.");
                MICAFlowInformation.get(UpdatedMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, CopyStr(StrSubstNo(StartSendFlowTxt, Format(UpdatedMICAFlowEntry."Entry No.")), 1, 250), ''));
                UpdatedMICAFlowEntry.CalcFields(Blob);
                if "Remove XML NameSpaces" then
                    UpdatedMICAFlowEntry.RemoveNameSpaces();
                UpdatedMICAFlowEntry.Blob.CreateInStream(MyInStream);
                case "EndPoint Type" of
                    "EndPoint Type"::Blob:
                        if not TryPutBlob(MICAFlowEndPoint, UpdatedMICAFlowEntry, MyInStream) then begin
                            Clear(ErrorMICAFlowInformation);
                            MICAFlowInformation.Validate("Info Type", ErrorMICAFlowInformation."Info Type"::Error);
                            MICAFlowInformation.Validate("Description 2", CopyStr(GetLastErrorText(), 1, 250));
                            Message(YouHaveMessageErrorErr, MICAFlowInformation."Entry No.");
                        end else
                            UpdatedMICAFlowEntry.SetStatusToSent();
                    "EndPoint Type"::MQ:
                        if not MICAInterfaceMonitoring.SendMessageToQueue(
                                MyInStream,
                                Rec,
                                MICAFlowEndPoint,
                                ErrorMsgID,
                                ErrorMsg,
                                ErrorExplanation,
                                ErrorAction)
                        then begin
                            MICAFlowInformation.Validate("Info Type", ErrorMICAFlowInformation."Info Type"::Error);
                            MICAFlowInformation.Validate("Description 2", CopyStr(ErrorMsg, 1, 250));
                            Message(YouHaveMessageErrorErr, MICAFlowInformation."Entry No.");
                        end else
                            UpdatedMICAFlowEntry.SetStatusToSent();
                    "EndPoint Type"::SMTP:
                        if not MICAInterfaceMonitoring.SendFileUsingSmtp(MyInStream, Rec, MICAFlowEntry) then begin
                            MICAFlowInformation.Validate("Info Type", ErrorMICAFlowInformation."Info Type"::Error);
                            MICAFlowInformation.Validate("Description 2", GetLastErrorText());
                            Message(YouHaveMessageErrorErr, MICAFlowInformation."Entry No.");
                        end else
                            UpdatedMICAFlowEntry.SetStatusToSent();
                end;
                MICAFlowInformation.Update('', '');
            until MICAFlowEntry.Next() = 0;

    end;

    [TryFunction]
    local procedure TryPutBlob(MICAFlowEndPoint: Record "MICA Flow EndPoint"; var MICAFlowEntry: Record "MICA Flow Entry"; MyInStream: InStream)
    var
        MICAInterfaceMonitoring: Codeunit "MICA Interface Monitoring";
    begin
        MICAFlowEntry.UpdateNameWithPrefix();
        MICAInterfaceMonitoring.PutBlob(
            Copystr(MICAFlowEndPoint.SubstituteParameters(MICAFlowEndPoint."Blob Storage"), 1, 100),
            MICAFlowEndPoint."Blob SSAS Signature",
            MICAFlowEndPoint.SubstituteParameters("Blob Container"),
            MICAFlowEntry.Description,
            MyInStream)
    end;

    procedure ReceiveData()
    var
        MICAFlowEndPoint: Record "MICA Flow EndPoint";
        ErrorMICAFlowInformation: Record "MICA Flow Information";
        TempMICAMMEBlobStorageBlob: Record "MICA MME BlobStorage Blob" temporary;
        MICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowInformation: Record "MICA Flow Information";
        TempBlob: Codeunit "Temp Blob";
        MICAInterfaceMonitoring: Codeunit "MICA Interface Monitoring";
        ErrorMsgID: Text;
        ErrorMsg: Text;
        ErrorExplanation: Text;
        ErrorAction: Text;
        FlowEntryNo: Integer;
        MaxCountOfMsgToRetrieve: Integer;
        CountOfMsgRetrieved: Integer;
        QueueEmptyInfoMsg: label 'Queue is empty.';
        BlobListEmptyInfoMsg: label 'Blob storage is empty.';
        YouHaveMessageErr: label 'Error reported in Entry No. %1.';
        LimitedGetWarningMsg: label 'Field %1 is not enabled in Flow Card: only %2 message(s) are read from queue.';
        MsgInfoType: Integer;
        OutStream: OutStream;
        InStream: InStream;
    begin
        TestField(Status, Status::Released);
        if not MICAFlowEndPoint.Get("EndPoint Code") then begin
            AddInformation(ErrorMICAFlowInformation."Info Type"::Warning, EndPointNotFoundWarningMsg, '');
            exit;
        end;

        case MICAFlowEndPoint."EndPoint Type" of
            MICAFlowEndPoint."EndPoint Type"::Blob:
                if not MICAInterfaceMonitoring.GetListOfBlob(rec, MICAFlowEndPoint, TempMICAMMEBlobStorageBlob) then begin
                    Message(YouHaveMessageErr, AddInformation(ErrorMICAFlowInformation."Info Type"::Error, GetLastErrorText(), ''));
                    exit;
                end else begin
                    if TempMICAMMEBlobStorageBlob.Count() = 0 then begin
                        //Message(BlobListEmptyInfoMsg, 
                        AddInformation(ErrorMICAFlowInformation."Info Type"::Information, BlobListEmptyInfoMsg, '');
                        exit;
                    end;
                    TempMICAMMEBlobStorageBlob.FindSet();
                    repeat
                        FlowEntryNo := CreateFlowEntry();
                        if MICAFlowEntry.Get(FlowEntryNo) then begin
                            MICAFlowEntry.Validate(Description, TempMICAMMEBlobStorageBlob.Name);
                            MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, CopyStr(StrSubstNo(StartReceiveFlowEntryTxt, Format(MICAFlowEntry."Entry No.")), 1, 250), ''));
                            if not TryGetBlob(MICAFlowEndPoint, TempMICAMMEBlobStorageBlob, MICAFlowEntry) then begin
                                MICAFlowInformation.Validate("Info Type", MICAFlowInformation."Info Type"::Error);
                                MICAFlowInformation.Validate("Description 2", CopyStr(GetLastErrorText(), 1, 250));
                                Message(YouHaveMessageErr, MICAFlowInformation."Entry No.");
                            end else
                                if "Delete After Receive" then
                                    if not TryDeleteBlob(MICAFlowEndPoint, TempMICAMMEBlobStorageBlob) then begin
                                        MICAFlowInformation.Validate("Info Type", MICAFlowInformation."Info Type"::Error);
                                        MICAFlowInformation.Validate("Description 2", CopyStr(GetLastErrorText(), 1, 250));
                                        Message(YouHaveMessageErr, MICAFlowInformation."Entry No.");
                                    end;
                            if Direction = Direction::Send then
                                MICAFlowEntry.Validate("Send Status", MICAFlowEntry."Send Status"::Prepared)
                            else
                                if Direction = Direction::Receive then
                                    MICAFlowEntry.Validate("Receive Status", MICAFlowEntry."Receive Status"::Received);
                            MICAFlowEntry.Modify(true);
                            if "Remove XML NameSpaces" then
                                MICAFlowEntry.RemoveNameSpaces();
                            MICAFlowEntry.UpdateFlowEntryDescription();
                            MICAFlowInformation.Update('', '');
                        end;
                    until TempMICAMMEBlobStorageBlob.Next() = 0;
                end;

            MICAFlowEndPoint."EndPoint Type"::MQ:
                begin
                    CountOfMsgRetrieved := 0;
                    MaxCountOfMsgToRetrieve := 99999;
                    if not "Delete After Receive" then
                        MaxCountOfMsgToRetrieve := 1;//avoid infinite loop in case of msg not deleted                

                    while
                        (MICAInterfaceMonitoring.GetMessageFromQueue(TempBlob, Rec, MICAFlowEndPoint, ErrorMsgID, ErrorMsg, ErrorExplanation, ErrorAction)) and
                        (CountOfMsgRetrieved < MaxCountOfMsgToRetrieve)
                    do begin
                        FlowEntryNo := CreateFlowEntry();
                        MICAFlowEntry.Get(FlowEntryNo);

                        Clear(InStream);
                        Clear(OutStream);
                        TempBlob.CreateInStream(InStream);
                        MICAFlowEntry.Blob.CreateOutStream(OutStream);
                        CopyStream(OutStream, InStream);
                        MICAFlowEntry.Validate(Blob);

                        MICAFlowEntry.Validate("Receive Status", MICAFlowEntry."Receive Status"::Received);
                        MICAFlowEntry.Modify(true);
                        if "Remove XML NameSpaces" then
                            MICAFlowEntry.RemoveNameSpaces();
                        MICAFlowEntry.UpdateFlowEntryDescription();
                        CountOfMsgRetrieved += 1;
                        clear(TempBlob);
                    end;

                    MsgInfoType := MICAFlowInformation."Info Type"::Error; //by default
                    if (not "Delete After Receive") and (CountOfMsgRetrieved > 0) then begin
                        ErrorMsg := StrSubstNo(LimitedGetWarningMsg, FieldCaption("Delete After Receive"), MaxCountOfMsgToRetrieve);
                        MsgInfoType := MICAFlowInformation."Info Type"::Warning;
                    end;

                    if ErrorMsgID = 'EMPTYQUEUE' then //=Empty blob returned by InterfaceMonitoring.GetMessageFromQueue
                        AddInformation(MICAFlowInformation."Info Type"::Information, QueueEmptyInfoMsg, '')
                    else begin
                        AddInformation(MsgInfoType, ErrorMsg, ErrorMsgID);
                        Message(ErrorMsg);
                    end;
                end;
        end;
    end;


    [TryFunction]
    local procedure TryGetBlob(MICAFlowEndPoint: Record "MICA Flow EndPoint"; TempMICAMMEBlobStorageBlob: Record "MICA MME BlobStorage Blob" temporary; var MICAFlowEntry: Record "MICA Flow Entry")
    var
        TempBlob: Codeunit "Temp Blob";
        MICAInterfaceMonitoring: Codeunit "MICA Interface Monitoring";
        MyInStream: InStream;
        MyOutStream: OutStream;
    begin
        MICAInterfaceMonitoring.GetBlob(MICAFlowEndPoint."Blob Storage", MICAFlowEndPoint."Blob SSAS Signature", "Blob Container", TempMICAMMEBlobStorageBlob.Name, MyInStream);
        TempBlob.CreateOutStream(MyOutStream);
        CopyStream(MyOutStream, MyInStream);

        Clear(MyInStream);
        Clear(MyOutStream);
        TempBlob.CreateInStream(MyInStream);
        MICAFlowEntry.Blob.CreateOutStream(MyOutStream);
        CopyStream(MyOutStream, MyInStream);
        MICAFlowEntry.Validate(Blob);

    end;

    [TryFunction]
    local procedure TryDeleteBlob(MICAFlowEndPoint: Record "MICA Flow EndPoint"; TempMICAMMEBlobStorageBlob: Record "MICA MME BlobStorage Blob" temporary)
    var
        MICAInterfaceMonitoring: Codeunit "MICA Interface Monitoring";
    begin
        MICAInterfaceMonitoring.DeleteBlob(CopyStr(MICAFlowEndPoint.SubstituteParameters(MICAFlowEndPoint."Blob Storage"), 1, 100), MICAFlowEndPoint."Blob SSAS Signature", TempMICAMMEBlobStorageBlob.Container, TempMICAMMEBlobStorageBlob.Name);
    end;

    procedure AddInformation(Type: Option; Description1: Text; Description2: Text): Integer
    var
        MICAFlowInformation: Record "MICA Flow Information";
    begin
        MICAFlowInformation.Init();
        MICAFlowInformation.Validate("Flow Code", Code);
        MICAFlowInformation.Validate("Info Type", Type);
        MICAFlowInformation.Validate(Description, CopyStr(Description1, 1, MaxStrLen(MICAFlowInformation.Description)));
        MICAFlowInformation.Validate("Description 2", CopyStr(Description2, 1, MaxStrLen(MICAFlowInformation."Description 2")));
        MICAFlowInformation.Insert(true);
        exit(MICAFlowInformation."Entry No.")
    end;

    procedure ExtractAll()
    var
        MICAFlowEntry: Record "MICA Flow Entry";
        ExtractedMICAFlowEntry: Record "MICA Flow Entry";
    begin
        TestField(Status, Status::Released);
        MICAFlowEntry.Reset();
        MICAFlowEntry.SetCurrentKey("Flow Code", "Receive Status", "Skip this Entry");
        MICAFlowEntry.SetRange("Flow Code", Code);
        MICAFlowEntry.SetRange("Receive Status", MICAFlowEntry."Receive Status"::Received);
        MICAFlowEntry.SetRange("Skip this Entry", false);
        if MICAFlowEntry.FindSet() then
            repeat
                ExtractedMICAFlowEntry.get(MICAFlowEntry."Entry No.");
                ExtractedMICAFlowEntry.Extract();
                Commit();
            until MICAFlowEntry.Next() = 0;
    end;

    procedure ProcessAll()
    var
        MICAFlowEntry: Record "MICA Flow Entry";
        ProcessedMICAFlowEntry: Record "MICA Flow Entry";
    begin
        TestField(Status, Status::Released);
        MICAFlowEntry.Reset();
        MICAFlowEntry.SetCurrentKey("Flow Code", "Receive Status", "Skip this Entry");
        MICAFlowEntry.SetRange("Flow Code", Code);
        MICAFlowEntry.SetRange("Receive Status", MICAFlowEntry."Receive Status"::Loaded);
        MICAFlowEntry.SetRange("Skip this Entry", false);
        if MICAFlowEntry.FindSet() then
            repeat
                ProcessedMICAFlowEntry.get(MICAFlowEntry."Entry No.");
                ProcessedMICAFlowEntry.Process(false);
                Commit();
            until MICAFlowEntry.Next() = 0;
    end;

    procedure PostProcessAll()
    var
        MICAFlowEntry: Record "MICA Flow Entry";
        PostProcessedMICAFlowEntry: Record "MICA Flow Entry";
    begin
        TestField(Status, Status::Released);
        MICAFlowEntry.Reset();
        MICAFlowEntry.SetCurrentKey("Flow Code", "Receive Status", "Skip this Entry");
        MICAFlowEntry.SetRange("Flow Code", Code);
        MICAFlowEntry.SetRange("Receive Status", MICAFlowEntry."Receive Status"::Processed);
        MICAFlowEntry.SetRange("Skip this Entry", false);
        if MICAFlowEntry.FindSet() then
            repeat
                PostProcessedMICAFlowEntry.get(MICAFlowEntry."Entry No.");
                PostProcessedMICAFlowEntry.PostProcess();
                Commit();
            until MICAFlowEntry.Next() = 0;
    end;

    procedure ExecuteSendCodeunit()
    begin
        TestField("Is ACK", false);
        if "Send Codeunit ID" <> 0 then begin
            Commit();
            Codeunit.Run("Send Codeunit ID", Rec);
        end;
    end;

    procedure ExecuteSendACKCodeunit(MICAFlowEntry: Record "MICA Flow Entry")
    begin
        TestField("Is ACK", true);
        if "Send Codeunit ID" <> 0 then begin
            Commit();
            Codeunit.Run("Send Codeunit ID", MICAFlowEntry);
        end;
    end;

    procedure SetAckConfirm(MICAFlowEntry: Record "MICA Flow Entry"; AckConfirm: Boolean)
    var
        MICAFlowRecord: Record "MICA Flow Record";
        RecordRef: RecordRef;
        myFieldRef: FieldRef;
    begin
        MICAFlowRecord.SetRange("Flow Entry No.", MICAFlowEntry."Entry No.");
        if MICAFlowRecord.FindSet() then
            repeat
                if RecordRef.Get(MICAFlowRecord."Linked RecordID") then begin
                    myFieldRef := RecordRef.Field(80869);
                    myFieldRef.Value(AckConfirm);
                    RecordRef.Modify(true);
                end;
            until MICAFlowRecord.Next() = 0;
    end;

    procedure GetCRLF(): Text
    var
        CRLF: Text[2];
    begin
        CRLF[1] := 13;
        CRLF[2] := 10;
        EXIT(CRLF);
    end;

    procedure UploadPublicKey()
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        FileName: Text;
        InStream: InStream;
        OutStream: OutStream;
        EmptyPublicKeyLbl: Label 'The file containing the public key is empty';
    begin
        TestField("Use SaaS Encryption", true);

        FileName := FileManagement.BLOBImportWithFilter(TempBlob, ImportTxt, FileName, AllFilesDescriptionTxt, AllFilesFilterTxt);
        if FileName = '' then
            exit;

        TempBlob.CreateInStream(InStream);
        Rec."Public Key Blob".CreateOutStream(OutStream);
        CopyStream(OutStream, InStream);
        Rec.CalcFields("Public Key Blob");
        if Rec."Public Key Blob".Length() > 0 then begin
            Rec.Validate("Public Key File Name", FileName);
            Rec.Modify(true);
        end else
            Error(EmptyPublicKeyLbl);
    end;

    procedure ClearPublicKey()
    begin
        TestField("Use SaaS Encryption", true);
        Rec.CalcFields("Public Key Blob");
        Clear(Rec."Public Key Blob");
        Rec."Public Key File Name" := '';
        Rec.Modify(true);
    end;
}
