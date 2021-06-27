tableextension 82780 "MICA Sales Order Entity Buffer" extends "Sales Order Entity Buffer"
{
    fields
    {
        field(82781; "MICA Series No."; Code[20])
        {
            Caption = 'Series No.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series".Code;
        }
        field(82780; "MICA Ship-To-Address Id"; Guid)
        {
            Caption = 'shipToAddressId';
            DataClassification = SystemMetadata;
            TableRelation = "Ship-to Address".SystemId;

            trigger OnValidate()
            begin
                UpdateShipToAddressCode();
            end;
        }
    }

    local procedure UpdateShipToAddressCode()
    var
        ShiptoAddress: Record "Ship-to Address";
    begin
        if not IsNullGuid("MICA Ship-To-Address Id") then begin
            ShiptoAddress.SetRange(SystemId, "MICA Ship-To-Address Id");
            ShiptoAddress.FindFirst();
        end;

        Validate("Ship-to Code", ShiptoAddress.Code);
        Validate("Ship-to Name", ShiptoAddress.Name);
    end;

    procedure UpdateShipToAddressId()
    var
        ShiptoAddress: Record "Ship-to Address";
    begin
        if "Ship-to Code" = '' then begin
            Clear("MICA Ship-To-Address Id");
            exit;
        end;

        if not ShiptoAddress.Get("Sell-to Customer No.", "Ship-to Code") then
            exit;

        "MICA Ship-To-Address Id" := ShiptoAddress.SystemId;
    end;

}