codeunit 80640 "MICA Extension Upg Management"
{
    Subtype = Upgrade;
    Permissions = tabledata "MICA Financial Reporting Setup" = rm, tabledata "Cust. Ledger Entry" = rm, tabledata "Detailed Cust. Ledg. Entry" = rm, tabledata "Value Entry" = rm, tabledata Item = rm, tabledata "MICA Rebate Recalc. Entry" = rm, tabledata "G/L Entry" = rm;


    trigger OnRun()
    begin
    end;

    trigger OnUpgradePerCompany()
    begin
        SetNewSTE4Filters();
        SetDueDateBuffer();
        UpgradeCustomerRequest();
        CleanOFFInvoiceLines();
        SetItemStarRating();
        SetSellToCustomerNo();
        InitLastArchSLRunDate();
        UpgradeAutoItemOffInvoice();
        InitContainerIDRawInASnFlowBuffer();
        InitItemECCNCodeAndCustomDates();
        InitTypeOfTransactionInGLEntry();
        InitCustomerDiscGroupRebateRecalcEntry();
        InitDefaultRPLStatus();
        InitMicaSourceDocLineInRebateLines();
        UpdateRecordIdPart1();
        UpgradeFlux2Buffer();
    end;

    local procedure UpgradeFlux2Buffer()
    var
        MICAFLUX2Buffer: Record "MICA FLUX2 Buffer";
        MICAFLUX2Buffer2: Record "MICA FLUX2 Buffer2";
        UpgradeTag: Codeunit "Upgrade Tag";
        UpgradeFlux2BufferTagLbl: Label 'CC-1611-REP-FLUX2-UpgradeFlux2Buffer-20210617', Locked = true;
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeFlux2BufferTagLbl) then
            exit;

        if MICAFLUX2Buffer.FindSet() then
            repeat
                MICAFLUX2Buffer2.Init();
                MICAFLUX2Buffer2.TransferFields(MICAFLUX2Buffer);
                MICAFLUX2Buffer2.Insert();
            until MICAFLUX2Buffer.Next() = 0;

        UpgradeTag.SetUpgradeTag(UpgradeFlux2BufferTagLbl);
    end;

    local procedure InitDefaultRPLStatus()
    var
        Customer: Record Customer;
        ShiptoAddress: Record "Ship-to Address";
        UpgradeTag: Codeunit "Upgrade Tag";
        InitDefaultRPLStatusTagLbl: Label 'CC-1596-O2C-024-InitRPLStatus', Locked = true;
    begin
        if UpgradeTag.HasUpgradeTag(InitDefaultRPLStatusTagLbl) then
            exit;


        Customer.SetFilter("MICA RPL Status", '<>%1', '');
        if Customer.FindSet(true, true) then
            repeat
                Customer.Validate("MICA RPL Status", '');
                Customer.Modify();
            until Customer.Next() = 0;


        ShiptoAddress.SetFilter("MICA RPL Status", '<>%1', '');
        if ShiptoAddress.FindSet(true, true) then
            repeat
                ShiptoAddress.Validate("MICA RPL Status", '');
                ShiptoAddress.Modify();
            until ShiptoAddress.Next() = 0;

        UpgradeTag.SetUpgradeTag(InitDefaultRPLStatusTagLbl);
    end;

    local procedure InitTypeOfTransactionInGLEntry()
    var
        GLEntry: Record "G/L Entry";
        UpdateGLEntry: Record "G/L Entry";
        UpgradeTag: Codeunit "Upgrade Tag";
        FirstDayOfMonth: Date;
        LastDayOfMonth: Date;
        ModifyRec: Boolean;
        InitTypeOfTransactionGLEntryUpgradeTagLbl: Label 'CC-984-REPF336-InitTypeOfTransactionGLEntryLabel-20210113', Locked = true;
    begin
        if UpgradeTag.HasUpgradeTag(InitTypeOfTransactionGLEntryUpgradeTagLbl) then
            exit;

        GLEntry.SetCurrentKey("MICA Type Of Transaction");
        GLEntry.SetRange("MICA Type Of Transaction", GLEntry."MICA Type Of Transaction"::"Manual Adjustment");
        GLEntry.SetFilter("MICA Rebate Code", '<>%1', '');
        if GLEntry.FindSet() then
            repeat
                ModifyRec := false;
                UpdateGLEntry.Get(GLEntry."Entry No.");

                FirstDayOfMonth := CalcDate('<-CM>', GLEntry."Posting Date");
                LastDayOfMonth := CalcDate('<CM>', GLEntry."Posting Date");

                case true of
                    GLEntry."Posting Date" = FirstDayOfMonth:
                        begin
                            UpdateGLEntry."MICA Type Of Transaction" := UpdateGLEntry."MICA Type Of Transaction"::"Rebate Reversal";
                            ModifyRec := true;
                        end;
                    GLEntry."Posting Date" = LastDayOfMonth:
                        begin
                            UpdateGLEntry."MICA Type Of Transaction" := UpdateGLEntry."MICA Type Of Transaction"::"Rebate Creation";
                            ModifyRec := true;
                        end;
                end;
                if ModifyRec then
                    UpdateGLEntry.Modify();
            until GLEntry.Next() = 0;

        UpgradeTag.SetUpgradeTag(InitTypeOfTransactionGLEntryUpgradeTagLbl);
    end;

    local procedure InitCustomerDiscGroupRebateRecalcEntry()
    var
        Customer: Record Customer;
        MICARebateRecalcEntry: Record "MICA Rebate Recalc. Entry";
        UpgradeTag: Codeunit "Upgrade Tag";
        InitCustomerDiscGroupRebateRecaclEntryTagLbl: Label 'CC-1568-O2C-054-InitCustomerDiscGroupRebateRecalcEntry', Locked = true;
    begin
        if UpgradeTag.HasUpgradeTag(InitCustomerDiscGroupRebateRecaclEntryTagLbl) then
            exit;

        if MICARebateRecalcEntry.FindSet() then
            repeat
                Customer.Get(MICARebateRecalcEntry."Customer No.");

                MICARebateRecalcEntry."Customer Discount Group" := Customer."Customer Disc. Group";
                MICARebateRecalcEntry.Modify();
            until MICARebateRecalcEntry.Next() = 0;

        UpgradeTag.SetUpgradeTag(InitCustomerDiscGroupRebateRecaclEntryTagLbl);
    end;

    local procedure InitItemECCNCodeAndCustomDates()
    var
        Item: Record Item;
        UpgradeTag: Codeunit "Upgrade Tag";
        InitItemECCNCodeAndCustomDatesUpgradeTagLbl: Label 'CC-1132-O2C026- InitItemECCNCodeAndCustomDates-202101130', Locked = true;
    begin
        if UpgradeTag.HasUpgradeTag(InitItemECCNCodeAndCustomDatesUpgradeTagLbl) then
            exit;

        if Item.FindSet() then
            repeat
                Item.Validate("MICA Military ECCN Code2", Item."MICA Military ECCN Code");
                Evaluate(Item."MICA Custom Start Date2", Item."MICA Custom Start Date");
                Evaluate(Item."MICA Custom End Date2", Item."MICA Custom End Date");
                Item.Modify();
            until Item.Next() = 0;

        UpgradeTag.SetUpgradeTag(InitItemECCNCodeAndCustomDatesUpgradeTagLbl);
    end;

    local procedure InitContainerIDRawInASnFlowBuffer()
    var
        MICAFlowBufferASN: Record "MICA Flow Buffer ASN";
        ToUpdateMICAFlowBufferASN: Record "MICA Flow Buffer ASN";
        UpgradeTag: Codeunit "Upgrade Tag";
        InitContainerIDRawUpgradeTagLbl: label 'CC-982-DOO002-InitContainerIDRawInASnFlowBuffer-20201203', Locked = true;
    begin
        IF UpgradeTag.HasUpgradeTag(InitContainerIDRawUpgradeTagLbl) THEN
            exit;

        MICAFlowBufferASN.SetCurrentKey("Container ID", "Container ID Raw");
        MICAFlowBufferASN.SetFilter("Container ID", '<>%1', '');
        MICAFlowBufferASN.SetFilter("Container ID Raw", '=%1', '');
        if MICAFlowBufferASN.FindSet(false, false) then
            repeat
                if ToUpdateMICAFlowBufferASN.get(MICAFlowBufferASN."Flow Code", MICAFlowBufferASN."Flow Entry No.", MICAFlowBufferASN."Entry No.") then begin
                    ToUpdateMICAFlowBufferASN."Container ID Raw" := MICAFlowBufferASN."Container ID";
                    ToUpdateMICAFlowBufferASN.Modify(false);
                end;
            until MICAFlowBufferASN.next() = 0;

        UpgradeTag.SetUpgradeTag(InitContainerIDRawUpgradeTagLbl);
    end;

    local procedure InitLastArchSLRunDate()
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        UpgradeTag: Codeunit "Upgrade Tag";
        InitLastArchSLRunDateLbl: Label 'CC-888-O2C062-InitLastArchSORunDate-20201015', Locked = true;
    begin
        IF UpgradeTag.HasUpgradeTag(InitLastArchSLRunDateLbl) THEN
            EXIT;

        if not GeneralLedgerSetup.Get() then
            exit;

        GeneralLedgerSetup."MICA Last DateTime SO Archive" := CurrentDateTime();
        GeneralLedgerSetup.Modify(true);

        UpgradeTag.SetUpgradeTag(InitLastArchSLRunDateLbl);
    end;

    local procedure SetNewSTE4Filters()
    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        UpgradeTag: Codeunit "Upgrade Tag";
        NewSTE4FilterTagNameLbl: Label 'CC-1378-STE4-ChangeFilterDataType-20200212', Locked = true;
    begin
        IF UpgradeTag.HasUpgradeTag(NewSTE4FilterTagNameLbl) THEN
            EXIT;

        if not MICAFinancialReportingSetup.Get() then
            exit;

        MICAFinancialReportingSetup."STE4 Posting Group Filter" := MICAFinancialReportingSetup."STE4 Posting Group";
        MICAFinancialReportingSetup."STE4 LOANS Pst. Group Filter" := MICAFinancialReportingSetup."STE4 LOANS Posting Grp Filter";
        MICAFinancialReportingSetup.Modify(false);
        MICAFinancialReportingSetup."STE4 Posting Group" := '';
        MICAFinancialReportingSetup."STE4 LOANS Posting Grp Filter" := '';
        MICAFinancialReportingSetup.Modify(false);

        UpgradeTag.SetUpgradeTag(NewSTE4FilterTagNameLbl);

    end;

    local procedure SetDueDateBuffer()
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        UpgradeTag: Codeunit "Upgrade Tag";
        InitDueDateBufferTagNameLbl: Label 'CC-680-O2C051-OverdueBuffer-20200611', Locked = true;
    begin
        IF UpgradeTag.HasUpgradeTag(InitDueDateBufferTagNameLbl) THEN
            exit;

        DetailedCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.");

        CustLedgerEntry.Reset();
        if CustLedgerEntry.FindSet() then
            repeat
                CustLedgerEntry."MICA Due Date (Buffer)" := CustLedgerEntry."Due Date";
                CustLedgerEntry.Modify();
                DetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
                DetailedCustLedgEntry.ModifyAll("MICA Initial Due Date (Buffer)", CustLedgerEntry."MICA Due Date (Buffer)");
            until CustLedgerEntry.Next() = 0;

        UpgradeTag.SetUpgradeTag(InitDueDateBufferTagNameLbl);
    end;

    local procedure UpgradeCustomerRequest()
    var
        MICAUpgradeCutomerRequest: Report "MICA Upgrade Cutomer Request";
        UpgradeTag: Codeunit "Upgrade Tag";
        CustomerRequestTagNameLbl: Label 'CC-RedesignCustomerRequest-20200630', Locked = true;
    begin
        if UpgradeTag.HasUpgradeTag(CustomerRequestTagNameLbl) then
            exit;

        MICAUpgradeCutomerRequest.Run();
        UpgradeTag.SetUpgradeTag(CustomerRequestTagNameLbl);
    end;

    local procedure CleanOFFInvoiceLines()
    var
        MICANewAppliedSLDiscount: Record "MICA New Applied SL Discount";
        MICAPostedAppliedSLDisc: Record "MICA Posted Applied SL Disc.";
        UpgradeTag: Codeunit "Upgrade Tag";
        CustomerRequestTagNameLbl: Label 'CC-CleanOFFInvoiceLine-20200708', Locked = true;
        localGUID: Guid;

    begin

        if UpgradeTag.HasUpgradeTag(CustomerRequestTagNameLbl) then
            exit;

        if MICANewAppliedSLDiscount.FindSet() then
            repeat
                clear(localGUID);
                if (StrLen(MICANewAppliedSLDiscount."Document No.") = 20)
                    and (Evaluate(localGUID, MICANewAppliedSLDiscount."Document No." + '000-000000000000')) then
                    MICANewAppliedSLDiscount.Delete();
            until MICANewAppliedSLDiscount.Next() = 0;

        if MICAPostedAppliedSLDisc.FindSet() then
            repeat
                clear(localGUID);
                if (StrLen(MICAPostedAppliedSLDisc."Document No.") = 20)
                    and (Evaluate(localGUID, MICAPostedAppliedSLDisc."Document No." + '000-000000000000')) then
                    MICAPostedAppliedSLDisc.Delete();
            until MICAPostedAppliedSLDisc.Next() = 0;

        UpgradeTag.SetUpgradeTag(CustomerRequestTagNameLbl);
    end;

    local procedure UpgradeAutoItemOffInvoice()
    var
        UpgradeTag: Codeunit "Upgrade Tag";
        AutoOffInvoiceSetupTagLbl: Label 'CC-O2C056-OffInvoiceAutoSetup-20201117';
    begin
        if UpgradeTag.HasUpgradeTag(AutoOffInvoiceSetupTagLbl) then
            exit;

        UpdateAutoItemOffInvoice();

        UpgradeTag.SetUpgradeTag(AutoOffInvoiceSetupTagLbl);
    end;

    local procedure UpdateAutoItemOffInvoice()
    var
        Item: Record Item;
    begin
        Item.SetRange("MICA Auto Off-Invoice Setup", false);
        if Item.FindSet() then
            repeat
                Item.Validate("MICA Auto Off-Invoice Setup", true);
                Item.Modify();
            until Item.Next() = 0;
    end;

    local procedure SetItemStarRating()
    var
        UpgradeTag: Codeunit "Upgrade Tag";
        ItemStarRatingTagNameLbl: Label 'CC-616-ItemStarRating-20201117';
    begin
        if UpgradeTag.HasUpgradeTag(ItemStarRatingTagNameLbl) then
            exit;

        UpdateItemStarRating();

        UpgradeTag.SetUpgradeTag(ItemStarRatingTagNameLbl);
    end;

    local procedure UpdateItemStarRating()
    var
        Item: Record Item;
    begin
        if Item.FindSet() then
            repeat
                Item."MICA Star Rating" := Item."MICA Star Sating";
                Item.Modify();
            until Item.Next() = 0;
    end;

    local procedure SetSellToCustomerNo()
    var
        UpgradeTag: Codeunit "Upgrade Tag";
        InitSellToCustomerNoTagLbl: Label 'CC-FIN005B-RebatesManagementNonFinancial-20201022';
    begin
        if UpgradeTag.HasUpgradeTag(InitSellToCustomerNoTagLbl) then
            exit;

        UpdateValueEntry();

        UpgradeTag.SetUpgradeTag(InitSellToCustomerNoTagLbl);
    end;

    local procedure UpdateValueEntry()
    var
        ValueEntry: Record "Value Entry";
    begin

        ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
        ValueEntry.SetFilter("Document Type", '%1|%2|%3|%4', ValueEntry."Document Type"::"Sales Invoice", ValueEntry."Document Type"::"Sales Credit Memo",
            ValueEntry."Document Type"::"Sales Shipment", ValueEntry."Document Type"::"Sales Return Receipt");
        ValueEntry.SetFilter("MICA Sell-to Customer No.", '%1', '');
        ValueEntry.SetRange("Source Type", ValueEntry."Source Type"::Customer);
        if ValueEntry.IsEmpty() then
            exit;

        if ValueEntry.FindSet() then
            repeat
                UpdateSellToCustomerNo(ValueEntry);
            until ValueEntry.Next() = 0;
    end;

    local procedure UpdateSellToCustomerNo(var ValueEntry: Record "Value Entry")
    var
        SalesPostDocRecordRef: RecordRef;
        DocumentNoFilterFieldRef: FieldRef;
        SellToCustNoFieldRef: FieldRef;
    begin
        Case ValueEntry."Document Type" of
            ValueEntry."Document Type"::"Sales Invoice":
                SalesPostDocRecordRef.Open(Database::"Sales Invoice Header");
            ValueEntry."Document Type"::"Sales Credit Memo":
                SalesPostDocRecordRef.Open(Database::"Sales Cr.Memo Header");
            ValueEntry."Document Type"::"Sales Shipment":
                SalesPostDocRecordRef.Open(Database::"Sales Shipment Header");
            ValueEntry."Document Type"::"Sales Return Receipt":
                SalesPostDocRecordRef.Open(Database::"Return Receipt Header");
        end;

        DocumentNoFilterFieldRef := SalesPostDocRecordRef.Field(3);
        DocumentNoFilterFieldRef.SetFilter(ValueEntry."Document No.");
        if SalesPostDocRecordRef.FindFirst() then begin
            SellToCustNoFieldRef := SalesPostDocRecordRef.Field(2);
            ValueEntry.Validate("MICA Sell-to Customer No.", SellToCustNoFieldRef.Value());
            ValueEntry.Modify();
        end;
        SalesPostDocRecordRef.Close();
    end;

    local procedure InitMicaSourceDocLineInRebateLines()
    var
        AppliedSLDiscount: Record "MICA New Applied SL Discount";
        PostedAppliedSLDiscount: Record "MICA Posted Applied SL Disc.";
        SalesCrMemoLine: Record "Sales Line";
        PostedSalesCrMemoLine: Record "Sales Cr.Memo Line";
        ValueEntry: Record "Value Entry";
        UpgradeTag: Codeunit "Upgrade Tag";
        SourceDocLineTagNameLbl: Label 'CC-O2C053-InitRebateSourceDocLineNo-20210428', Locked = true;
    begin
        IF UpgradeTag.HasUpgradeTag(SourceDocLineTagNameLbl) THEN
            EXIT;

        AppliedSLDiscount.SetCurrentKey("Document Type", "Document No.", "Document Line No.", "Rebates Type", Code);
        AppliedSLDiscount.SetRange("Document Type", AppliedSLDiscount."Document Type"::"Credit Memo");
        AppliedSLDiscount.SetFilter("MICA Source Document No.", '<>%1', '');
        if AppliedSLDiscount.FindSet(true) then
            repeat
                if SalesCrMemoLine.get(SalesCrMemoLine."Document Type"::"Credit Memo", AppliedSLDiscount."Document No.", AppliedSLDiscount."Document Line No.") then begin
                    ValueEntry.SetCurrentKey("Item Ledger Entry No.", "Entry Type");
                    ValueEntry.SetRange("Item Ledger Entry No.", SalesCrMemoLine."Appl.-from Item Entry");
                    ValueEntry.SetRange("Entry Type", ValueEntry."Entry Type"::"Direct Cost");
                    ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
                    ValueEntry.SetRange("Document No.", AppliedSLDiscount."MICA Source Document No.");
                    if ValueEntry.FindFirst() then begin
                        AppliedSLDiscount."MICA Source Doc. Line No." := ValueEntry."Document Line No.";
                        AppliedSLDiscount.Modify();
                    end;
                end;
            until AppliedSLDiscount.Next() = 0;

        PostedAppliedSLDiscount.SetCurrentKey("Document Type", "Document No.", "Document Line No.", "Rebates Type", Code);
        PostedAppliedSLDiscount.SetRange("Document Type", PostedAppliedSLDiscount."Document Type"::"Credit Memo");
        PostedAppliedSLDiscount.SetFilter("MICA Source Document No.", '<>%1', '');
        if PostedAppliedSLDiscount.FindSet(true) then
            repeat
                if PostedSalesCrMemoLine.get(PostedAppliedSLDiscount."Posted Document No.", PostedAppliedSLDiscount."Posted Document Line No.") then begin
                    ValueEntry.SetCurrentKey("Item Ledger Entry No.", "Entry Type");
                    ValueEntry.SetRange("Item Ledger Entry No.", PostedSalesCrMemoLine."Appl.-from Item Entry");
                    ValueEntry.SetRange("Entry Type", ValueEntry."Entry Type"::"Direct Cost");
                    ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
                    ValueEntry.SetRange("Document No.", PostedAppliedSLDiscount."MICA Source Document No.");
                    if ValueEntry.FindFirst() then begin
                        PostedAppliedSLDiscount."MICA Source Doc. Line No." := ValueEntry."Document Line No.";
                        PostedAppliedSLDiscount.Modify();
                    end;
                end;
            until PostedAppliedSLDiscount.Next() = 0;

        UpgradeTag.SetUpgradeTag(SourceDocLineTagNameLbl);
    end;

    local procedure UpdateRecordIdPart1()
    var
        Item: Record Item;
        Customer: Record Customer;
        UpgradeTag: Codeunit "Upgrade Tag";
        UpdateTag: Label 'CC-WIT1726-Part1', Locked = true;
    begin
        if UpgradeTag.HasUpgradeTag(UpdateTag) then
            exit;

        if Item.FindSet(true) then
            repeat
                if IsNullGuid(Item.id) then begin
                    Item.id := Item.SystemId;
                    Item.Modify();
                end
            until Item.Next() = 0;

        if Customer.FindSet(true) then
            repeat
                if IsNullGuid(Customer.id) then begin
                    Customer.id := Customer.SystemId;
                    Customer.Modify();
                end
            until Customer.Next() = 0;

        UpgradeTag.SetUpgradeTag(UpdateTag);
    end;


}