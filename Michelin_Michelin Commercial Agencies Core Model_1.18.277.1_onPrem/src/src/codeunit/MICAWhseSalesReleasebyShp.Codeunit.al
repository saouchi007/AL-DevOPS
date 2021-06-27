codeunit 81621 "MICA Whse.-Sales Release byShp"
{
    //3PL-009: Whse. Shipment BSC to 3PL
    // Based on standard codeunit "Whse.-Sales Release"

    trigger OnRun()
    begin
    end;

    var
        WhseRqst: Record "MICA Warehouse Request by Ship";
        SalesLine: Record "Sales Line";


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure T36OnBeforeDelete(VAR Rec: Record "Sales Header"; RunTrigger: Boolean)
    var
        WhseRequest: Record "MICA Warehouse Request by Ship";
        MICAAPISalesLine: Record "MICA API Sales Line";
    begin
        if not RunTrigger then
            exit;

        WhseRequest.SETRANGE("Source Type", DATABASE::"Sales Line");
        WhseRequest.SETRANGE("Source Subtype", Rec."Document Type");
        WhseRequest.SETRANGE("Source No.", Rec."No.");
        IF NOT WhseRequest.ISEMPTY() THEN
            WhseRequest.DELETEALL(TRUE);

        MICAAPISalesLine.SetRange("Document Type", Rec."Document Type");
        MICAAPISalesLine.SetRange("Document No.", Rec."No.");
        MICAAPISalesLine.DeleteAll(false);
    end;


    procedure CreateAllWhseRqst(var SalesHeader: Record "Sales Header")
    var
        WhseType: Option Inbound,Outbound;
        OldWhseType: Option Inbound,Outbound;
        OldLocationCode: Code[10];
        First: Boolean;
        OldShipmentDate: Date;
    begin
        OldLocationCode := '';
        OldShipmentDate := 0D;
        WITH SalesHeader DO BEGIN
            if ("Document Type" <> "Document Type"::Order) and ("Document Type" <> "Document Type"::"Return Order") then
                exit;

            SalesLine.SETCURRENTKEY("Document Type", "Document No.", "Location Code", "Shipment Date"); //real key dosn't exist
            SalesLine.SETRANGE("Document Type", "Document Type");
            SalesLine.SETRANGE("Document No.", "No.");
            SalesLine.SETRANGE(Type, SalesLine.Type::Item);
            SalesLine.SETRANGE("Drop Shipment", FALSE);
            SalesLine.SETRANGE("Job No.", '');
            IF SalesLine.FINDSET() THEN BEGIN
                First := TRUE;
                REPEAT
                    IF (("Document Type" = "Document Type"::Order) AND (SalesLine.Quantity >= 0)) OR
                       (("Document Type" = "Document Type"::"Return Order") AND (SalesLine.Quantity < 0))
                    THEN
                        WhseType := WhseType::Outbound
                    ELSE
                        WhseType := WhseType::Inbound;

                    IF First OR (SalesLine."Location Code" <> OldLocationCode) OR (WhseType <> OldWhseType) OR
                                (SalesLine."Shipment Date" <> OldShipmentDate) THEN
                        CreateWhseRqst(SalesHeader, SalesLine, WhseType);

                    First := FALSE;
                    OldLocationCode := SalesLine."Location Code";
                    OldWhseType := WhseType;
                    OldShipmentDate := SalesLine."Shipment Date";
                UNTIL SalesLine.NEXT() = 0;
            END;

            WhseRqst.RESET();
            WhseRqst.SETCURRENTKEY("Source Type", "Source Subtype", "Source No.");
            WhseRqst.SETRANGE(Type, WhseRqst.Type);
            WhseRqst.SETRANGE("Source Type", DATABASE::"Sales Line");
            WhseRqst.SETRANGE("Source Subtype", "Document Type");
            WhseRqst.SETRANGE("Source No.", "No.");
            WhseRqst.SETRANGE("Document Status", Status::Open);
            IF NOT WhseRqst.ISEMPTY() THEN
                WhseRqst.DELETEALL(TRUE);

            WhseRqst.SetRange("Document Status");
            if WhseRqst.FindSet() then
                repeat
                    SalesLine.SetRange("Shipment Date", WhseRqst."Shipment Date");
                    if not SalesLine.FindFirst() then
                        WhseRqst.Delete(true);
                until WhseRqst.Next() = 0;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Sales Release", 'OnAfterRelease', '', false, false)]
    local procedure C5771OnAfterRelease(var SalesHeader: Record "Sales Header")
    begin
        CreateAllWhseRqst(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 5771, 'OnAfterReopen', '', false, false)]
    local procedure C5771OnAfterReopen(var SalesHeader: Record "Sales Header")
    begin
        WITH SalesHeader DO BEGIN
            CASE "Document Type" OF
                "Document Type"::Order:
                    WhseRqst.Type := WhseRqst.Type::Outbound;
                "Document Type"::"Return Order":
                    WhseRqst.Type := WhseRqst.Type::Inbound;
            END;

            WhseRqst.RESET();
            WhseRqst.SETCURRENTKEY("Source Type", "Source Subtype", "Source No.");
            WhseRqst.SETRANGE(Type, WhseRqst.Type);
            WhseRqst.SETRANGE("Source Type", DATABASE::"Sales Line");
            WhseRqst.SETRANGE("Source Subtype", "Document Type");
            WhseRqst.SETRANGE("Source No.", "No.");
            WhseRqst.SETRANGE("Document Status", Status::Released);
            WhseRqst.LOCKTABLE();
            IF NOT WhseRqst.ISEMPTY() THEN
                WhseRqst.MODIFYALL("Document Status", WhseRqst."Document Status"::Open);
        END;
    end;

    local procedure CreateWhseRqst(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; WhseType: Option Inbound,Outbound)
    var
        SalesLine2: Record "Sales Line";
        Location: Record Location;
        MICAWhseRqstbyShip: Record "MICA Warehouse Request by Ship";
        ShipDateFind: Date;
    begin
        Location.GET(SalesLine."Location Code");
        //IF SalesLine."Shipment Date" > CalcDate(Location."MICA 3PL Anticipation Period", WorkDate()) THEN
        //    EXIT;

        IF ((WhseType = WhseType::Outbound) AND
            (Location.RequireShipment(SalesLine."Location Code") OR
             Location.RequirePicking(SalesLine."Location Code"))) OR
           ((WhseType = WhseType::Inbound) AND
            (Location.RequireReceive(SalesLine."Location Code") OR
             Location.RequirePutaway(SalesLine."Location Code")))

        THEN BEGIN
            SalesLine2.COPY(SalesLine);
            SalesLine2.SETRANGE("Location Code", SalesLine."Location Code");
            SalesLine2.SETRANGE("Unit of Measure Code", '');
            IF SalesLine2.FINDFIRST() THEN
                SalesLine2.TESTFIELD("Unit of Measure Code");

            if not (WhseType = WhseType::Inbound) then
                ShipDateFind := SalesLine."Shipment Date";
            if not WhseRqst.Get(WhseType, SalesLine."Location Code", DATABASE::"Sales Line", SalesHeader."Document Type".AsInteger(), SalesHeader."No.", ShipDateFind) then begin
                WhseRqst.Init();
                WhseRqst.Type := WhseType;
                WhseRqst."Location Code" := SalesLine."Location Code";
                WhseRqst."Source Type" := DATABASE::"Sales Line";
                WhseRqst."Source Subtype" := SalesHeader."Document Type".AsInteger();
                WhseRqst."Source No." := SalesHeader."No.";
                WhseRqst."Shipment Method Code" := SalesHeader."Shipment Method Code";
                WhseRqst."Shipping Advice" := SalesHeader."Shipping Advice".AsInteger();
                WhseRqst."Document Status" := SalesHeader.Status::Released.AsInteger();
                WhseRqst."Destination Type" := WhseRqst."Destination Type"::Customer;
                WhseRqst."Destination No." := SalesHeader."Sell-to Customer No.";
                WhseRqst."External Document No." := SalesHeader."External Document No.";
                UpdateFields(SalesHeader, SalesLine, WhseType);
                WhseRqst.Insert();
            end else begin
                UpdateFields(SalesHeader, SalesLine, WhseType);
                WhseRqst.MODIFY();
            end;
        END;
    end;

    local procedure UpdateFields(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; WhseType: Option Inbound,Outbound)
    begin
        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Order:
                WhseRqst."Source Document" := WhseRqst."Source Document"::"Sales Order";
            SalesHeader."Document Type"::"Return Order":
                WhseRqst."Source Document" := WhseRqst."Source Document"::"Sales Return Order";
        end;
        WhseRqst."Shipping Agent Code" := SalesLine."Shipping Agent Code";
        IF WhseType = WhseType::Inbound THEN
            WhseRqst."Expected Receipt Date" := SalesLine."Shipment Date"
        ELSE
            WhseRqst."Shipment Date" := SalesLine."Shipment Date";

        WhseRqst."Completely Handled" := IsCompletelyShipped(SalesLine);
    end;

    local procedure IsCompletelyShipped(SalesLine: Record "Sales Line"): Boolean
    var
        CompletelyShipped: Boolean;
    begin
        //  Min("Sales Line"."Completely Shipped" WHERE
        //     (Document Type=FIELD(Document Type),Document No.=FIELD(No.),Type=FILTER(<>' '),Location Code=FIELD(Location Filter)))
        SalesLine.SETRANGE("Document No.", SalesLine."Document No.");
        SalesLine.SETRANGE("Document Type", SalesLine."Document Type");
        SalesLine.SETFILTER(Type, '<>''''');
        SalesLine.SETRANGE("Location Code", SalesLine."Location Code");
        SalesLine.SETRANGE("Shipment Date", SalesLine."Shipment Date");
        IF SalesLine.FINDSET(FALSE) THEN BEGIN
            CompletelyShipped := TRUE;
            REPEAT
                IF NOT SalesLine."Completely Shipped" THEN
                    CompletelyShipped := FALSE;
            UNTIL SalesLine.NEXT() = 0;
        END ELSE
            CompletelyShipped := FALSE;
        EXIT(CompletelyShipped);
    end;

}