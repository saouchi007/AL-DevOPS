codeunit 80120 "MICA ForcedDimension"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertGlobalGLEntry', '', false, false)]
    local procedure OnBeforeInsertGlobalGLEntry(var GlobalGLEntry: Record "G/L Entry")
    var

    begin
        SetForcedDimValue(GlobalGLEntry);
    end;

    local procedure SetForcedDimValue(var GLEntry: Record "G/L Entry")
    var
        TempDimensionSetEntry: Record "Dimension Set Entry" temporary;
        DimensionManagement: Codeunit DimensionManagement;

    begin
        InitTempDimSetEntry(TempDimensionSetEntry, GLEntry."Dimension Set ID", GLEntry."G/L Account No.");
        GLEntry."Dimension Set ID" := DimensionManagement.GetDimensionSetID(TempDimensionSetEntry);
        DimensionManagement.UpdateGlobalDimFromDimSetID(GLEntry."Dimension Set ID", GLEntry."Global Dimension 1 Code", GLEntry."Global Dimension 2 Code");
    end;

    procedure InitTempDimSetEntry(var TempDimensionSetEntry: Record "Dimension Set Entry" temporary; DimSetId: Integer; GLAccNo: Code[20])
    var
        MICAGLAccForcedDim: Record "MICA G/L Acc. Forced Dim.";
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        TempDimensionSetEntry.DeleteAll();
        DimensionSetEntry.Reset();
        DimensionSetEntry.SetRange("Dimension Set ID", DimSetId);
        if DimensionSetEntry.FindSet() then
            repeat
                TempDimensionSetEntry.Init();
                TempDimensionSetEntry.Validate("Dimension Code", DimensionSetEntry."Dimension Code");
                TempDimensionSetEntry.validate("Dimension Value Code", DimensionSetEntry."Dimension Value Code");
                TempDimensionSetEntry.Insert(true);
            until DimensionSetEntry.Next() = 0;
        MICAGLAccForcedDim.SetRange("MICA G/L Account No.", GLAccNo);
        if MICAGLAccForcedDim.FindSet() then
            repeat
                TempDimensionSetEntry.init();
                TempDimensionSetEntry.Validate("Dimension Code", MICAGLAccForcedDim."MICA Dimension Code");
                TempDimensionSetEntry.Validate("Dimension Value Code", MICAGLAccForcedDim."MICA Dimension Value Code");
                if not TempDimensionSetEntry.Insert(true) then
                    TempDimensionSetEntry.Modify(true);
            until MICAGLAccForcedDim.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::DimensionManagement, 'OnAfterCheckDimValuePosting', '', false, false)]
    local procedure OnAfterCollectDefaultDimsToCheck(TableID: array[10] of Integer; No: array[10] of Code[20]; var TempDefaultDim: Record "Default Dimension" temporary)
    var
        MICAGLAccForcedDim: Record "MICA G/L Acc. Forced Dim.";
        MandatoryDefaultDimension: Record "Default Dimension";
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        GLAccountCount: Integer;
        ForcedDimCountOk: Integer;
        i: integer;
    begin
        if not MICAFinancialReportingSetup.Get() then;
        if MICAFinancialReportingSetup."Disable Forced Dim. Uncheck" then
            exit;

        if MICAGLAccForcedDim.IsEmpty() then
            exit;

        MandatoryDefaultDimension.Reset();
        MandatoryDefaultDimension.SetRange("Table ID", Database::"G/L Account");
        MandatoryDefaultDimension.Setfilter("No.", '%1', '');
        MandatoryDefaultDimension.setrange("Value Posting", MandatoryDefaultDimension."Value Posting"::"Code Mandatory");
        if not MandatoryDefaultDimension.FindSet() then
            exit;
        repeat //For each mandatory dim. on G/L Account
            GLAccountCount := 0;
            ForcedDimCountOk := 0;
            for i := 1 to 10 do
                if (TableID[i] = Database::"G/L Account")
                and (No[i] <> '') then begin
                    MICAGLAccForcedDim.Reset();
                    MICAGLAccForcedDim.setrange("MICA Dimension Code", MandatoryDefaultDimension."Dimension Code");
                    MICAGLAccForcedDim.setrange("MICA G/L Account No.", No[i]);
                    MICAGLAccForcedDim.setfilter("MICA Dimension Value Code", '<>%1', '');
                    if not MICAGLAccForcedDim.IsEmpty() then
                        ForcedDimCountOk += 1; //Check that all G/L Acc. has a forced dimension value on the mandatory dim.
                    GLAccountCount += 1;
                end;
            if (GLAccountCount > 0) and (ForcedDimCountOk = GLAccountCount) then begin
                TempDefaultDim.setrange("Dimension Code", MandatoryDefaultDimension."Dimension Code");
                TempDefaultDim.Deleteall(); //If all G/ Acc. have a Forced Dim, delete the mandatory dim. from the dim. to check
                TempDefaultDim.setrange("Dimension Code");
            end;
        until MandatoryDefaultDimension.next() = 0;
    end;
}