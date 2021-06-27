pageextension 81120 "MICA Sales Return Order" extends "Sales Return Order" //MyTargetPageId
{
    layout
    {
        addlast(General)
        {
            field("MICA Return Order With Collect"; Rec."MICA Return Order With Collect")
            {
                ApplicationArea = All;

                trigger OnValidate()
                var
                    WarehouseReceiptLine: Record "Warehouse Receipt Line";
                    WarRecLinAlreadyExistErr: Label 'Warehouse Receipt Line exists';
                begin
                    Rec.TestField(Status, Rec.Status::Open);
                    WarehouseReceiptLine.SetRange("Source Document", WarehouseReceiptLine."Source Document"::"Sales Return Order");
                    WarehouseReceiptLine.SetRange("Source No.", Rec."No.");

                    IF not WarehouseReceiptLine.IsEmpty() then
                        Error(WarRecLinAlreadyExistErr);
                End;

            }
        }
        addlast("Ship-to")
        {
            field("MICA Retrieve-From Address Code"; Rec."MICA Retrieve-From Addr. Code")
            {
                ApplicationArea = All;
            }
            field("MICA Retrieve-From Address"; Rec."MICA Retrieve-From Address")
            {
                ApplicationArea = All;
            }
        }
    }
}