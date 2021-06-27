tableextension 81300 "MICA Purchase Header" extends "Purchase Header"
{
    fields
    {
        //Flow Export
        field(80860; "MICA Send Last Flow Entry No."; Integer)
        {
            Caption = 'Send Last Flow Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MICA Flow Entry";
        }
        field(80862; "MICA Send Last Flow Status"; Option)
        {
            Caption = 'Send Last Flow Status';
            DataClassification = CustomerContent;
            Editable = false;
            OptionMembers = "",Prepared,Sent;
            OptionCaption = ',Prepared,Sent';
        }
        field(80864; "MICA Send Last DateTime"; DateTime)
        {
            Caption = 'Send Last DateTime';
            FieldClass = FlowField;
            CalcFormula = lookup("MICA Flow Entry"."Sent Date Time" where("Entry No." = field("MICA Send Last Flow Entry No.")));
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80866; "MICA Send Last Info Count"; Integer)
        {
            Caption = 'Send Last Info Count';
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Information), "Flow Entry No." = field("MICA Send Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80867; "MICA Send Last Warning Count"; Integer)
        {
            Caption = 'Send Last Warning Count';
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Warning), "Flow Entry No." = field("MICA Send Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80868; "MICA Send Last Error Count"; Integer)
        {
            Caption = 'Send Last Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Error), "Flow Entry No." = field("MICA Send Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';

        }
        field(80869; "MICA Send Ack. Received"; Boolean)
        {
            Caption = 'Send Ack. Received';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(80870; "MICA Rcv. Last Flow Entry No."; Integer)
        {
            Caption = 'Receive Last Flow Entry No.';
            Editable = false;
            TableRelation = "MICA Flow Entry";
            DataClassification = CustomerContent;
        }

        field(80872; "MICA Receive Last Flow Status"; Option)
        {
            Caption = 'Receive Last Flow Status';
            Editable = false;
            OptionMembers = "",Created,Received,Loaded,Processed,PostProcessed;
            OptionCaption = ',Created,Received,Loaded,Processed,PostProcessed';
            FieldClass = FlowField;
            CalcFormula = lookup("MICA Flow Entry"."Receive Status" where("Entry No." = field("MICA Rcv. Last Flow Entry No.")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80874; "MICA Receive Last DateTime"; DateTime)
        {
            Caption = 'Receive Last DateTime';
            FieldClass = FlowField;
            CalcFormula = lookup("MICA Flow Entry"."Received Date Time" where("Entry No." = field("MICA Rcv. Last Flow Entry No.")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80876; "MICA Receive Last Info Count"; Integer)
        {
            Caption = 'Receive Last Info Count';
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Information), "Flow Entry No." = field("MICA Rcv. Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80877; "MICA Rcv. Last Warning Count"; Integer)
        {
            Caption = 'Receive Last Warning Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Warning), "Flow Entry No." = field("MICA Rcv. Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80878; "MICA Receive Last Error Count"; Integer)
        {
            Caption = 'Receive Last Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Error), "Flow Entry No." = field("MICA Rcv. Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80879; "MICA Record ID"; RecordId)
        {
            Caption = 'Record ID';
            DataClassification = CustomerContent;
        }
        //flow ends
        field(81306; "MICA AL No."; Code[35])
        {
            Caption = 'AL No.';
            DataClassification = CustomerContent;
        }
        field(81307; "MICA SRD"; Date)
        {
            Caption = 'SRD';
            DataClassification = CustomerContent;
        }
        field(81308; "MICA Location-To Code"; Code[10])
        {
            Caption = 'Location-To Code';
            DataClassification = CustomerContent;
            TableRelation = Location.Code where("Use As In-Transit" = filter(false));
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
                ShippingTime: DateFormula;
            begin
                if GuiAllowed then begin
                    TestField("MICA Location-To Code");
                    TestField("Location Code");
                    TransferRoute.Get("Location Code", "MICA Location-To Code");
                    TransferRoute.GetShippingTime("Location Code", "MICA Location-To Code", TransferRoute."Shipping Agent Code", TransferRoute."Shipping Agent Service Code", ShippingTime);
                    "MICA SRD" := CalcDate(ShippingTime, "MICA ETA");
                end;
            end;
        }
        field(81462; "MICA Container ID"; Code[50])
        {
            Caption = 'Container ID';
            DataClassification = CustomerContent;
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
        field(81260; "MICA Purch. Doc. Creation DT"; DateTime)
        {
            Caption = 'Purchase Document Creation Date/time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        //Flow end

        field(82022; "MICA RELFAC Code"; Code[10])
        {
            Caption = 'GIS RELFAC Code';
            Description = 'RELFAC Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82023; "MICA Total Inv. Amt.(excl.VAT)"; Decimal)
        {
            Caption = 'GIS Total Invoice Amount (excluded VAT)';
            Description = 'GIS Total Invoice Amount (excluded VAT)';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(82024; "MICA GIS Invoice Doc. No."; Code[20])
        {
            Caption = 'GIS Original Invoice No.';
            Description = 'GIS Original Invoice No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82025; "MICA GIS Invoice Doc. Date"; Date)
        {
            Caption = 'GIS Original Invoice Date';
            Description = 'GIS Original Invoice Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82026; "MICA GIS Rebill Reason Code"; Text[30])
        {
            Caption = 'GIS Rebill Reason Code';
            Description = 'GIS Rebill Reason Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82027; "MICA GIS Ship-to Location"; Code[20])
        {
            Caption = 'GIS Ship-to Location';
            Description = 'GIS Ship-to Location';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82028; "MICA GIS Despatch Country"; Code[10])
        {
            Caption = 'GIS Despatch Country';
            Description = 'GIS Despatch Country';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82029; "MICA GIS DCN No."; Text[30])
        {
            Caption = 'GIS DCN No.';
            Description = 'GIS DCN No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81270; "MICA Shipment Instructions"; Text[20])
        {
            Caption = 'Shipment Instructions';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82140; "MICA Vendor Posting Group Alt."; Code[20])
        {
            Caption = 'Vendor Posting Group Alt.';
            DataClassification = CustomerContent;
            TableRelation = "Customer Posting Group";

            trigger OnValidate()
            begin
                if CurrFieldNo = FieldNo("Vendor Posting Group") then
                    exit;

                Validate("Vendor Posting Group", "MICA Vendor Posting Group Alt.");

            end;
        }
        field(82360; "MICA DC14"; code[20])
        {
            Caption = 'DC14';
            DataClassification = CustomerContent;
        }
        field(82361; "MICA Ship From Vendor"; Code[20])
        {
            Caption = 'Ship From Vendor';
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnValidate()
            var
                PurchaseLine: Record "Purchase Line";
            begin
                PurchaseLine.SetRange("Document Type", Rec."Document Type");
                PurchaseLine.SetRange("Document No.", Rec."No.");
                PurchaseLine.ModifyAll("MICA Ship From Vendor", "MICA Ship From Vendor");

            end;
        }
        field(82800; "MICA Auto. Trans. Order"; Boolean)
        {
            Caption = 'Automatic Transfer Order Creation';
            DataClassification = CustomerContent;

            Trigger OnValidate()
            var
                TransRoute: Record "Transfer Route";
                InvSetup: Record "Inventory Setup";
            begin
                TestStatusOpen();

                if not "MICA Auto. Trans. Order" then
                    exit;

                TestField("MICA ETA");
                TestField("MICA Container ID");

                InvSetup.Get();
                InvSetup.Testfield("MICA Purchase Location Code");
                if InvSetup."MICA Purchase Location Code" <> "Location Code" then
                    Error(AutoTransOrderLocErr, "Location Code");

                TransRoute.Reset();
                TransRoute.SetRange("Transfer-from Code", "Location Code");
                TransRoute.SetFilter("In-Transit Code", '<>%1', '');
                if TransRoute.IsEmpty then
                    Error(TransRouteErr)
                else
                    if "MICA Location-To Code" <> '' then begin
                        TransRoute.SetRange("Transfer-to Code", "MICA Location-To Code");
                        if TransRoute.IsEmpty then
                            Error(TransRouteToLocErr, "Location Code", "MICA Location-To Code");
                    end;
            end;
        }
        field(82860; "MICA Last Modified Date Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82920; "MICA 3rd Party"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = '3rd Party';

        }
        modify("Vendor Posting Group")
        {
            trigger OnAfterValidate()
            begin
                if CurrFieldNo = FieldNo("MICA Vendor Posting Group Alt.") then
                    exit;

                Validate("MICA Vendor Posting Group Alt.", "Vendor Posting Group");
            End;
        }
    }

    var
        AutoTransOrderLocErr: Label 'Automatic transfer order creation is not possible for the location %1', Comment = '%1 = location code of the purchase order';
        TransRouteErr: Label 'No In-Transit Location defined in Transfer Route matrix. In-Transit Location must exist for automatic transfer order creation';
        TransRouteToLocErr: Label 'There is no transfer route between location %1 to %2', comment = '%1 = Location-from, %2 = Location-to';

    trigger OnAfterInsert()
    begin
        Rec.Validate("MICA Last Modified Date Time", CurrentDateTime());
    end;

    trigger OnAfterModify()
    begin
        Rec.Validate("MICA Last Modified Date Time", CurrentDateTime());
    end;

    procedure InitExternalInventory()
    var
        UserSetup: Record "User Setup";
        Location: Record Location;
    begin
        UserSetup.Get(UserId);
        Location.SetRange("MICA Commitment Type", Location."MICA Commitment Type"::"Third Party");
        Location.SetRange("MICA 3rd Party Vendor No.", UserSetup."MICA 3rd Party Vendor No.");
        Location.FindFirst();

        Rec.Validate("Document Type", Rec."Document Type"::"Blanket Order");
        Rec.Validate("Buy-from Vendor No.", UserSetup."MICA 3rd Party Vendor No.");
        Rec.Validate("Vendor Order No.", UserSetup."MICA 3rd Party Vendor No.");
        Rec.Validate("Location Code", Location.Code);
        Rec.Validate("MICA 3rd Party", true);
    end;
}