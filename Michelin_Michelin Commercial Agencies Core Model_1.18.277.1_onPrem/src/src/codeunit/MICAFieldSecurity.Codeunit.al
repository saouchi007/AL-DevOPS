codeunit 81280 "MICA FieldSecurity"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnBeforeOnDatabaseInsert', '', false, false)]
    local procedure OnBeforeOnDatabaseInsertGlobalTriggerManagementCodeunit(RecRef: RecordRef)
    begin
        FieldSecurityOnInsert(RecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnBeforeOnDatabaseModify', '', false, false)]
    local procedure OnBeforeOnDatabaseModifyGlobalTriggerManagementCodeunit(RecRef: RecordRef)
    begin
        FieldSecurityOnModify(RecRef, true);
    end;

    procedure FieldSecurityOnInsert(RecordRef: RecordRef)
    var
        MICAFieldSecurityField: Record "MICA Field Security Field";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        if RecordRef.IsTemporary() then
            exit;

        GeneralLedgerSetup.Get();
        MICAFieldSecurityField.SetRange("Table ID", RecordRef.RecordId().TableNo());
        if MICAFieldSecurityField.FindSet() then
            if MICAFieldSecurityField.TableIsEnable() then
                repeat
                    if HasValue(RecordRef.Field(MICAFieldSecurityField."Field Id")) then begin
                        if GeneralLedgerSetup."MICA Field Security Enable" then
                            UserAcces(MICAFieldSecurityField);
                        if GeneralLedgerSetup."MICA Mandatory Field Enable" and MICAFieldSecurityField.Mandatory then
                            CheckMandatoryField(RecordRef, MICAFieldSecurityField);
                    end;
                until MICAFieldSecurityField.Next() = 0;
    end;

    procedure FieldSecurityOnModify(RecordRef: RecordRef; ExistingRecord: Boolean)
    var
        MICAFieldSecurityField: Record "MICA Field Security Field";
        GeneralLedgerSetup: Record "General Ledger Setup";
        xRecordRef: RecordRef;
    begin
        if RecordRef.IsTemporary() then
            exit;

        GeneralLedgerSetup.Get();
        MICAFieldSecurityField.SetRange("Table ID", RecordRef.RecordId().TableNo());
        if MICAFieldSecurityField.FindSet() then
            if MICAFieldSecurityField.TableIsEnable() then
                repeat
                    clear(xRecordRef);
                    xRecordRef.Open(RecordRef.Number());
                    xRecordRef.SecurityFiltering := SecurityFilter::Filtered;
                    if xRecordRef.ReadPermission() then
                        if not xRecordRef.GET(RecordRef.RecordId()) then
                            exit;

                    if xRecordRef.Field(MICAFieldSecurityField."Field Id").Value() <> RecordRef.Field(MICAFieldSecurityField."Field Id").Value() then begin
                        if GeneralLedgerSetup."MICA Field Security Enable" then
                            UserAcces(MICAFieldSecurityField);
                        if GeneralLedgerSetup."MICA Mandatory Field Enable" and MICAFieldSecurityField.Mandatory then
                            CheckMandatoryField(RecordRef, MICAFieldSecurityField);
                    end;
                until MICAFieldSecurityField.Next() = 0;
    end;

    local procedure UserAcces(MICAFieldSecurityField: Record "MICA Field Security Field")
    var
        MICAFSecurityUserAccess: Record "MICA F. Security User Access";
        UserGroupMember: Record "User Group Member";
        HaveAccess: Boolean;
        AuthorizedCount: Integer;
    begin
        MICAFSecurityUserAccess.SetRange("Table Id", MICAFieldSecurityField."Table ID");
        MICAFSecurityUserAccess.SetRange("Field ID", MICAFieldSecurityField."Field Id");
        MICAFSecurityUserAccess.SetRange(Restricted, false);
        AuthorizedCount := MICAFSecurityUserAccess.Count();
        MICAFSecurityUserAccess.SetRange(Restricted);
        if (AuthorizedCount > 0) then
            HaveAccess := false
        else
            HaveAccess := true;

        MICAFSecurityUserAccess.SetFilter("User Group", '<>%1', '');
        if MICAFSecurityUserAccess.FindSet() then
            repeat
                UserGroupMember.SetRange("User Group Code", MICAFSecurityUserAccess."User Group");
                UserGroupMember.SetRange("User Security ID", UserSecurityId());
                UserGroupMember.SetFilter("Company Name", '%1|%2', '', CompanyName());
                if not UserGroupMember.IsEmpty() then
                    HaveAccess := not MICAFSecurityUserAccess.Restricted;
            until (MICAFSecurityUserAccess.Next() = 0);

        MICAFSecurityUserAccess.SetRange("User Group");
        MICAFSecurityUserAccess.SetFilter("User Guid", '<>%1', '00000000-0000-0000-0000-000000000000');
        if MICAFSecurityUserAccess.FindSet() then
            repeat
                if MICAFSecurityUserAccess."User Guid" = UserSecurityId() then
                    HaveAccess := not MICAFSecurityUserAccess.Restricted;
            until MICAFSecurityUserAccess.Next() = 0;
        if not HaveAccess then begin
            MICAFieldSecurityField.CalcFields("Field Caption");
            Error(YouAreNotAllowedThisOperationErr, MICAFieldSecurityField.GetTableName(), MICAFieldSecurityField."Field Caption", UserId());
        end;
    end;

    local procedure CheckMandatoryField(RecordRef: RecordRef; MICAFieldSecurityField: Record "MICA Field Security Field")
    begin
        if MICAFieldSecurityField."Equal To" <> '' then begin
            if Format(RecordRef.Field(MICAFieldSecurityField."Field Id").Value()) <> MICAFieldSecurityField."Equal To" then
                RecordRef.Field(MICAFieldSecurityField."Field Id").TestField(MICAFieldSecurityField."Equal To");
        end else
            RecordRef.Field(MICAFieldSecurityField."Field Id").TestField();
    end;

    local procedure HasValue(FieldRef: FieldRef): Boolean
    var
        Field: Record Field;
        FieldHasValue: Boolean;
        Int: Integer;
        Dec: Decimal;
        D: Date;
        T: Time;
    begin
        Evaluate(Field.Type, Format(FieldRef.Type()));

        case Field.Type of
            Field.Type::Boolean:
                FieldHasValue := FieldRef.Value();
            Field.Type::Option:
                FieldHasValue := true;
            Field.Type::Integer:
                begin
                    Int := FieldRef.Value();
                    FieldHasValue := Int <> 0;
                end;
            Field.Type::Decimal:
                begin
                    Dec := FieldRef.Value();
                    FieldHasValue := Dec <> 0;
                end;
            Field.Type::Date:
                begin
                    D := FieldRef.Value();
                    FieldHasValue := D <> 0D;
                end;
            Field.Type::Time:
                begin
                    T := FieldRef.Value();
                    FieldHasValue := T <> 0T;
                end;
            Field.Type::Blob:
                FieldHasValue := false;
            else
                FieldHasValue := Format(FieldRef.Value()) <> '';
        end;

        exit(FieldHasValue);
    end;

    var
        YouAreNotAllowedThisOperationErr: Label 'You are not allowed to do this operation on Table %1 and Fields %2 with User Id %3';
}