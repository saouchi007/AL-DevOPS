codeunit 80100 "MICA Customer Request"
{
    // version REQUEST

    procedure CreateInteractionLogEntry(Contact: Record Contact; var InteractionLogEntry: Record "Interaction Log Entry")
    var
        FoundInteractionLogEntry: Record "Interaction Log Entry";
    begin
        WITH InteractionLogEntry DO BEGIN
            INIT();
            VALIDATE("Contact No.", Contact."No.");
            VALIDATE("Contact Company No.", Contact."Company No.");
            //"Interaction Template Code" := ;
            VALIDATE("User ID", USERID());
            VALIDATE("MICA User", UserSecurityId());
            VALIDATE("MICA Interaction Creation Date", CURRENTDATETIME());
            VALIDATE("MICA Request Status", "MICA Request Status"::"In progress");
            VALIDATE("MICA Responsible User", UserSecurityId());
            VALIDATE("MICA Assigned User", UserSecurityId());
            VALIDATE("Salesperson Code", Contact."Salesperson Code");
            IF FoundInteractionLogEntry.FINDLAST() THEN
                VALIDATE("Entry No.", FoundInteractionLogEntry."Entry No." + 1)
            ELSE
                VALIDATE("Entry No.", 1);

            INSERT(TRUE);
        END;
    end;

    [EventSubscriber(ObjectType::Table, 5065, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyTableInteractionLogEntry(var Rec: Record "Interaction Log Entry"; var xRec: Record "Interaction Log Entry"; RunTrigger: Boolean)
    var
        MICAInteractionActivities: Record "MICA Interaction Activities";
        FoundMICAInteractionActivities: Record "MICA Interaction Activities";
    begin
        WITH Rec DO
            IF ("Contact No." <> '') AND
              ("Interaction Template Code" <> '') AND
              (Description <> '') AND
              ("MICA Request Status" = "MICA Request Status"::"In progress") AND
              not IsNullGuid("MICA Responsible User") AND
              not IsNullGuid("MICA Assigned User") THEN BEGIN
                FoundMICAInteractionActivities.SETRANGE("Interaction No.", Rec."Entry No.");
                IF FoundMICAInteractionActivities.ISEMPTY() THEN BEGIN
                    MICAInteractionActivities.INIT();
                    MICAInteractionActivities.VALIDATE("Interaction No.", "Entry No.");
                    MICAInteractionActivities.VALIDATE(Description, CopyStr(Description, 1, 50));
                    MICAInteractionActivities.VALIDATE("Assigned User", "MICA Assigned User");
                    MICAInteractionActivities.VALIDATE("Creation Date", CURRENTDATETIME());
                    MICAInteractionActivities.VALIDATE("Creation User", "MICA User");
                    MICAInteractionActivities.VALIDATE("Activity Status", MICAInteractionActivities."Activity Status"::Open);
                    MICAInteractionActivities.INSERT(TRUE);
                END;
            END;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Interaction Log Entry", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnBeforeDeleteTableInteractionLogEntry(var Rec: Record "Interaction Log Entry"; RunTrigger: Boolean)
    var
        MICAInteractionActivities: Record "MICA Interaction Activities";
    begin
        MICAInteractionActivities.SETRANGE("Interaction No.", Rec."Entry No.");
        MICAInteractionActivities.DELETEALL(TRUE);
    end;

    [EventSubscriber(ObjectType::Page, Page::"User Task Card", 'OnDeleteRecordEvent', '', false, false)]
    local procedure OnDeleteUserTaskCard(var Rec: Record "User Task")
    begin
        if Rec."MICA Process ID" = Rec."MICA Process ID"::"Customer Request" then
            Error(OpenCustomerRequestToCompleteActionErr);
    end;

    [EventSubscriber(ObjectType::Page, Page::"User Task Card", 'OnBeforeActionEvent', 'Mark Completed', false, false)]
    local procedure OnBeforeActionMarkCompletedUserTaskCard(var Rec: Record "User Task")
    begin
        if Rec."MICA Process ID" = Rec."MICA Process ID"::"Customer Request" then
            Error(OpenCustomerRequestToCompleteActionErr);
    end;

    [EventSubscriber(ObjectType::Page, Page::"User Task Card", 'OnBeforeValidateEvent', 'Assigned To User Name', false, false)]
    local procedure OnBeforeValidateAssignedToUserNameUserTaskCard(var Rec: Record "User Task")
    begin
        if Rec."MICA Process ID" = Rec."MICA Process ID"::"Customer Request" then
            Error(OpenCustomerRequestToCompleteActionErr);
    end;

    [EventSubscriber(ObjectType::Page, Page::"User Task Card", 'OnBeforeValidateEvent', 'Completed By User Name', false, false)]
    local procedure OnBeforeValidateCompletedByUserNameUserTaskCard(var Rec: Record "User Task")
    begin
        if Rec."MICA Process ID" = Rec."MICA Process ID"::"Customer Request" then
            Error(OpenCustomerRequestToCompleteActionErr);
    end;

    [EventSubscriber(ObjectType::Page, Page::"User Task Card", 'OnBeforeValidateEvent', 'Title', false, false)]
    local procedure OnBeforeValidateTitleUserTaskCard(var Rec: Record "User Task")
    begin
        if Rec."MICA Process ID" = Rec."MICA Process ID"::"Customer Request" then
            Error(OpenCustomerRequestToCompleteActionErr);
    end;

    [EventSubscriber(ObjectType::Page, Page::"User Task List", 'OnDeleteRecordEvent', '', false, false)]
    local procedure OnDeleteUserTaskList(var Rec: Record "User Task")
    begin
        if Rec."MICA Process ID" = Rec."MICA Process ID"::"Customer Request" then
            Error(OpenCustomerRequestToCompleteActionErr);
    end;

    [EventSubscriber(ObjectType::Page, Page::"User Task List", 'OnBeforeValidateEvent', 'Assigned To User Name', false, false)]
    local procedure OnBeforeValidateAssignedToUserNameUserTaskList(var Rec: Record "User Task")
    begin
        if Rec."MICA Process ID" = Rec."MICA Process ID"::"Customer Request" then
            Error(OpenCustomerRequestToCompleteActionErr);
    end;

    [EventSubscriber(ObjectType::Page, Page::"User Task List", 'OnBeforeValidateEvent', 'Completed By User Name', false, false)]
    local procedure OnBeforeValidateCompletedByUserNameUserTaskList(var Rec: Record "User Task")
    begin
        if Rec."MICA Process ID" = Rec."MICA Process ID"::"Customer Request" then
            Error(OpenCustomerRequestToCompleteActionErr);
    end;

    [EventSubscriber(ObjectType::Page, Page::"User Task List", 'OnBeforeValidateEvent', 'Title', false, false)]
    local procedure OnBeforeValidateTitleUserTaskList(var Rec: Record "User Task")
    begin
        if Rec."MICA Process ID" = Rec."MICA Process ID"::"Customer Request" then
            Error(OpenCustomerRequestToCompleteActionErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"User Task", 'OnAfterValidateEvent', 'Percent Complete', false, false)]
    local procedure OnAfterValidatePercentCompleteUserTask(var Rec: Record "User Task"; var xRec: Record "User Task")
    begin
        if (Rec."MICA Process ID" = Rec."MICA Process ID"::"Customer Request") and (xRec."Percent Complete" <> 100) and (Rec."Percent Complete" = 100) then begin
            Clear(Rec."Completed By");
            Clear(Rec."Completed DateTime");
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"User Task List", 'OnBeforeActionEvent', 'Mark Complete', false, false)]
    local procedure OnBeforeActionMarkCompletedUserTaskList(var Rec: Record "User Task")
    begin
        if Rec."MICA Process ID" = Rec."MICA Process ID"::"Customer Request" then
            Error(OpenCustomerRequestToCompleteActionErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Interaction Log Entry", 'OnAfterValidateEvent', 'Document Type', false, false)]
    local procedure OnAfterValidateDocumentTypeInteractionLogEntry(var Rec: Record "Interaction Log Entry")
    begin
        case Rec."Document Type" of
            Rec."Document Type"::"Sales Cr. Memo":
                Rec."MICA Doc. Type" := Rec."MICA Doc. Type"::"Sales Credit Memo";
            Rec."Document Type"::"Sales Inv.":
                Rec."MICA Doc. Type" := Rec."MICA Doc. Type"::"Sales Invoice";
            Rec."Document Type"::"Sales Ord. Cnfrmn.":
                Rec."MICA Doc. Type" := Rec."MICA Doc. Type"::"Sales Order";
            Rec."Document Type"::"Sales Return Order":
                Rec."MICA Doc. Type" := Rec."MICA Doc. Type"::"Sales Return";
            Rec."Document Type"::"Sales Return Receipt":
                Rec."MICA Doc. Type" := Rec."MICA Doc. Type"::"Sales Return Receipt";
            Rec."Document Type"::"Sales Shpt. Note":
                Rec."MICA Doc. Type" := Rec."MICA Doc. Type"::"Sales Shipment";
            else
                Rec."MICA Doc. Type" := Rec."MICA Doc. Type"::" ";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Interaction Log Entry", 'OnAfterValidateEvent', 'Document No.', false, false)]
    local procedure OnAfterValidateDocumentNoInteractionLogEntry(var Rec: Record "Interaction Log Entry")
    begin
        Rec."MICA Doc. No." := Rec."Document No.";
    end;

    [EventSubscriber(ObjectType::Page, Page::"User Task List", 'OnAfterActionEvent', 'Mark Complete', false, false)]
    local procedure OnAfterActionMarkCompletedUserTaskList(var Rec: Record "User Task")
    var
        UserTask: Record "User Task";
    begin
        UserTask.Get(Rec.ID);
        if (UserTask."MICA Process ID" = UserTask."MICA Process ID"::"Customer Request") and (UserTask."Percent Complete" = 100) then begin
            Clear(UserTask."Completed By");
            Clear(UserTask."Completed DateTime");
            UserTask.Modify(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Interaction Log Entry", 'OnAfterCopyFromSegment', '', false, false)]
    local procedure OnAfterCopyFromSegmentInteractionLogEntry(var InteractionLogEntry: Record "Interaction Log Entry")
    begin
        InteractionLogEntry.Validate("Document Type");
        InteractionLogEntry.Validate("Document No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Interaction Log Entry", 'OnAfterValidateEvent', 'Description', false, false)]
    local procedure OnAfterValidateDescriptionInteractionLogEntry(var Rec: Record "Interaction Log Entry")
    var
        UserTask: Record "User Task";
        MICAInteractionActivities: Record "MICA Interaction Activities";
    begin
        //if InteractLogEntry.Get("Interaction No.") then
        MICAInteractionActivities.SetRange("Interaction No.", Rec."Entry No.");
        if MICAInteractionActivities.FindSet() then
            repeat
                UserTask.SetRange("MICA Record ID Label", Format(Rec.RecordId()));
                if UserTask.FindSet() then
                    repeat
                        UserTask.SetDescription(RequestTxt + Format(Rec."Entry No.") + ' ' + Rec.Description + '. ' + MICAInteractionActivities.Description);
                        UserTask.Modify(true);
                    until UserTask.Next() = 0;
            until MICAInteractionActivities.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Interaction Log Entry", 'OnAfterValidateEvent', 'Contact No.', false, false)]
    local procedure OnAfterValidateContactNoInteractionLogEntryTable(var Rec: Record "Interaction Log Entry")
    var
        ContactBusinessRelation: Record "Contact Business Relation";
        Contact: Record Contact;
    begin
        if Contact.Get(Rec."Contact No.") then begin
            ContactBusinessRelation.SetRange("Contact No.", Contact."Company No.");
            ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
            if not ContactBusinessRelation.FindFirst() then begin
                ContactBusinessRelation.SetRange("Contact No.", Contact."No.");
                ContactBusinessRelation.FindSet();
            end;
            if not ContactBusinessRelation.IsEmpty() then
                Rec.Validate("MICA Customer No.", ContactBusinessRelation."No.");
        end;
    end;

    procedure AssignToUser(InteractionLogEntry: Record "Interaction Log Entry"; pDescription: Text[50]; pUser: Guid; pEstimatedDate: Date)
    var
        MICAInteractionActivities: Record "MICA Interaction Activities";
    begin
        CloseInteractionActivity(InteractionLogEntry);

        WITH InteractionLogEntry DO BEGIN
            CLEAR(MICAInteractionActivities);
            MICAInteractionActivities.RESET();
            MICAInteractionActivities.INIT();
            MICAInteractionActivities.VALIDATE("Interaction No.", "Entry No.");
            MICAInteractionActivities.VALIDATE(Description, pDescription);
            MICAInteractionActivities.TESTFIELD(Description);
            MICAInteractionActivities.VALIDATE("Assigned User", pUser);
            //InteractionActivities.TESTFIELD("Assigned User Name");
            MICAInteractionActivities.VALIDATE("Creation Date", CURRENTDATETIME());
            MICAInteractionActivities.VALIDATE("Creation User", UserSecurityId());
            MICAInteractionActivities.VALIDATE("Activity Status", MICAInteractionActivities."Activity Status"::Open);
            MICAInteractionActivities.VALIDATE("Estimated Ending Date", pEstimatedDate);
            MICAInteractionActivities.TESTFIELD("Estimated Ending Date");
            MICAInteractionActivities.INSERT(TRUE);
        END;

        InteractionLogEntry.Validate("MICA Assigned User", MICAInteractionActivities."Assigned User");
        InteractionLogEntry.Validate("MICA Level", MICAInteractionActivities."Level");
        InteractionLogEntry.MODIFY(TRUE);
    end;

    procedure CloseTheLoop(var InteractionLogEntry: Record "Interaction Log Entry")
    begin
        CloseInteractionActivity(InteractionLogEntry);
        InteractionLogEntry.VALIDATE("MICA Request Status", InteractionLogEntry."MICA Request Status"::"Close the Loop");
        InteractionLogEntry.VALIDATE("MICA CES Comment");
        InteractionLogEntry.MODIFY(TRUE);
    end;

    procedure ReopenTheLoop(InteractionLogEntry: Record "Interaction Log Entry")
    begin
        InteractionLogEntry.Validate("MICA Request Status", InteractionLogEntry."MICA Request Status"::"In progress");
        InteractionLogEntry.MODIFY(TRUE);
    end;

    procedure CloseInteractionActivity(InteractionLogEntry: Record "Interaction Log Entry")
    var
        MICAInteractionActivities: Record "MICA Interaction Activities";
    begin
        MICAInteractionActivities.SETRANGE("Interaction No.", InteractionLogEntry."Entry No.");
        MICAInteractionActivities.SETRANGE("Activity Status", MICAInteractionActivities."Activity Status"::Open);
        IF MICAInteractionActivities.FindSet() THEN
            REPEAT
                MICAInteractionActivities.VALIDATE("Activity Status", MICAInteractionActivities."Activity Status"::Closed);
                MICAInteractionActivities.MODIFY(TRUE);
            UNTIL MICAInteractionActivities.Next() = 0;
    end;

    procedure AnalyzeEvaluation(InitInteractionLogEntry: Record "Interaction Log Entry")
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        InteractionLogEntry: Record "Interaction Log Entry";
        FoundInteractionLogEntry: Record "Interaction Log Entry";
        MICANewCustomerRequest: Page "MICA New Customer Request";
    begin
        SalesReceivablesSetup.Get();
        SalesReceivablesSetup.TestField("MICA Interact Templ Req Analy");
        InteractionLogEntry.Init();
        InteractionLogEntry.VALIDATE("Contact No.", InitInteractionLogEntry."Contact No.");
        InteractionLogEntry.Validate("Contact Company No.", InitInteractionLogEntry."Contact Company No.");
        InteractionLogEntry.Validate("User ID", USERID());
        InteractionLogEntry.Validate("MICA Interaction Creation Date", CURRENTDATETIME());
        InteractionLogEntry.Validate("MICA Request Status", InitInteractionLogEntry."MICA Request Status"::"In progress");
        InteractionLogEntry.Validate("MICA Responsible User", InitInteractionLogEntry."MICA User");
        InteractionLogEntry.Validate("MICA Assigned User", InitInteractionLogEntry."MICA User");
        InteractionLogEntry.Validate("Salesperson Code", InitInteractionLogEntry."Salesperson Code");
        InteractionLogEntry.Validate("Document Type", InitInteractionLogEntry."MICA Doc. Type");
        InteractionLogEntry.Validate("Document No.", InitInteractionLogEntry."MICA Doc. No.");
        InteractionLogEntry.Validate("Interaction Template Code", SalesReceivablesSetup."MICA Interact Templ Req Analy");
        InteractionLogEntry.Validate("MICA Linked Request", InitInteractionLogEntry."Entry No.");
        IF FoundInteractionLogEntry.FINDLAST() THEN
            InteractionLogEntry.Validate("Entry No.", FoundInteractionLogEntry."Entry No." + 1)
        ELSE
            InteractionLogEntry.Validate("Entry No.", 1);
        InteractionLogEntry.Insert(true);
        InteractionLogEntry.Validate(Description, InitInteractionLogEntry.Description);
        InteractionLogEntry.Modify(true);
        InteractionLogEntry.SetRange("Entry No.", InteractionLogEntry."Entry No.");
        MICANewCustomerRequest.SetTableView(InteractionLogEntry);
        MICANewCustomerRequest.Run();

    end;

    procedure CloseTheCase(InteractionLogEntry: Record "Interaction Log Entry")
    begin
        if not InteractionLogEntry."MICA Public Closing Desc.".HasValue() then
            Error(InteractionCanNotBeClosedErr);
        InteractionLogEntry.Validate("MICA Request Status", InteractionLogEntry."MICA Request Status"::"Close the Case");
        InteractionLogEntry.Modify(true);
    end;

    procedure GoToTaskItem(UserTask: Record "User Task")
    var
        AllObjWithCaption: Record AllObjWithCaption;
        RecRefVariant: Variant;
    begin
        with UserTask do begin
            IF ("Object Type" = 0) OR ("Object ID" = 0) THEN
                EXIT;
            IF "Object Type" = AllObjWithCaption."Object Type"::Page THEN begin
                if "MICA Record ID".TableNo() <> 0 then begin
                    RecRefVariant := "MICA Record ID".GetRecord();
                    Page.Run(Page::"MICA New Customer Request", RecRefVariant);
                end else
                    PAGE.RUN("Object ID")
            end ELSE
                REPORT.RUN("Object ID");
        end;
    end;

    var
        InteractionCanNotBeClosedErr: Label 'Interaction can''t be closed. Public Conclusion Text is mandatory';
        OpenCustomerRequestToCompleteActionErr: Label 'Open the Customer Request to complete this action.';
        RequestTxt: Label 'Request: ';
}

