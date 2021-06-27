codeunit 82100 "MICA Transfer In Transit Mgt."
{
    trigger OnRun()
    begin

    end;

    procedure FillTempTransferLine(var TempTransferLine: Record "Transfer Line")
    var
        TransferLine: Record "Transfer Line";
        TotalWhseQty: Decimal;
    begin
        if TempTransferLine.IsTemporary() then
            TempTransferLine.DeleteAll();
        TransferLine.SetAutoCalcFields("Whse. Inbnd. Otsdg. Qty (Base)");
        TransferLine.SetFilter("Qty. in Transit", '<>%1', 0);
        TransferLine.SetRange("Derived From Line No.", 0);
        if TransferLine.FindSet() then
            repeat
                if TransferLine."Whse. Inbnd. Otsdg. Qty (Base)" <> 0 then begin
                    InsertTempTransferLineFromWhseReceiptLine(TransferLine, TempTransferLine, TotalWhseQty);
                    if TotalWhseQty <> TransferLine."Qty. in Transit" then
                        CopyFromTransverLine(TransferLine, TempTransferLine, TransferLine."Qty. in Transit" - TotalWhseQty);
                end else
                    CopyFromTransverLine(TransferLine, TempTransferLine, TransferLine."Qty. in Transit");
            until TransferLine.Next() = 0;

    end;

    local procedure InsertTempTransferLineFromWhseReceiptLine(FromTransferLine: Record "Transfer Line"; var ToTransferLine: Record "Transfer Line"; var TotalWhseQty: Decimal)
    var
        WarehouseReceiptLine: Record "Warehouse Receipt Line";
        i: Integer;
    begin
        Clear(TotalWhseQty);
        i := 1;
        WarehouseReceiptLine.SetRange("Source Type", Database::"Transfer Line");
        WarehouseReceiptLine.SetRange("Source Document", WarehouseReceiptLine."Source Document"::"Inbound Transfer");
        WarehouseReceiptLine.SetRange("Source No.", FromTransferLine."Document No.");
        WarehouseReceiptLine.SetRange("Source Line No.", FromTransferLine."Line No.");
        if WarehouseReceiptLine.FindSet() then
            repeat
                ToTransferLine.Init();
                ToTransferLine.TransferFields(FromTransferLine);
                ToTransferLine."Line No." += i;
                ToTransferLine.Quantity := WarehouseReceiptLine."Qty. Outstanding";
                ToTransferLine."MICA Whse. Receipt No." := WarehouseReceiptLine."No.";
                ToTransferLine.Insert();
                TotalWhseQty += WarehouseReceiptLine."Qty. Outstanding";
                i += 1;
            until WarehouseReceiptLine.Next() = 0;
    end;

    local procedure CopyFromTransverLine(FromTransferLine: Record "Transfer Line"; var ToTransferLine: Record "Transfer Line"; qty: Decimal)
    begin
        ToTransferLine.Init();
        ToTransferLine.TransferFields(FromTransferLine);
        ToTransferLine.Quantity := qty;
        ToTransferLine.Insert();
    end;
}