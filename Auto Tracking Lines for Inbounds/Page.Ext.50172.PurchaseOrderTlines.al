/// <summary>
/// PageExtension ISA_PurchaseOrderTlines (ID 50172) extends Record Purchase Order.
/// </summary>
pageextension 50172 ISA_PurchaseOrderTlines extends "Purchase Order"
{
    actions
    {
        addlast(processing)
        {
            action(UpdateTrackingLines)
            {
                Caption = 'Update Tracking lines';
                Image = CreateDocument;
                ApplicationArea = All;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Promoted = true;
                ToolTip = 'To mass update all tracking lines for items on the lines';

                trigger OnAction()
                begin
                    UpdateItemTrackingLines();
                end;
            }
        }
    }

    local procedure UpdateItemTrackingLines()
    begin
        IsUpdated := false;
        LastEntryNo := 0;
        PurchaseLines.Reset();
        PurchaseLines.SetRange("Document Type", Rec."Document Type");
        PurchaseLines.SetRange("Document No.", Rec."No.");
        PurchaseLines.SetFilter("Qty. to Invoice", '<>0');
        if PurchaseLines.FindSet() then
            repeat
                if IsReservationEntryExist() then
                    ModifyReservationEntry()
                else
                    CreateReservationEntry();

                IF IsLotInfoExist() THEN
                    ModifyLotInfo()
                else
                    CreateLotNoInfo();
            until PurchaseLines.Next = 0;

        if IsUpdated then
            Message(ItemTrackinglinesHasUpdated)
        else
            Message(NothingUpdate);
    end;

    local procedure IsReservationEntryExist(): Boolean
    begin
        ReservationEntry.Reset();
        ReservationEntry.SetRange("Source Type", Database::"Purchase Line");
        ReservationEntry.SetRange("Source ID", PurchaseLines."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", PurchaseLines."Line No.");
        if ReservationEntry.FindSet then
            exit(true);
        exit(false);
    end;

    local procedure ModifyReservationEntry()
    begin
        ReservationEntry.Description := PurchaseLines.Description;
        ReservationEntry.VALIDATE("Quantity (Base)", PurchaseLines."Qty. to Receive (Base)");
        ReservationEntry."Qty. per Unit of Measure" := PurchaseLines."Qty. per Unit of Measure";
        ReservationEntry."Expected Receipt Date" := PurchaseLines."Expected Receipt Date";
        ReservationEntry."Creation Date" := WorkDate();
        ReservationEntry."Created By" := UserId;
        ReservationEntry.Modify();
        IsUpdated := true;
    end;

    local procedure CreateReservationEntry()
    begin
        if not Item.Get(PurchaseLines."No.") then
            exit;
        Item.TestField("Item Tracking Code");
        Item.TestField("Lot Nos.");

        ReservationEntry.Init();
        ReservationEntry."Entry No." := NextEntryNo;
        ReservationEntry."Item No." := PurchaseLines."No.";
        ReservationEntry.Description := PurchaseLines.Description;
        ReservationEntry."Location Code" := PurchaseLines."Location Code";
        ReservationEntry."Variant Code" := PurchaseLines."Variant Code";
        ReservationEntry.Validate("Quantity (Base)", PurchaseLines."Qty. to Receive (Base)");
        ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Surplus;
        ReservationEntry."Source Type" := Database::"Purchase Line";
        ReservationEntry."Source Subtype" := ReservationEntry."Source Subtype"::"1";
        ReservationEntry."Source ID" := PurchaseLines."Document No.";
        ReservationEntry."Source Ref. No." := PurchaseLines."Line No.";
        ReservationEntry."Expected Receipt Date" := PurchaseLines."Expected Receipt Date";
        ReservationEntry."Qty. per Unit of Measure" := PurchaseLines."Qty. per Unit of Measure";
        ReservationEntry.VALIDATE("Lot No.", NoSeriesMgt.GetNextNo(Item."Lot Nos.", WorkDate(), true));
        ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
        ReservationEntry."Created By" := UserId;
        ReservationEntry.Positive := true;
        ReservationEntry."Creation Date" := WorkDate();
        ReservationEntry.Insert();
    end;



    local procedure IsLotInfoExist(): Boolean
    var
        myInt: Integer;
    begin
        IF LotNoInfo.Get(ReservationEntry."Item No.", ReservationEntry."Variant Code", ReservationEntry."Lot No.") then
            exit(true);
        exit(false);
    end;

    local procedure ModifyLotInfo()
    var
        myInt: Integer;
    begin
        LotNoInfo.Description := ReservationEntry.Description;
        //You can add custom fields in Lot Information.
        LotNoInfo.Modify();

        IsUpdated := true;
    end;

    local procedure CreateLotNoInfo()
    var
        myInt: Integer;
    begin
        LotNoInfo.Init();
        LotNoInfo."Item No." := ReservationEntry."Item No.";
        LotNoInfo."Variant Code" := ReservationEntry."Variant Code";
        LotNoInfo."Lot No." := ReservationEntry."Lot No.";
        LotNoInfo.Description := ReservationEntry.Description;
        //You can add custom fields in Lot Information.
        LotNoInfo.Insert();
        IsUpdated := true;
    end;

    local procedure NextEntryNo(): Integer
    var
        ReserveEntry: Record "Reservation Entry";
    begin
        ReserveEntry.Reset();
        if LastEntryNo = 0 then
            if ReserveEntry.FindLast() then
                LastEntryNo := ReserveEntry."Entry No.";
        LastEntryNo += 1;
        exit(LastEntryNo);
    end;

    var
        PurchaseLines: Record "Purchase Line";
        IsUpdated: Boolean;
        ItemTrackinglinesHasUpdated: Label 'Item Tracking lines have been updated.';
        NothingUpdate: Label 'Nothing update.';
        ReservationEntry: Record "Reservation Entry";
        LotNoInfo: Record "Lot No. Information";
        Item: Record Item;
        LastEntryNo: Integer;
        NoSeriesMgt: Codeunit NoSeriesManagement;
}