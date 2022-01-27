/// <summary>
/// Page Recovery Overview by Categorie (ID 52182521).
/// </summary>
page 52182521 "Recovery Overview by Categorie"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Recovery Overview by Categories',
                FRA = 'Détail récupérations par catégorie';
    DataCaptionExpression = '';
    PageType = Document;
    SaveValues = true;
    SourceTable = 5200;

    layout
    {
        area(content)
        {
            group(Options)
            {
                CaptionML = ENU = 'Options',
                            FRA = 'Options';
                field("Employee No. Filter"; "Employee No. Filter")
                {
                }
                field(PeriodType; PeriodType)
                {
                    Caption = 'View by';
                    OptionCaption = 'Day,Week,Month,Quarter,Year,Accounting Period';
                    ToolTipML = ENU = 'Day',
                                FRA = 'Jour';

                    trigger OnValidate();
                    begin
                        IF PeriodType = PeriodType::"Accounting Period" THEN
                            AccountingPerioPeriodTypeOnVal;
                        IF PeriodType = PeriodType::Year THEN
                            YearPeriodTypeOnValidate;
                        IF PeriodType = PeriodType::Quarter THEN
                            QuarterPeriodTypeOnValidate;
                        IF PeriodType = PeriodType::Month THEN
                            MonthPeriodTypeOnValidate;
                        IF PeriodType = PeriodType::Week THEN
                            WeekPeriodTypeOnValidate;
                        IF PeriodType = PeriodType::Day THEN
                            DayPeriodTypeOnValidate;
                    end;
                }
            }
            part(SubForm; "Empl. Recovery by Cat. Matrix")
            {
            }
            field(RecoveryType; RecoveryType)
            {
                OptionCaption = 'Balance at Date,Net Change';
                ToolTipML = ENU = 'Net Change',
                            FRA = 'Solde période';

                trigger OnValidate();
                begin
                    IF RecoveryType = RecoveryType::"Balance at Date" THEN
                        BalanceatDateRecoveryTypeOnVal;
                    IF RecoveryType = RecoveryType::"Net Change" THEN
                        NetChangeRecoveryTypeOnValidat;
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        PasteFilter;
    end;

    trigger OnOpenPage();
    begin
        PasteFilter;
    end;

    var
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        RecoveryType: Option "Balance at Date","Net Change";
        EmployeeNoFilter: Text[250];


    local procedure PasteFilter();
    begin
        EmployeeNoFilter := GETFILTER("Employee No. Filter");
        CurrPage.SubForm.PAGE.MatrixUpdate(RecoveryType, PeriodType, EmployeeNoFilter);
    end;

    local procedure AccountingPerioPeriodTypOnPush();
    begin
        PasteFilter;
    end;

    local procedure YearPeriodTypeOnPush();
    begin
        PasteFilter;
    end;

    local procedure QuarterPeriodTypeOnPush();
    begin
        PasteFilter;
    end;

    local procedure MonthPeriodTypeOnPush();
    begin
        PasteFilter;
    end;

    local procedure WeekPeriodTypeOnPush();
    begin
        PasteFilter;
    end;

    local procedure DayPeriodTypeOnPush();
    begin
        PasteFilter;
    end;

    local procedure NetChangeRecoveryTypeOnPush();
    begin
        PasteFilter;
    end;

    local procedure BalanceatDateRecoveryTypOnPush();
    begin
        PasteFilter;
    end;

    local procedure DayPeriodTypeOnValidate();
    begin
        DayPeriodTypeOnPush;
    end;

    local procedure WeekPeriodTypeOnValidate();
    begin
        WeekPeriodTypeOnPush;
    end;

    local procedure MonthPeriodTypeOnValidate();
    begin
        MonthPeriodTypeOnPush;
    end;

    local procedure QuarterPeriodTypeOnValidate();
    begin
        QuarterPeriodTypeOnPush;
    end;

    local procedure YearPeriodTypeOnValidate();
    begin
        YearPeriodTypeOnPush;
    end;

    local procedure AccountingPerioPeriodTypeOnVal();
    begin
        AccountingPerioPeriodTypOnPush;
    end;

    local procedure NetChangeRecoveryTypeOnValidat();
    begin
        NetChangeRecoveryTypeOnPush;
    end;

    local procedure BalanceatDateRecoveryTypeOnVal();
    begin
        BalanceatDateRecoveryTypOnPush;
    end;
}

