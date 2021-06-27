tableextension 81221 "MICA Warehouse Shipment Line" extends "Warehouse Shipment Line"
{
    fields
    {
        field(80979; "MICA 3PL Whse Shpt. Comment"; Text[50])
        {
            Caption = '3PL Warehouse Shipment Comment';
            DataClassification = CustomerContent;
            Description = 'Comment for 3PL system';
        }
        field(81193; "MICA 3PL Qty. To Ship"; Decimal)
        {
            Caption = '3PL Qty. To Ship';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(81194; "MICA 3PL Country Of Origin"; Code[2])
        {
            Caption = '3PL Country Of Origin';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                UpdateDotAndCountryOnSalesLine();
            end;
        }
        field(81195; "MICA 3PL DOT Value"; Code[10])
        {
            Caption = '3PL DOT Value';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                UpdateDotAndCountryOnSalesLine();
            end;
        }
        field(81620; "MICA Shipment Date in SO"; Date)
        {
            Caption = 'Shipment Date in SO';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81621; "MICA Planed Shipm. Date in SO"; Date)
        {
            Caption = 'Planned Shipment Date in SO';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81622; "MICA Planned Deliv. Date in SO"; Date)
        {
            Caption = 'Planned Delivery Date in SO';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81624; "MICA Truck Driver Info"; Text[50])
        {
            Caption = 'Truck Driver Info';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                UpdateTruckInfoOnHeader(Rec);
            end;
        }
        field(81625; "MICA Truck License Plate"; Text[50])
        {
            Caption = 'Truck License Plate';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                UpdateTruckInfoOnHeader(Rec);
            end;
        }

        //Flow 
        field(80879; "MICA Record ID"; RecordId)
        {
            Caption = 'Record ID';
            Editable = false;
            DataClassification = CustomerContent;
        }

        //Flow Export
        field(80860; "MICA Send Flow Entry No."; Integer)
        {
            Caption = 'Send Flow Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MICA Flow Entry";
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80865; "MICA Send Last Flow Entry No."; Integer)
        {
            Caption = 'Send Last Flow Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MICA Flow Entry";
        }
        field(80861; "MICA Send Flow Record No."; Integer)
        {
            Caption = 'Send Record Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MICA Flow Record";
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80862; "MICA Send Last Flow Status"; Option)
        {
            Caption = 'Send Last Flow Status';
            OptionMembers = " ",Prepared,Sent;
            OptionCaption = ' ,Prepared,Sent';
            FieldClass = FlowField;
            CalcFormula = lookup("MICA Flow Entry"."Send Status" where("Entry No." = field("MICA Send Last Flow Entry No.")));
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80864; "MICA Send Last DateTime"; DateTime)
        {
            Caption = 'Send Last DateTime';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("MICA Flow Entry"."Sent Date Time" where("Entry No." = field("MICA Send Last Flow Entry No.")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80866; "MICA Send Last Info Count"; Integer)
        {
            Caption = 'Send Last Info Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Information),
                                                                "Flow Entry No." = field("MICA Send Last Flow Entry No."),
                                                                "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80867; "MICA Send Last Warning Count"; Integer)
        {
            Caption = 'Send Last Warning Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Warning),
                                                                "Flow Entry No." = field("MICA Send Last Flow Entry No."),
                                                                "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80868; "MICA Send Last Error Count"; Integer)
        {
            Caption = 'Send Last Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Error),
                                                                "Flow Entry No." = field("MICA Send Last Flow Entry No."),
                                                                "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80869; "MICA Send Ack. Received"; Boolean)
        {
            Caption = 'Send Ack. Received';
            Editable = false;
            DataClassification = CustomerContent;
        }

        //Flow Receive
        field(80870; "MICA Rcv. Last Flow Entry No."; Integer)
        {
            Caption = 'Receive Last Flow Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MICA Flow Entry";
        }
        field(80872; "MICA Receive Last Flow Status"; Option)
        {
            Caption = 'Receive Last Flow Status';
            OptionMembers = " ",Created,Received,Loaded,Processed,PostProcessed;
            OptionCaption = ' ,Created,Received,Loaded,Processed,PostProcessed';
            FieldClass = FlowField;
            CalcFormula = lookup("MICA Flow Entry"."Receive Status" where("Entry No." = field("MICA Rcv. Last Flow Entry No.")));
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80874; "MICA Receive Last DateTime"; DateTime)
        {
            Caption = 'Receive Last DateTime';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("MICA Flow Entry"."Received Date Time" where("Entry No." = field("MICA Rcv. Last Flow Entry No.")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80876; "MICA Receive Last Info Count"; Integer)
        {
            Caption = 'Receive Last Info Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Information),
                                                                "Flow Entry No." = field("MICA Rcv. Last Flow Entry No."),
                                                                "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80877; "MICA Rcv. Last Warning Count"; Integer)
        {
            Caption = 'Receive Last Warning Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Warning),
                                                                "Flow Entry No." = field("MICA Rcv. Last Flow Entry No."),
                                                                "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80878; "MICA Receive Last Error Count"; Integer)
        {
            Caption = 'Receive Last Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Error),
                                                                "Flow Entry No." = field("MICA Rcv. Last Flow Entry No."),
                                                                "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80960; "MICA Receive Flow Entry No."; Integer)
        {
            Caption = 'Receive Flow Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MICA Flow Entry";
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80961; "MICA Receive Buffer Entry No."; Integer)
        {
            Caption = 'Receive Buffer Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(81460; "MICA ASN No."; Code[35])
        {
            Caption = 'ASN No.';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(81470; "MICA ASN Line No."; Integer)
        {
            Caption = 'ASN Line No.';
            DataClassification = CustomerContent;
            Editable = false;
        }

        // ASN Integration
        field(81306; "MICA AL No."; Code[35])
        {
            Caption = 'AL No.';
            DataClassification = CustomerContent;
        }
        field(81310; "MICA AL Line No."; Text[30])
        {
            Caption = 'AL Line No.';
            DataClassification = CustomerContent;
        }

        field(81434; "MICA Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(81435; "MICA Purchase Order Line No."; Integer)
        {
            Caption = 'Purchase Order Line No.';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(81462; "MICA Container ID"; Code[50])
        {
            Caption = 'Container ID';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(81461; "MICA ETA"; Date)
        {
            Caption = 'ETA';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(81307; "MICA SRD"; Date)
        {
            Caption = 'SRD';
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

        field(81471; "MICA Country of Origin"; Code[10])
        {
            Caption = 'Country of Origin';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Country/Region";
        }
        field(82460; "MICA Shipping Agent Code"; Code[20])
        {
            Caption = 'Shipping Agent Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82461; "MICA Shipp. Agent Service Code"; Code[20])
        {
            Caption = 'Shipping Agent Service Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82462; "MICA Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Warehouse Shipment Header"."MICA Ship to Name" where("No." = field("No.")));
        }
        field(82463; "MICA Ship-to Address"; Text[100])
        {
            Caption = 'Ship-to Address';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Warehouse Shipment Header"."MICA Ship-to Address" where("No." = field("No.")));
        }
        field(82464; "MICA Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Warehouse Shipment Header"."MICA Ship to City" where("No." = field("No.")));
        }
        field(82465; "MICA 3PL Product Weight"; Decimal)
        {
            Caption = '3PL Product Weight';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82466; "MICA 3PL Line Weight"; Decimal)
        {
            Caption = '3PL Line Weight';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82467; "MICA 3PL Weight UoM"; Code[10])
        {
            Caption = '3PL Weight UoM';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82468; "MICA 3PL Product Volume"; Decimal)
        {
            Caption = '3PL Product Volume';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82469; "MICA 3PL Line Volume"; Decimal)
        {
            Caption = '3PL Line Volume';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82470; "MICA 3PL Volume UoM"; Code[10])
        {
            Caption = '3PL Volume UoM';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82471; "MICA Customer Transport"; Boolean)
        {
            Caption = 'Customer Transport';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Warehouse Shipment Header"."MICA Customer Transport" where("No." = field("No.")));
        }
        field(82472; "MICA Shipping Advice"; Option)
        {
            Caption = 'Customer Transport';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'Partial,Complete';
            OptionMembers = Partial,Complete;
            CalcFormula = lookup("Warehouse Shipment Header"."MICA Shipping Advice" where("No." = field("No.")));
        }
        field(82473; "MICA Ship-to Code"; code[10])
        {
            Caption = 'Ship-to Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Warehouse Shipment Header"."MICA Ship to code" where("No." = field("No.")));
        }

        field(80140; "MICA Transport Instruction"; Code[20])
        {
            Caption = 'Transport Instruction';
            DataClassification = CustomerContent;
            TableRelation = "MICA Transport Instructions".Code;
        }

    }

    trigger OnInsert()
    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        SalesHeader: Record "Sales Header";
    begin
        WarehouseShipmentHeader.Get(rec."No.");
        SalesHEader.Get("Source Document", "Source No.");

        WarehouseShipmentHeader."MICA Ship to City" := SalesHeader."Ship-to City";
        WarehouseShipmentHeader."MICA Ship to code" := SalesHeader."Ship-to Code";
        WarehouseShipmentHeader."MICA Ship to Name" := SalesHeader."Ship-to Name";
        WarehouseShipmentHeader."MICA Ship-to Address" := SalesHeader."Ship-to Address";
        WarehouseShipmentHeader.Modify();

        "MICA Record ID" := RecordId();
    END;

    trigger OnRename()
    begin
        "MICA Record ID" := RecordId();
    end;

    local procedure UpdateTruckInfoOnHeader(FromWarehouseShipmentLine: Record "Warehouse Shipment Line")
    var
        ToWarehouseShipmentHeader: Record "Warehouse Shipment Header";
        ToWarehouseShipmentLine: Record "Warehouse Shipment Line";
        SourceDocErrTxt: Text;
        SourceDocErr: Label 'You cannot update %1 or %2 if %3 is %4.';
    begin
        if NOT (FromWarehouseShipmentLine."Source Document" IN [FromWarehouseShipmentLine."Source Document"::"Sales Order", FromWarehouseShipmentLine."Source Document"::"Sales Return Order"]) Then begin
            SourceDocErrTxt := StrSubstNo(SourceDocErr, FieldCaption("MICA Truck Driver Info"), FieldCaption("MICA Truck License Plate"),
                                                        FieldCaption("Source Document"), FromWarehouseShipmentLine."Source Document");
            Error(SourceDocErrTxt);
        end;
        if not ToWarehouseShipmentHeader.Get(FromWarehouseShipmentLine."No.") then
            exit;
        ToWarehouseShipmentHeader."MICA Truck Driver Info" := FromWarehouseShipmentLine."MICA Truck Driver Info";
        ToWarehouseShipmentHeader."MICA Truck License Plate" := FromWarehouseShipmentLine."MICA Truck License Plate";
        ToWarehouseShipmentHeader.Modify(true);
        ToWarehouseShipmentLine.SetRange("No.", FromWarehouseShipmentLine."No.");
        ToWarehouseShipmentLine.SetFilter("Line No.", '<>%1', FromWarehouseShipmentLine."Line No.");
        ToWarehouseShipmentLine.ModifyAll("MICA Truck Driver Info", FromWarehouseShipmentLine."MICA Truck Driver Info", false);
        ToWarehouseShipmentLine.ModifyAll("MICA Truck License Plate", FromWarehouseShipmentLine."MICA Truck License Plate", false);
    end;

    local procedure UpdateDotAndCountryOnSalesLine()
    var
        SalesLine: Record "Sales Line";
    begin
        if ("Source Document" = "Source Document"::"Sales Order") and SalesLine.get(SalesLine."Document Type"::Order, "Source No.", "Source Line No.") then begin
            SalesLine."MICA 3PL Country Of Origin" := "MICA 3PL Country Of Origin";
            SalesLine."MICA 3PL DOT Value" := "MICA 3PL DOT Value";
            SalesLine.Modify(false);
        end;
    end;
}