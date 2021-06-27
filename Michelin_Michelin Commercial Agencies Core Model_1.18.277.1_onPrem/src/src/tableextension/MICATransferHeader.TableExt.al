tableextension 81462 "MICA Transfer Header" extends "Transfer Header"
{
    fields
    {
        field(81306; "MICA AL No."; Code[35])
        {
            Caption = 'AL No.';
            DataClassification = CustomerContent;
        }
        field(81307; "MICA SRD"; Date)
        {
            Caption = 'SRD';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                PostProc: Codeunit "MICA Flow PostProcessPurchOrd";
            begin
                Validate("Receipt Date", PostProc.CalcReceiptDate("Transfer-to Code", "MICA SRD"));
                if "MICA Initial SRD" = 0D then
                    "MICA Initial SRD" := "MICA SRD";
            end;
        }

        field(81460; "MICA ASN No."; Code[35])
        {
            Caption = 'ASN No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81461; "MICA ETA"; Date)
        {
            Caption = 'ETA';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                TransferRoute: Record "Transfer Route";
                DiffDate: Integer;
                SRDDateCannotBeAutomaticallyPopulatedMsg: Label 'SRD date cannot be automatically populated because there is no Transfer route from %1 to %2';
            begin
                if "MICA Initial ETA" = 0D then
                    "MICA Initial ETA" := "MICA ETA";
                if TransferRoute.get("Transfer-from Code", "Transfer-to Code") then begin
                    if "MICA ETA" <> 0D then
                        Validate("MICA SRD", CalcSRDDate(TransferRoute, "MICA ETA"));
                end else
                    if (xRec."MICA ETA" <> 0D) and ("MICA SRD" <> 0D) and ("MICA ETA" <> 0D) then begin
                        DiffDate := "MICA SRD" - xRec."MICA ETA";
                        Validate("MICA SRD", CalcDate('<' + Format(DiffDate) + 'D>', "MICA ETA"));
                    end else
                        if ("MICA ETA" <> 0D) and not HideValidationMsg then
                            Message(SRDDateCannotBeAutomaticallyPopulatedMsg, "Transfer-from Code", "Transfer-to Code");
            end;
        }
        field(81462; "MICA Container ID"; Code[50])
        {
            Caption = 'Container ID';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81463; "MICA Seal No."; Code[20])
        {
            Caption = 'Seal No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81464; "MICA Port of Arrival"; Code[20])
        {
            Caption = 'Port of Arrival';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81465; "MICA Carrier Doc. No."; Code[20])
        {
            Caption = 'Carrier Doc. No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81466; "MICA ASN Date"; Date)
        {
            Caption = 'ASN Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81468; "MICA Initial ETA"; Date)
        {
            Caption = 'Initial ETA';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81469; "MICA Initial SRD"; Date)
        {
            Caption = 'Initial SRD';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81470; "MICA Maritime Air Company Name"; Text[50])
        {
            Caption = 'Maritime Air Company Name';
            DataClassification = CustomerContent;
        }
        field(81471; "MICA Maritime Air Number"; Text[50])
        {
            Caption = 'Maritime Air Number';
            DataClassification = CustomerContent;
        }
        field(81980; "MICA Action From Page"; Boolean)
        {
            Caption = 'Action From Page';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82800; "MICA Vendor Order No."; Code[35])
        {
            Caption = 'Vendor Order No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "MICA ASN No.")
        {
        }
        key(Key2; "MICA AL No.")
        {
        }
        key(Key3; "MICA SRD")
        {
        }
    }

    var
        HideValidationMsg: Boolean;

    local procedure CalcSRDDate(TransferRoute: Record "Transfer Route"; SRD: Date): Date
    var
        ShippingAgentServices: Record "Shipping Agent Services";
    begin
        if SRD = 0D then
            exit;
        if (TransferRoute."Shipping Agent Code" <> '') and (TransferRoute."Shipping Agent Service Code" <> '') then
            ShippingAgentServices.Get(TransferRoute."Shipping Agent Code", TransferRoute."Shipping Agent Service Code");
        Exit(CalcDate(ShippingAgentServices."Shipping Time", SRD));
    End;

    procedure SetHideValidationMsg(NewHideValidationMsg: Boolean)
    begin
        HideValidationMsg := NewHideValidationMsg;
    end;

    procedure GetHideValidationMsg(): Boolean
    begin
        exit(HideValidationMsg);
    end;
}