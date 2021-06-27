table 80864 "MICA Flow Record"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "MICA Flow Record List";
    LookupPageId = "MICA Flow Record List";
    Permissions = tabledata "Purch. Inv. Header" = RIMD, tabledata "Purch. Inv. Line" = RIMD;
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
            Editable = false;
        }
        field(30; "Flow Entry No."; Integer)
        {
            Caption = 'Flow Entry No.';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow Entry";
            trigger OnValidate()
            var
                FlowEntry: Record "MICA Flow Entry";
            begin
                if FlowEntry.Get("Flow Entry No.") then
                    Validate("Flow Code", FlowEntry."Flow Code");
            end;
        }
        field(40; "Linked RecordID"; RecordID)
        {
            Caption = 'RecordId';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Validate("Linked Record", COPYSTR(FORMAT("Linked RecordID"), 1, 250));
            end;
        }
        field(50; "Linked Record"; Text[250])
        {
            Caption = 'Linked Record';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60; "Info Count"; Integer)
        {
            Caption = 'Info Count';
            FieldClass = FlowField;
            //CalcFormula = count ("MICA Flow Information" where ("Info Type" = const (Information), "Flow Record Entry No." = field ("Entry No.")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(70; "Warning Count"; Integer)
        {
            Caption = 'Info Count';
            FieldClass = FlowField;
            //CalcFormula = count ("MICA Flow Information" where ("Info Type" = const (Warning), "Flow Record Entry No." = field ("Entry No.")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80; "Error Count"; Integer)
        {
            Caption = 'Info Count';
            FieldClass = FlowField;
            //CalcFormula = count ("MICA Flow Information" where ("Info Type" = const (Error), "Flow Record Entry No." = field ("Entry No.")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(90; "Date Time Creation"; DateTime)
        {
            Caption = 'Date Time Creation';
            DataClassification = CustomerContent;
        }
        field(200; "Disable Post-Processed"; Boolean)
        {
            Caption = 'Disable Post-Processed';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(KEY1; "Flow Entry No.")
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        key(KEY2; "Flow Code")
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        key(KEY3; "Linked Record")
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        key(KEY4; "Flow Code", "Flow Entry No.", "Linked RecordID")
        {

        }
    }

    trigger OnInsert()
    var
        MICAFlowEntry: Record "MICA Flow Entry";
    begin
        Validate("Date Time Creation", CurrentDateTime());
        if MICAFlowEntry.Get("Flow Entry No.") then
            Validate("Flow Code", MICAFlowEntry."Flow Code");
    end;

    procedure UpdateSendRecord(FlowEntryNo: Integer; LinkedRecordID: RecordId; SendStatus: Option " ",Prepared,Sent)
    var
        MICAFlowRecord: Record "MICA Flow Record";
        MICAFlowEntry: Record "MICA Flow Entry";
    begin
        MICAFlowRecord.Reset();
        MICAFlowRecord.SetRange("Flow Entry No.", FlowEntryNo);
        MICAFlowRecord.SetRange("Linked RecordID", LinkedRecordID);
        if not MICAFlowRecord.FindFirst() then begin
            clear(MICAFlowRecord);
            MICAFlowRecord.Validate("Flow Entry No.", FlowEntryNo);
            MICAFlowRecord.Validate("Linked RecordID", LinkedRecordID);
            MICAFlowRecord.Insert(true);
        end;
        MICAFlowEntry.Get(FlowEntryNo);
        UpdateSendFields(MICAFlowRecord, MICAFlowEntry, SendStatus);

    end;

    procedure UpdateSendFields(MICAFlowRecord: Record "MICA Flow Record"; MICAFlowEntry: Record "MICA Flow Entry"; SendStatus: Option " ",Prepared,Sent)
    var
        MICAFlowInformation: Record "MICA Flow Information";
        Field: Record Field;
        RecordRef: RecordRef;
        FieldNotFoundLbl: Label 'Cannot Update Send Fields : %1 %2';
        SendFieldName: Text;
        SendFieldNameLbl: Label '@*%1*', Comment = '%1', Locked = true;
    begin
        if not RecordRef.Get(MICAFlowRecord."Linked RecordID") then
            exit;
        SendFieldName := 'Send Last Flow Entry No.';
        Field.Reset();
        Field.SetRange(ObsoleteState, Field.ObsoleteState::No, Field.ObsoleteState::Pending);
        Field.SetRange(TableNo, RecordRef.RecordId().TableNo());
        Field.SetFilter(FieldName, StrSubstNo(SendFieldNameLbl, SendFieldName));
        if Field.FindFirst() then
            UpdateField(RecordRef, Field, MICAFlowEntry."Entry No.")
        else
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Warning, StrSubstNo(FieldNotFoundLbl, RecordRef.RecordId().TableNo(), SendFieldName), '');

        SendFieldName := 'Send Last Flow Status';
        Field.Reset();
        Field.SetRange(ObsoleteState, Field.ObsoleteState::No, Field.ObsoleteState::Pending);
        Field.SetRange(TableNo, RecordRef.RecordId().TableNo());
        Field.SetFilter(FieldName, StrSubstNo(SendFieldNameLbl, SendFieldName));
        if Field.FindFirst() then
            UpdateField(RecordRef, Field, SendStatus)
        else
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Warning, StrSubstNo(FieldNotFoundLbl, RecordRef.RecordId().TableNo(), SendFieldName), '');

        SendFieldName := 'Record Id';
        Field.Reset();
        Field.SetRange(ObsoleteState, Field.ObsoleteState::No, Field.ObsoleteState::Pending);
        Field.SetRange(TableNo, RecordRef.RecordId().TableNo());
        Field.SetFilter(FieldName, StrSubstNo(SendFieldNameLbl, SendFieldName));
        if Field.FindFirst() then
            UpdateField(RecordRef, Field, MICAFlowRecord."Linked RecordID")
        else
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Warning, StrSubstNo(FieldNotFoundLbl, RecordRef.RecordId().TableNo(), SendFieldName), '');

        RecordRef.Modify();
    end;

    procedure UpdateField(RecordRef: Recordref; Field: Record Field; ValueVariant: Variant)
    var
        FieldRef: FieldRef;
    begin
        FieldRef := RecordRef.Field(Field."No.");
        FieldRef.Value(ValueVariant);
    end;

    procedure UpdateReceiveRecord(FlowEntryNo: Integer; LinkedRecordID: RecordId; ReceiveStatus: Option)
    var
        MICAFlowRecord: Record "MICA Flow Record";
        MICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowInformation: Record "MICA Flow Information";
        myField: Record Field;
        RecordRef: RecordRef;
        myFieldRef: FieldRef;
        myValueVariant: Variant;
        FindReceiveLastFlowEntryNo: Boolean;
    begin
        MICAFlowRecord.SetRange("Flow Entry No.", FlowEntryNo);
        MICAFlowRecord.SetRange("Linked RecordID", LinkedRecordID);
        if not MICAFlowRecord.FindSet() then begin
            MICAFlowRecord.Init();
            MICAFlowRecord.Validate("Flow Entry No.", FlowEntryNo);
            MICAFlowRecord.Validate("Linked RecordID", LinkedRecordID);
            MICAFlowRecord.Insert(true);
        end;
        repeat
            if RecordRef.Get(MICAFlowRecord."Linked RecordID") then begin
                myField.SetFilter(ObsoleteState, '<>%1', myField.ObsoleteState::Removed);
                myField.SetRange(TableNo, RecordRef.RecordId().TableNo());
                myField.SetFilter(FieldName, '*Rcv. Last Flow Entry No.*');
                if myField.FindFirst() then begin
                    myFieldRef := RecordRef.Field(myField."No.");
                    myValueVariant := MICAFlowRecord."Flow Entry No.";
                    myFieldRef.Value(myValueVariant);
                    FindReceiveLastFlowEntryNo := true;
                end;
                if not FindReceiveLastFlowEntryNo then begin
                    MICAFlowEntry.Get(FlowEntryNo);
                    if not FindReceiveLastFlowEntryNo then
                        MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Warning, StrSubstNo(MissingFieldOnTableErr, 'Receive Last Flow Entry No.', RecordRef.Name()), '');
                end else
                    RecordRef.Modify(true);
            end;
        until MICAFlowRecord.Next() = 0;
    end;

    var
        MissingFieldOnTableErr: Label 'Missing Field %1 on Table %2';
}
