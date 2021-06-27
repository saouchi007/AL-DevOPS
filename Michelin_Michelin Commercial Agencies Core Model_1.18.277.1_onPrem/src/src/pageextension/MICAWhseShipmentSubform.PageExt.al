pageextension 80962 "MICA Whse. Shipment Subform" extends "Whse. Shipment Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("MICA 3PL Whse Shpt. Comment"; Rec."MICA 3PL Whse Shpt. Comment")
            {
                ApplicationArea = All;
            }
            field("MICA 3PL Qty. To Ship"; Rec."MICA 3PL Qty. To Ship")
            {
                ApplicationArea = All;
            }
            field("MICA Shipment Date in SO"; Rec."MICA Shipment Date in SO")
            {
                ApplicationArea = All;
            }
            field("MICA Planed Shipm. Date in SO"; Rec."MICA Planed Shipm. Date in SO")
            {
                ApplicationArea = All;
            }
            field("MICA Planned Deliv. Date in SO"; Rec."MICA Planned Deliv. Date in SO")
            {
                ApplicationArea = All;
            }
            field("MICA Customer Transport"; Rec."MICA Customer Transport")
            {
                ApplicationArea = All;
            }
            field("MICA Transport Instruction"; Rec."MICA Transport Instruction")
            {
                ApplicationArea = All;
                Editable = TransportInstructionIsEditable;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateTransportInstructionEditable()
    end;

    local procedure UpdateTransportInstructionEditable()
    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
    begin
        if WarehouseShipmentHeader.Get(Rec."No.") then
            TransportInstructionIsEditable := not (WarehouseShipmentHeader.Status = WarehouseShipmentHeader.Status::Released);
    end;

    var
        TransportInstructionIsEditable: Boolean;
}