codeunit 82760 "MICA Recalc. Wksh. To Excel"
{
    trigger OnRun()
    begin

    end;

    procedure ExportWkshToExcel(): Boolean
    begin
        if not ClearTempExcelBuffer() then
            exit;

        if ExportPriceRecalcWorksheet(TypeOfWorksheet) then begin
            CreateAndSaveExcel(TypeOfWorksheet);
            exit(true);
        end;
        exit(false);
    end;

    local procedure ClearTempExcelBuffer(): Boolean
    begin
        if not TempExcelBuffer.IsTemporary() then
            exit(false);
        TempExcelBuffer.DeleteAll();
        exit(true);
    end;

    local procedure ExportPriceRecalcWorksheet(TypeOfWorksheet: Integer): Boolean
    var
        WorksheetsRecordRef: RecordRef;
    begin
        case TypeOfWorksheet of
            0:
                WorksheetsRecordRef.Open(Database::"MICA Price Recalc. Worksheet");
            1:
                WorksheetsRecordRef.Open(Database::"MICA Rebate Recalc. Worksheet");
        end;

        if WorksheetsRecordRef.FindSet() then begin
            FillExcelHeader(WorksheetsRecordRef);
            repeat
                FillExcelLines(WorksheetsRecordRef);
            until WorksheetsRecordRef.Next() = 0;

            WorksheetsRecordRef.Close();
            exit(true);
        end else begin
            WorksheetsRecordRef.Close();
            exit(false);
        end;
    end;

    local procedure FillExcelHeader(WorksheetsRecordRef: RecordRef)
    var
        FielsWkshFieldRef: FieldRef;
        i: Integer;
    begin
        TempExcelBuffer.NewRow();

        for i := 1 to WorksheetsRecordRef.FieldCount() do begin
            FielsWkshFieldRef := WorksheetsRecordRef.Field(i);
            TempExcelBuffer.AddColumn(FielsWkshFieldRef.Caption(), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        end;
    end;

    local procedure FillExcelLines(WorksheetsRecordRef: RecordRef)
    var
        FielsWkshFieldRef: FieldRef;
        i: Integer;
    begin
        TempExcelBuffer.NewRow();

        for i := 1 to WorksheetsRecordRef.FieldCount() do begin
            FielsWkshFieldRef := WorksheetsRecordRef.Field(i);

            if FielsWkshFieldRef.Class = FielsWkshFieldRef.Class::FlowField then
                FielsWkshFieldRef.CalcField();

            if FielsWkshFieldRef.Active then
                case FielsWkshFieldRef.Type of
                    FielsWkshFieldRef.Type::Code, FielsWkshFieldRef.Type::Text, FielsWkshFieldRef.Type::Option, FielsWkshFieldRef.Type::Decimal:
                        TempExcelBuffer.AddColumn(FielsWkshFieldRef.Value(), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    FielsWkshFieldRef.Type::Date:
                        TempExcelBuffer.AddColumn(FielsWkshFieldRef.Value(), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                    FielsWkshFieldRef.Type::Integer:
                        TempExcelBuffer.AddColumn(FielsWkshFieldRef.Value(), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                end;
        end;
    end;

    local procedure CreateAndSaveExcel(TypeOfWorksheet: Integer)
    var
        SelectedOptionExcelBook: Text[30];
        SelectedOptionWorksheet: Text[20];
        SelectedFriendlyName: Text[50];
        PriceRecalcWkshLbl: Label 'Price Recalculation Worksheet';
        PriceWkshLbl: Label 'Price Worksheet';
        PriceWkshDataLbl: Label 'Price Worksheet Data_%1';
        RebateRecalcWkshLbl: Label 'Rebate Recalculation Worksheet';
        RebateWkshLbl: Label 'Rebate Worksheet';
        RebateWkshDataLbl: Label 'Rebate Worksheet Data_%1';
    begin
        Case TypeOfWorksheet of
            0:
                begin
                    SelectedOptionExcelBook := PriceRecalcWkshLbl;
                    SelectedOptionWorksheet := PriceWkshLbl;
                    SelectedFriendlyName := StrSubstNo(PriceWkshDataLbl, Format(CurrentDateTime(), 0, '<Year4><Month,2><Day,2>_<Hours24,2><Minutes,2><Seconds,2>'));
                end;
            1:
                begin
                    SelectedOptionExcelBook := RebateRecalcWkshLbl;
                    SelectedOptionWorksheet := RebateWkshLbl;
                    SelectedFriendlyName := StrSubstNo(RebateWkshDataLbl, Format(CurrentDateTime(), 0, '<Year4><Month,2><Day,2>_<Hours24,2><Minutes,2><Seconds,2>'));
                end;
        end;

        TempExcelBuffer.CreateNewBook(SelectedOptionExcelBook);
        TempExcelBuffer.WriteSheet(SelectedOptionWorksheet, CompanyName(), UserId());
        TempExcelBuffer.SetFriendlyFilename(SelectedFriendlyName);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.OpenExcel();
    end;

    procedure InitializeRequestFromWksh(NewTypeOfWorksheet: Integer)
    begin
        TypeOfWorksheet := NewTypeOfWorksheet;
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        TypeOfWorksheet: Integer;
}