/// <summary>
/// PageExtension SalesLines_Ext (ID 50155) extends Record Sales Lines.
/// </summary>
pageextension 50155 SalesLines_Ext extends "Sales Lines"
{
    layout
    {
        addfirst(FactBoxes)
        {
            part(SelectedSalesLinesTotal; SelectedSalesLinesTotal)
            {
                Caption = 'Selected Sales Lines Total';
                ApplicationArea = All;
                SubPageLink = Number = const(1);
            }
        }
    }

    actions
    {
        addbefore("Show Document")
        {
            action(CalculateTotal)
            {
                Caption = 'Calculate Total';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Calculate;

                trigger OnAction()
                var
                    SelecSalLines: Record "Sales Line";
                    totalAmount: Decimal;
                    totalQuantity: Decimal;
                    LinesCount: Integer;
                    LinesAverage: Decimal;
                begin
                    SelecSalLines.Reset();
                    Clear(LinesCount);
                    Clear(LinesAverage);
                    Clear(totalAmount);
                    Clear(totalQuantity);
                    CurrPage.SetSelectionFilter(SelecSalLines);

                    if SelecSalLines.FindSet() then
                        repeat
                            LinesCount += 1;
                            totalAmount += SelecSalLines.Amount;
                            totalQuantity += SelecSalLines.Quantity;
                        until SelecSalLines.Next() = 0;

                    if LinesCount > 0 then begin
                        LinesAverage := totalAmount / LinesCount;

                        CurrPage.SelectedSalesLinesTotal.Page.SetTotals(LinesCount, LinesAverage, totalAmount, totalQuantity);
                        CurrPage.SelectedSalesLinesTotal.Page.Update();

                    end;
                end;

            }
            action(ClearTotal)
            {
                Caption = 'Clear Total';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ClearLog;

                trigger OnAction()
                begin
                    ClearTotal();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ClearTotal();
    end;

    local procedure ClearTotal()
    var
        TotalSalesLines: record TotalSalesLines;
    begin
        TotalSalesLines.Reset();
        TotalSalesLines.DeleteAll();

    end;

}