codeunit 82080 "MICA Flow Process Buffer PS9"
{
    TableNo = "MICA Flow Entry";
    trigger OnRun()
    var
        MICAFlow: Record "MICA Flow";

        MICAFlowRecord: Record "MICA Flow Record";
        Item: Record Item;
        MICAFlowBufferPS9: Record "MICA Flow Buffer PS9";
        ProcessStartedLbl: Label 'Process started.';
        ProcessFinishedLbl: Label 'Process terminated : %1 record(s) processed / %2';
        ProcessAbortedLbl: Label 'Process aborted : %1 error(s) found.';
        BufferCountLbl: Label '%1 buffer record(s) to process.';
        UpdateErrorLbl: Label 'Error while updating record %1.';
        UpdateCount: Integer;
        BufferCount: Integer;
    begin
        MICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Information, ProcessStartedLbl, ''));
        MICAFlow.get(Rec."Flow Code");

        MICAFlowBufferPS9.Reset();
        MICAFlowBufferPS9.SetRange("Flow Code", Rec."Flow Code");
        MICAFlowBufferPS9.SetRange("Flow Entry No.", Rec."Entry No.");
        MICAFlowBufferPS9.SetRange("Skip Line", false);
        MICAFlowInformation."Description 2" := StrSubstNo(BufferCountLbl, MICAFlowBufferPS9.Count());
        if MICAFlowBufferPS9.FindSet() then
            repeat
                EvaluateFields(MICAFlowBufferPS9, Rec);
                MICAFlowBufferPS9.Modify();
            until MICAFlowBufferPS9.Next() = 0;

        Rec.CalcFields("Error Count");
        if not MICAFlow."Allow Partial Processing" then
            if Rec."Error Count" > 0 then begin
                MICAFlowInformation.Update('', '');
                Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ProcessAbortedLbl, Rec."Error Count"), '');
                exit;
            end;

        MICAFlowBufferPS9.Reset();
        MICAFlowBufferPS9.SetAutoCalcFields("Error Count");
        MICAFlowBufferPS9.SetRange("Flow Code", Rec."Flow Code");
        MICAFlowBufferPS9.SetRange("Flow Entry No.", Rec."Entry No.");
        MICAFlowBufferPS9.SetRange("Skip Line", false);
        if MICAFlowBufferPS9.FindSet() then
            repeat
                if MICAFlowBufferPS9."Error Count" = 0 then begin
                    BufferCount += 1;
                    Commit();
                    if Codeunit.Run(Codeunit::"MICA Flow Update PS9", MICAFlowBufferPS9) then
                        UpdateCount += 1
                    else
                        if Item.get(MICAFlowBufferPS9."No.") then begin
                            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, Item.RecordId(), StrSubstNo(UpdateErrorLbl, format(Item.RecordId())), GetLastErrorText());
                            MICAFlowRecord.UpdateReceiveRecord(Rec."Entry No.", Item.RecordId(), Rec."Receive Status"::Loaded);
                        end else
                            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferPS9."Entry No.", StrSubstNo(UpdateErrorLbl, MICAFlowBufferPS9."No."), GetLastErrorText());
                end;

            until MICAFlowBufferPS9.Next() = 0;

        Rec.AddInformation(MICAFlowInformation."Info Type"::information, StrSubstNo(ProcessFinishedLbl, format(UpdateCount), Format(BufferCount)), '');
        MICAFlowInformation.Update('', '');
    end;

    local procedure EvaluateFields(var MICAFlowBufferPS9: Record "MICA Flow Buffer PS9"; MICAFlowEntry: Record "MICA Flow Entry")
    var
        ItemCategory: Record "Item Category";
        MICATableValue: Record "MICA Table Value";
        MissingValueLbl: Label 'Missing value : Field %1.';
        IncorrectValueLbl: Label 'Incorrect Value : Field %1 value %2.';
    begin
        if MICAFlowBufferPS9."No." = '' then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferPS9."Entry No.", StrSubstNo(MissingValueLbl, MICAFlowBufferPS9.FieldCaption("No.")), '');

        if MICAFlowBufferPS9.Description = '' then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferPS9."Entry No.", StrSubstNo(MissingValueLbl, MICAFlowBufferPS9.FieldCaption(Description)), '');

        if MICAFlowBufferPS9."Item Category Code" <> '' then
            if not ItemCategory.Get(MICAFlowBufferPS9."Item Category Code") then
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferPS9."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferPS9.FieldCaption("Item Category Code"), MICAFlowBufferPS9."Item Category Code"), '');

        if MICAFlowBufferPS9."Base Unit of Measure" <> '' then
            if MICAFlowBufferPS9."Base Unit of Measure" <> 'EA' then
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferPS9."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferPS9.FieldCaption("Base Unit of Measure"), MICAFlowBufferPS9."Base Unit of Measure"), '');

        if MICAFlowBufferPS9."MICA Primary Unit Of Measure" <> '' then
            CheckUnitOfMeasure(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICAFlowBufferPS9.FieldCaption("MICA Primary Unit Of Measure"), MICAFlowBufferPS9."MICA Primary Unit Of Measure");
        if MICAFlowBufferPS9."MICA Product Weight UOM" <> '' then
            CheckUnitOfMeasure(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICAFlowBufferPS9.FieldCaption("MICA Product Weight UOM"), MICAFlowBufferPS9."MICA Product Weight UOM");
        if MICAFlowBufferPS9."MICA Product Volume UoM" <> '' then
            CheckUnitOfMeasure(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICAFlowBufferPS9.FieldCaption("MICA Product Volume UoM"), MICAFlowBufferPS9."MICA Product Volume UoM");
        if MICAFlowBufferPS9."MICA Rim Diameter UOM" <> '' then
            CheckUnitOfMeasure(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICAFlowBufferPS9.FieldCaption("MICA Rim Diameter UOM"), MICAFlowBufferPS9."MICA Rim Diameter UOM");

        if MICAFlowBufferPS9."MICA Business Line" <> '' then
            CheckDimensionValue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICAFlowBufferPS9.FieldCaption("MICA Business Line"), MICAFlowBufferPS9."MICA Business Line");
        if MICAFlowBufferPS9."MICA Business Line OE" <> '' then
            CheckDimensionValue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICAFlowBufferPS9.FieldCaption("MICA Business Line OE"), MICAFlowBufferPS9."MICA Business Line OE");
        if MICAFlowBufferPS9."MICA Business Line RT" <> '' then
            CheckDimensionValue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICAFlowBufferPS9.FieldCaption("MICA Business Line RT"), MICAFlowBufferPS9."MICA Business Line RT");
        if MICAFlowBufferPS9."MICA LB-OE" <> '' then
            CheckDimensionValue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICAFlowBufferPS9.FieldCaption("MICA LB-OE"), MICAFlowBufferPS9."MICA LB-OE");
        if MICAFlowBufferPS9."MICA LB-RT" <> '' then
            CheckDimensionValue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICAFlowBufferPS9.FieldCaption("MICA LB-RT"), MICAFlowBufferPS9."MICA LB-RT");

        if MICAFlowBufferPS9."MICA Homologation Country" <> '' then
            CheckCountryRegion(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICAFlowBufferPS9.FieldCaption("MICA Homologation Country"), MICAFlowBufferPS9."MICA Homologation Country");
        if MICAFlowBufferPS9."MICA Certificate Country" <> '' then
            CheckCountryRegion(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICAFlowBufferPS9.FieldCaption("MICA Certificate Country"), MICAFlowBufferPS9."MICA Certificate Country");
        if MICAFlowBufferPS9."MICA Regional. Active Country" <> '' then
            CheckCountryRegion(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICAFlowBufferPS9.FieldCaption("MICA Regional. Active Country"), MICAFlowBufferPS9."MICA Regional. Active Country");
        if MICAFlowBufferPS9."MICA Custom Export Country" <> '' then
            CheckCountryRegion(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICAFlowBufferPS9.FieldCaption("MICA Custom Export Country"), MICAFlowBufferPS9."MICA Custom Export Country");
        if MICAFlowBufferPS9."MICA Military Export Country" <> '' then
            CheckCountryRegion(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICAFlowBufferPS9.FieldCaption("MICA Military Export Country"), MICAFlowBufferPS9."MICA Military Export Country");

        if MICAFlowBufferPS9."MICA Market Code" <> '' then
            CheckTablevalue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICATableValue."Table Type"::MarketCode, MICAFlowBufferPS9.FieldCaption("MICA Market Code"), MICAFlowBufferPS9."MICA Market Code");
        if MICAFlowBufferPS9."MICA Item Master Type Code" <> '' then
            CheckTablevalue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICATableValue."Table Type"::ItemItemMasterTypeCode, MICAFlowBufferPS9.FieldCaption("MICA Item Master Type Code"), CopyStr(MICAFlowBufferPS9."MICA Item Master Type Code", 1, 10));
        if MICAFlowBufferPS9."MICA Brand" <> '' then
            CheckTablevalue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICATableValue."Table Type"::ItemBrand, MICAFlowBufferPS9.FieldCaption("MICA Brand"), MICAFlowBufferPS9."MICA Brand");
        if MICAFlowBufferPS9."MICA Product Segment" <> '' then
            CheckTablevalue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICATableValue."Table Type"::ItemProductSegment, MICAFlowBufferPS9.FieldCaption("MICA Product Segment"), CopyStr(MICAFlowBufferPS9."MICA Product Segment", 1, 10));
        if MICAFlowBufferPS9."MICA Speed Index 1" <> '' then
            CheckTablevalue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICATableValue."Table Type"::ItemSpeedIndex1, MICAFlowBufferPS9.FieldCaption("MICA Speed Index 1"), MICAFlowBufferPS9."MICA Speed Index 1");
        if MICAFlowBufferPS9."MICA LP Family Code" <> '' then
            CheckTablevalue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICATableValue."Table Type"::ItemLPFamily, MICAFlowBufferPS9.FieldCaption("MICA LP Family Code"), MICAFlowBufferPS9."MICA LP Family Code");
        if MICAFlowBufferPS9."MICA LPR Category" <> '' then
            CheckTablevalue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICATableValue."Table Type"::ItemLPRCategory, MICAFlowBufferPS9.FieldCaption("MICA LPR Category"), MICAFlowBufferPS9."MICA LPR Category");
        if MICAFlowBufferPS9."MICA LPR Sub Family" <> '' then
            CheckTablevalue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICATableValue."Table Type"::ItemLPRSubFamily, MICAFlowBufferPS9.FieldCaption("MICA LPR Sub Family"), MICAFlowBufferPS9."MICA LPR Sub Family");
        if MICAFlowBufferPS9."MICA Product Nature" <> '' then
            CheckTablevalue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICATableValue."Table Type"::ItemProductNature, MICAFlowBufferPS9.FieldCaption("MICA Product Nature"), MICAFlowBufferPS9."MICA Product Nature");
        if MICAFlowBufferPS9."MICA Usage Category" <> '' then
            CheckTablevalue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICATableValue."Table Type"::ItemUsageCategory, MICAFlowBufferPS9.FieldCaption("MICA Usage Category"), MICAFlowBufferPS9."MICA Usage Category");
        if MICAFlowBufferPS9."MICA Prevision Indicator" <> '' then
            CheckTablevalue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICATableValue."Table Type"::ItemPrevisionIndicator, MICAFlowBufferPS9.FieldCaption("MICA Prevision Indicator"), MICAFlowBufferPS9."MICA Prevision Indicator");
        if MICAFlowBufferPS9."MICA Speed Index 1" <> '' then
            CheckTablevalue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICATableValue."Table Type"::ItemSpeedIndex1, MICAFlowBufferPS9.FieldCaption("MICA Speed Index 1"), MICAFlowBufferPS9."MICA Speed Index 1");
        if MICAFlowBufferPS9."MICA Tire Type" <> '' then
            CheckTablevalue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICATableValue."Table Type"::ItemTireType, MICAFlowBufferPS9.FieldCaption("MICA Tire Type"), MICAFlowBufferPS9."MICA Tire Type");
        if MICAFlowBufferPS9."MICA Star Rating" <> '' then
            CheckTablevalue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICATableValue."Table Type"::ItemStarRating, MICAFlowBufferPS9.FieldCaption("MICA Star Rating"), MICAFlowBufferPS9."MICA Star Rating");
        if MICAFlowBufferPS9."MICA Grading Type" <> '' then
            CheckTablevalue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICATableValue."Table Type"::ItemGradingType, MICAFlowBufferPS9.FieldCaption("MICA Grading Type"), MICAFlowBufferPS9."MICA Grading Type");
        if MICAFlowBufferPS9."MICA Aspect Quality2" <> '' then
            CheckTablevalue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICATableValue."Table Type"::ItemAspectQuality, MICAFlowBufferPS9.FieldCaption("MICA Aspect Quality2"), CopyStr(MICAFlowBufferPS9."MICA Aspect Quality2", 1, 10));
        if MICAFlowBufferPS9."MICA User Item Type" <> '' then
            CheckTablevalue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICATableValue."Table Type"::ItemUserItemType, MICAFlowBufferPS9.FieldCaption("MICA User Item Type"), MICAFlowBufferPS9."MICA User Item Type");
        if MICAFlowBufferPS9."MICA Administrative Status" <> '' then
            CheckTablevalue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICATableValue."Table Type"::ItemAdministrativeStatus, MICAFlowBufferPS9.FieldCaption("MICA Administrative Status"), CopyStr(MICAFlowBufferPS9."MICA Administrative Status", 1, 10));
        if MICAFlowBufferPS9."MICA Airtightness" <> '' then
            CheckTablevalue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICATableValue."Table Type"::ItemAirtightness, MICAFlowBufferPS9.FieldCaption("MICA Airtightness"), MICAFlowBufferPS9."MICA Airtightness");
        if MICAFlowBufferPS9."MICA Pattern Code" <> '' then
            CheckTablevalue(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICATableValue."Table Type"::ItemPatternCode, MICAFlowBufferPS9.FieldCaption("MICA Pattern Code"), CopyStr(MICAFlowBufferPS9."MICA Pattern Code", 1, 10));

        CheckAndEvaluateRawDecimalFields(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICAFlowBufferPS9.FieldCaption("MICA Product Weight"), MICAFlowBufferPS9."MICA Product Weight", MICAFlowBufferPS9."MICA Product Weight Raw");
        CheckAndEvaluateRawDecimalFields(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICAFlowBufferPS9.FieldCaption("MICA Load Index 1"), MICAFlowBufferPS9."MICA Load Index 1", MICAFlowBufferPS9."MICA Load Index 1 Raw");
        CheckAndEvaluateRawDecimalFields(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICAFlowBufferPS9.FieldCaption("MICA Derogation Quantity"), MICAFlowBufferPS9."MICA Derogation Quantity", MICAFlowBufferPS9."MICA Derogation Quantity Raw");
        CheckAndEvaluateRawDecimalFields(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICAFlowBufferPS9.FieldCaption("MICA Product Volume"), MICAFlowBufferPS9."MICA Product Volume", MICAFlowBufferPS9."MICA Product Volume Raw");
        CheckAndEvaluateRawDecimalFields(MICAFlowEntry, MICAFlowBufferPS9."Entry No.", MICAFlowBufferPS9.FieldCaption("MICA Section Width"), MICAFlowBufferPS9."MICA Section Width", MICAFlowBufferPS9."MICA Section Width Raw");
    end;

    local procedure CheckTablevalue(var MICAFlowEntry: Record "MICA Flow Entry"; EntryNo: Integer; TableType: Integer; BufferFieldCaption: Text; BufferCode: Code[10]);
    var
        MICATableValue: Record "MICA Table Value";
        IncorrectValueLbl: Label 'Incorrect Value : Field %1 value %2.';
        CodeBlockedLbl: Label '%1 %2 is blocked.';
    begin
        if not MICATableValue.Get(TableType, BufferCode) then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, EntryNo, StrSubstNo(IncorrectValueLbl, BufferFieldCaption, BufferCode), '')
        else
            if MICATableValue.Blocked then
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, EntryNo, StrSubstNo(CodeBlockedLbl, BufferFieldCaption, BufferCode), '');
    end;

    local procedure CheckCountryRegion(var MICAFlowEntry: Record "MICA Flow Entry"; EntryNo: integer; BufferFieldCaption: Text; BufferCode: Code[10]);
    var
        CountryRegion: Record "Country/Region";
        MissingValueLbl: Label 'Missing value : Field %1.';
    begin
        if not CountryRegion.Get(BufferCode) then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, EntryNo, StrSubstNo(MissingValueLbl, BufferFieldCaption), '');
    end;

    local procedure CheckDimensionValue(var MICAFlowEntry: Record "MICA Flow Entry"; EntryNo: integer; BufferFieldCaption: Text; BufferCode: Code[10])
    var
        DimensionValue: Record "Dimension Value";
        MissingValueLbl: Label 'Missing value : Field %1.';
    begin
        DimensionValue.SetRange("MICA Michelin Code", BufferCode);
        if DimensionValue.IsEmpty() then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, EntryNo, StrSubstNo(MissingValueLbl, BufferFieldCaption), '');
    end;

    local procedure CheckUnitOfMeasure(var MICAFlowEntry: Record "MICA Flow Entry"; EntryNo: integer; BufferFieldCaption: Text; BufferCode: Code[10])
    var
        UnitofMeasure: Record "Unit of Measure";
        IncorrectValueLbl: Label 'Incorrect Value : Field %1 value %2.';
    begin
        if not UnitofMeasure.Get(BufferCode) then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, EntryNo, StrSubstNo(IncorrectValueLbl, BufferFieldCaption, BufferCode), '');
    end;

    local procedure CheckAndEvaluateRawDecimalFields(var MICAFlowEntry: Record "MICA Flow Entry"; FlowEntryNo: Integer; FieldCaptionTxt: Text; var NonRawValue: Decimal; RawValue: Text)
    var
        IncorrectValueLbl: Label 'Incorrect Value : Field %1 value %2.';
    begin
        if RawValue <> '' then
            if not Evaluate(NonRawValue, RawValue) then
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, FlowEntryNo, StrSubstNo(IncorrectValueLbl, FieldCaptionTxt, RawValue), '');
    end;

    var
        MICAFlowInformation: Record "MICA Flow Information";

}