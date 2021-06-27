report 82761 "MICA Implement Price Changes"
{
    Caption = 'Implement Price Change';
    ProcessingOnly = true;
    UseRequestPage = true;
    UsageCategory = None;

    dataset
    {
        dataitem("MICA Price Recalc. Worksheet"; "MICA Price Recalc. Worksheet")
        {
            RequestFilterFields = "Order No.", "Item No.";
            trigger OnPreDataItem()
            begin
                WindowDialog.Open(
                    Text000Msg +
                    Text002Msg +
                    Text003Msg);
            end;

            trigger OnAfterGetRecord()
            var
                SuggestImplPriceRebateChanges: Codeunit "MICA Sugg.Imp. Pric.Reb. Chng.";
                UpdatedSalesLinePrice: Boolean;
            begin
                Clear(SuggestImplPriceRebateChanges);

                WindowDialog.Update(1, "Order No.");
                WindowDialog.Update(2, "Item No.");

                UpdatedSalesLinePrice := SuggestImplPriceRebateChanges.UpdatePriceSalesOrderLines("MICA Price Recalc. Worksheet");
                if UpdatedSalesLinePrice then
                    SuggestImplPriceRebateChanges.InsertPriceRecalcEntry("MICA Price Recalc. Worksheet");
            end;

            trigger OnPostDataItem()
            begin
                DeleteAll();
                Commit();
            end;
        }
    }

    var
        WindowDialog: Dialog;
        Text000Msg: Label 'Updating Price Recalc. Entry...\\';
        Text002Msg: Label 'Order No.              #1##########\';
        Text003Msg: Label 'Item No.               #2######';
}