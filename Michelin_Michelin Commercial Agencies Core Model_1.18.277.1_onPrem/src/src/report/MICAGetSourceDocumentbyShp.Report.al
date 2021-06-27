report 81620 "MICA Get Source Document byShp"
{
    //3PL-009: Whse. Shipment BSC to 3PL
    // Based on standard report "Get Source Document"

    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Get Source Documents by Shipment Date';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Warehouse Request by Ship"; "MICA Warehouse Request by Ship")
        {
            DataItemTableView = WHERE("Document Status" = CONST(Released),
                                      "Completely Handled" = FILTER(false));
            RequestFilterFields = "Source Document", "Source No.";
            dataitem("Sales Header"; "Sales Header")
            {
                DataItemLinkReference = "Warehouse Request by Ship";
                DataItemLink = "Document Type" = FIELD("Source Subtype"),
                               "No." = FIELD("Source No.");
                DataItemTableView = SORTING("Document Type", "No.");
                dataitem("Sales Line"; "Sales Line")
                {
                    DataItemLinkReference = "Sales Header";
                    DataItemLink = "Document Type" = FIELD("Document Type"),
                                   "Document No." = FIELD("No.");
                    DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");

                    trigger OnAfterGetRecord()
                    var
                        Loc: Record Location;
                    begin
                        if "Sales Line"."MICA Status" <> "Sales Line"."MICA Status"::"Reserve OnHand" then
                            CurrReport.Skip();
                        if not "Sales Header"."MICA Exempt from 3PL Ant. Chk." then
                            if Loc.Get("Sales Line"."Location Code") then
                                if format(Loc."MICA 3PL Anticipation Period") <> '' then
                                    if "Sales Line"."Shipment Date" > CalcDate(Loc."MICA 3PL Anticipation Period", WorkDate()) then
                                        CurrReport.Skip();


                        VerifyItemNotBlocked("No.");
                        IF ("Location Code" = "Warehouse Request by Ship"."Location Code") AND
                           ("Sales Line"."Shipment Date" = "Warehouse Request by Ship"."Shipment Date") THEN
                            CASE RequestType OF
                                RequestType::Receive:
                                    IF ActWhseCreateSourceDocument.CheckIfSalesLine2ReceiptLine("Sales Line") THEN BEGIN
                                        IF NOT OneHeaderCreated AND NOT WhseHeaderCreated THEN
                                            CreateReceiptHeader();
                                        IF NOT ActWhseCreateSourceDocument.SalesLine2ReceiptLine(WarehouseReceiptHeader, "Sales Line") THEN
                                            ErrorOccured := TRUE;
                                        LineCreated := TRUE;
                                    END;
                                RequestType::Ship:
                                    IF ActWhseCreateSourceDocument.CheckIfFromSalesLine2ShptLine("Sales Line") THEN BEGIN
                                        IF Customer.Blocked <> Customer.Blocked::" " THEN BEGIN
                                            IF NOT SalesHeaderCounted THEN BEGIN
                                                SkippedSourceDoc += 1;
                                                SalesHeaderCounted := TRUE;
                                            END;
                                            CurrReport.SKIP();
                                        END;

                                        IF NOT OneHeaderCreated AND NOT WhseHeaderCreated THEN
                                            CreateShptHeader();
                                        IF NOT ActWhseCreateSourceDocument.FromSalesLine2ShptLine(WarehouseShipmentHeader, "Sales Line") THEN
                                            ErrorOccured := TRUE;
                                        LineCreated := TRUE;
                                    END;
                            END;
                    end;

                    trigger OnPostDataItem()
                    begin
                        IF WhseHeaderCreated THEN BEGIN
                            UpdateReceiptHeaderStatus();
                            CheckFillQtyToHandle();
                        END;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SETRANGE(Type, Type::Item);
                        IF (("Warehouse Request by Ship".Type = "Warehouse Request by Ship".Type::Outbound) AND
                            ("Warehouse Request by Ship"."Source Document" = "Warehouse Request by Ship"."Source Document"::"Sales Order")) OR
                           (("Warehouse Request by Ship".Type = "Warehouse Request by Ship".Type::Inbound) AND
                            ("Warehouse Request by Ship"."Source Document" = "Warehouse Request by Ship"."Source Document"::"Sales Return Order"))
                        THEN
                            SETFILTER("Outstanding Quantity", '>0')
                        ELSE
                            SETFILTER("Outstanding Quantity", '<0');
                        SETRANGE("Drop Shipment", FALSE);
                        SETRANGE("Job No.", '');
                    end;
                } //salesLine

                trigger OnAfterGetRecord()
                var
                    SalesLn: Record "Sales Line";
                    Loc: Record Location;
                    OneLineOk: Boolean;
                begin
                    if "Sales Header"."Shipping Advice" = "Sales Header"."Shipping Advice"::Complete then begin
                        SalesLn.SetRange("Document Type", "Sales Header"."Document Type");
                        SalesLn.SetRange("Document No.", "Sales Header"."No.");
                        SalesLn.SetFilter("MICA Status", '<>%1&<>%2&<>%3', SalesLn."MICA Status"::"Reserve OnHand", SalesLn."MICA Status"::"Send to Execution", SalesLn."MICA Status"::Closed);
                        if not SalesLn.IsEmpty() then
                            CurrReport.Skip();
                    end;

                    SalesLn.SetRange("Document Type", "Sales Header"."Document Type");
                    SalesLn.SetRange("Document No.", "Sales Header"."No.");
                    SalesLn.SetRange("MICA Status", SalesLn."MICA Status"::"Reserve OnHand");
                    if not SalesLn.FindSet() then
                        CurrReport.Skip()
                    else
                        repeat
                            if Loc.Get(SalesLn."Location Code") then
                                if format(Loc."MICA 3PL Anticipation Period") <> '' then begin
                                    if SalesLn."Shipment Date" <= CalcDate(Loc."MICA 3PL Anticipation Period", WorkDate()) then
                                        OneLineOk := true
                                    else
                                        if "Sales Header"."Shipping Advice" = "Sales Header"."Shipping Advice"::Complete then
                                            CurrReport.Skip();
                                end else
                                    OneLineOk := true;
                        until SalesLn.Next() = 0;
                    if not "Sales Header"."MICA Exempt from 3PL Ant. Chk." then
                        if not OneLineOk then
                            CurrReport.Skip();

                    TESTFIELD("Sell-to Customer No.");
                    Customer.GET("Sell-to Customer No.");
                    IF NOT SkipBlockedCustomer THEN
                        Customer.CheckBlockedCustOnDocs(Customer, "Document Type", FALSE, FALSE);
                    SalesHeaderCounted := FALSE;
                end;

                trigger OnPreDataItem()
                begin
                    IF "Warehouse Request by Ship"."Source Type" <> DATABASE::"Sales Line" THEN
                        CurrReport.BREAK();
                end;
            } //salesHeader

            dataitem("Transfer Header"; "Transfer Header")
            {
                DataItemLinkReference = "Warehouse Request by Ship";
                DataItemLink = "No." = FIELD("Source No.");
                DataItemTableView = SORTING("No.");
                dataitem("Transfer Line"; "Transfer Line")
                {
                    DataItemLinkReference = "Transfer Header";
                    DataItemLink = "Document No." = FIELD("No.");
                    DataItemTableView = SORTING("Document No.", "Line No.");

                    trigger OnAfterGetRecord()
                    begin
                        IF "Transfer Line"."Shipment Date" = "Warehouse Request by Ship"."Shipment Date" THEN
                            CASE RequestType OF
                                RequestType::Receive:
                                    IF ActWhseCreateSourceDocument.CheckIfTransLine2ReceiptLine("Transfer Line") THEN BEGIN
                                        IF NOT OneHeaderCreated AND NOT WhseHeaderCreated THEN
                                            CreateReceiptHeader();
                                        IF NOT ActWhseCreateSourceDocument.TransLine2ReceiptLine(WarehouseReceiptHeader, "Transfer Line") THEN
                                            ErrorOccured := TRUE;
                                        LineCreated := TRUE;
                                    END;
                                RequestType::Ship:
                                    IF ActWhseCreateSourceDocument.CheckIfFromTransLine2ShptLine("Transfer Line") THEN BEGIN
                                        IF NOT OneHeaderCreated AND NOT WhseHeaderCreated THEN
                                            CreateShptHeader();
                                        IF NOT ActWhseCreateSourceDocument.FromTransLine2ShptLine(WarehouseShipmentHeader, "Transfer Line") THEN
                                            ErrorOccured := TRUE;
                                        LineCreated := TRUE;
                                    END;
                            END;
                    end;

                    trigger OnPostDataItem()
                    begin
                        IF WhseHeaderCreated THEN BEGIN
                            UpdateReceiptHeaderStatus();
                            CheckFillQtyToHandle();
                        END;
                    end;

                    trigger OnPreDataItem()
                    begin
                        CASE "Warehouse Request by Ship"."Source Subtype" OF
                            0:
                                SETFILTER("Outstanding Quantity", '>0');
                            1:
                                SETFILTER("Qty. in Transit", '>0');
                        END;
                    end;
                } //TransferLine

                trigger OnAfterGetRecord()
                var
                    TransferLine: Record "Transfer Line";
                    Loc: Record Location;
                    OneLineOk: Boolean;
                begin
                    TransferLine.SetRange("Document No.");
                    TransferLine.SetRange("Derived From Line No.", 0);
                    if not TransferLine.FindSet() then
                        CurrReport.Skip()
                    else
                        repeat
                            if Loc.Get("Transfer Header"."Transfer-to Code") then
                                if format(Loc."MICA 3PL Anticipation Period") <> '' then
                                    if TransferLine."Shipment Date" <= CalcDate(Loc."MICA 3PL Anticipation Period", WorkDate()) then
                                        OneLineOk := true
                                    else
                                        if "Sales Header"."Shipping Advice" = "Sales Header"."Shipping Advice"::Complete then
                                            CurrReport.Skip();
                        until TransferLine.Next() = 0;
                    if not OneLineOk then
                        CurrReport.Skip();
                end;

                trigger OnPreDataItem()
                begin
                    IF "Warehouse Request by Ship"."Source Type" <> DATABASE::"Transfer Line" THEN
                        CurrReport.BREAK();
                end;
            } //<<TransferHeader

            //>>Warehouse request
            trigger OnAfterGetRecord()
            var
                WhseSetup: Record "Warehouse Setup";
            begin
                WhseHeaderCreated := FALSE;
                CASE Type OF
                    Type::Inbound:
                        BEGIN
                            IF NOT Location.RequireReceive("Location Code") THEN BEGIN
                                IF "Location Code" = '' THEN
                                    WhseSetup.TESTFIELD("Require Receive");
                                Location.GET("Location Code");
                                Location.TESTFIELD("Require Receive");
                            END;
                            IF NOT OneHeaderCreated THEN
                                RequestType := RequestType::Receive;
                        END;
                    Type::Outbound:
                        BEGIN
                            IF NOT Location.RequireShipment("Location Code") THEN BEGIN
                                IF "Location Code" = '' THEN
                                    WhseSetup.TESTFIELD("Require Shipment");
                                Location.GET("Location Code");
                                Location.TESTFIELD("Require Shipment");
                            END;
                            IF NOT OneHeaderCreated THEN
                                RequestType := RequestType::Ship;
                        END;
                END;
            end;

            trigger OnPostDataItem()
            var
                Loc: Record Location;
                ShipLine: Record "Warehouse Shipment Line";
                ReleaseWhseShptDoc: Codeunit "Whse.-Shipment Release";
            begin
                IF WhseHeaderCreated OR OneHeaderCreated THEN BEGIN
                    WarehouseShipmentHeader.SortWhseDoc();
                    WarehouseReceiptHeader.SortWhseDoc();
                END;

                WarehouseShipmentHeader.MarkedOnly(true);
                if WarehouseShipmentHeader.FindSet() then
                    repeat
                        Loc.Get(WarehouseShipmentHeader."Location Code");
                        if Loc."MICA 3PL Location Code" <> '' then begin
                            ShipLine.SetRange("No.", WarehouseShipmentHeader."No.");
                            if ShipLine.FindSet(true) then
                                repeat
                                    ShipLine.Validate("Qty. to Ship", 0);
                                    ShipLine.Modify();
                                until ShipLine.Next() = 0;

                            ReleaseWhseShptDoc.Release(WarehouseShipmentHeader);
                        end;
                    until WarehouseShipmentHeader.Next() = 0;
            end;

            trigger OnPreDataItem()
            begin
                IF OneHeaderCreated THEN BEGIN
                    CASE RequestType OF
                        RequestType::Receive:
                            Type := Type::Inbound;
                        RequestType::Ship:
                            Type := Type::Outbound;
                    END;
                    SETRANGE(Type, Type);
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(DoNotFillQtytoHandle; DoNotFillQtytoHandleValue)
                    {
                        ApplicationArea = Warehouse;
                        Caption = 'Do Not Fill Qty. to Handle';
                        ToolTip = 'Specifies if the Quantity to Handle field in the warehouse document is prefilled according to the source document quantities.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        IF NOT HideDialog THEN
            CASE RequestType OF
                RequestType::Receive:
                    ShowReceiptDialog();
                RequestType::Ship:
                    ShowShipmentDialog();
            END;
        IF SkippedSourceDoc > 0 THEN
            MESSAGE(CustomerIsBlockedMsg, SkippedSourceDoc);
        Completed := TRUE;
    end;

    trigger OnPreReport()
    begin
        ActivitiesCreated := 0;
        LineCreated := FALSE;
    end;

    var
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        WarehouseReceiptLine: Record "Warehouse Receipt Line";
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        Location: Record "Location";
        Customer: Record Customer;
        ActWhseCreateSourceDocument: Codeunit "Whse.-Create Source Document";
        ActivitiesCreated: Integer;
        OneHeaderCreated: Boolean;
        Completed: Boolean;
        LineCreated: Boolean;
        WhseHeaderCreated: Boolean;
        DoNotFillQtytoHandleValue: Boolean;
        HideDialog: Boolean;
        SkipBlockedCustomer: Boolean;
        SkipBlockedItem: Boolean;
        RequestType: Option Receive,Ship;
        SalesHeaderCounted: Boolean;
        SkippedSourceDoc: Integer;
        ErrorOccured: Boolean;
        Text000Err: Label 'There are no Warehouse Receipt Lines created.';
        Text001Msg: Label '%1 %2 has been created.';
        Text002Msg: Label '%1 Warehouse Receipts have been created.';
        Text003Msg: Label 'There are no Warehouse Shipment Lines created.';
        Text004Msg: Label '%1 Warehouse Shipments have been created.';
        Text005Msg: Label 'One or more of the lines on this %1 require special warehouse handling. The %2 for such lines has been set to blank.';
        CustomerIsBlockedMsg: Label '%1 source documents were not included because the customer is blocked.';

    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;

    procedure SetOneCreatedShptHeader(LocWarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        RequestType := RequestType::Ship;
        WarehouseShipmentHeader := LocWarehouseShipmentHeader;
        IF WarehouseShipmentHeader.FIND() THEN
            OneHeaderCreated := TRUE;
    end;

    procedure SetOneCreatedReceiptHeader(LocWarehouseReceiptHeader: Record "Warehouse Receipt Header")
    begin
        RequestType := RequestType::Receive;
        WarehouseReceiptHeader := LocWarehouseReceiptHeader;
        IF WarehouseReceiptHeader.FIND() THEN
            OneHeaderCreated := TRUE;
    end;

    procedure SetDoNotFillQtytoHandle(DoNotFillQtytoHandle2: Boolean)
    begin
        DoNotFillQtytoHandleValue := DoNotFillQtytoHandle2;
    end;

    procedure GetLastShptHeader(var LocWarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        RequestType := RequestType::Ship;
        LocWarehouseShipmentHeader := WarehouseShipmentHeader;
    end;

    procedure NotCancelled(): Boolean
    begin
        EXIT(Completed);
    end;

    local procedure CreateShptHeader()
    var
        IsHandled: Boolean;
    begin
        IsHandled := FALSE;
        IF IsHandled THEN
            EXIT;

        WarehouseShipmentHeader.INIT();
        WarehouseShipmentHeader."No." := '';
        WarehouseShipmentHeader."Location Code" := "Warehouse Request by Ship"."Location Code";
        IF Location.Code = WarehouseShipmentHeader."Location Code" THEN
            WarehouseShipmentHeader."Bin Code" := Location."Shipment Bin Code";
        WarehouseShipmentHeader."External Document No." := "Warehouse Request by Ship"."External Document No.";
        WarehouseShipmentHeader."MICA Customer Transport" := "Sales Header"."MICA Customer Transport";
        WarehouseShipmentHeader."MICA Ship to code" := "Sales Header"."Ship-to Code";
        WarehouseShipmentHeader."MICA Ship to Name" := "Sales Header"."Ship-to Name";
        WarehouseShipmentHeader."MICA Ship-to Address" := "Sales Header"."Ship-to Address";
        WarehouseShipmentHeader."MICA Ship to City" := "Sales Header"."Ship-to City";
        WarehouseShipmentLine.LOCKTABLE();
        WarehouseShipmentHeader.INSERT(TRUE);

        WarehouseShipmentHeader."Shipment Date" := "Warehouse Request by Ship"."Shipment Date";
        WarehouseShipmentHeader."Posting Date" := "Warehouse Request by Ship"."Shipment Date";
        WarehouseShipmentHeader.Modify();

        ActivitiesCreated := ActivitiesCreated + 1;
        WhseHeaderCreated := TRUE;

        WarehouseShipmentHeader.Mark(true);
    end;

    local procedure CreateReceiptHeader()
    begin
        WarehouseReceiptHeader.INIT();
        WarehouseReceiptHeader."No." := '';
        WarehouseReceiptHeader."Location Code" := "Warehouse Request by Ship"."Location Code";
        IF Location.Code = WarehouseReceiptHeader."Location Code" THEN
            WarehouseReceiptHeader."Bin Code" := Location."Receipt Bin Code";
        WarehouseReceiptHeader."Vendor Shipment No." := "Warehouse Request by Ship"."External Document No.";
        WarehouseReceiptLine.LOCKTABLE();
        WarehouseReceiptHeader.INSERT(TRUE);
        ActivitiesCreated := ActivitiesCreated + 1;
        WhseHeaderCreated := TRUE;
        COMMIT();
    end;

    local procedure UpdateReceiptHeaderStatus()
    begin
        WITH WarehouseReceiptHeader DO BEGIN
            IF "No." = '' THEN
                EXIT;
            VALIDATE("Document Status", GetHeaderStatus(0));
            MODIFY(TRUE);
        END;
    end;

    procedure SetSkipBlocked(Skip: Boolean)
    begin
        SkipBlockedCustomer := Skip;
    end;

    procedure SetSkipBlockedItem(Skip: Boolean)
    begin
        SkipBlockedItem := Skip;
    end;

    local procedure VerifyItemNotBlocked(ItemNo: Code[20])
    var
        Item: Record Item;
    begin
        Item.GET(ItemNo);
        IF SkipBlockedItem AND Item.Blocked THEN
            CurrReport.SKIP();

        Item.TESTFIELD(Blocked, FALSE);
    end;

    procedure ShowReceiptDialog()
    var
        SpecialHandlingMessage: Text[1024];
    begin
        IF NOT LineCreated THEN
            ERROR(Text000Err);

        IF ErrorOccured THEN
            SpecialHandlingMessage :=
              ' ' + STRSUBSTNO(Text005Msg, WarehouseReceiptHeader.TABLECAPTION(), WarehouseReceiptLine.FIELDCAPTION("Bin Code"));
        IF (ActivitiesCreated = 0) AND LineCreated AND ErrorOccured THEN
            MESSAGE(SpecialHandlingMessage);
        IF ActivitiesCreated = 1 THEN
            MESSAGE(STRSUBSTNO(Text001Msg, ActivitiesCreated, WarehouseReceiptHeader.TABLECAPTION()) + SpecialHandlingMessage);
        IF ActivitiesCreated > 1 THEN
            MESSAGE(STRSUBSTNO(Text002Msg, ActivitiesCreated) + SpecialHandlingMessage);
    end;

    procedure ShowShipmentDialog()
    var
        SpecialHandlingMessage: Text[1024];
    begin
        IF NOT LineCreated THEN
            ERROR(Text003Msg);

        IF ErrorOccured THEN
            SpecialHandlingMessage :=
              ' ' + STRSUBSTNO(Text005Msg, WarehouseShipmentHeader.TABLECAPTION(), WarehouseShipmentLine.FIELDCAPTION("Bin Code"));
        IF (ActivitiesCreated = 0) AND LineCreated AND ErrorOccured THEN
            MESSAGE(SpecialHandlingMessage);
        IF ActivitiesCreated = 1 THEN
            MESSAGE(STRSUBSTNO(Text001Msg, ActivitiesCreated, WarehouseShipmentHeader.TABLECAPTION()) + SpecialHandlingMessage);
        IF ActivitiesCreated > 1 THEN
            MESSAGE(STRSUBSTNO(Text004Msg, ActivitiesCreated) + SpecialHandlingMessage);
    end;

    local procedure CheckFillQtyToHandle()
    begin
        IF DoNotFillQtytoHandleValue AND (RequestType = RequestType::Receive) THEN BEGIN
            WarehouseReceiptLine.RESET();
            WarehouseReceiptLine.SETRANGE("No.", WarehouseReceiptHeader."No.");
            WarehouseReceiptLine.DeleteQtyToReceive(WarehouseReceiptLine);
        END;
    end;

    procedure DecreaseActivitiesCreated()
    begin
        ActivitiesCreated -= 1;
    end;
}

