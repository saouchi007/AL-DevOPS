table 80865 "MICA Flow Information"
{
    DataClassification = CustomerContent;
    LookupPageId = "MICA Flow Information List";
    DrillDownPageId = "MICA Flow Information List";
    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(20; "Flow Code"; Code[20])
        {
            Caption = 'Flow Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow";
        }
        field(30; "Flow Entry No."; Integer)
        {
            Caption = 'Flow Entry No.';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow Entry";
            trigger OnValidate()
            var
                MICAFlowEntry: Record "MICA Flow Entry";
            begin
                if MICAFlowEntry.Get("Flow Entry No.") then
                    Validate("Flow Code", MICAFlowEntry."Flow Code");
            end;
        }
        field(40; "Flow Record Entry No."; Integer)
        {
            Caption = 'Flow Record Entry No.';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow Record";
            ObsoleteState = Pending;
            ObsoleteReason = 'to be Deleted';
        }
        field(50; "Flow Buffer Entry No."; Integer)
        {
            Caption = 'Flow Buffer Entry No.';
            DataClassification = CustomerContent;
        }
        field(60; "Info Type"; Option)
        {
            Caption = 'Info Type';
            DataClassification = CustomerContent;
            OptionMembers = Information,Warning,Error;
            OptionCaption = 'Information,Warning,Error';
        }
        field(70; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(80; "Description 2"; Text[250])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(90; "Created Date"; Date)
        {
            Caption = 'Created Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(100; "Created Date Time"; DateTime)
        {
            Caption = 'Created Date Time ';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(110; "End Date Time"; DateTime)
        {
            Caption = 'End Date Time';
            DataClassification = CustomerContent;
            Editable = false;
            trigger OnValidate()
            begin
                Validate("Information Duration", "End Date Time" - "Created Date Time");
            end;
        }
        field(120; "Information Duration"; Duration)
        {
            Caption = 'Information Duration';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(130; "Linked Record ID"; RecordID)
        {
            Caption = 'Linked Record ID';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Validate("Linked Record", CopyStr(Format("Linked Record ID"), 1, 250));
            end;
        }
        field(140; "Linked Record"; Text[250])
        {
            Caption = 'Linked Record';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(200; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = " ",Open,InProgress,Closed;
            OptionCaption = ' ,Open,In Progress,Closed';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestField("Info Type", "Info Type"::Error);
            end;
        }
        field(300; "Modified Date Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(310; "Modified UserID"; Text[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(320; "Additional Text"; Text[200])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(KEY1; "Flow Code", "Info Type", "Created Date")
        {

        }
        key(KEY2; "Flow Entry No.", "Info Type", "Linked Record ID")
        {

        }
        key(KEY3; "Flow Entry No.", "Flow Buffer Entry No.", "Info Type")
        {

        }
        key(KEY4; "Flow Record Entry No.", "Info Type")
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        key(KEY5; "Linked Record ID", "Info Type")
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        key(KEY6; "Flow Entry No.", "Info Type", Status, "Created Date")
        {

        }
        key(KEY7; "Flow Code", "Info Type", Status, "Created Date")
        {

        }
        key(KEY8; "Info Type", Status)
        {

        }
        key(KEY9; "Flow Buffer Entry No.", "Info Type")
        {

        }
    }

    trigger OnInsert()
    begin
        Validate("Created Date", Today());
        Validate("Created Date Time", CurrentDateTime());
        if "Info Type" = "Info Type"::Error then
            Status := status::Open;
    end;

    trigger OnModify()
    begin
        "Modified Date Time" := CurrentDateTime();
        "Modified UserID" := CopyStr(UserId(), 1, 50);
    end;

    procedure Update(Description1: Text[250]; Description2: Text[250])
    begin
        if Description1 <> '' then
            Validate(Description, Description1);
        if Description2 <> '' then
            Validate("Description 2", Description2);
        Validate("End Date Time", CurrentDateTime());
        Modify(true);
    end;

    procedure GetMessage(): Text
    begin
        exit(Description + "Description 2")
    end;

    procedure ShowMessage()
    var
        TextMsg: Text;
        NoErrMsgLbl: label 'There is no message.';
    begin
        TextMsg := GetMessage();
        if TextMsg = '' then
            TextMsg := NoErrMsgLbl;
        Message(TextMsg);
    end;

    procedure SetStyle(): Text
    begin
        case Status of
            status::Open:
                exit('Unfavorable');
            status::InProgress:
                exit('Attention');
        end;
    end;

    procedure UpdateStatus(var SelectedMICAFlowInformation: record "MICA Flow Information"; NewStatus: Integer)
    var
        MICAIntMonitoringSetup: Record "MICA Int. Monitoring Setup";
        UpdatedMICAFlowInformation: record "MICA Flow Information";
        ConfirmUpdateLbl: label 'Do you want to update %1 information messages ?';
        UpdatingLbl: label 'Updating message #1###### with new status...';
        UpdatedLbl: label '%1 information(s) messages were updated with status %2.';
        UpdateCount: integer;
        Dialog: Dialog;
    begin
        if not Confirm(ConfirmUpdateLbl, false, SelectedMICAFlowInformation.Count()) then
            exit;
        MICAIntMonitoringSetup.Get();
        if SelectedMICAFlowInformation.FindSet() then begin
            Dialog.open(UpdatingLbl, SelectedMICAFlowInformation."Entry No.");
            repeat
                Dialog.Update();
                UpdatedMICAFlowInformation.get(SelectedMICAFlowInformation."Entry No.");
                if (NewStatus = Status::Closed)
                and (MICAIntMonitoringSetup."Force Add. Text On Close Error") then
                    UpdatedMICAFlowInformation.TestField(UpdatedMICAFlowInformation."Additional Text");
                UpdatedMICAFlowInformation.validate(Status, newstatus);
                UpdatedMICAFlowInformation.Modify(true);
                UpdateCount += 1;
            until SelectedMICAFlowInformation.next() = 0;
            Dialog.Close();
            Message(UpdatedLbl, UpdateCount, UpdatedMICAFlowInformation.Status);
        end;
    end;
}
