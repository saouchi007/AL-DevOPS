codeunit 82022 "MICA Update Supplier Invoice"
{
    //INTGIS001 – Supplier Invoice Integration
    TableNo = "MICA Flow Buffer Supplier Inv.";

    var
        PurchaseHeader: Record "Purchase Header"; // invoice, credit memo, rebill credit memo
        RebillInvPurchaseHeader: Record "Purchase Header"; // rebill invoice
        MICAFlowEntry: Record "MICA Flow Entry";
        HeadersDef: array[3] of Boolean;
        // [1] single header   - TRUE for IG_INV_Firm and IG_CM; FALSE for IG_INV_Rebill
        // [2] inserted header - invoice and credit memo for single, and credit memo for rebill xml
        // [3] inserted header - invoice for rebill xml
        IGINVFirmLbl: Label 'IG_INV_Firm', Locked = true;
        IGINVRebillLbl: Label 'IG_INV_Rebill', Locked = true;
        IGCMLbl: Label 'IG_CM', Locked = true;
        InsertFailedLbl: Label 'Insert failed: %1 %2';
        BSCProcessingLbl: Label 'BSC_PROCESSING', Locked = true;

    trigger OnRun()
    var
        MICAFlowRecord: Record "MICA Flow Record";
    begin
        case Rec.DOCTYPE of
            IGINVFirmLbl:
                begin
                    HeadersDef[1] := true;
                    CreateInvoice(Rec, HeadersDef);
                end;
            IGINVRebillLbl:
                begin
                    HeadersDef[1] := false;
                    CreateRebillInvoice(Rec, HeadersDef);
                end;
            IGCMLbl:
                begin
                    HeadersDef[1] := true;
                    CreateCreditMemo(Rec, HeadersDef);
                end;
        end;

        MICAFlowRecord.UpdateReceiveRecord(Rec."Flow Entry No.", PurchaseHeader.RecordId(), MICAFlowEntry."Receive Status"::Processed);

    end;

    local procedure CreateInvoice(var MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv."; var HeadersDef: array[3] of Boolean)
    begin
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Invoice;
        HeadersDef[2] := CreateHeader(MICAFlowBufferSupplierInv, PurchaseHeader);

    end;

    local procedure CreateRebillInvoice(var MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv."; var HeadersDef: array[3] of Boolean)
    var
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        // credit memo for original invoice
        if PurchInvHeader.Get(MICAFlowBufferSupplierInv."MICH.ORIGINVNUM") then begin
            PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::"Credit Memo";
            PurchaseHeader."MICA GIS Rebill Reason Code" := CopyStr(MICAFlowBufferSupplierInv.DOCUMENTID, 1, 30);
            HeadersDef[2] := CreateHeader(MICAFlowBufferSupplierInv, PurchaseHeader);
            PurchaseHeader.Validate("Dimension Set ID", PurchInvHeader."Dimension Set ID");
            PurchaseHeader.Validate("VAT Bus. Posting Group", PurchInvHeader."VAT Bus. Posting Group");
            PurchaseHeader.Validate("Gen. Bus. Posting Group", PurchInvHeader."Gen. Bus. Posting Group");
            PurchaseHeader.Modify(true);
        end;

        // new invoice
        RebillInvPurchaseHeader."Document Type" := RebillInvPurchaseHeader."Document Type"::Invoice;
        RebillInvPurchaseHeader."MICA GIS Rebill Reason Code" := CopyStr(MICAFlowBufferSupplierInv.DOCUMENTID, 1, 30);
        HeadersDef[3] := CreateHeader(MICAFlowBufferSupplierInv, RebillInvPurchaseHeader);

    end;

    local procedure CreateCreditMemo(var MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv."; var HeadersDef: array[3] of Boolean)
    var
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        if PurchInvHeader.Get(MICAFlowBufferSupplierInv."MICH.ORIGINVNUM") then begin
            PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::"Credit Memo";
            PurchaseHeader."MICA GIS Rebill Reason Code" := CopyStr(MICAFlowBufferSupplierInv.DOCUMENTID, 1, 30);
            HeadersDef[2] := CreateHeader(MICAFlowBufferSupplierInv, PurchaseHeader);
            PurchaseHeader.Validate("Dimension Set ID", PurchInvHeader."Dimension Set ID");
            PurchaseHeader.Validate("VAT Bus. Posting Group", PurchInvHeader."VAT Bus. Posting Group");
            PurchaseHeader.Validate("Gen. Bus. Posting Group", PurchInvHeader."Gen. Bus. Posting Group");
            PurchaseHeader.Modify(true);
        end;

    end;

    local procedure CreateHeader(var MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv."; var LocPurchaseHeader: Record "Purchase Header"): Boolean
    var
        MICAFlowInformation: Record "MICA Flow Information";
    begin
        LocPurchaseHeader.SetHideValidationDialog(true);
        ValidateFields(MICAFlowBufferSupplierInv, LocPurchaseHeader);
        LocPurchaseHeader."MICA RELFAC Code" := MICAFlowBufferSupplierInv.RELFACTCODE;
        LocPurchaseHeader."Posting No." := CopyStr(MICAFlowBufferSupplierInv."Vendor Invoice No.", 1, 20);
        LocPurchaseHeader."MICA AL No." := MICAFlowBufferSupplierInv."Line DocumentID2";
        LocPurchaseHeader."MICA GIS Invoice Doc. No." := CopyStr(MICAFlowBufferSupplierInv."MICH.ORIGINVNUM", 1, 20);
        LocPurchaseHeader."MICA GIS Ship-to Location" := CopyStr(MICAFlowBufferSupplierInv."ShipTo Descriptn", 1, 20);
        LocPurchaseHeader."MICA GIS Despatch Country" := CopyStr(MICAFlowBufferSupplierInv."MICH.ATTRIBUTE1", 1, 10);
        LocPurchaseHeader."MICA GIS DCN No." := MICAFlowBufferSupplierInv.ATTRIBUTE1;
        LocPurchaseHeader."MICA Total Inv. Amt.(excl.VAT)" := MICAFlowBufferSupplierInv."Total Amount";
        if not LocPurchaseHeader.Insert(true) then begin
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
              StrSubstNo(InsertFailedLbl, MICAFlowBufferSupplierInv.DOCUMENTID, GetLastErrorText()), BSCProcessingLbl);
            exit(false)
        end;
        exit(true);

    end;

    local procedure ValidateFields(MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv."; var LocPurchaseHeader: Record "Purchase Header")
    var
        PaymentTerms: Record "Payment Terms";
    begin
        LocPurchaseHeader.Validate("Buy-from Vendor No.", MICAFlowBufferSupplierInv."Supplier PARTNERID");
        LocPurchaseHeader.Validate("Buy-from Country/Region Code", MICAFlowBufferSupplierInv."Supplier COUNTRY");
        if MICAFlowBufferSupplierInv."Supplier NAME" <> '' then
            LocPurchaseHeader."Buy-from Vendor Name" := CopyStr(MICAFlowBufferSupplierInv."Supplier NAME", 1, 100);
        //PurchaseHdr.Validate("Buy-from Vendor Name", FlowBufSupplierInv."Supplier NAME");

        LocPurchaseHeader.Validate("Pay-to Vendor No.", MICAFlowBufferSupplierInv."BillTo PARTNERID");
        LocPurchaseHeader.Validate("Pay-to Country/Region Code", MICAFlowBufferSupplierInv."BillTo COUNTRY");
        if MICAFlowBufferSupplierInv."BillTo NAME" <> '' then
            LocPurchaseHeader."Pay-to Name" := CopyStr(MICAFlowBufferSupplierInv."BillTo NAME", 1, 100);
        // PurchaseHdr.Validate("Pay-to Name", FlowBufSupplierInv."BillTo NAME");

        LocPurchaseHeader.Validate("Document Date", MICAFlowBufferSupplierInv."Document Date");
        LocPurchaseHeader.Validate("Posting Date", MICAFlowBufferSupplierInv."Document Date");

        if LocPurchaseHeader."Document Type" = LocPurchaseHeader."Document Type"::Invoice then
            LocPurchaseHeader.Validate("Vendor Invoice No.", MICAFlowBufferSupplierInv."Vendor Invoice No.")
        else
            LocPurchaseHeader.Validate("Vendor Cr. Memo No.", MICAFlowBufferSupplierInv."Vendor Invoice No.");

        LocPurchaseHeader.Validate("Currency Code", MICAFlowBufferSupplierInv.CURRENCY);
        LocPurchaseHeader.Validate("Vendor Shipment No.", MICAFlowBufferSupplierInv.SHIPNUMBER);

        PaymentTerms.SetRange("MICA GIS Payment Term Code", MICAFlowBufferSupplierInv.TERMID);
        if PaymentTerms.FindFirst() then
            LocPurchaseHeader.Validate("Payment Terms Code", PaymentTerms.Code);

        Evaluate(LocPurchaseHeader."MICA GIS Invoice Doc. Date", MICAFlowBufferSupplierInv."MICH.ORIGINVDATE", 9);

        LocPurchaseHeader."MICA Record ID" := LocPurchaseHeader.RecordId();

    end;

    procedure GetHeadersDef(var HeadersDefIn: array[3] of Boolean)
    begin
        CopyArray(HeadersDefIn, HeadersDef, 1);

    end;

    procedure GetPurchaseHeader(var InPurchaseHeader: Record "Purchase Header"; InMICAFlowEntry: Record "MICA Flow Entry")
    begin
        InPurchaseHeader := PurchaseHeader;
        MICAFlowEntry := InMICAFlowEntry;
    end;

    procedure GetPurchaseHeaderRebillInv(var InPurchaseHeader: Record "Purchase Header")
    begin
        InPurchaseHeader := RebillInvPurchaseHeader;

    end;

}