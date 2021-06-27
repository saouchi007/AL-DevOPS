report 82763 "MICA Implement Rebate Changes"
{
    Caption = 'Implement Rebate Changes';
    ProcessingOnly = true;
    UseRequestPage = true;
    UsageCategory = None;

    dataset
    {
        dataitem("MICA Rebate Recalc. Worksheet"; "MICA Rebate Recalc. Worksheet")
        {
            RequestFilterFields = "Order No.", "Item No.";

            trigger OnPreDataItem()
            begin
                SalesReceivablesSetup.Get();

                WindowDialog.Open(
                Text000Msg +
                Text002Msg +
                Text003Msg);
            end;

            trigger OnAfterGetRecord()
            var
                SuggestImplPriceRebateChanges: Codeunit "MICA Sugg.Imp. Pric.Reb. Chng.";
                UpdatedSalesLineDiscount: Boolean;
            begin
                Clear(SuggestImplPriceRebateChanges);

                WindowDialog.Update(1, "Order No.");
                WindowDialog.Update(2, "Item No.");

                SuggestImplPriceRebateChanges.SetSORebateRecalcExclWindow(SalesReceivablesSetup."MICA SO Reb. Rec. Excl. Wind.");
                UpdatedSalesLineDiscount := SuggestImplPriceRebateChanges.UpdateRebateSalesOrderLines("MICA Rebate Recalc. Worksheet");
                if UpdatedSalesLineDiscount then
                    SuggestImplPriceRebateChanges.InsertRebateRecalcEntry("MICA Rebate Recalc. Worksheet");
            end;

            trigger OnPostDataItem()
            begin
                DeleteAll();
                Commit();
            end;
        }
    }

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        WindowDialog: Dialog;
        Text000Msg: Label 'Updating Rebate Recalc. Entry...\\';
        Text002Msg: Label 'Order No.              #1##########\';
        Text003Msg: Label 'Item No.               #2######';
}