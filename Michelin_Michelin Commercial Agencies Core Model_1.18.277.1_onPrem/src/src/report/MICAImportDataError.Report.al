report 82260 "MICA Import Data Error"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rdl82260.MICAImportDataError.rdl';
    Caption = 'Import Data Error';
    UsageCategory = None;
    dataset
    {
        dataitem(IntegerHeader; Integer)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(CompanyInformationPicture; CompanyInformation.Picture) { }
            column(ReportHeaderLbl; ReportHeaderLbl) { }
            column(ReportSubtitle; ReportSubtitle) { }
            column(DateFormatLbl; DateFormatLbl) { }
            column(DecimalSeparatorLbl; DecimalSeparatorLbl) { }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl) { }
            column(NoCaption; NoCaptionLbl) { }
            column(RowCaption; RowCaptionLbl) { }
            column(ErrorDescCaption; ErrorDescCaptionLbl) { }
            column(DateFormat; Format(DateFormat)) { }
            column(DecimalSeparator; Format(DecimalSeparator)) { }
            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                CompanyInformation.CalcFields(Picture);
            end;

        }
        dataitem(Integer; Integer)
        {
            column(ID; TempErrorMessage.ID) { }
            column(Description; TempErrorMessage.Description) { }
            column(AdditionalInformation; TempErrorMessage."Additional Information") { }

            trigger OnPreDataItem()
            begin
                TempErrorMessage.Reset();
                Integer.SetRange(Number, 1, TempErrorMessage.Count());
            end;

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    TempErrorMessage.FindFirst()
                else
                    TempErrorMessage.Next();

            end;

        }
    }
    var
        TempErrorMessage: Record "Error Message" temporary;
        CompanyInformation: Record "Company Information";
        DateFormat: Option "MM/DD/YYYYY","DD/MM/YYYY";
        DecimalSeparator: Option Comma,Dot;
        ReportSubtitle: Text[30];
        ReportHeaderLbl: Label 'Import Data Errors';
        DecimalSeparatorLbl: Label 'Valid Decimal Separator';
        DateFormatLbl: Label 'Valid Date Format';
        CurrReportPageNoCaptionLbl: Label 'Page';
        NoCaptionLbl: Label 'No.';
        RowCaptionLbl: Label 'Row';
        ErrorDescCaptionLbl: Label 'Error Description';

    procedure SetErrorMessage(var ErrorMessage: Record "Error Message");
    begin
        ErrorMessage.Reset();
        if ErrorMessage.FindSet() then
            repeat
                TempErrorMessage.Init();
                TempErrorMessage.TransferFields(ErrorMessage);
                TempErrorMessage.Insert();
            until ErrorMessage.Next() = 0;
    end;

    procedure SetInputData(InputDateFormat: Integer; InputDecimalSeparator: integer)
    begin
        DateFormat := InputDateFormat;
        DecimalSeparator := InputDecimalSeparator;
    end;

    procedure SetReportSubtitle(NewSubtitle: Text)
    begin
        ReportSubtitle := CopyStr(NewSubtitle, 1, 30);
    end;

}