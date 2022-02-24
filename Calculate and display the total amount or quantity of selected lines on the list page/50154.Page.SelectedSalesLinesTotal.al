/// <summary>
/// Page SelectedSalesLinesTotal (ID 50154).
/// </summary>
page 50154 SelectedSalesLinesTotal
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = TotalSalesLines;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(LinesCount; Rec.LinesCount)
                {
                    ApplicationArea = All;
                    Caption = 'Count';
                }

                field(LinesAverage; Rec.LinesAverage)
                {
                    ApplicationArea = All;
                    Caption = 'Average';
                }
                field(Amount; Rec.Amount)
                {
                    Caption = 'Total Amount';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    Caption = 'Total Quantity';
                    ApplicationArea = All;
                }
            }
        }
    }


    /// <summary>
    /// SetTotals.
    /// </summary>
    /// <param name="NewCount">VAR Integer.</param>
    /// <param name="NewAverage">Decimal.</param>
    /// <param name="newTotalAmount">Decimal.</param>
    /// <param name="NewTotalQuantity">Decimal.</param>
    procedure SetTotals(var NewCount: Integer; NewAverage: Decimal; newTotalAmount: Decimal; NewTotalQuantity: Decimal)
    begin
        Rec.Reset();
        Rec.DeleteAll();
        Rec.Init();
        Rec.Number := 1;
        Rec.LinesCount := NewCount;
        Rec.LinesAverage := NewAverage;
        Rec.Amount := newTotalAmount;
        Rec.Quantity := NewTotalQuantity;
        Rec.Insert();
    end;
}