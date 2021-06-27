table 82680 "MICA Flow Entry Archive"
{
    Caption = 'Flow Entry Archive';
    DataClassification = CustomerContent;
    DrillDownPageId = "MICA Archived Flow Entry List";
    LookupPageId = "MICA Archived Flow Entry List";

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
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
        }
        field(60; "Receive Status"; Option)
        {
            Caption = 'Receive Status';
            DataClassification = CustomerContent;
            OptionMembers = " ",Created,Received,Loaded,Processed,PostProcessed;
            OptionCaption = ' ,Created,Received,Loaded,Processed,Post Processed';
            Editable = false;
        }
        field(70; "Blob"; Blob)
        {
            Caption = 'Blob';
            DataClassification = CustomerContent;
        }
        field(72; "Initial Blob"; Blob)
        {
            Caption = 'Initial Blob';
            DataClassification = CustomerContent;
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
            OptionMembers = " ",Blob,MQ;
            OptionCaption = ' ,Blob,MQ';
            Editable = false;
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
            CalcFormula = count("MICA Flow Record Archive" where("Flow Entry No." = field("Entry No.")));
        }
        field(190; "Info Count"; Integer)
        {
            Caption = 'Info Count';
            Editable = false;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information Archive" where
                ("Flow Entry No." = field("Entry No."),
                "Info Type" = const(Information)));
        }
        field(200; "Warning Count"; Integer)
        {
            Caption = 'Warning Count';
            Editable = false;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information Archive" where
                ("Flow Entry No." = field("Entry No."),
                "Info Type" = const(Warning)));
        }
        field(210; "Error Count"; Integer)
        {
            Caption = 'Error Count';
            Editable = false;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information Archive" where
                ("Flow Entry No." = field("Entry No."),
                "Info Type" = const(Error)));
        }
        field(212; "Open Error Count"; Integer)
        {
            Caption = 'Open Error Count';
            Editable = false;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information Archive" where
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
            CalcFormula = count("MICA Flow Information Archive" where
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
            CalcFormula = count("MICA Flow Information Archive" where
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
            TableRelation = "MICA Flow Entry Archive";
            Editable = false;
        }
        field(710; "ACK Flow Entry Count"; Integer)
        {
            Caption = 'Flow Entry ACK Count';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "MICA Flow Entry Archive";
            CalcFormula = count("MICA Flow Entry Archive" where("ACK from Flow Entry ID" = field("Entry No.")));
        }
        field(82680; "Archive Date Time"; DateTime)
        {
            Caption = 'Archive Date Time';
            DataClassification = CustomerContent;
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
        key(KEY2; "Flow Code")
        {
        }
    }
    procedure DownloadData()
    var
        MICAFlow: Record "MICA Flow";
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        OutStream: OutStream;
        InStream: InStream;
        DefaultFlowDescriptionLbl: Label 'FlowEntry Archive %1 - Entry No %2';
    begin
        if MICAFlow.Get("Flow Code") then begin
            MICAFlow.TestField("Allow Download by User", true);
            CalcFields(Blob);
            TempBlob.CreateInStream(InStream);
            Blob.CreateOutStream(OutStream);
            CopyStream(OutStream, InStream);
            //TempBlob.Blob := Blob;
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
        OutStream: OutStream;
        InStream: InStream;
    begin
        if MICAFlow.Get("Flow Code") then begin
            MICAFlow.TestField("Allow Download by User", true);
            CalcFields("Initial Blob");
            TempBlob.CreateInStream(InStream);
            "Initial Blob".CreateOutStream(OutStream);
            CopyStream(OutStream, InStream);
            //TempBlob.Blob := "Initial Blob";
            TestField(Description);
            FileManagement.BLOBExport(TempBlob, Description, true)
        end;
    end;

    trigger OnInsert()
    begin
        "Archive Date Time" := CurrentDateTime();
    end;
}
