/// <summary>
/// PageExtension ISA_CurrenciesExt (ID 50303) extends Record Currencies.
/// </summary>
pageextension 50303 ISA_CurrenciesExt extends Currencies
{
    layout
    {
        addafter(Description)
        {

            field("Process Check 01"; Rec."Process Check 01")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Process Check 01 field.';
            }
            field("Process Check 02"; Rec."Process Check 02")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Process Check 02 field.';
            }
            field("Process Check 03"; Rec."Process Check 03")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Process Check 03 field.';
            }
            field("Process Check 04"; Rec."Process Check 04")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Process Check 04 field.';
            }
            field("Process Check 05"; Rec."Process Check 05")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Process Check 05 field.';
            }
            field("Process Check 06"; Rec."Process Check 06")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Process Check 06 field.';
            }
            field("Total No. of Pending"; Rec."Total No. of Pending")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total No. of Pending field.';
            }
            field("Total No. of Processed"; Rec."Total No. of Processed")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total No. of Processed field.';
            }
            field("Total No. of Unprocessed"; Rec."Total No. of Unprocessed")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total No. of Unprocessed field.';
            }
        }

    }
    actions
    {
        addfirst(processing)
        {
            action(Totals)
            {
                ApplicationArea = All;
                Image = Totals;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Caption = 'Table Counts';

                trigger OnAction()
                begin
                    CountAcrossLines();
                end;
            }
        }
    }


    local procedure CountAcrossLines()
    var
        Currencies: Record Currency;
        Result: Label 'There are about :\- %1 Processed\- %2 Pending \- %3 Unprocessed';
        TotalPending, TotalProcessed, TotalUnprocessed : Integer;
    begin
        Currencies.Reset();
        Currencies.FilterGroup(-1);

        ApplyBatchFilters(Currencies, Enum::ISA_ProcessCheck::Processed);
        TotalProcessed := Currencies.Count;

        ApplyBatchFilters(Currencies, Enum::ISA_ProcessCheck::Pending);
        TotalPending := Currencies.Count;

        ApplyBatchFilters(Currencies, Enum::ISA_ProcessCheck::Unprocessed);
        TotalUnprocessed := Currencies.Count;

        Message(Result, TotalProcessed, TotalPending, TotalUnprocessed);

    end;

    local procedure ApplyBatchFilters(var Currencies: Record Currency; ProcessCheck: Enum ISA_ProcessCheck)
    begin
        Currencies.SetRange("Process Check 01", ProcessCheck);
        Currencies.SetRange("Process Check 02", ProcessCheck);
        Currencies.SetRange("Process Check 03", ProcessCheck);
        Currencies.SetRange("Process Check 04", ProcessCheck);
        Currencies.SetRange("Process Check 05", ProcessCheck);
        Currencies.SetRange("Process Check 06", ProcessCheck);
    end;
}