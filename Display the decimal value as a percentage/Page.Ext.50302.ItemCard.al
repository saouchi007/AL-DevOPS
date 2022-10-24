/// <summary>
/// PageExtension MyExtension (ID 50302) extends Record Item Card.
/// </summary>
pageextension 50302 MyExtension extends "Item Card"
{
    layout
    {
        addafter("Item Category Code")
        {
            field(ISA_ExpectedProfit; ISA_ExpectedProfit)
            {
                ApplicationArea = All;
                Caption = '% Expected Profit';
                AutoFormatType = 10;
                AutoFormatExpression = '<precision, 2:4><standard format,0>%';
            }
        }
    }

    var
        ISA_ExpectedProfit: Decimal;
}