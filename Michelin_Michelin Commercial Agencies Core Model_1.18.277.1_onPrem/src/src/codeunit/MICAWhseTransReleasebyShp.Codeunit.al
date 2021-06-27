codeunit 81623 "MICA Whse.-Trans.Release byShp"
{
    //3PL-009: Whse. Shipment BSC to 3PL
    // Based on standard codeunit "Whse.-Transfer Release"

    var
        Location: Record Location;
        WhseManagement: Codeunit "Whse. Management";

    [EventSubscriber(ObjectType::Table, 5740, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure T5740OnBeforeDelete(VAR Rec: Record "Transfer Header"; RunTrigger: Boolean)
    var
        MICAWarehouseRequestbyShip: Record "MICA Warehouse Request by Ship";
    begin
        if not RunTrigger then
            exit;

        Rec.TESTFIELD(Status, Rec.Status::Open);
        MICAWarehouseRequestbyShip.SETRANGE("Source Type", DATABASE::"Transfer Line");
        MICAWarehouseRequestbyShip.SETRANGE("Source No.", Rec."No.");
        IF NOT MICAWarehouseRequestbyShip.ISEMPTY() THEN
            MICAWarehouseRequestbyShip.DELETEALL(TRUE);
    end;

    [EventSubscriber(ObjectType::Codeunit, 5773, 'OnAfterRelease', '', false, false)]
    local procedure C5773OnAfterRelease(var TransferHeader: Record "Transfer Header")
    var
        MICAWarehouseRequestbyShip: Record "MICA Warehouse Request by Ship";
        TransferLine: Record "Transfer Line";
        First: Boolean;
        OldShipmentDate: Date;
    begin
        OldShipmentDate := 0D;
        WITH TransferHeader DO BEGIN
            InitializeWhseRequest(MICAWarehouseRequestbyShip, TransferHeader, Status::Released);

            //IF Location.RequireReceive("Transfer-to Code") OR Location.RequirePutaway("Transfer-to Code") THEN
            //    CreateInboundWhseRequest(WhseRqst, TransferHeader);

            IF Location.RequireShipment("Transfer-from Code") OR Location.RequirePicking("Transfer-from Code") THEN begin
                TransferLine.SETCURRENTKEY("Document No.", "Shipment Date"); //real key dosn't exist
                IF TransferLine.FINDSET() THEN BEGIN
                    First := TRUE;
                    REPEAT
                        IF First OR (TransferLine."Shipment Date" <> OldShipmentDate) THEN
                            CreateOutboundWhseRequest(MICAWarehouseRequestbyShip, TransferHeader, TransferLine);
                        First := FALSE;
                        OldShipmentDate := TransferLine."Shipment Date";
                    UNTIL TransferLine.NEXT() = 0;
                end;

                DeleteOpenWhseRequest("No.");
            END;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 5773, 'OnAfterReopen', '', false, false)]
    local procedure C5773OnAfterReopen(var TransferHeader: Record "Transfer Header")
    var
        MICAWarehouseRequestbyShip: Record "MICA Warehouse Request by Ship";
        TransferLine: Record "Transfer Line";
    begin
        TransferLine.SetRange("Document No.", TransferHeader."No.");
        if TransferLine.FindSet() then
            repeat
                IF MICAWarehouseRequestbyShip.GET(MICAWarehouseRequestbyShip.Type::Inbound, TransferHeader."Transfer-to Code", DATABASE::"Transfer Line", 1, TransferHeader."No.", TransferLine."Shipment Date") THEN
                    if MICAWarehouseRequestbyShip."Document Status" <> TransferHeader.Status::Open then begin
                        MICAWarehouseRequestbyShip."Document Status" := TransferHeader.Status::Open;
                        MICAWarehouseRequestbyShip.MODIFY();
                    end;

                IF MICAWarehouseRequestbyShip.GET(MICAWarehouseRequestbyShip.Type::Outbound, TransferHeader."Transfer-from Code", DATABASE::"Transfer Line", 0, TransferHeader."No.", TransferLine."Shipment Date") THEN
                    if MICAWarehouseRequestbyShip."Document Status" <> TransferHeader.Status::Open then begin
                        MICAWarehouseRequestbyShip."Document Status" := TransferHeader.Status::Open;
                        MICAWarehouseRequestbyShip.MODIFY();
                    end;
            until TransferLine.Next() = 0;
    end;

    procedure InitializeWhseRequest(VAR MICAWarehouseRequestbyShip: Record "MICA Warehouse Request by Ship"; TransferHeader: Record "Transfer Header"; DocumentStatus: Option)
    begin
        MICAWarehouseRequestbyShip."Source Type" := DATABASE::"Transfer Line";
        MICAWarehouseRequestbyShip."Source No." := TransferHeader."No.";
        MICAWarehouseRequestbyShip."Document Status" := DocumentStatus;
        MICAWarehouseRequestbyShip."Destination Type" := MICAWarehouseRequestbyShip."Destination Type"::Location;
        MICAWarehouseRequestbyShip."External Document No." := TransferHeader."External Document No.";
    end;

    // procedure CreateInboundWhseRequest(VAR WarehouseRequest: Record "MICA Warehouse Request by Ship"; TransferHeader: Record "Transfer Header")
    // begin

    //     WITH WarehouseRequest DO BEGIN
    //         CheckUnitOfMeasureCode(TransferHeader."No.");
    //         TransferHeader.SETRANGE("Location Filter", TransferHeader."Transfer-to Code");
    //         TransferHeader.CALCFIELDS("Completely Received");

    //         Type := Type::Inbound;
    //         "Source Subtype" := 1;
    //         "Source Document" := WhseMgt.GetSourceDocument("Source Type", "Source Subtype");
    //         "Expected Receipt Date" := TransferHeader."Receipt Date";
    //         "Location Code" := TransferHeader."Transfer-to Code";
    //         "Completely Handled" := TransferHeader."Completely Received";
    //         "Shipment Method Code" := TransferHeader."Shipment Method Code";
    //         "Shipping Agent Code" := TransferHeader."Shipping Agent Code";
    //         "Destination No." := TransferHeader."Transfer-to Code";
    //         IF MODIFY() THEN;
    //     END;
    // end;

    procedure CreateOutboundWhseRequest(VAR MICAWarehouseRequestbyShip: Record "MICA Warehouse Request by Ship"; TransferHeader: Record "Transfer Header"; TransferLine: Record "Transfer Line")
    begin
        WITH MICAWarehouseRequestbyShip DO BEGIN
            Location.GET(TransferHeader."Transfer-from Code");
            //IF TransLine."Shipment Date" > CalcDate(Location."MICA 3PL Anticipation Period", WorkDate()) THEN
            //    EXIT;

            CheckUnitOfMeasureCode(TransferHeader."No.");
            TransferHeader.SETRANGE("Location Filter", TransferHeader."Transfer-from Code");

            Type := Type::Outbound;
            "Source Subtype" := 0;
            "Source Document" := WhseManagement.GetSourceDocument("Source Type", "Source Subtype");
            "Location Code" := TransferHeader."Transfer-from Code";
            "Shipment Method Code" := TransferHeader."Shipment Method Code";
            "Shipping Agent Code" := TransferHeader."Shipping Agent Code";
            "Shipping Advice" := TransferHeader."Shipping Advice".AsInteger();
            "Shipment Date" := TransferLine."Shipment Date";
            "Destination No." := TransferHeader."Transfer-from Code";
            "Completely Handled" := IsCompletelyShipped(TransferLine);
            IF NOT INSERT() THEN
                MODIFY();
        END;
    end;

    LOCAL procedure DeleteOpenWhseRequest(TransferOrderNo: Code[20])
    var
        MICAWarehouseRequestbyShip: Record "MICA Warehouse Request by Ship";
    begin
        MICAWarehouseRequestbyShip.SETCURRENTKEY("Source Type", "Source No.");
        MICAWarehouseRequestbyShip.SETRANGE("Source Type", DATABASE::"Transfer Line");
        MICAWarehouseRequestbyShip.SETRANGE("Source No.", TransferOrderNo);
        MICAWarehouseRequestbyShip.SETRANGE("Document Status", MICAWarehouseRequestbyShip."Document Status"::Open);
        IF NOT MICAWarehouseRequestbyShip.ISEMPTY() THEN
            MICAWarehouseRequestbyShip.DELETEALL(TRUE);
    end;

    LOCAL procedure CheckUnitOfMeasureCode(DocumentNo: Code[20])
    var
        TransferLine: Record "Transfer Line";
    begin
        TransferLine.SETRANGE("Document No.", DocumentNo);
        TransferLine.SETRANGE("Unit of Measure Code", '');
        TransferLine.SETFILTER("Item No.", '<>%1', '');
        IF TransferLine.FINDFIRST() THEN
            TransferLine.TESTFIELD("Unit of Measure Code");
    end;


    local procedure IsCompletelyShipped(TransferLine: Record "Transfer Line"): Boolean
    var
        CompletelyShipped: Boolean;
    begin
        //Min("Transfer Line"."Completely Shipped" WHERE (Document No.=FIELD(No.),Shipment Date=FIELD(Date Filter),Transfer-from Code=FIELD(Location Filter),
        //                                                Derived From Line No.=CONST(0)))

        TransferLine.SETRANGE("Document No.", TransferLine."Document No.");
        TransferLine.SETRANGE("Derived From Line No.", 0);
        TransferLine.SETRANGE("Shipment Date", TransferLine."Shipment Date");
        IF TransferLine.FINDSET(FALSE) THEN BEGIN
            CompletelyShipped := TRUE;
            REPEAT
                IF NOT TransferLine."Completely Shipped" THEN
                    CompletelyShipped := FALSE;
            UNTIL TransferLine.NEXT() = 0;
        END ELSE
            CompletelyShipped := FALSE;
        EXIT(CompletelyShipped);
    end;


}