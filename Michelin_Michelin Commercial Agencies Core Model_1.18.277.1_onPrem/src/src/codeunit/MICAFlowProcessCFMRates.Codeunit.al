codeunit 80926 "MICA Flow Process CFM Rates"
{
    TableNo = "MICA Flow Entry";

    var
        MICAFlowBufferCFMExchRates: Record "MICA Flow Buf. CFM Exch. Rates";
        MICAFlowBufCFMExchRatesBlocType90: Record "MICA Flow Buf. CFM Exch. Rates";
        MICAFlowInformation: Record "MICA Flow Information";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        GeneralLedgerSetup: Record "General Ledger Setup";
        CompanyCurrencyCode: Code[10];
        StartMsg: label 'Start processing data';
        ProcessAbortedLbl: Label 'Process aborted : %1 error(s) found.', comment = '%1 = no. of errors';
        BufferWithoutBlocType90Err: label 'For %1 no. %2, there''s no %3 with "Bloc Type" = 90.', Comment = '%1 = Table caption ; %2 = Table Key ; %3 = Buffer Table Caption';


    trigger OnRun()
    var
        MICAFlow: Record "MICA Flow";
        FromMICAFlowInformation: Record "MICA Flow Information";
        RecordsProcessed: Integer;
        RecordsRejected: Integer;
    begin
        GeneralLedgerSetup.Get();
        CompanyCurrencyCode := GeneralLedgerSetup.GetCurrencyCode('');
        MICAFlow.Get(Rec."Flow Code");
        FromMICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StartMsg, ''));

        EvaluateValuesInBuffer(Rec);

        Rec.CalcFields("Error Count");
        if not MICAFlow."Allow Partial Processing" then
            if Rec."Error Count" > 0 then begin
                FromMICAFlowInformation.Update('', '');
                Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ProcessAbortedLbl, Rec."Error Count"), '');
                exit;
            end;

        MICAFlowBufCFMExchRatesBlocType90.SetRange("Flow Entry No.", Rec."Entry No.");
        MICAFlowBufCFMExchRatesBlocType90.SetRange("Bloc Type", '90');
        if MICAFlowBufCFMExchRatesBlocType90.FindFirst() then begin
            ProcessBuffer(Rec, RecordsProcessed, RecordsRejected);
            SetWarningsForCurrenciesWithoutExchRate(Rec);
        end else
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(BufferWithoutBlocType90Err, Rec.TableCaption(), Rec."Entry No.", MICAFlowBufferCFMExchRates.TableCaption()), '');

        FromMICAFlowInformation.Update('', '');
    end;

    local procedure EvaluateValuesInBuffer(var FromMICAFlowEntry: Record "MICA Flow Entry")
    var
        Currency: Record Currency;
        CountryRegion: Record "Country/Region";
        BufferRecordRef: RecordRef;
        IncorrectValueLbl: Label 'Incorrect Value : Field %1 value ''%2''.', comment = '%1 = Field caption ; %2 = Field value';

    begin
        MICAFlowBufferCFMExchRates.SetRange("Flow Entry No.", FromMICAFlowEntry."Entry No.");
        if MICAFlowBufferCFMExchRates.FindSet(true, false) then
            repeat
                MICAFlowBufferCFMExchRates.Error := false;
                BufferRecordRef.GetTable(MICAFlowBufferCFMExchRates);
                if not EvaluateRawDateToDate(MICAFlowBufferCFMExchRates."Exchange Rate Date", MICAFlowBufferCFMExchRates."Exchange Rate Date Raw") then
                    FromMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferCFMExchRates."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferCFMExchRates.FieldCaption("Exchange Rate Date"), MICAFlowBufferCFMExchRates."Exchange Rate Date Raw"), GetLastErrorText());
                case MICAFlowBufferCFMExchRates."Bloc Type" of
                    '90':
                        if not EvaluateRawDateToDate(MICAFlowBufferCFMExchRates."Exchange Rate Receipt Date", MICAFlowBufferCFMExchRates."Exchange Rate Receipt Date Raw") then
                            FromMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferCFMExchRates."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferCFMExchRates.FieldCaption("Exchange Rate Date"), MICAFlowBufferCFMExchRates."Exchange Rate Date Raw"), GetLastErrorText());
                    '91':
                        begin
                            if (MICAFlowBufferCFMExchRates."Base Currency Code Raw" <> CompanyCurrencyCode) then
                                if not Currency.Get(MICAFlowBufferCFMExchRates."Base Currency Code Raw") then
                                    MICAFlowBufferCFMExchRates."Skip Line" := true
                                else
                                    MICAFlowBufferCFMExchRates.Validate("Base Currency Code", MICAFlowBufferCFMExchRates."Base Currency Code Raw");
                            if not Currency.Get(MICAFlowBufferCFMExchRates."Currency Code Raw") then
                                MICAFlowBufferCFMExchRates."Skip Line" := true
                            else
                                MICAFlowBufferCFMExchRates.Validate("Currency Code", MICAFlowBufferCFMExchRates."Currency Code Raw");

                            if not EvaluateRawDecToDec(MICAFlowBufferCFMExchRates."Direct Cross Rate", MICAFlowBufferCFMExchRates."Direct Cross Rate Raw") then
                                FromMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferCFMExchRates."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferCFMExchRates.FieldCaption("Direct Cross Rate"), MICAFlowBufferCFMExchRates."Direct Cross Rate Raw"), GetLastErrorText());
                            if not EvaluateRawDecToDec(MICAFlowBufferCFMExchRates."Indirect Cross Rate", MICAFlowBufferCFMExchRates."Indirect Cross Rate Raw") then
                                FromMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferCFMExchRates."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferCFMExchRates.FieldCaption("Indirect Cross Rate"), MICAFlowBufferCFMExchRates."Indirect Cross Rate Raw"), GetLastErrorText());

                            if CountryRegion.Get(MICAFlowBufferCFMExchRates."Country/Region Code Raw") then
                                MICAFlowBufferCFMExchRates.Validate("Country/Region Code", MICAFlowBufferCFMExchRates."Country/Region Code Raw");
                        end;
                end;
                MICAFlowBufferCFMExchRates.Modify(true);
            until MICAFlowBufferCFMExchRates.Next() = 0;
    end;

    local procedure ProcessBuffer(FromMICAFlowEntry: Record "MICA Flow Entry"; var ToRecordsProcessed: Integer; var ToRecordsRejected: Integer)
    var
        ExchRateDate: date;
        ExchRateTestDate: date;
        RelExchAmtToApply: Decimal;
        NoRecordBasedOnLCYMsg: label 'No %1 record with filters %2.', comment = '%1 = Flow buffer table caption; %2 = Flow buffer table filters';
        CurrExchRateInsertErr: label 'Cannot insert %1 for %2 %3 %4.', comment = '%1 = Currency Exch. Rate Tablecaption ; %2 = Currency Code ; %3 = Starting Date ; %4 = Rate';
    begin
        MICAFlowBufferCFMExchRates.SetRange("Bloc Type", '91');
        MICAFlowBufferCFMExchRates.SetFilter("Base Currency Code", '%1', '');
        MICAFlowBufferCFMExchRates.SetRange("Skip Line", false);
        MICAFlowBufferCFMExchRates.SetRange(Error, false);
        if MICAFlowBufferCFMExchRates.FindFirst() then
            repeat
                ExchRateDate := MICAFlowBufCFMExchRatesBlocType90."Exchange Rate Date";
                ExchRateTestDate := MICAFlowBufCFMExchRatesBlocType90."Exchange Rate Receipt Date";
                repeat
                    ExchRateTestDate := CalcDate('<+1D>', ExchRateTestDate);
                    RelExchAmtToApply := GetRelationalExchangeRateToApply(ExchRateTestDate);
                    if not CurrencyExchangeRate.Get(MICAFlowBufferCFMExchRates."Currency Code", ExchRateTestDate) and (RelExchAmtToApply > 0) then begin
                        CurrencyExchangeRate.Init();
                        if CreateExchangeRatesFromCFM(MICAFlowBufferCFMExchRates."Currency Code", ExchRateTestDate, RelExchAmtToApply) then begin
                            CurrencyExchangeRate.Insert(true);
                            ToRecordsProcessed += 1;
                        end else begin
                            FromMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferCFMExchRates."Entry No.",
                                                            StrSubstNo(CurrExchRateInsertErr, CurrencyExchangeRate.TableCaption(), MICAFlowBufferCFMExchRates."Currency Code", MICAFlowBufferCFMExchRates."Exchange Rate Date", RelExchAmtToApply),
                                                            GetLastErrorText());
                            ToRecordsRejected += 1;
                        end;
                    end;
                until ExchRateTestDate = ExchRateDate;
            until MICAFlowBufferCFMExchRates.Next() = 0
        else
            FromMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Warning, StrSubstNo(NoRecordBasedOnLCYMsg, MICAFlowBufferCFMExchRates.TableCaption(), MICAFlowBufferCFMExchRates.GetFilters()), '');
    end;

    local procedure GetRelationalExchangeRateToApply(FromExchangeTestRateDate: Date): Decimal
    var
        FromCurrencyExchangeRate: Record "Currency Exchange Rate";
        DaysBetweenReceiptAndRateDate: Duration;
    begin
        FromCurrencyExchangeRate.SetRange("Currency Code", MICAFlowBufferCFMExchRates."Currency Code");
        FromCurrencyExchangeRate.Setfilter("Starting Date", '<=%1', MICAFlowBufCFMExchRatesBlocType90."Exchange Rate Receipt Date");
        DaysBetweenReceiptAndRateDate := MICAFlowBufCFMExchRatesBlocType90."Exchange Rate Date" - FromExchangeTestRateDate;
        if DaysBetweenReceiptAndRateDate = 0 then
            exit(MICAFlowBufferCFMExchRates."Indirect Cross Rate")
        else
            if not FromCurrencyExchangeRate.FindLast() then
                exit(0)
            else
                exit(FromCurrencyExchangeRate."Relational Exch. Rate Amount");
    end;

    local procedure SetWarningsForCurrenciesWithoutExchRate(var FromMICAFlowEntry: Record "MICA Flow Entry")
    var
        Currency: Record Currency;
        ExchRateDate: date;
        CurrencyWithoutRateErr: label 'No %1 exists for the %2 %3 on %4.', comment = '%1 = exch. rate table caption ; %2 = ';
    begin
        MICAFlowBufCFMExchRatesBlocType90.FindFirst();
        CurrencyExchangeRate.Reset();
        ExchRateDate := MICAFlowBufCFMExchRatesBlocType90."Exchange Rate Date";
        Currency.SetFilter(Code, '<>%1', GeneralLedgerSetup."LCY Code");
        if Currency.FindSet(false, false) then
            repeat
                if not CurrencyExchangeRateExist(Currency.Code, ExchRateDate) then
                    FromMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Warning, StrSubstNo(CurrencyWithoutRateErr, CurrencyExchangeRate.TableCaption(), Currency.TableCaption(),
                                                                                                Currency.Code, ExchRateDate), '');
            until Currency.Next() = 0;
    end;

    local procedure CurrencyExchangeRateExist(CurrencyCode: Code[10]; FromDate: Date): Boolean
    begin
        CurrencyExchangeRate.SetRange("Currency Code", CurrencyCode);
        CurrencyExchangeRate.SetRange("Starting Date", FromDate);
        exit(not CurrencyExchangeRate.IsEmpty);
    end;


    [TryFunction]
    local procedure CreateExchangeRatesFromCFM(FromCurrencyCode: Code[10]; FromExchRate: Date; RelationalExchRateAmtToApply: Decimal)
    begin
        CurrencyExchangeRate.Validate("Currency Code", FromCurrencyCode);
        CurrencyExchangeRate.validate("Starting Date", FromExchRate);
        CurrencyExchangeRate.Validate("Exchange Rate Amount", 1);
        CurrencyExchangeRate.Validate("Relational Exch. Rate Amount", RelationalExchRateAmtToApply);
        CurrencyExchangeRate.Validate("Adjustment Exch. Rate Amount", 1);
        CurrencyExchangeRate.Validate("Relational Adjmt Exch Rate Amt", RelationalExchRateAmtToApply);
    end;

    local procedure EvaluateRawDateToDate(var OutValue: Date; RawDate: Text): boolean
    var
        Day: Integer;
        Month: Integer;
        Year: Integer;
    begin
        Evaluate(Year, CopyStr(RawDate, 1, 4));
        Evaluate(Month, CopyStr(RawDate, 5, 2));
        Evaluate(Day, CopyStr(RawDate, 7, 2));
        OutValue := DMY2Date(Day, Month, Year);
        exit(true);
    end;

    local procedure EvaluateRawDecToDec(var OutValue: Decimal; RawDec: Text): Boolean
    var
        DecSeparator: Text;
    begin
        DecSeparator := CopyStr(Format(1.2), 2, 1);
        RawDec := ConvertStr(RawDec, '.', DecSeparator);
        exit(Evaluate(OutValue, RawDec));
    end;
}