page 82260 "MICA Import Data Dialog"
{
    PageType = StandardDialog;
    SourceTable = Integer;
    SourceTableView = where(number = CONST(1));
    Caption = 'Import Data Input';
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(InputDateFormat; InputDateFormatValue)
                {
                    ApplicationArea = All;
                    Caption = 'Date Format';
                    OptionCaption = 'MM/DD/YYYYY,DD/MM/YYYY';

                }
                field(InputDecimalSeparator; InputDecimalSeparatorValue)
                {
                    ApplicationArea = All;
                    Caption = 'Decimal Separator';
                    OptionCaption = 'Comma,Dot';
                }
            }
        }
    }

    var
        InputDateFormatValue: Option "MM/DD/YYYYY","DD/MM/YYYY";
        InputDecimalSeparatorValue: Option Comma,Dot;

    procedure GetInputData(var DateFormat: Option; var DecimalSeparator: Option)
    begin
        DateFormat := InputDateFormatValue;
        DecimalSeparator := InputDecimalSeparatorValue;
    end;
}