codeunit 82023 "MICA Update Supplier Inv. Line"
{
    //INTGIS001 – Supplier Invoice Integration
    TableNo = "MICA Flow Buffer Supplier Inv.";

    var
        MICAFlowInformation: Record "MICA Flow Information";
        PurchaseHeader: Record "Purchase Header";
        RebillPurchaseHeader: Record "Purchase Header";
        MICAFlowEntry: Record "MICA Flow Entry";
        HeadersDef: array[3] of Boolean;
        // [1] single header   - TRUE for IG_INV_Firm and IG_CM; FALSE for IG_INV_Rebill
        // [2] inserted header - invoice and credit memo for single, and credit memo for rebill xml
        // [3] inserted header - invoice for rebill xml
        IGINVFirmLbl: Label 'IG_INV_Firm', Locked = true;
        IGINVRebillLbl: Label 'IG_INV_Rebill', Locked = true;
        IGCMLbl: Label 'IG_CM', Locked = true;
        BSCProcessingLbl: Label 'BSC_PROCESSING', Locked = true;

    trigger OnRun()
    begin
        case Rec.DOCTYPE of
            IGINVFirmLbl:
                begin
                    if not HeadersDef[2] then
                        exit;

                    // xml - INVLINE
                    if Rec."Line No." <> '' then
                        CreateInvLineFromReceipt(Rec);

                    // xml - INVCHARGE
                    if Rec."Freight Line No." <> '' then
                        CreateFreightLine(Rec, PurchaseHeader);
                end;
            IGCMLbl:
                begin
                    if not HeadersDef[2] then
                        exit;

                    // xml - INVLINE
                    if Rec."Line No." <> '' then
                        CreateCrMemoLine(Rec);

                    // xml - INVCHARGE
                    if Rec."Freight Line No." <> '' then
                        CreateFreightLine(Rec, PurchaseHeader);
                end;
            IGINVRebillLbl:
                begin
                    if HeadersDef[2] then begin
                        // xml - INVLINE
                        if Rec."Line No." <> '' then
                            CreateCrMemoLine(Rec);

                        // xml - INVCHARGE
                        if Rec."Freight Line No." <> '' then
                            CreateFreightLine(Rec, PurchaseHeader);
                    end;

                    if HeadersDef[3] then begin
                        // xml - INVLINE
                        if Rec."Line No." <> '' then
                            CreateRebillInvoiceLine(Rec);

                        // xml - INVCHARGE
                        if Rec."Freight Line No." <> '' then
                            CreateFreightLine(Rec, RebillPurchaseHeader);
                    end;
                end;
        end;

    end;

    local procedure CreateInvLineFromReceipt(var MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv.")
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        if not CreateInvLinesFromReceiptLine(MICAFlowBufferSupplierInv, PurchRcptLine) then // Receipt doesn't exist
            exit;

        UpdateInvLine(MICAFlowBufferSupplierInv, PurchRcptLine);

    end;

    local procedure CreateRebillInvoiceLine(var MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv.")
    var
        PurchaseLine: Record "Purchase Line";
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
    begin
        MICAFinancialReportingSetup.Get();
        PurchaseLine."Document Type" := RebillPurchaseHeader."Document Type";
        PurchaseLine."Document No." := RebillPurchaseHeader."No.";
        PurchaseLine."Line No." := GetNexLineNo(PurchaseLine);
        PurchaseLine.Validate(Type, PurchaseLine.Type::"Charge (Item)");
        PurchaseLine.Validate("No.", MICAFinancialReportingSetup."GIS AP Integrat. Charge (Item)");
        PurchaseLine.Validate(Quantity, MICAFlowBufferSupplierInv."Line Quantity");
        PurchaseLine.Validate("Direct Unit Cost", ABS(MICAFlowBufferSupplierInv."Line Amount"));
        PurchaseLine.Insert(true);
        ModifyPurchaseLine(MICAFlowBufferSupplierInv, PurchaseLine);

        CreateItemChargeAssgnt(MICAFlowBufferSupplierInv, PurchaseLine);

    end;

    local procedure CreateFreightLine(var MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv."; var PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
    begin
        // Freight(Item) - FinancialReportingSetup."GIS AP Integrat. Freight Item"
        MICAFinancialReportingSetup.Get();
        PurchaseLine."Document Type" := PurchaseHeader."Document Type";
        PurchaseLine."Document No." := PurchaseHeader."No.";
        PurchaseLine."Line No." := GetNexLineNo(PurchaseLine);
        PurchaseLine.Validate(Type, PurchaseLine.Type::Item);
        PurchaseLine.Validate("No.", MICAFinancialReportingSetup."GIS AP Integrat. Freight Item");
        PurchaseLine.Validate(Quantity, 1);
        PurchaseLine.Validate("Direct Unit Cost", ABS(MICAFlowBufferSupplierInv."Line Charge Amount"));
        Evaluate(PurchaseLine."MICA GIS Freight Doc. Line No.", MICAFlowBufferSupplierInv."Freight Line No.");
        PurchaseLine."MICA Record ID" := PurchaseLine.RecordId();
        PurchaseLine.Insert(true);

    end;

    local procedure CreateCrMemoLine(var MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv.")
    var
        PurchaseLine: Record "Purchase Line";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        PurchaseLine1Lbl: Label '%1%2', Comment = '%1%2', Locked = true;
    begin
        MICAFinancialReportingSetup.Get();
        PurchaseLine."Document Type" := PurchaseHeader."Document Type";
        PurchaseLine."Document No." := PurchaseHeader."No.";
        PurchaseLine."Line No." := GetNexLineNo(PurchaseLine);
        PurchaseLine.Validate(Type, PurchaseLine.Type::"Charge (Item)");
        PurchaseLine.Validate("No.", MICAFinancialReportingSetup."GIS AP Integrat. Charge (Item)");
        PurchaseLine.Validate(Quantity, MICAFlowBufferSupplierInv."Line Quantity");
        PurchaseLine.Validate("Direct Unit Cost", ABS(MICAFlowBufferSupplierInv."Line Amount"));

        // transfer data from posted invoice line
        if PurchInvHeader.Get(MICAFlowBufferSupplierInv."MICH.ORIGINVNUM") then begin
            PurchInvLine.SetRange("Document No.", PurchInvHeader."No.");
            PurchInvLine.SetFilter("MICA AL No.", StrSubstNo(PurchaseLine1Lbl, CopyStr(MICAFlowBufferSupplierInv."Line DocumentID2", 1, 9), '*')); // AL section from xml
            PurchInvLine.SETRANGE("MICA AL Line No.", MICAFlowBufferSupplierInv."Line Linenum2"); // AL section from xml
            if PurchInvLine.FindFirst() then begin
                PurchaseLine.Validate("Dimension Set ID", PurchInvLine."Dimension Set ID");
                PurchaseLine.Validate("VAT Bus. Posting Group", PurchInvLine."VAT Bus. Posting Group");
                PurchaseLine.Validate("VAT Prod. Posting Group", PurchInvLine."VAT Prod. Posting Group");
                PurchaseLine.Validate("Gen. Bus. Posting Group", PurchInvLine."Gen. Bus. Posting Group");
                PurchaseLine.Validate("Gen. Prod. Posting Group", PurchInvLine."Gen. Prod. Posting Group");
            end;
        end;

        PurchaseLine."MICA Record ID" := PurchaseLine.RecordId();
        PurchaseLine.Insert(true);

        CreateItemChargeAssgnt(MICAFlowBufferSupplierInv, PurchaseLine);

    end;


    local procedure CreateInvLinesFromReceiptLine(var MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv."; var PurchRcptLine: Record "Purch. Rcpt. Line"): Boolean
    var
        PurchGetReceipt: Codeunit "Purch.-Get Receipt";
        UpdateErrorLbl: Label '%1 not found. Filter: %2';
        PurchRcptLine1Lbl: Label '%1%2', Comment = '%1%2', Locked = true;
    begin
        PurchRcptLine.SETRANGE("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
        PurchRcptLine.SETRANGE("Order No.", MICAFlowBufferSupplierInv."Line DocumentID3"); // PurchaseOrder section from xml
        PurchRcptLine.SetFilter("MICA AL No.", StrSubstNo(PurchRcptLine1Lbl, CopyStr(MICAFlowBufferSupplierInv."Line DocumentID2", 1, 9), '*')); // AL section from xml
        PurchRcptLine.SETRANGE("MICA AL Line No.", MICAFlowBufferSupplierInv."Line Linenum2"); // AL section from xml
        PurchRcptLine.SETRANGE("Pay-to Vendor No.", PurchaseHeader."Pay-to Vendor No."); // to avoid a message
        PurchRcptLine.SETRANGE("Currency Code", PurchaseHeader."Currency Code"); // to avoid a message        
        if PurchRcptLine.FindFirst() then begin
            PurchGetReceipt.SetPurchHeader(PurchaseHeader);
            PurchGetReceipt.CreateInvLines(PurchRcptLine);
            exit(true);
        end else
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
          StrSubstNo(UpdateErrorLbl, PurchRcptLine.TableCaption(), PurchRcptLine.GetFilters()), BSCProcessingLbl);
        exit(false);

    end;

    local procedure UpdateInvLine(var MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv."; var PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        PurchaseLine: Record "Purchase Line";
        PurchaseLine2Lbl: Label '%1%2', Comment = '%1%2', Locked = true;
    begin
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetRange("Receipt No.", PurchRcptLine."Document No.");
        PurchaseLine.SetRange("Receipt Line No.", PurchRcptLine."Line No.");
        PurchaseLine.SetFilter("MICA AL No.", StrSubstNo(PurchaseLine2Lbl, CopyStr(PurchRcptLine."MICA AL No.", 1, 9), '*'));
        PurchaseLine.SetRange("MICA AL Line No.", PurchRcptLine."MICA AL Line No.");
        if PurchaseLine.FindFirst() then
            ModifyPurchaseLine(MICAFlowBufferSupplierInv, PurchaseLine);

    end;

    local procedure ModifyPurchaseLine(var MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv."; var PurchaseLine: Record "Purchase Line")
    begin
        PurchaseLine.validate("Unit of Measure Code", MICAFlowBufferSupplierInv."Line Unit of Measure");
        PurchaseLine.Validate(Quantity, MICAFlowBufferSupplierInv."Line Quantity");
        PurchaseLine.Validate("Direct Unit Cost", MICAFlowBufferSupplierInv."Line OPERAMT");
        Evaluate(PurchaseLine."MICA GIS Document Line No.", MICAFlowBufferSupplierInv."Line No.");
        PurchaseLine."MICA GIS Dest. Country Code" := MICAFlowBufferSupplierInv."Line MICH.DESTCOUNTRYCODE";
        PurchaseLine."MICA Country of Origin" := MICAFlowBufferSupplierInv."Line MICH.COUNTRYORIG";
        PurchaseLine."MICA GIS Delivery Terms" := MICAFlowBufferSupplierInv."Line MICH.DELIVERTERMS";
        PurchaseLine."Transaction Type" := MICAFlowBufferSupplierInv."Line MICH.TRXCODENATURE";
        PurchaseLine."MICA GIS Commodity Code" := MICAFlowBufferSupplierInv."Line MICH.COMMODITYCODE";
        PurchaseLine."MICA GIS Net Mass" := MICAFlowBufferSupplierInv."Line Neto Weight";
        PurchaseLine."MICA GIS Supplementary Units" := MICAFlowBufferSupplierInv."Line MICH.SUPPLEMENTUNITS";
        PurchaseLine."MICA GIS Mode of Transport" := MICAFlowBufferSupplierInv."Line MICH.TRANSPORTMODE";
        PurchaseLine."MICA GIS Loading Port" := MICAFlowBufferSupplierInv."Line MICH.LOADINGPORT";
        PurchaseLine."MICA GIS Statistic Procedure" := MICAFlowBufferSupplierInv."Line MICH.STATISTICPROCED";
        PurchaseLine."MICA GIS Statistical Value" := MICAFlowBufferSupplierInv."Line MICH.STATISTICVALUE";
        PurchaseLine."MICA GIS Country of Manuf." := MICAFlowBufferSupplierInv."Line MICH.LINEATTRIBUTE3";
        PurchaseLine."MICA GIS Container No." := MICAFlowBufferSupplierInv."Line MICH.CONTAINERNUM";
        PurchaseLine."MICA Freight Line No." := MICAFlowBufferSupplierInv."Freight Line No.";
        PurchaseLine."MICA Record ID" := PurchaseLine.RecordId();
        PurchaseLine.Modify(true);

    end;

    local procedure CreateItemChargeAssgnt(MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv."; var PurchaseLine: Record "Purchase Line")
    var
        FoundPurchaseLine: Record "Purchase Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        ItemChargeAssignmentPurch: Record "Item Charge Assignment (Purch)";
        ItemChargeAssgntPurch: Codeunit "Item Charge Assgnt. (Purch.)";
        PurchRcptLine2Lbl: Label '%1%2', Comment = '%1%2', Locked = true;
    begin
        FoundPurchaseLine.get(PurchaseLine."Document Type", PurchaseLine."Document No.", PurchaseLine."Line No.");
        PurchRcptLine.SETRANGE("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
        PurchRcptLine.SETRANGE("Order No.", MICAFlowBufferSupplierInv."Line DocumentID3"); // PurchaseOrder section from xml
        PurchRcptLine.SetFilter("MICA AL No.", StrSubstNo(PurchRcptLine2Lbl, CopyStr(MICAFlowBufferSupplierInv."Line DocumentID2", 1, 9), '*')); // AL section from xml
        PurchRcptLine.SETRANGE("MICA AL Line No.", MICAFlowBufferSupplierInv."Line Linenum2"); // AL section from xml
        PurchRcptLine.SETRANGE("Pay-to Vendor No.", PurchaseHeader."Pay-to Vendor No."); // to avoid a message
        PurchRcptLine.SETRANGE("Currency Code", PurchaseHeader."Currency Code"); // to avoid a message        
        if PurchRcptLine.FindFirst() then begin
            ItemChargeAssignmentPurch."Document Type" := FoundPurchaseLine."Document Type";
            ItemChargeAssignmentPurch."Document No." := FoundPurchaseLine."Document No.";
            ItemChargeAssignmentPurch."Document Line No." := FoundPurchaseLine."Line No.";
            ItemChargeAssignmentPurch."Item Charge No." := FoundPurchaseLine."No.";
            ItemChargeAssignmentPurch."Applies-to Doc. Type" := ItemChargeAssignmentPurch."Applies-to Doc. Type"::Receipt;
            ItemChargeAssignmentPurch."Unit Cost" := FoundPurchaseLine."Unit Cost";

            ItemChargeAssgntPurch.CreateRcptChargeAssgnt(PurchRcptLine, ItemChargeAssignmentPurch);
            ItemChargeAssgntPurch.SuggestAssgnt(FoundPurchaseLine, FoundPurchaseLine.Quantity, FoundPurchaseLine."Line Amount");
        end;

    end;

    local procedure GetNexLineNo(PurchaseLine: Record "Purchase Line"): Integer
    var
        FoundPurchaseLine: Record "Purchase Line";
    begin
        FoundPurchaseLine.SetRange("Document Type", PurchaseLine."Document Type");
        FoundPurchaseLine.SetRange("Document No.", PurchaseLine."Document No.");
        if FoundPurchaseLine.FindLast() then
            exit(FoundPurchaseLine."Line No." + 10000);
        exit(10000);

    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", 'OnAfterCopyFromPurchRcptLine', '', false, false)]
    LOCAL procedure T121OnAfterCopyFromPurchRcptLine(VAR PurchaseLine: Record "Purchase Line"; PurchRcptLine: Record "Purch. Rcpt. Line")
    begin
        PurchaseLine."MICA AL No." := PurchRcptLine."MICA AL No.";
        PurchaseLine."MICA AL Line No." := PurchRcptLine."MICA AL Line No.";

    end;


    procedure SetHeadersDef(var HeadersDefIn: array[3] of Boolean)
    begin
        CopyArray(HeadersDef, HeadersDefIn, 1);

    end;

    procedure SetPurchHeader(InPurchaseHeader: Record "Purchase Header"; InMICAFlowEntry: Record "MICA Flow Entry")
    begin
        PurchaseHeader := InPurchaseHeader;
        MICAFlowEntry := InMICAFlowEntry;
    end;

    procedure SetPurchaseHeaderRebill(InPurchaseHeader: Record "Purchase Header")
    begin
        RebillPurchaseHeader := InPurchaseHeader;

    end;
}