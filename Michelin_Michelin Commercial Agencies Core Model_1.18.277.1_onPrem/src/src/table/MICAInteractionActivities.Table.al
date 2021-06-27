table 80100 "MICA Interaction Activities"
{
    // version REQUEST
    DataClassification = CustomerContent;
    DrillDownPageID = "MICA Interaction Activity";
    LookupPageID = "MICA Interaction Activity";

    fields
    {
        field(1; "Interaction No."; Integer)
        {
            Caption = 'Interaction No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Interaction Log Entry"."Entry No.";
        }
        field(2; "Activity No."; Integer)
        {
            Caption = 'Activity No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                UserTask: Record "User Task";
                InteractLogEntry: Record "Interaction Log Entry";
            begin
                if InteractLogEntry.Get("Interaction No.") then begin
                    UserTask.SetRange("MICA Record ID Label", Format(InteractLogEntry.RecordId()));
                    UserTask.SetFilter("Percent Complete", '<%1', 100);
                    if UserTask.FindFirst() then begin
                        UserTask.Validate(Title, Description);
                        UserTask.SetDescription(RequestTxt + Format(InteractLogEntry."Entry No.") + ' ' + InteractLogEntry.Description + '. ' + Description);
                        UserTask.Modify(true);
                    end;
                end;
            end;
        }
        field(4; "Assigned User ID"; Code[50])
        {
            Caption = 'Assigned User ID';
            DataClassification = CustomerContent;
            //Editable = false;
            //TableRelation = User."User Name";
            //ValidateTableRelation = false;
            ObsoleteState = Pending;
            ObsoleteReason = 'Deleted';
        }
        field(5; "Creation Date"; DateTime)
        {
            Caption = 'Creation Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(6; "Creation User ID"; Code[50])
        {
            Caption = 'Creation User ID';
            DataClassification = CustomerContent;
            //Editable = false;
            //TableRelation = User."User Name";
            //ValidateTableRelation = false;
            ObsoleteState = Pending;
            ObsoleteReason = 'Deleted';
        }
        field(7; "Estimated Ending Date"; Date)
        {
            Caption = 'Estimated Ending Date';
            DataClassification = CustomerContent;
        }
        field(8; "Ending Date"; DateTime)
        {
            Caption = 'Ending Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(9; "Internal Comment"; BLOB)
        {
            Caption = 'Internal Comment';
            DataClassification = CustomerContent;
        }
        field(10; "Public Comment"; BLOB)
        {
            Caption = 'Public Comment';
            DataClassification = CustomerContent;
        }
        field(11; "Activity Status"; Option)
        {
            Caption = 'Activity Status';
            DataClassification = CustomerContent;
            Editable = false;
            OptionMembers = Open,Closed;

            trigger OnValidate()
            var
                InteractLogEntry: Record "Interaction Log Entry";
                UserTask: Record "User Task";
                User: Record User;
            begin
                IF ("Activity Status" = "Activity Status"::Closed) AND (xRec."Activity Status" = "Activity Status"::Open) THEN BEGIN
                    "Activity Closer" := UserSecurityId();
                    "Ending Date" := CURRENTDATETIME();
                    if InteractLogEntry.Get("Interaction No.") then begin
                        UserTask.SetRange("MICA Record ID", InteractLogEntry.RecordId());
                        UserTask.SetRange("Completed DateTime", 0DT);
                        if UserTask.FindSet() then
                            repeat
                                UserTask.Validate("Completed DateTime", "Ending Date");
                                User.SetRange("User Security ID", "Activity Closer");
                                if User.FindFirst() then
                                    UserTask.Validate("Completed By", User."User Security ID");
                                if UserTask."Start DateTime" = 0DT then
                                    UserTask.Validate(UserTask."Completed DateTime");
                                UserTask.Modify(true);
                            until UserTask.Next() = 0;
                    end;
                END else
                    if ("Activity Status" = "Activity Status"::Open) AND (xRec."Activity Status" = "Activity Status"::Closed) THEN BEGIN
                        "Activity Closer" := '00000000-0000-0000-0000-000000000000';
                        "Ending Date" := 0DT;
                    end;
            end;
        }
        field(12; "Activity Closer ID"; Code[50])
        {
            Caption = 'Activity Closer ID';
            DataClassification = CustomerContent;
            //Editable = false;
            //TableRelation = User."User Name";
            //ValidateTableRelation = false;
            ObsoleteState = Pending;
            ObsoleteReason = 'Deleted';
        }
        field(13; Level; Integer)
        {
            Caption = 'Level';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
            InitValue = 1;

            trigger OnValidate()
            var
                InteractLogEntry: Record "Interaction Log Entry";
            begin
                IF ("Level" < 1) OR ("Level" > 9) THEN
                    ERROR(Text80010Err);
                InteractLogEntry.Get("Interaction No.");
                if ("Activity Status" = "Activity Status"::Open) and (InteractLogEntry."MICA Request Status" = InteractLogEntry."MICA Request Status"::"In progress") then begin
                    InteractLogEntry.Validate("MICA Level", "Level");
                    InteractLogEntry.Modify(true);
                end;
            end;
        }
        field(14; "Assigned User"; Guid)
        {
            Caption = 'Assigned User';
            TableRelation = User."User Security ID" WHERE("License Type" = CONST("Full User"));
        }
        field(15; "Creation User"; Guid)
        {
            Caption = 'Creation User';
            TableRelation = User."User Security ID" WHERE("License Type" = CONST("Full User"));
        }
        field(16; "Activity Closer"; Guid)
        {
            Caption = 'Activity Closer';
            TableRelation = User."User Security ID" WHERE("License Type" = CONST("Full User"));
        }
        field(17; "Assigned User Name"; Text[80])
        {
            Caption = 'Assigned User Name';
            Editable = false;
            CalcFormula = Lookup(User."Full Name" WHERE("User Security ID" = FIELD("Assigned User"),
                                                         "License Type" = CONST("Full User")));
            FieldClass = FlowField;
        }
        field(18; "Creation User Name"; Text[80])
        {
            Caption = 'Creation User Name';
            Editable = false;
            CalcFormula = Lookup(User."Full Name" WHERE("User Security ID" = FIELD("Creation User"),
                                                         "License Type" = CONST("Full User")));
            FieldClass = FlowField;
        }
        field(19; "Activity Closer Name"; Text[80])
        {
            Caption = 'Activity Closer Name';
            Editable = false;
            CalcFormula = Lookup(User."Full Name" WHERE("User Security ID" = FIELD("Activity Closer"),
                                                         "License Type" = CONST("Full User")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Interaction No.", "Activity No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        MICAInteractionActivities: Record "MICA Interaction Activities";
        UserTask: Record "User Task";
        FoundUserTask: Record "User Task";
        User: Record User;
        InteractionLogEntry: Record "Interaction Log Entry";
    begin
        MICAInteractionActivities.SETRANGE("Interaction No.", "Interaction No.");
        IF MICAInteractionActivities.FINDLAST() THEN
            "Activity No." := MICAInteractionActivities."Activity No." + 1
        ELSE
            "Activity No." := 1;

        UserTask.Init();
        if User.Get(Rec."Assigned User") then
            UserTask.Validate("Assigned To", User."User Security ID");
        if User.Get(Rec."Creation User") then
            UserTask.Validate("Created By", User."User Security ID");
        UserTask.Validate("Created DateTime", Rec."Creation Date");
        UserTask.Validate("Due DateTime", CreateDateTime(Rec."Estimated Ending Date", 0T));
        UserTask.Validate(Title, Rec.Description);
        UserTask.Validate("MICA Process ID", UserTask."MICA Process ID"::"Customer Request");
        UserTask.Validate("Object Type", UserTask."Object Type"::Page);
        UserTask.Validate("Object ID", Page::"MICA New Customer Request");
        if FoundUserTask.FindLast() then
            UserTask.Validate(ID, FoundUserTask.ID + 1)
        else
            UserTask.Validate(ID, 1);
        UserTask.Insert(true);
        InteractionLogEntry.Get(Rec."Interaction No.");
        InteractionLogEntry.SetRange("Entry No.", InteractionLogEntry."Entry No.");
        UserTask.SetMICAURL(GetUrl(ClientType::Web, CompanyName(), ObjectType::Page, Page::"MICA New Customer Request", InteractionLogEntry));
        UserTask.Validate("MICA Record ID", InteractionLogEntry.RecordId());
        UserTask.SetDescription(RequestTxt + Format(InteractionLogEntry."Entry No.") + ' ' + InteractionLogEntry.Description + '. ' + Rec.Description);
        UserTask.Modify(true);
    end;

    procedure GetInternalComment(): Text
    begin
        CALCFIELDS("Internal Comment");
        EXIT(GetInternalCommentInternalCommentCalculated());
    end;

    procedure GetInternalCommentInternalCommentCalculated(): Text
    var
        TempBlob: Codeunit "Temp Blob";
        CR: Text[1];
        InStream: InStream;
        Result: Text;
    begin
        IF NOT "Internal Comment".HASVALUE() THEN
            EXIT('');

        CR[1] := 10;

        TempBlob.FromRecord(Rec, Rec.FieldNo("Internal Comment"));
        TempBLob.CreateInStream(Instream, TextEncoding::Windows);
        Instream.Read(Result);
        Exit(Result);
    end;

    procedure SetInternalComment(NewInternalComment: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        InStream: InStream;
    begin
        CLEAR("Internal Comment");
        IF NewInternalComment = '' THEN
            EXIT;

        TempBlob.FromRecord(Rec, Rec.FieldNo("Internal Comment"));
        Clear(OutStream);
        TempBlob.CreateOutStream(OutStream, TextEncoding::Windows);
        OutStream.Write(NewInternalComment);
        Clear(InStream);
        Clear(OutStream);
        TempBlob.CreateInStream(InStream);
        "Internal Comment".CreateOutStream(OutStream);
        CopyStream(OutStream, InStream);

        Modify();
    end;

    procedure GetPublicComment(): Text
    begin
        CALCFIELDS("Public Comment");
        EXIT(GetPublicCommentPublicCommentCalculated());
    end;

    procedure GetPublicCommentPublicCommentCalculated(): Text
    var
        TempBlob: Codeunit "Temp Blob";
        CR: Text[1];
        InStream: InStream;
        Result: Text;
    begin
        IF NOT "Public Comment".HASVALUE() THEN
            EXIT('');

        CR[1] := 10;
        TempBlob.FromRecord(Rec, Rec.FieldNo("Public Comment"));
        TempBLob.CreateInStream(Instream, TextEncoding::Windows);
        Instream.Read(Result);
        Exit(Result);
    end;

    procedure SetPublicComment(NewPublicComment: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        InStream: InStream;
    begin
        CLEAR("Public Comment");
        IF NewPublicComment = '' THEN
            EXIT;

        TempBlob.FromRecord(Rec, Rec.FieldNo("Public Comment"));
        Clear(OutStream);
        TempBlob.CreateOutStream(OutStream, TextEncoding::Windows);
        OutStream.Write(NewPublicComment);
        Clear(InStream);
        Clear(OutStream);
        TempBlob.CreateInStream(InStream);
        "Public Comment".CreateOutStream(OutStream);
        CopyStream(OutStream, InStream);

        Modify();
    end;

    var
        Text80010Err: Label 'Level is between 1 and 9.';
        RequestTxt: Label 'Request: ';
}

