tableextension 80100 "MICA Interaction Log Entry" extends "Interaction Log Entry"
{
    fields
    {
        field(80000; "MICA Linked Request"; Integer)
        {
            Caption = 'Linked Request';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
            TableRelation = "Interaction Log Entry"."Entry No.";
        }
        field(80001; "MICA Interaction Creation Date"; DateTime)
        {
            Caption = 'Interaction Creation Date';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
            Editable = false;
        }
        field(80002; "MICA Responsible User ID"; Code[50])
        {
            Caption = 'Responsible User ID';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
            //Editable = false;
            //TableRelation = User."User Name";
            ObsoleteState = Pending;
            ObsoleteReason = 'Delete';
        }
        field(80003; "MICA Assigned User ID"; Code[50])
        {
            Caption = 'Assigned User ID';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
            //Editable = false;
            //TableRelation = User."User Name";
            ObsoleteState = Pending;
            ObsoleteReason = 'Delete';
        }
        field(80004; "MICA Request Description"; BLOB)
        {
            Caption = 'Request Description';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
        }
        field(80005; "MICA Result Document Type"; Option)
        {
            Caption = 'Result Document Type';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
            OptionCaption = ' ,Sales Order,Sales Return,Sales Shipment,Sales Return Receipt,Sales Invoice,Sales Credit Memo';
            OptionMembers = " ","Sales Order","Sales Return","Sales Shipment","Sales Return Receipt","Sales Invoice","Sales Credit Memo";
            trigger OnValidate()
            begin
                if Rec."MICA Result Document Type" <> xRec."MICA Result Document Type" then
                    "MICA Result Document No." := '';
            end;
        }
        field(80006; "MICA Result Document No."; Code[20])
        {
            Caption = 'Result Document No.';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
            TableRelation = IF ("MICA Result Document Type" = CONST("Sales Order")) "Sales Header"."No." WHERE("Document Type" = CONST(Order), "Sell-to Customer No." = field("MICA Customer No."))
            ELSE
            IF ("MICA Result Document Type" = CONST("Sales Return")) "Sales Header"."No." WHERE("Document Type" = CONST("Return Order"), "Sell-to Customer No." = field("MICA Customer No."))
            ELSE
            IF ("MICA Result Document Type" = CONST("Sales Shipment")) "Sales Shipment Header"."No." where("Sell-to Customer No." = field("MICA Customer No."))
            ELSE
            IF ("MICA Result Document Type" = CONST("Sales Return Receipt")) "Return Receipt Header"."No." where("Sell-to Customer No." = field("MICA Customer No."))
            ELSE
            IF ("MICA Result Document Type" = CONST("Sales Invoice")) "Sales Invoice Header"."No." where("Sell-to Customer No." = field("MICA Customer No."))
            ELSE
            IF ("MICA Result Document Type" = CONST("Sales Credit Memo")) "Sales Cr.Memo Header"."No." where("Sell-to Customer No." = field("MICA Customer No."));
        }
        field(80007; "MICA Request Status"; Option)
        {
            Caption = 'Request Status';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
            //Editable = false;
            OptionMembers = "In progress","Close the Loop","Close the Case","Close the Case - CES";

            trigger OnValidate()
            var
                MICAInteractActivities: Record "MICA Interaction Activities";
                MICACustRqst: Codeunit "MICA Customer Request";
            begin
                if ("MICA Request Status" = "MICA Request Status"::"In progress") and (xRec."MICA Request Status" = rec."MICA Request Status"::"Close the Loop") then begin
                    "MICA Close the Loop Date" := 0DT;
                    "MICA Close the Loop User Guid" := '00000000-0000-0000-0000-000000000000';
                    MICAInteractActivities.SetRange("Interaction No.", "Entry No.");
                    if MICAInteractActivities.FindLast() then begin
                        MICAInteractActivities.Validate("Activity Status", MICAInteractActivities."Activity Status"::Open);
                        MICAInteractActivities.Modify(true);
                    end;
                end else
                    if ("MICA Request Status" = "MICA Request Status"::"Close the Loop") and (xRec."MICA Request Status" = rec."MICA Request Status"::"In progress") then begin
                        MICAInteractActivities.SETRANGE("Interaction No.", Rec."Entry No.");
                        IF MICAInteractActivities.IsEmpty() THEN
                            Error(CanNotCloseLoopWithoutActivityErr);
                        "MICA Close the Loop Date" := CurrentDateTime();
                        "MICA Close the Loop User Guid" := UserSecurityId()
                    end else
                        IF ("MICA Request Status" = "MICA Request Status"::"Close the Case - CES") AND (xRec."MICA Request Status" = "MICA Request Status"::"Close the Case") THEN
                            "MICA Close the Case - CES Date" := CURRENTDATETIME()
                        ELSE
                            IF ("MICA Request Status" = "MICA Request Status"::"Close the Case") AND (xRec."MICA Request Status" = "MICA Request Status"::"Close the Loop") THEN BEGIN
                                "MICA Close the Case Date" := CURRENTDATETIME();
                                "MICA Close the Case User Guid" := UserSecurityId();
                                MICACustRqst.CloseInteractionActivity(Rec);
                            END;
            end;
        }
        field(80008; "MICA CES Evaluation"; Integer)
        {
            BlankZero = true;
            Caption = 'CES Evaluation';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
            InitValue = -1;

            trigger OnValidate()
            begin
                IF ("MICA CES Evaluation" < 0) OR ("MICA CES Evaluation" > 10) THEN
                    ERROR(Text80010Err);

                IF ("MICA CES Evaluation" <> -1) AND ("MICA Request Status" = "MICA Request Status"::"Close the Case") THEN
                    IF "MICA CES Comment".HASVALUE() THEN
                        VALIDATE("MICA Request Status", "MICA Request Status"::"Close the Case - CES")
                    ELSE
                        if GuiAllowed() then
                            IF CONFIRM(Text80000Qst) THEN
                                VALIDATE("MICA Request Status", "MICA Request Status"::"Close the Case - CES")
                            ELSE
                                ERROR(Text80020Err)
                        else
                            VALIDATE("MICA Request Status", "MICA Request Status"::"Close the Case - CES");


            end;
        }
        field(80009; "MICA CES Comment"; BLOB)
        {
            Caption = 'CES Comment';
            DataClassification = CustomerContent;
            Description = 'REQUEST';

            trigger OnValidate()
            begin
                IF ("MICA CES Evaluation" <> 0) AND "MICA CES Comment".HASVALUE() AND xRec."MICA CES Comment".HASVALUE() AND ("MICA Request Status" = "MICA Request Status"::"Close the Case") THEN
                    VALIDATE("MICA Request Status", "MICA Request Status"::"Close the Case - CES");
            end;
        }
        field(80011; "MICA Closed-Michelin Date"; DateTime)
        {
            Caption = 'Closed-Michelin Date';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Name change, new name : Close the Case Date';
        }
        field(80012; "MICA Closed-Customer Date"; DateTime)
        {
            Caption = 'Closed-Customer Date';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Name change, new name : Close the Case - CES Date';
        }
        field(80013; "MICA Public Closing Desc."; BLOB)
        {
            Caption = 'Public Closing Desc.';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
        }
        field(80014; "MICA Internal Closing Desc."; BLOB)
        {
            Caption = 'Internal Closing Desc.';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
        }
        field(80015; "MICA Close the Loop Date"; DateTime)
        {
            Caption = 'Close the Loop Date';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
            Editable = false;
        }
        field(80016; "MICA Close the Loop User"; Code[50])
        {
            Caption = 'Close the Loop User ID';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
            //Editable = false;
            //TableRelation = User."User Name";
            ObsoleteState = Pending;
            ObsoleteReason = 'Delete';
        }
        field(80017; "MICA Level"; Integer)
        {
            Caption = 'Level';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
            InitValue = 1;
            Editable = false;
        }
        field(80018; "MICA Close the Case User"; Code[50])
        {
            Caption = 'Close the Case User ID';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
            //Editable = false;
            //TableRelation = User."User Name";
            ObsoleteState = Pending;
            ObsoleteReason = 'Delete';
        }
        field(80019; "MICA Close the Case Date"; DateTime)
        {
            Caption = 'Close the Case Date';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
            Editable = false;
        }
        field(80020; "MICA Close the Case - CES Date"; DateTime)
        {
            Caption = 'Close the Case - CES Date';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
            Editable = false;
        }
        field(80021; "MICA Doc. Type"; Option)
        {
            Caption = 'Doc. Type';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
            OptionCaption = ' ,Sales Order,Sales Return,Sales Shipment,Sales Return Receipt,Sales Invoice,Sales Credit Memo';
            OptionMembers = " ","Sales Order","Sales Return","Sales Shipment","Sales Return Receipt","Sales Invoice","Sales Credit Memo";
            trigger OnValidate()
            begin
                if (Rec."MICA Doc. Type" <> xRec."MICA Doc. Type") and (Rec."MICA Doc. Type" <> xRec."MICA Doc. Type") then
                    "MICA Doc. No." := '';
                case Rec."MICA Doc. Type" of
                    "MICA Doc. Type"::"Sales Credit Memo":
                        Validate("Document Type", "Document Type"::"Sales Cr. Memo");
                    "MICA Doc. Type"::"Sales Invoice":
                        Validate("Document Type", "Document Type"::"Sales Inv.");
                    "MICA Doc. Type"::"Sales Order":
                        Validate("Document Type", "Document Type"::"Sales Ord. Cnfrmn.");
                    "MICA Doc. Type"::"Sales Return":
                        Validate("Document Type", "Document Type"::"Sales Return Order");
                    "MICA Doc. Type"::"Sales Return Receipt":
                        Validate("Document Type", "Document Type"::"Sales Return Receipt");
                    "MICA Doc. Type"::"Sales Shipment":
                        Validate("Document Type", "Document Type"::"Sales Shpt. Note");
                    else
                        Validate("Document Type", Rec."Document Type"::" ")
                end;
            end;
        }
        field(80022; "MICA Doc. No."; Code[20])
        {
            Caption = 'Doc. No.';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
            TableRelation = IF ("MICA Doc. Type" = CONST("Sales Order")) "Sales Header"."No." WHERE("Document Type" = CONST(Order), "Sell-to Customer No." = field("MICA Customer No."))
            ELSE
            IF ("MICA Doc. Type" = CONST("Sales Return")) "Sales Header"."No." WHERE("Document Type" = CONST("Return Order"), "Sell-to Customer No." = field("MICA Customer No."))
            ELSE
            IF ("MICA Doc. Type" = CONST("Sales Shipment")) "Sales Shipment Header"."No." where("Sell-to Customer No." = field("MICA Customer No."))
            ELSE
            IF ("MICA Doc. Type" = CONST("Sales Return Receipt")) "Return Receipt Header"."No." where("Sell-to Customer No." = field("MICA Customer No."))
            ELSE
            IF ("MICA Doc. Type" = CONST("Sales Invoice")) "Sales Invoice Header"."No." where("Sell-to Customer No." = field("MICA Customer No."))
            ELSE
            IF ("MICA Doc. Type" = CONST("Sales Credit Memo")) "Sales Cr.Memo Header"."No." where("Sell-to Customer No." = field("MICA Customer No."));

            trigger OnValidate()
            begin
                Validate("Document No.", "MICA Doc. No.");
            end;
        }
        field(80023; "MICA Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
        }
        field(80029; "MICA Use Windows Encoding"; Boolean)
        {
            Caption = 'Use Windows Encoding';
            DataClassification = CustomerContent;

        }
        field(80030; "MICA Responsible User"; Guid)
        {
            Caption = 'Responsible User';
            TableRelation = User."User Security ID" WHERE("License Type" = CONST("Full User"));
            DataClassification = CustomerContent;
        }
        field(80031; "MICA Assigned User"; Guid)
        {
            Caption = 'Assigned User';
            TableRelation = User."User Security ID" WHERE("License Type" = CONST("Full User"));
            DataClassification = CustomerContent;
        }
        field(80032; "MICA Close the Loop User Guid"; Guid)
        {
            Caption = 'Close the Loop User';
            TableRelation = User."User Security ID" WHERE("License Type" = CONST("Full User"));
            DataClassification = CustomerContent;
        }
        field(80033; "MICA Close the Case User Guid"; Guid)
        {
            Caption = 'Close the Case User';
            TableRelation = User."User Security ID" WHERE("License Type" = CONST("Full User"));
            DataClassification = CustomerContent;
        }
        field(80034; "MICA User"; Guid)
        {
            Caption = 'User';
            TableRelation = User."User Security ID" WHERE("License Type" = CONST("Full User"));
            DataClassification = CustomerContent;
        }
        field(80035; "MICA Responsible User Name"; Text[80])
        {
            Caption = 'Responsible User Name';
            Description = 'REQUEST';
            Editable = false;
            CalcFormula = lookup (User."Full Name" where("User Security ID" = field("MICA Responsible User"),
                                                         "License Type" = const("Full User")));
            FieldClass = FlowField;
        }
        field(80036; "MICA Assigned User Name"; Text[80])
        {
            Caption = 'Assigned User Name';
            Description = 'REQUEST';
            Editable = false;
            CalcFormula = lookup (User."Full Name" where("User Security ID" = field("MICA Assigned User"),
                                                         "License Type" = const("Full User")));
            FieldClass = FlowField;
        }
        field(80037; "MICA Close the Loop User Name"; Text[80])
        {
            Caption = 'Close the Loop User Name';
            Description = 'REQUEST';
            Editable = false;
            CalcFormula = lookup (User."Full Name" where("User Security ID" = field("MICA Close the Loop User Guid"),
                                                         "License Type" = const("Full User")));
            FieldClass = FlowField;
        }
        field(80038; "MICA Close the Case User Name"; Text[80])
        {
            Caption = 'Close the Case User Name';
            Description = 'REQUEST';
            Editable = false;
            CalcFormula = lookup (User."Full Name" where("User Security ID" = field("MICA Close the Case User Guid"),
                                                         "License Type" = const("Full User")));
            FieldClass = FlowField;
        }
    }

    var
        Text80000Qst: Label 'CES comment not informed. Do you want to continue?';
        Text80010Err: Label 'CES is between 0 and 10.';
        Text80020Err: Label 'CES evaluation cancelled.';
        CanNotCloseLoopWithoutActivityErr: Label 'You can''t close the loop if you don''t have a linked activity ';

    procedure ConvertRequestDescription()
    var
        TempBlob: Codeunit "Temp Blob";
        WindowsEncodedText: text;
        CR: Text[1];
        InStream: InStream;
        OutStream: OutStream;
    begin
        //Temporary function to convert old description in Windows Encodigin to UTF16
        if not confirm('Do you want to convet unreadable description fields for the current record ?', false) then
            exit;

        CR[1] := 10;
        IF "MICA Request Description".HASVALUE() then begin
            calcfields("MICA Request Description");

            TempBlob.FromRecord(Rec, Rec.FieldNo("MICA Request Description"));
            Clear(InStream);
            TempBlob.CreateInStream(InStream, TextEncoding::Windows);
            InStream.Read(WindowsEncodedText);
            Clear(OutStream);
            "MICA Request Description".CreateOutStream(OutStream, TextEncoding::UTF16);
            OutStream.Write(WindowsEncodedText);

            // WindowsEncodedText := TempBlob.ReadAsText(CR, TEXTENCODING::Windows);
            // TempBlob.WriteAsText(WindowsEncodedText, TEXTENCODING::UTF16);
            // "MICA Request Description" := TempBlob.Blob;
        end;
        IF "MICA CES Comment".HASVALUE() then begin
            calcfields("MICA CES Comment");

            TempBlob.FromRecord(Rec, Rec.FieldNo("MICA CES Comment"));
            Clear(InStream);
            TempBlob.CreateInStream(InStream, TextEncoding::Windows);
            InStream.Read(WindowsEncodedText);
            Clear(OutStream);
            "MICA CES Comment".CreateOutStream(OutStream, TextEncoding::UTF16);
            OutStream.Write(WindowsEncodedText);

            // WindowsEncodedText := TempBlob.ReadAsText(CR, TEXTENCODING::Windows);
            // TempBlob.WriteAsText(WindowsEncodedText, TEXTENCODING::UTF16);
            // "MICA CES Comment" := TempBlob.Blob;
        end;
        IF "MICA Public Closing Desc.".HASVALUE() then begin
            calcfields("MICA Public Closing Desc.");

            TempBlob.FromRecord(Rec, Rec.FieldNo("MICA Public Closing Desc."));
            Clear(InStream);
            TempBlob.CreateInStream(InStream, TextEncoding::Windows);
            InStream.Read(WindowsEncodedText);
            Clear(OutStream);
            "MICA Public Closing Desc.".CreateOutStream(OutStream, TextEncoding::UTF16);
            OutStream.Write(WindowsEncodedText);

            // WindowsEncodedText := TempBlob.ReadAsText(CR, TEXTENCODING::Windows);
            // TempBlob.WriteAsText(WindowsEncodedText, TEXTENCODING::UTF16);
            // "MICA Public Closing Desc." := TempBlob.Blob;
        end;
        IF "MICA Internal Closing Desc.".HASVALUE() then begin
            calcfields("MICA Internal Closing Desc.");

            TempBlob.FromRecord(Rec, Rec.FieldNo("MICA Internal Closing Desc."));
            Clear(InStream);
            TempBlob.CreateInStream(InStream, TextEncoding::Windows);
            InStream.Read(WindowsEncodedText);
            Clear(OutStream);
            "MICA Internal Closing Desc.".CreateOutStream(OutStream, TextEncoding::UTF16);
            OutStream.Write(WindowsEncodedText);

            // WindowsEncodedText := TempBlob.ReadAsText(CR, TEXTENCODING::Windows);
            // TempBlob.WriteAsText(WindowsEncodedText, TEXTENCODING::UTF16);
            // "MICA Internal Closing Desc." := TempBlob.Blob;
        end;
        Modify();
        message('Description fields converted.');
    end;

    procedure GetRequestDescription(): Text
    begin
        CALCFIELDS("MICA Request Description");
        Exit(GetRequestDescriptionRequestDescriptionCalculated());
    end;

    procedure GetRequestDescriptionRequestDescriptionCalculated(): Text
    var
        TempBlob: Codeunit "Temp Blob";
        CR: Text[1];
        InStream: InStream;
        Result: Text;
    begin
        IF NOT "MICA Request Description".HASVALUE() THEN
            Exit('');

        CR[1] := 10;
        TempBlob.FromRecord(Rec, Rec.FieldNo("MICA Request Description"));
        Clear(InStream);
        TempBlob.CreateInStream(InStream, TextEncoding::UTF16);
        InStream.Read(Result);
        Exit(Result);
    end;


    procedure SetRequestDescription(NewRequestDescription: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
    begin
        CLEAR("MICA Request Description");
        IF NewRequestDescription = '' THEN
            Exit;

        TempBlob.FromRecord(Rec, Rec.FieldNo("MICA Request Description"));
        Clear(OutStream);
        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF16);
        OutStream.Write(NewRequestDescription);
        Clear(InStream);
        Clear(OutStream);
        TempBlob.CreateInStream(InStream);
        "MICA Request Description".CreateOutStream(OutStream);
        CopyStream(OutStream, InStream);

        Modify();
    end;


    procedure GetCESComment(): Text
    begin
        CALCFIELDS("MICA CES Comment");
        Exit(GetCESCommentCESCommentCalculated());
    end;


    procedure GetCESCommentCESCommentCalculated(): Text
    var
        TempBlob: Codeunit "Temp Blob";
        CR: Text[1];
        InStream: InStream;
        Result: Text;
    begin
        IF NOT "MICA CES Comment".HASVALUE() THEN
            Exit('');

        CR[1] := 10;

        TempBlob.FromRecord(Rec, Rec.FieldNo("MICA CES Comment"));
        Clear(InStream);
        TempBlob.CreateInStream(InStream, TextEncoding::UTF16);
        InStream.Read(Result);
        Exit(Result);
    end;


    procedure SetCESComment(NewCESComment: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        InStream: InStream;
    begin
        CLEAR("MICA CES Comment");
        IF NewCESComment = '' THEN
            Exit;

        TempBlob.FromRecord(Rec, Rec.FieldNo("MICA CES Comment"));
        Clear(OutStream);
        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF16);
        OutStream.Write(NewCESComment);
        Clear(InStream);
        Clear(OutStream);
        TempBlob.CreateInStream(InStream);
        "MICA CES Comment".CreateOutStream(OutStream);
        CopyStream(OutStream, InStream);

        Modify();
    end;


    procedure GetPublicClosingDesc(): Text
    begin
        CALCFIELDS("MICA Public Closing Desc.");
        Exit(GetPublicClosingDescPublicClosingDescCalculated());
    end;


    procedure GetPublicClosingDescPublicClosingDescCalculated(): Text
    var
        TempBlob: Codeunit "Temp Blob";
        CR: Text[1];
        InStream: InStream;
        Result: Text;
    begin
        IF NOT "MICA Public Closing Desc.".HASVALUE() THEN
            Exit('');

        CR[1] := 10;

        TempBlob.FromRecord(Rec, Rec.FieldNo("MICA Public Closing Desc."));
        Clear(InStream);
        TempBlob.CreateInStream(InStream, TextEncoding::UTF16);
        InStream.Read(Result);
        Exit(Result);

        // TempBlob.Blob := "MICA Public Closing Desc.";
        // Exit(TempBlob.ReadAsText(CR, TEXTENCODING::UTF16));
    end;


    procedure SetPublicClosing(NewPublicClosingDesc: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        InStream: InStream;
    begin
        CLEAR("MICA Public Closing Desc.");
        IF NewPublicClosingDesc = '' THEN
            Exit;

        TempBlob.FromRecord(Rec, Rec.FieldNo("MICA Public Closing Desc."));
        Clear(OutStream);
        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF16);
        OutStream.Write(NewPublicClosingDesc);
        Clear(InStream);
        Clear(OutStream);
        TempBlob.CreateInStream(InStream);
        "MICA Public Closing Desc.".CreateOutStream(OutStream);
        CopyStream(OutStream, InStream);

        Modify();
    end;


    procedure GetInternalClosingDesc(): Text
    begin
        CALCFIELDS("MICA Internal Closing Desc.");
        Exit(GetInternalClosingDescInternalClosingDescCalculated());
    end;


    procedure GetInternalClosingDescInternalClosingDescCalculated(): Text
    var
        TempBlob: Codeunit "Temp Blob";
        CR: Text[1];
        InStream: InStream;
        Result: Text;
    begin
        IF NOT "MICA Internal Closing Desc.".HASVALUE() THEN
            Exit('');

        CR[1] := 10;

        TempBlob.FromRecord(Rec, Rec.FieldNo("MICA Internal Closing Desc."));
        Clear(InStream);
        TempBlob.CreateInStream(InStream, TextEncoding::UTF16);
        InStream.Read(Result);
        Exit(Result);
    end;


    procedure SetInternalClosingDesc(NewInternalClosingDesc: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        InStream: InStream;
    begin
        CLEAR("MICA Internal Closing Desc.");
        IF NewInternalClosingDesc = '' THEN
            Exit;

        TempBlob.FromRecord(Rec, Rec.FieldNo("MICA Internal Closing Desc."));
        Clear(OutStream);
        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF16);
        OutStream.Write(NewInternalClosingDesc);
        Clear(InStream);
        Clear(OutStream);
        TempBlob.CreateInStream(InStream);
        "MICA Internal Closing Desc.".CreateOutStream(OutStream);
        CopyStream(OutStream, InStream);

        Modify();
    end;

}