page 82783 "MICA S2S Sales Order Lines"
{
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Sales Invoice Line Aggregate";
    SourceTableTemporary = true;
    ODataKeyFields = Id;
    Extensible = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.Id)
                {
                    ApplicationArea = All;
                    Caption = 'id', Locked = true;

                    trigger OnValidate()
                    begin
                        IF xRec.Id <> Rec.Id THEN
                            ERROR(CannotChangeIdNoErr);
                    end;
                }
                field(documentId; Rec."Document Id")
                {
                    ApplicationArea = All;
                    Caption = 'documentId', Locked = true;

                    trigger OnValidate()
                    begin
                        IF (not IsNullGuid(xRec."Document Id")) and (xRec."Document Id" <> Rec."Document Id") THEN
                            ERROR(CannotChangeDocumentIdNoErr);
                    end;
                }
                field(sequence; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'sequence', Locked = true;

                    trigger OnValidate()
                    begin
                        IF (xRec."Line No." <> Rec."Line No.") AND
                           (xRec."Line No." <> 0)
                        THEN
                            ERROR(CannotChangeLineNoErr);

                        RegisterFieldSet(Rec.FIELDNO("Line No."));
                    end;
                }
                field(itemId; Rec."Item Id")
                {
                    ApplicationArea = All;
                    Caption = 'itemId', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FIELDNO(Type));
                        RegisterFieldSet(Rec.FIELDNO("No."));
                        RegisterFieldSet(Rec.FIELDNO("Item Id"));

                        IF NOT Item.GetBySystemId(Rec."Item Id") THEN BEGIN
                            InsertItem := TRUE;
                            EXIT;
                        END;

                        Rec."No." := Item."No.";
                    end;
                }
                field(accountId; Rec."Account Id")
                {
                    ApplicationArea = All;
                    Caption = 'accountId', Locked = true;

                    trigger OnValidate()
                    var
                        EmptyGuid: Guid;
                    begin
                        IF Rec."Account Id" <> EmptyGuid THEN
                            IF Item."No." <> '' THEN
                                ERROR(BothItemIdAndAccountIdAreSpecifiedErr);
                        RegisterFieldSet(Rec.FIELDNO(Type));
                        RegisterFieldSet(Rec.FIELDNO("Account Id"));
                        RegisterFieldSet(Rec.FIELDNO("No."));
                    end;
                }
                field(lineType; Rec."API Type")
                {
                    ApplicationArea = All;
                    Caption = 'lineType', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FIELDNO(Type));
                    end;
                }
                field(lineDetails; LineObjectDetailsJSON)
                {
                    ApplicationArea = All;
                    Caption = 'lineDetails', Locked = true;
                    ODataEDMType = 'DOCUMENTLINEOBJECTDETAILS';
                    ToolTip = 'Specifies details about the line.';

                    trigger OnValidate()
                    var
                        GraphMgtComplexTypes: Codeunit "Graph Mgt - Complex Types";
                    begin
                        IF NOT InsertItem THEN
                            EXIT;

                        GraphMgtComplexTypes.ParseDocumentLineObjectDetailsFromJSON(
                          LineObjectDetailsJSON, Item."No.", Item.Description, Item."Description 2");

                        IF Item."No." <> '' THEN
                            RegisterItemFieldSet(Item.FIELDNO("No."));

                        RegisterFieldSet(Rec.FIELDNO("No."));

                        IF Item.Description <> '' THEN
                            RegisterItemFieldSet(Item.FIELDNO(Description));

                        IF Rec.Description = '' THEN BEGIN
                            Rec.Description := Item.Description;
                            RegisterFieldSet(Rec.FIELDNO(Description));
                        END;

                        IF Item."Description 2" <> '' THEN BEGIN
                            Rec."Description 2" := Item."Description 2";
                            RegisterItemFieldSet(Item.FIELDNO("Description 2"));
                            RegisterFieldSet(Rec.FIELDNO("Description 2"));
                        END;
                    end;
                }
                field(description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'description';
                    ToolTip = 'Specifies the description of the sales order line.';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FIELDNO(Description));
                    end;
                }
                field(unitOfMeasureId; UnitOfMeasureIdGlobal)
                {
                    ApplicationArea = All;
                    Caption = 'UnitOfMeasureId', Locked = true;
                    ToolTip = 'Specifies Unit of Measure.';

                    trigger OnValidate()
                    var
                        SalesInvoiceAggregator: Codeunit "Sales Invoice Aggregator";
                        GraphMgtSalesInvLines: Codeunit "Graph Mgt - Sales Inv. Lines";
                        BlankGUID: Guid;
                    begin
                        Rec.VALIDATE("Unit of Measure Id", UnitOfMeasureIdGlobal);
                        SalesInvoiceAggregator.VerifyCanUpdateUOM(Rec);

                        IF (UnitOfMeasureJSON = 'null') AND (Rec."Unit of Measure Id" <> BlankGUID) THEN
                            EXIT;

                        IF Rec."Unit of Measure Id" = BlankGUID THEN
                            Rec."Unit of Measure Code" := ''
                        ELSE BEGIN
                            IF NOT GlobalUnitofMeasure.GetBySystemId(Rec."Unit of Measure Id") THEN
                                ERROR(UnitOfMeasureIdDoesNotMatchAUnitOfMeasureErr);

                            Rec."Unit of Measure Code" := GlobalUnitofMeasure.Code;
                        END;

                        RegisterFieldSet(Rec.FIELDNO("Unit of Measure Code"));

                        IF InsertItem THEN
                            EXIT;

                        IF Item.GetBySystemId(Rec."Item Id") THEN
                            SalesInvoiceAggregator.UpdateUnitOfMeasure(Item, GraphMgtSalesInvLines.GetUnitOfMeasureJSON(Rec));
                    end;
                }
                field(unitOfMeasure; UnitOfMeasureJSON)
                {
                    ApplicationArea = All;
                    Caption = 'unitOfMeasure', Locked = true;
                    ODataEDMType = 'ITEM-UOM';
                    ToolTip = 'Specifies Unit of Measure.';

                    trigger OnValidate()
                    var
                        TempUnitOfMeasure: Record "Unit of Measure" temporary;
                        SalesInvoiceAggregator: Codeunit "Sales Invoice Aggregator";
                        GraphCollectionMgtItem: Codeunit "Graph Collection Mgt - Item";
                        GraphMgtSalesInvLines: Codeunit "Graph Mgt - Sales Inv. Lines";
                    begin
                        SalesInvoiceAggregator.VerifyCanUpdateUOM(Rec);

                        IF UnitOfMeasureJSON = 'null' THEN
                            TempUnitOfMeasure.Code := ''
                        ELSE
                            GraphCollectionMgtItem.ParseJSONToUnitOfMeasure(UnitOfMeasureJSON, TempUnitOfMeasure);

                        IF (UnitOfMeasureJSON = 'null') AND (GlobalUnitofMeasure.Code <> '') THEN
                            EXIT;
                        IF (GlobalUnitofMeasure.Code <> '') AND (GlobalUnitofMeasure.Code <> TempUnitOfMeasure.Code) THEN
                            ERROR(UnitOfMeasureValuesDontMatchErr);

                        Rec."Unit of Measure Code" := TempUnitOfMeasure.Code;
                        RegisterFieldSet(Rec.FIELDNO("Unit of Measure Code"));

                        IF InsertItem THEN
                            EXIT;

                        IF Item.GetBySystemId(Rec."Item Id") THEN
                            IF UnitOfMeasureJSON = 'null' THEN
                                SalesInvoiceAggregator.UpdateUnitOfMeasure(Item, GraphMgtSalesInvLines.GetUnitOfMeasureJSON(Rec))
                            ELSE
                                SalesInvoiceAggregator.UpdateUnitOfMeasure(Item, UnitOfMeasureJSON);
                    end;
                }
                field(quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'quantity', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FIELDNO(Quantity));
                    end;
                }
                field(unitPrice; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Caption = 'unitPrice', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FIELDNO("Unit Price"));
                    end;
                }
                field(discountAmount; Rec."Line Discount Amount")
                {
                    ApplicationArea = All;
                    Caption = 'discountAmount', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FIELDNO("Line Discount Amount"));
                    end;
                }
                field(discountPercent; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                    Caption = 'discountPercent', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FIELDNO("Line Discount %"));
                    end;
                }
                field(discountAppliedBeforeTax; Rec."Discount Applied Before Tax")
                {
                    ApplicationArea = All;
                    Caption = 'discountAppliedBeforeTax', Locked = true;
                    Editable = false;
                }
                field(amountExcludingTax; Rec."Line Amount Excluding Tax")
                {
                    ApplicationArea = All;
                    Caption = 'amountExcludingTax', Locked = true;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FIELDNO(Amount));
                    end;
                }
                field(taxCode; Rec."Tax Code")
                {
                    ApplicationArea = All;
                    Caption = 'taxCode', Locked = true;

                    trigger OnValidate()
                    var
                        GeneralLedgerSetup: Record "General Ledger Setup";
                    begin
                        IF InsertItem THEN BEGIN
                            IF GeneralLedgerSetup.UseVat() THEN
                                EXIT;

                            Item."Tax Group Code" := COPYSTR(Rec."Tax Code", 1, MAXSTRLEN(Item."Tax Group Code"));
                            RegisterItemFieldSet(Item.FIELDNO("Tax Group Code"));
                        END;

                        IF GeneralLedgerSetup.UseVat() THEN BEGIN
                            Rec.VALIDATE("VAT Prod. Posting Group", COPYSTR(Rec."Tax Code", 1, 20));
                            RegisterFieldSet(Rec.FIELDNO("VAT Prod. Posting Group"));
                        END ELSE BEGIN
                            Rec.VALIDATE("Tax Group Code", COPYSTR(Rec."Tax Code", 1, 20));
                            RegisterFieldSet(Rec.FIELDNO("Tax Group Code"));
                        END;
                    end;
                }
                field(taxPercent; Rec."VAT %")
                {
                    ApplicationArea = All;
                    Caption = 'taxPercent', Locked = true;
                    Editable = false;
                }
                field(totalTaxAmount; Rec."Line Tax Amount")
                {
                    ApplicationArea = All;
                    Caption = 'totalTaxAmount', Locked = true;
                    Editable = false;
                }
                field(amountIncludingTax; Rec."Line Amount Including Tax")
                {
                    ApplicationArea = All;
                    Caption = 'amountIncludingTax', Locked = true;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FIELDNO("Amount Including VAT"));
                    end;
                }
                field(invoiceDiscountAllocation; Rec."Inv. Discount Amount Excl. VAT")
                {
                    ApplicationArea = All;
                    Caption = 'invoiceDiscountAllocation', Locked = true;
                    Editable = false;
                }
                field(netAmount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'netAmount', Locked = true;
                    Editable = false;
                }
                field(netTaxAmount; Rec."Tax Amount")
                {
                    ApplicationArea = All;
                    Caption = 'netTaxAmount', Locked = true;
                    Editable = false;
                }
                field(netAmountIncludingTax; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'netAmountIncludingTax', Locked = true;
                    Editable = false;
                }
                field(shipmentDate; Rec."Shipment Date")
                {
                    ApplicationArea = All;
                    Caption = 'shipmentDate', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FIELDNO("Shipment Date"));
                    end;
                }
                field(shippedQuantity; Rec."Quantity Shipped")
                {
                    ApplicationArea = All;
                    Caption = 'shippedQuantity', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FIELDNO("Quantity Shipped"));
                    end;
                }
                field(invoicedQuantity; Rec."Quantity Invoiced")
                {
                    ApplicationArea = All;
                    Caption = 'invoicedQuantity', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FIELDNO("Quantity Invoiced"));
                    end;
                }
                field(invoiceQuantity; Rec."Qty. to Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'invoiceQuantity', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FIELDNO("Qty. to Invoice"));
                    end;
                }
                field(shipQuantity; Rec."Qty. to Ship")
                {
                    ApplicationArea = All;
                    Caption = 'shipQuantity', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FIELDNO("Qty. to Ship"));
                    end;
                }
                field(itemVariantId; Rec."Variant Id")
                {
                    ApplicationArea = All;
                    Caption = 'itemVariantId', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FIELDNO("Variant Code"));
                    end;
                }
                field(splitSourceLineNo; Rec."MICA Split Source line No.")
                {
                    ApplicationArea = All;
                    Caption = 'splitSourceLineNo', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FIELDNO("MICA Split Source line No."));
                    end;
                }
                field(splitSrcExpOrdQtyB; Rec."MICA Split Src Exp Ord Qty (b)")
                {
                    ApplicationArea = All;
                    Caption = 'splitSrcExpOrdQtyB', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FIELDNO("MICA Split Src Exp Ord Qty (b)"));
                    end;
                }
                field(status; Rec."MICA Status")
                {
                    ApplicationArea = All;
                    Caption = 'status', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FIELDNO("MICA Status"));
                    end;
                }
                field(plannedDeliveryDate; Rec."MICA Planned Delivery Date")
                {
                    ApplicationArea = All;
                    Caption = 'plannedDeliveryDate', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FIELDNO("MICA Planned Delivery Date"));
                    end;
                }
                field(plannedShipmentDate; Rec."MICA Planned Shipment Date")
                {
                    ApplicationArea = All;
                    Caption = 'plannedShipmentDate', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FIELDNO("MICA Planned Shipment Date"));
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetCalculatedFields();
    end;

    trigger OnDeleteRecord(): Boolean
    var
        GraphMgtSalesOrderBuffer: Codeunit "Graph Mgt - Sales Order Buffer";
    begin
        GraphMgtSalesOrderBuffer.PropagateDeleteLine(Rec);
    end;

    trigger OnFindRecord(Which: Text): Boolean
    var
        GraphMgtSalesInvLines: Codeunit "Graph Mgt - Sales Inv. Lines";
        DocumentIdFilter: Text;
        IdFilter: Text;
        FilterView: Text;
    begin
        IF NOT LinesLoaded THEN BEGIN
            FilterView := Rec.GETVIEW();
            IdFilter := Rec.GETFILTER(Id);
            DocumentIdFilter := Rec.GETFILTER("Document Id");
            IF (IdFilter = '') AND (DocumentIdFilter = '') THEN
                ERROR(IDOrDocumentIdShouldBeSpecifiedForLinesErr);
            IF IdFilter <> '' THEN
                DocumentIdFilter := GraphMgtSalesInvLines.GetDocumentIdFilterFromIdFilter(IdFilter)
            ELSE
                DocumentIdFilter := Rec.GETFILTER("Document Id");
            LoadLines(Rec, DocumentIdFilter);
            Rec.SETVIEW(FilterView);
            IF NOT Rec.FINDFIRST() THEN
                EXIT(FALSE);
            LinesLoaded := TRUE;
        END;

        EXIT(TRUE);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        GraphMgtSalesOrderBuffer: Codeunit "Graph Mgt - Sales Order Buffer";
    begin
        IF InsertItem THEN
            InsertItemOnTheFly();

        GraphMgtSalesOrderBuffer.PropagateInsertLine(Rec, TempFieldBuffer);

        SetCalculatedFields();
    end;

    trigger OnModifyRecord(): Boolean
    var
        GraphMgtSalesOrderBuffer: Codeunit "Graph Mgt - Sales Order Buffer";
    begin
        IF InsertItem THEN
            InsertItemOnTheFly();

        GraphMgtSalesOrderBuffer.PropagateModifyLine(Rec, TempFieldBuffer);

        SetCalculatedFields();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ClearCalculatedFields();
        Rec.VALIDATE(Type, Rec.Type::Item);
        RegisterFieldSet(Rec.FIELDNO(Type));
    end;

    var
        TempFieldBuffer: Record "Field Buffer" temporary;
        TempItemFieldSetTableField: Record 2000000041 temporary;
        Item: Record "Item";
        GlobalUnitofMeasure: Record "Unit of Measure";
        UnitOfMeasureJSON: Text;
        LineObjectDetailsJSON: Text;
        LinesLoaded: Boolean;
        InsertItem: Boolean;
        IDOrDocumentIdShouldBeSpecifiedForLinesErr: Label 'You must specify an Id or a Document Id to get the lines.', Locked = true;
        CannotChangeIdNoErr: Label 'The value for id cannot be modified.', Locked = true;
        CannotChangeDocumentIdNoErr: Label 'The value for documentId cannot be modified.', Locked = true;
        CannotChangeLineNoErr: Label 'The value for sequence cannot be modified. Delete and insert the line again.', Locked = true;
        BothItemIdAndAccountIdAreSpecifiedErr: Label 'Both itemId and accountId are specified. Specify only one of them.';
        UnitOfMeasureValuesDontMatchErr: Label 'The unit of measure values do not match to a specific Unit of Measure.', Locked = true;
        UnitOfMeasureIdDoesNotMatchAUnitOfMeasureErr: Label 'The "unitOfMeasureId" does not match to a Unit of Measure.', Locked = true;
        DocumentIDNotSpecifiedErr: Label 'You must specify a document id to get the lines.', Locked = true;
        UnitOfMeasureIdGlobal: Guid;

    local procedure RegisterFieldSet(FieldNo: Integer)
    var
        LastOrderNo: Integer;
    begin
        LastOrderNo := 1;
        IF TempFieldBuffer.FINDLAST() THEN
            LastOrderNo := TempFieldBuffer.Order + 1;

        CLEAR(TempFieldBuffer);
        TempFieldBuffer.Order := LastOrderNo;
        TempFieldBuffer."Table ID" := DATABASE::"Sales Invoice Line Aggregate";
        TempFieldBuffer."Field ID" := FieldNo;
        TempFieldBuffer.INSERT();
    end;

    local procedure ClearCalculatedFields()
    begin
        TempFieldBuffer.RESET();
        TempFieldBuffer.DELETEALL();
        TempItemFieldSetTableField.RESET();
        TempItemFieldSetTableField.DELETEALL();

        CLEAR(Item);
        CLEAR(UnitOfMeasureJSON);
        CLEAR(InsertItem);
        CLEAR(LineObjectDetailsJSON);
        CLEAR(UnitOfMeasureIdGlobal);
    end;

    local procedure SetCalculatedFields()
    var
        GraphMgtSalesInvLines: Codeunit "Graph Mgt - Sales Inv. Lines";
        GraphMgtComplexTypes: Codeunit "Graph Mgt - Complex Types";
    begin
        LineObjectDetailsJSON := GraphMgtComplexTypes.GetSalesLineDescriptionComplexType(Rec);
        UnitOfMeasureJSON := GraphMgtSalesInvLines.GetUnitOfMeasureJSON(Rec);
        UnitOfMeasureIdGlobal := Rec."Unit of Measure Id";
    end;

    local procedure RegisterItemFieldSet(FieldNo: Integer)
    begin
        IF TempItemFieldSetTableField.GET(DATABASE::Item, FieldNo) THEN
            EXIT;

        TempItemFieldSetTableField.INIT();
        TempItemFieldSetTableField.TableNo := DATABASE::Item;
        TempItemFieldSetTableField.VALIDATE("No.", FieldNo);
        TempItemFieldSetTableField.INSERT(TRUE);
    end;

    local procedure InsertItemOnTheFly()
    var
        GraphCollectionMgtItem: Codeunit "Graph Collection Mgt - Item";
    begin
        GraphCollectionMgtItem.InsertItemFromSalesDocument(Item, TempItemFieldSetTableField, UnitOfMeasureJSON);
        Rec.VALIDATE("No.", Item."No.");

        IF Rec.Description = '' THEN
            Rec.Description := Item.Description;
    end;

    procedure LoadLines(var SalesInvoiceLineAggregate: Record "Sales Invoice Line Aggregate"; DocumentIdFilter: Text)
    var
        SalesOrderEntityBuffer: Record "Sales Order Entity Buffer";
    begin
        if DocumentIdFilter = '' then
            Error(DocumentIDNotSpecifiedErr);

        SalesOrderEntityBuffer.SetFilter(Id, DocumentIdFilter);
        if not SalesOrderEntityBuffer.FindFirst() then
            exit;

        LoadSalesLines(SalesInvoiceLineAggregate, SalesOrderEntityBuffer);
    end;

    local procedure LoadSalesLines(var SalesInvoiceLineAggregate: Record "Sales Invoice Line Aggregate"; var SalesOrderEntityBuffer: Record "Sales Order Entity Buffer")
    var
        MICAAPISalesLine: Record "MICA API Sales Line";
    begin
        MICAAPISalesLine.SetRange("Document Type", MICAAPISalesLine."Document Type"::Order);
        MICAAPISalesLine.SetRange("Document No.", SalesOrderEntityBuffer."No.");

        if MICAAPISalesLine.FindSet(false, false) then
            repeat
                TransferFromSalesLine(SalesInvoiceLineAggregate, SalesOrderEntityBuffer, MICAAPISalesLine);
                SalesInvoiceLineAggregate.Insert(true);
            until MICAAPISalesLine.Next() = 0;
    end;

    local procedure TransferFromSalesLine(var SalesInvoiceLineAggregate: Record "Sales Invoice Line Aggregate"; var SalesOrderEntityBuffer: Record "Sales Order Entity Buffer"; var MICAAPISalesLine: Record "MICA API Sales Line")
    var
        SalesInvoiceAggregator: Codeunit "Sales Invoice Aggregator";
#if not OnPremise
        GraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
#endif

    begin
        Clear(SalesInvoiceLineAggregate);
        SalesInvoiceLineAggregate.TransferFields(MICAAPISalesLine, true);
#if OnPremise
        SalesInvoiceLineAggregate.Id :=
          SalesInvoiceAggregator.GetIdFromDocumentIdAndSequence(SalesOrderEntityBuffer.Id, MICAAPISalesLine."Line No.");
#else
        SalesInvoiceLineAggregate.Id := LowerCase(GraphMgtGeneralTools.StripBrackets(Format(SalesOrderEntityBuffer.Id) + '-' + format(MICAAPISalesLine."Line No.")));
#endif
        SalesInvoiceLineAggregate."Document Id" := SalesOrderEntityBuffer.Id;
        SalesInvoiceAggregator.SetTaxGroupIdAndCode(
          SalesInvoiceLineAggregate,
          MICAAPISalesLine."Tax Group Code",
          MICAAPISalesLine."VAT Prod. Posting Group",
          MICAAPISalesLine."VAT Identifier");
        SalesInvoiceLineAggregate."VAT %" := MICAAPISalesLine."VAT %";
        SalesInvoiceLineAggregate."Tax Amount" := MICAAPISalesLine."Amount Including VAT" - MICAAPISalesLine."VAT Base Amount";
        SalesInvoiceLineAggregate."MICA Planned Delivery Date" := MICAAPISalesLine."Planned Delivery Date";
        SalesInvoiceLineAggregate."MICA Planned Shipment Date" := MICAAPISalesLine."Planned Shipment Date";
        SalesInvoiceLineAggregate.UpdateReferencedRecordIds();
        UpdateLineAmountsFromSalesLine(SalesInvoiceLineAggregate, MICAAPISalesLine);
        SalesInvoiceAggregator.SetItemVariantId(SalesInvoiceLineAggregate, MICAAPISalesLine."No.", MICAAPISalesLine."Variant Code");
    end;

    local procedure UpdateLineAmountsFromSalesLine(var SalesInvoiceLineAggregate: Record "Sales Invoice Line Aggregate"; var MICAAPISalesLine: Record "MICA API Sales Line")
    begin
        SalesInvoiceLineAggregate."Line Amount Excluding Tax" := MICAAPISalesLine.GetLineAmountExclVAT();
        SalesInvoiceLineAggregate."Line Amount Including Tax" := MICAAPISalesLine.GetLineAmountInclVAT();
        SalesInvoiceLineAggregate."Line Tax Amount" :=
          SalesInvoiceLineAggregate."Line Amount Including Tax" - SalesInvoiceLineAggregate."Line Amount Excluding Tax";
        UpdateInvoiceDiscountAmount(SalesInvoiceLineAggregate);
    end;

    local procedure UpdateInvoiceDiscountAmount(var SalesInvoiceLineAggregate: Record "Sales Invoice Line Aggregate")
    begin
        if SalesInvoiceLineAggregate."Prices Including Tax" then
            SalesInvoiceLineAggregate."Inv. Discount Amount Excl. VAT" :=
              SalesInvoiceLineAggregate."Line Amount Excluding Tax" - SalesInvoiceLineAggregate.Amount
        else
            SalesInvoiceLineAggregate."Inv. Discount Amount Excl. VAT" := SalesInvoiceLineAggregate."Inv. Discount Amount";
    end;
}




















