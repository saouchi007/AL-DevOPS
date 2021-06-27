tableextension 80200 "MICA Sales Header" extends "Sales Header" //MyTargetTableId
{
    fields
    {
        field(80000; "MICA Order Type"; Option)
        {
            Caption = 'Order Type';
            DataClassification = CustomerContent;
            OptionMembers = "Standard Order","Express Order";

            trigger OnValidate()
            var
                Cust: Record Customer;
                ShippingAgentServices: Record "Shipping Agent Services";
                Location: Record Location;
                ShiptoAddr: Record "Ship-to Address";
                MICANextTruckMgt: Codeunit "MICA Next Truck Management";
                ShippingTime: DateFormula;
                ShippingAgentCode: Code[10];
                ShippingAgentServicesCode: Code[10];
            begin
                if "MICA Order Type" <> xRec."MICA Order Type" then begin
                    if not CheckThereIsNoLine() then
                        Error(CantChangeFieldCauseSalesLineErr, FieldCaption("MICA Order Type"));
                    Location.Get("Location Code");
                    Cust.Get("Sell-to Customer No.");
                    if "MICA Order Type" = "MICA Order Type"::"Express Order" then begin
                        "MICA Customer Transport" := false;
                        CanBeAnExpressOrder();
                        if ShiptoAddr.Get("Sell-to Customer No.", "Ship-to Code") then begin
                            ShippingAgentCode := ShiptoAddr."MICA Ship. Agent Exp. Order";
                            ShippingAgentServicesCode := ShiptoAddr."MICA Ship Agent Serv Exp Order";
                        end else begin
                            ShippingAgentCode := Cust."MICA Shipping Agent Exp. Order";
                            ShippingAgentServicesCode := Cust."MICA Ship Agent Serv Exp Order";
                        end;
                        if ShippingAgentServices.Get(ShippingAgentCode, ShippingAgentServicesCode) then
                            ShippingTime := ShippingAgentServices."Shipping Time"
                        else
                            ShippingTime := Cust."Shipping Time";
                        Validate("Shipping Agent Code", ShippingAgentCode);
                        Validate("Shipping Agent Service Code", ShippingAgentServicesCode);
                        Validate("Shipping Time", ShippingTime);
                        Validate("Outbound Whse. Handling Time", Location."MICA Outb Whse Hand T Exp Ord");
                    end else begin
                        if ShiptoAddr.Get("Sell-to Customer No.", "Ship-to Code") then begin
                            ShippingAgentCode := ShiptoAddr."Shipping Agent Code";
                            ShippingAgentServicesCode := ShiptoAddr."Shipping Agent Service Code";
                        end else begin
                            ShippingAgentCode := Cust."Shipping Agent Code";
                            ShippingAgentServicesCode := Cust."Shipping Agent Service Code";
                            ShippingTime := Cust."Shipping Time";
                        end;
                        if "MICA Customer Transport" then
                            GetShipPickUpFromLocation(ShippingAgentCode, ShippingAgentServicesCode);
                        if ShippingAgentServices.Get(ShippingAgentCode, ShippingAgentServicesCode) then
                            ShippingTime := ShippingAgentServices."Shipping Time"
                        else
                            ShippingTime := Cust."Shipping Time";

                        Validate("Shipping Agent Code", ShippingAgentCode);
                        Validate("Shipping Agent Service Code", ShippingAgentServicesCode);
                        Validate("Shipping Time", ShippingTime);
                        Validate("Outbound Whse. Handling Time", Location."Outbound Whse. Handling Time");
                    end;
                    if Rec."Sell-to Customer No." <> '' then
                        MICANextTruckMgt.CalculateRequestedDeliveryDateSalesHeader(Rec);
                end;
            end;
        }
        field(80300; "MICA % Of Prepayment"; Decimal)
        {
            Caption = '% Of Prepayment';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;
            Editable = false;
            DecimalPlaces = 0 : 2;
        }
        field(80301; "MICA Prepayment Amount"; Decimal)
        {
            Caption = 'Prepayment Amount';
            DataClassification = CustomerContent;
            //Editable = false;
            DecimalPlaces = 0 : 2;
        }
        field(80302; "MICA Prepaid Amount"; Decimal)
        {
            Caption = 'Prepaid Amount';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
        }

        field(81100; "MICA Customer Transport"; Boolean)
        {
            Caption = 'Customer Transport';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not CheckThereIsNoLine() then
                    Error(CantChangeFieldCauseSalesLineErr, FieldCaption("MICA Customer Transport"));
                CalculateRequestDeliveryDate();
            end;
        }

        field(81120; "MICA Return Order With Collect"; Boolean)
        {
            Caption = 'Return Order With Collect';
            DataClassification = CustomerContent;
        }

        field(81040; "MICA Shipment"; Option)
        {
            Caption = 'Shipment';
            DataClassification = CustomerContent;
            OptionMembers = "1","2","3";
        }
        field(81500; "MICA Credit Memo Reason Code"; Code[20])
        {
            Caption = 'Credit Memo Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = filter(ReasonCreditNote));
            trigger OnValidate()
            begin
                CalcFields("MICA Credit Memo Reason Desc.")
            end;
        }
        field(81510; "MICA Credit Memo Reason Desc."; Text[200])
        {
            FieldClass = FlowField;
            Caption = 'Credit Memo Reason Description';
            CalcFormula = lookup("MICA Table Value".Description where(Code = field("MICA Credit Memo Reason Code")));
        }
        field(81570; "MICA Retrieve-From Addr. Code"; Code[10])
        {
            Caption = 'Retrieve-From Address Code';
            DataClassification = CustomerContent;
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Sell-to Customer No."));
            Editable = false;
        }
        field(81571; "MICA Retrieve-From Address"; Text[50])
        {
            Caption = 'Retrieve-From Address';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81624; "MICA Truck Driver Info"; Text[50])
        {
            Caption = 'Truck Driver Info';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81625; "MICA Truck License Plate"; Text[50])
        {
            Caption = 'Truck License Plate';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81640; "MICA Sales Agreement"; Code[20])
        {
            Caption = 'Sales Agreement';
            DataClassification = CustomerContent;
            Editable = False;
        }

        field(81780; "MICA Release Status Count"; Integer)
        {
            Caption = 'Release Status Count';
            DataClassification = CustomerContent;
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }


        field(81820; "MICA Shipment Post Option"; Option)
        {
            Caption = 'Shipment Post Option';
            DataClassification = CustomerContent;
            OptionMembers = " ",Ship,"Ship and Invoice";
            OptionCaption = ' ,Ship,Ship and Invoice';
        }

        field(82140; "MICA Cust. Posting Group Alt."; Code[20])
        {
            Caption = 'Customer Posting Group Alt.';
            DataClassification = CustomerContent;
            TableRelation = "Customer Posting Group";

            trigger OnValidate()
            begin
                if CurrFieldNo = FieldNo("Customer Posting Group") then
                    exit;

                Validate("Customer Posting Group", "MICA Cust. Posting Group Alt.");

            end;
        }
        field(82500; "MICA Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82860; "MICA Last Modified Date Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82700; "MICA Exempt from 3PL Ant. Chk."; Boolean)
        {
            Caption = 'Exempt from 3PL Anticipation Check';
            DataClassification = CustomerContent;
        }
        field(82920; "MICA 3rd Party Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor;
            Editable = false;
        }
        field(83000; "MICA Created From Comb. Ship."; Boolean)
        {
            Caption = 'Created From Combine Ship';
            DataClassification = CustomerContent;
        }
        field(83500; "MICA Automatic Release Date"; Date)
        {
            Caption = 'Automatic Release Date';
            DataClassification = CustomerContent;
            Editable = false;
        }

        modify("Customer Posting Group")
        {
            trigger OnAfterValidate()
            begin
                if CurrFieldNo = FieldNo("MICA Cust. Posting Group Alt.") then
                    exit;

                Validate("MICA Cust. Posting Group Alt.", "Customer Posting Group");
            End;
        }
    }

    procedure CanBeAnExpressOrder()
    var
        SalesLine: Record "Sales Line";
        Customer: Record Customer;
        ShiptoAddress: Record "Ship-to Address";
        Item: Record Item;
    begin
        TestField("Sell-to Customer No.");
        if Customer.Get("Sell-to Customer No.") then
            Customer.TestField("MICA Express Order", true);
        if ShiptoAddress.Get("Sell-to Customer No.", "Ship-to Code") then
            ShiptoAddress.TestField("MICA Express Order", true);
        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.FindSet() then
            repeat
                Item.Get(SalesLine."No.");
                Item.TestField("MICA Express Order");
            until SalesLine.Next() = 0;
    end;

    [IntegrationEvent(true, false)]
    procedure OnCustomerOverdueExceeded()
    begin
    end;

    [IntegrationEvent(true, false)]
    procedure OnCustomerOverdueNotExceeded()
    begin
    end;

    [IntegrationEvent(true, false)]
    procedure OnPrepaymentIsNeeded()
    begin
    end;

    [IntegrationEvent(true, false)]
    procedure OnPrepaymentIsNotNeeded()
    begin
    end;

    trigger OnAfterInsert()
    begin
        Rec.Validate("MICA Last Modified Date Time", CurrentDateTime);
    end;

    trigger OnAfterModify()
    begin
        Rec.Validate("MICA Last Modified Date Time", CurrentDateTime);
    end;

    procedure CheckAvailableOverdue(): Decimal
    var
        Customer: Record Customer;
    begin
        IF ("Bill-to Customer No." = '') AND ("Sell-to Customer No." = '') THEN
            EXIT(0);

        IF NOT Customer.GET("Bill-to Customer No.") THEN
            Customer.GET("Sell-to Customer No.");
        Customer.SetRange("Date Filter", 0D, Today());
        Customer.CALCFIELDS("MICA Balance Due (Buffer)");
        IF Customer."MICA Balance Due (Buffer)" > 0 THEN
            OnCustomerOverdueExceeded()
        ELSE
            OnCustomerOverdueNotExceeded();

        EXIT(Customer."Balance Due");
    end;

    procedure CheckThereIsNoLine(): Boolean
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "No.");
        exit(SalesLine.IsEmpty());
    end;

    procedure GetTotalItemQuantity(): Decimal
    var
        SalesLine: Record "Sales Line";
        TotalQuantity: Decimal;
    begin
        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.FindSet() then
            repeat
                TotalQuantity += SalesLine.Quantity;
            until SalesLine.Next() = 0;
        exit(TotalQuantity);
    end;

    procedure GetCountOftSalesLineSplitted(): Integer
    var
        SalesLine: Record "Sales Line";
    begin
        if "No." = '' then
            exit;

        with SalesLine do begin
            SetRange("Document Type", "Document Type");
            SetRange("Document No.", "No.");
            SetRange(Type, Type::Item);
            SetRange("MICA Splitted Line", true);
            exit(Count());
        end;
    end;

    procedure CheckPrepayment()
    begin
        if ("MICA % Of Prepayment" > 0) AND ("MICA Prepayment Amount" > "MICA Prepaid Amount") then
            OnPrepaymentIsNeeded()
        else
            OnPrepaymentIsNotNeeded();
    end;

    local procedure GetShipPickUpFromLocation(var ShippingAgentCode: Code[10]; var ShippingAgentServicesCode: Code[10])
    var
        Location: Record Location;
    begin
        if not Location.Get("Location Code") then
            exit;
        if Location."MICA Pick-Up Shipping Agent" <> '' then
            ShippingAgentCode := Location."MICA Pick-Up Shipping Agent";
        if Location."MICA PickUp Ship Agent Service" <> '' then
            ShippingAgentServicesCode := Location."MICA PickUp Ship Agent Service";
    end;

    local procedure CalculateRequestDeliveryDate()
    var
        Customer: Record Customer;
        ShippingAgentServices: Record "Shipping Agent Services";
        Location: Record Location;
        ShiptoAddress: Record "Ship-to Address";
        MICANextTruckManagement: Codeunit "MICA Next Truck Management";
        ShippingTime: DateFormula;
        ShippingAgentCode: Code[10];
        ShippingAgentServicesCode: Code[10];
    begin
        Location.Get("Location Code");
        Customer.Get("Sell-to Customer No.");
        if ShiptoAddress.Get("Sell-to Customer No.", "Ship-to Code") then begin
            ShippingAgentCode := ShiptoAddress."Shipping Agent Code";
            ShippingAgentServicesCode := ShiptoAddress."Shipping Agent Service Code";
        end else begin
            ShippingAgentCode := Customer."Shipping Agent Code";
            ShippingAgentServicesCode := Customer."Shipping Agent Service Code";
            ShippingTime := Customer."Shipping Time";
        end;
        if "MICA Customer Transport" then
            GetShipPickUpFromLocation(ShippingAgentCode, ShippingAgentServicesCode);
        if ShippingAgentServices.Get(ShippingAgentCode, ShippingAgentServicesCode) then
            ShippingTime := ShippingAgentServices."Shipping Time"
        else
            ShippingTime := Customer."Shipping Time";

        Validate("Shipping Agent Code", ShippingAgentCode);
        Validate("Shipping Agent Service Code", ShippingAgentServicesCode);
        Validate("Shipping Time", ShippingTime);
        Validate("Outbound Whse. Handling Time", Location."Outbound Whse. Handling Time");
        MICANextTruckManagement.CalculateRequestedDeliveryDateSalesHeader(Rec);
    end;

    procedure CommitAll(FromAPI: Boolean)
    var
        SalesLine: Record "Sales Line";
        TempSalesLine: Record "Sales Line" temporary;
        MICACommitSplitLineSetup: Record "MICA Commit/Split Line Setup";
        MICASplitLineManagement: Codeunit "MICA Split Line Management";
    begin
        Rec.TestField(Status, Status::Open);
        MICACommitSplitLineSetup.GET();
        IF MICACommitSplitLineSetup."Back Order Default Ship. Date" = 0D THEN
            MICACommitSplitLineSetup."Back Order Default Ship. Date" := 20991231D;
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("No.", '<>%1', '');
        SalesLine.SetFilter(Quantity, '>%1', 0);
        SalesLine.SetRange("Quantity Shipped", 0);
        if SalesLine.FindSet() then
            repeat
                TempSalesLine.TransferFields(SalesLine);
                TempSalesLine.Insert();
            until SalesLine.Next() = 0;
        Clear(TempSalesLine);
        TempSalesLine.Reset();
        if TempSalesLine.FindSet() then
            repeat
                if SalesLine.Get(TempSalesLine."Document Type", TempSalesLine."Document No.", TempSalesLine."Line No.") then
                    if not (SalesLine."MICA Splitted Line") or (SalesLine."MICA Splitted Line" and (SalesLine."Shipment Date" = MICACommitSplitLineSetup."Back Order Default Ship. Date")) then
                        MICASplitLineManagement.SplitLine(SalesLine, false, false, FromAPI);
            until TempSalesLine.Next() = 0;
    end;

    procedure AutofillQtyToHandle()
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document No.", "No.");
        SalesLine.SetRange("Document Type", "Document Type");
        if Salesline.FindSet(true) then
            repeat
                SalesLine.Validate("Qty. to Ship", SalesLine."Quantity (Base)" - SalesLine."Quantity Shipped");
                SalesLine.Modify(true);
            until SalesLine.Next() = 0
    end;

    var
        CantChangeFieldCauseSalesLineErr: Label 'It is not possible to change %1 if sales order lines exist', Comment = '%1 = Field caption';

}