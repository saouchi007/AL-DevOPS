/// <summary>
/// Codeunit ISA_TempRecMethod (ID 50301).
/// </summary>
codeunit 50305 ISA_TempRecMethodandFilter
{
    trigger OnRun()
    begin

    end;

    /// <summary>
    /// ISA_SalesLineTempRecGroupMethod.
    /// </summary>
    procedure ISA_SalesLineTempRecGroupMethod()
    var
        SalesLine: Record "Sales Line";
        TempSalesLineResult: Record "Sales Line" temporary;
        GroupNo: Integer;
    begin
        SalesLine.SetCurrentKey("Sell-to Customer No.", Type, "No.");
        if SalesLine.FindSet() then
            repeat
                TempSalesLineResult.SetRange("Sell-to Customer No.", SalesLine."Sell-to Customer No.");
                TempSalesLineResult.SetRange(Type, SalesLine.Type);
                TempSalesLineResult.SetRange("No.", SalesLine."No.");

                if not TempSalesLineResult.FindFirst() then begin
                    GroupNo += 1;
                    TempSalesLineResult := SalesLine;
                    TempSalesLineResult.Insert();
                end else begin
                    TempSalesLineResult.Amount += SalesLine.Amount;
                    TempSalesLineResult.Modify();
                end;
            until SalesLine.Next() = 0;
    end;

    /// <summary>
    /// ISA_FilterGroupMehtod.
    /// </summary>
    procedure ISA_FilterGroupMehtod()
    var
        SalesLine: Record "Sales Line";
        GroupNo: Integer;
        FieldFilterAlpha, FieldFilterBeta, FieldFilterCharlie : Text;
        DicOfGroup: Dictionary of [Integer, Decimal];
    begin
        FieldFilterAlpha := SalesLine.GetFilter("Sell-to Customer No.");
        FieldFilterBeta := SalesLine.GetFilter(Type);
        FieldFilterCharlie := SalesLine.GetFilter("No.");

        SalesLine.SetCurrentKey("Sell-to Customer No.", Type, "No.");

        if SalesLine.FindSet() then
            repeat
                //Set current group filters
                SalesLine.SetRange("Sell-to Customer No.", SalesLine."Sell-to Customer No.");
                SalesLine.SetRange(Type, SalesLine.Type);
                SalesLine.SetRange("No.", SalesLine."No.");
                //Go to last record of group
                SalesLine.FindLast();
                //New group, calc amount and put it to dictionary
                SalesLine.CalcSums(Amount);
                GroupNo += 1;
                DicOfGroup.Add(GroupNo, SalesLine.Amount);
                //Set default filters
                SalesLine.SetFilter("Sell-to Customer No.", FieldFilterAlpha);
                SalesLine.SetFilter(Type, FieldFilterBeta);
                SalesLine.SetFilter("No.", FieldFilterCharlie);
            until SalesLine.Next() = 0;
    end;
}