page 82480 "MICA Update ASN ETA SRD"
{
    Caption = 'P_UPDATE_ASN_ETA_SRD', Locked = true;
    PageType = List;
    SourceTable = "Transfer Header";
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = false;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("P_ASN_NUMBER"; Rec."MICA ASN No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("P_ETA_DATE"; Rec."MICA ETA")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("P_SCH_RECEPTION_DATE"; Rec."MICA SRD")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("P_TO_BSC_NO"; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    begin
        UpdateReceiptDocument(Rec);
    end;

    local procedure UpdateReceiptDocument(TransferHeader: Record "Transfer Header")
    var
        WarehouseReceiptLine: Record "Warehouse Receipt Line";
    begin
        WarehouseReceiptLine.SetRange("MICA ASN No.", TransferHeader."MICA ASN No.");
        if WarehouseReceiptLine.FindSet() then
            repeat
                WarehouseReceiptLine.Validate("MICA SRD", TransferHeader."MICA SRD");
                WarehouseReceiptLine.Validate("MICA ETA", TransferHeader."MICA ETA");
                WarehouseReceiptLine.Modify(true);
                UpdateWhseReceiptHeader(WarehouseReceiptLine);
            until WarehouseReceiptLine.Next() = 0;
    end;

    local procedure UpdateWhseReceiptHeader(WarehouseReceiptLine: Record "Warehouse Receipt Line")
    var
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
    begin
        if WarehouseReceiptHeader.Get(WarehouseReceiptLine."No.") then begin
            WarehouseReceiptHeader.Validate("MICA SRD", WarehouseReceiptLine."MICA SRD");
            WarehouseReceiptHeader.Validate("MICA ETA", WarehouseReceiptLine."MICA ETA");
            WarehouseReceiptHeader.Modify(true);
        end;
    end;
}