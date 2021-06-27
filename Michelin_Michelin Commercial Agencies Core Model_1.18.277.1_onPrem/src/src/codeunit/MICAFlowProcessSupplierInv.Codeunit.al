codeunit 82021 "MICA Flow Process Supplier Inv"
{
    //INTGIS001 – Supplier Invoice Integration
    TableNo = "MICA Flow Entry";

    var
        IGINVFirmLbl: Label 'IG_INV_Firm', Locked = true;
        IGINVRebillLbl: Label 'IG_INV_Rebill', Locked = true;
        IGCMLbl: Label 'IG_CM', Locked = true;
        TechnicalACKFlowLbl: Label 'TECHNICALACKFLOW', Locked = true;
        FunctioinalACKFlowLbl: Label 'FUNCTIONALACKFLOW', Locked = true;
        ReasonReBillLbl: Label 'REASONREBILL', Locked = true;
        EAPINV018Lbl: Label 'EAPINV018', Locked = true;
        EAPINV019Lbl: Label 'EAPINV019', Locked = true;
        EAPINV021Lbl: Label 'EAPINV021', Locked = true;
        EAPINV023Lbl: Label 'EAPINV023', Locked = true;
        EAPINV025Lbl: Label 'EAPINV025', Locked = true;
        EAPINV029Lbl: Label 'EAPINV029', Locked = true;
        EAPINV031Lbl: Label 'EAPINV031', Locked = true;
        EAPINV032Lbl: Label 'EAPINV032', Locked = true;
        EAPINV035Lbl: Label 'EAPINV035', Locked = true;
        EAPINV036Lbl: Label 'EAPINV036', Locked = true;
        EAPINV039Lbl: Label 'EAPINV039', Locked = true;
        EAPINV047Lbl: Label 'EAPINV047', Locked = true;
        EAPINV049Lbl: Label 'EAPINV049', Locked = true;
        EAPINVXXXLbl: Label 'EAPINVXXX', Locked = true;
        LOGICALIDLbl: Label 'LOGICALID', Locked = true;
        COMPONENTLbl: Label 'COMPONENT', Locked = true;
        TASKLbl: Label 'TASK', Locked = true;
        LANGUAGELbl: Label 'LANGUAGE', Locked = true;
        DESCRIPTNLbl: Label 'DESCRIPTN', Locked = true;
        FILENAMINGLbl: Label 'FILENAMING', Locked = true;
        BSC_PROCESSINGLbl: Label 'BSC_PROCESSING', Locked = true;
        Param_GISAPINVTECHACKLbl: Label 'GIS_AP_INV_TECH_ACK', Locked = true;
        ParamGISAPINVFCTACKLbl: Label 'GIS_AP_INV_FCT_ACK', Locked = true;
        IncorrectValueLbl: Label 'Incorrect Value: %1=%2.';
        UpdateErrorLbl: Label 'Error while updating record %1 %2.';
        IncorrectDocumentTypeErr: Label 'Incorrect document type %1 %2.';

    trigger OnRun()
    var
        MICAFlow: Record "MICA Flow";
        MICAFlowInformation: Record "MICA Flow Information";
        ProcessStartedLbl: Label 'Process started.';
        ProcessFinishedLbl: Label 'Process terminated : %1 record(s) processed / %2';
        ProcessAbortedLbl: Label 'Process aborted : %1 error(s) found.';
        UpdateCount: Integer;
        BufferCount: Integer;
    begin
        UpdateCount := 0;
        BufferCount := 0;
        MICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Information, ProcessStartedLbl, ''));
        MICAFlow.Get(Rec."Flow Code");

        CheckFinancialReportingSetup(Rec);

        CheckBufferData(Rec);

        Rec.CalcFields("Error Count");
        if not MICAFlow."Allow Partial Processing" then
            if Rec."Error Count" > 0 then begin
                MICAFlowInformation.Update('', '');
                Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ProcessAbortedLbl, Rec."Error Count"), '');
                exit;
            end;

        InsertAndPostPurchaseData(Rec);

        Rec.AddInformation(MICAFlowInformation."Info Type"::information, StrSubstNo(ProcessFinishedLbl, format(UpdateCount), Format(BufferCount)), '');
        MICAFlowInformation.Update('', '');
    end;

    local procedure CheckBufferData(MICAFlowEntry: Record "MICA Flow Entry")
    var
        MICAFlow: Record "MICA Flow";
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv.";
        LinesAmount: Decimal;
        BufferCountLbl: Label '%1 buffer record(s) to process.';
    begin
        MICAFlowBufferSupplierInv.SetRange("Flow Code", MICAFlowEntry."Flow Code");
        MICAFlowBufferSupplierInv.SetRange("Flow Entry No.", MICAFlowEntry."Entry No.");
        MICAFlowBufferSupplierInv.SetRange("Skip Line", false);
        MICAFlowInformation."Description 2" := StrSubstNo(BufferCountLbl, MICAFlowBufferSupplierInv.Count());
        if MICAFlowBufferSupplierInv.FindSet() then begin
            MICAFlow.Get(MICAFlowEntry."Flow Code");
            CheckACKParameters(MICAFlow);
            repeat
                CheckLine(MICAFlowEntry, MICAFlowBufferSupplierInv, MICAFlow, LinesAmount);
            until MICAFlowBufferSupplierInv.Next() = 0;

            CheckHeader(MICAFlowEntry, MICAFlowBufferSupplierInv, MICAFlow, LinesAmount);
        end;
    end;

    local procedure InsertAndPostPurchaseData(MICAFlowEntry: Record "MICA Flow Entry")
    var
        PurchaseHeader: Record "Purchase Header";
        FoundPurchaseHeader: Record "Purchase Header";
        RebillPurchaseHeader: Record "Purchase Header";
        MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv.";
        HeadersDef: array[3] of Boolean;
        HeaderInserted: Boolean;
    begin
        MICAFlowBufferSupplierInv.Reset();
        MICAFlowBufferSupplierInv.SetAutoCalcFields("Error Count");
        MICAFlowBufferSupplierInv.SetRange("Flow Code", MICAFlowEntry."Flow Code");
        MICAFlowBufferSupplierInv.SetRange("Flow Entry No.", MICAFlowEntry."Entry No.");
        MICAFlowBufferSupplierInv.SetRange("Skip Line", false);
        if MICAFlowBufferSupplierInv.FindSet() then begin
            repeat
                if MICAFlowBufferSupplierInv."Error Count" = 0 then begin
                    Commit();

                    InsertPurchaseHeader(MICAFlowEntry, MICAFlowBufferSupplierInv, PurchaseHeader, RebillPurchaseHeader, HeaderInserted, HeadersDef);
                    if HeaderInserted then
                        InsertPurchaseLines(MICAFlowEntry, MICAFlowBufferSupplierInv, PurchaseHeader, RebillPurchaseHeader, HeadersDef);

                end;
            until MICAFlowBufferSupplierInv.Next() = 0;

            SendFunctionalACK(FoundPurchaseHeader, MICAFlowBufferSupplierInv);

            FoundPurchaseHeader.Get(PurchaseHeader."Document Type", PurchaseHeader."No.");
            CODEUNIT.RUN(CODEUNIT::"Purch.-Post", FoundPurchaseHeader);

            if HeadersDef[3] then begin
                FoundPurchaseHeader.Get(RebillPurchaseHeader."Document Type", RebillPurchaseHeader."No.");
                CODEUNIT.RUN(CODEUNIT::"Purch.-Post", RebillPurchaseHeader);
            end;
        end;
    end;

    local procedure CheckHeader(MICAFlowEntry: Record "MICA Flow Entry"; var MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv."; MICAFlow: Record "MICA Flow"; LinesAmount: Decimal)
    var
        MICAFlowInformation: Record "MICA Flow Information";
        ParamMICAFlowSetup: Record "MICA Flow Setup";
        PaymentTerms: Record "Payment Terms";
        Vendor: Record Vendor;
        CountryRegion: Record "Country/Region";
        Currency: Record Currency;
        PurchaseHeader: Record "Purchase Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        GISInvoiceDocDate: Date;
    Begin
        if not EvaluateRawDecToDec(MICAFlowBufferSupplierInv."Total Amount", MICAFlowBufferSupplierInv."Total Amount RAW") then
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
              StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINV019Lbl), MICAFlowBufferSupplierInv."Line Charge Amount RAW"), EAPINV019Lbl);

        if not EvaluateRawDateToDate(MICAFlowBufferSupplierInv."Document Date", MICAFlowBufferSupplierInv.YEAR + MICAFlowBufferSupplierInv.MONTH + MICAFlowBufferSupplierInv.DAY) then
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
              StrSubstNo(IncorrectValueLbl, ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINV036Lbl),
                MICAFlowBufferSupplierInv.YEAR + MICAFlowBufferSupplierInv.MONTH + MICAFlowBufferSupplierInv.DAY),
                EAPINV036Lbl);

        if not Evaluate(GISInvoiceDocDate, MICAFlowBufferSupplierInv."MICH.ORIGINVDATE", 9) then
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
              StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINVXXXLbl), StrSubstNo(IncorrectValueLbl, MICAFlowBufferSupplierInv.FieldCaption("MICH.ORIGINVDATE"), MICAFlowBufferSupplierInv."MICH.ORIGINVDATE")), EAPINVXXXLbl);

        UpdateBuffSupplierInvCommonData(MICAFlowBufferSupplierInv);

        case MICAFlowBufferSupplierInv.DOCTYPE of
            IGINVFirmLbl,
            IGINVRebillLbl:
                begin
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Invoice);
                    PurchaseHeader.SetRange("Vendor Invoice No.", MICAFlowBufferSupplierInv."Vendor Invoice No.");
                    if not PurchaseHeader.IsEmpty() then
                        MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
                          StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINV018Lbl), MICAFlowBufferSupplierInv."Vendor Invoice No."), EAPINV018Lbl);

                    PurchInvHeader.SetRange("Vendor Invoice No.", MICAFlowBufferSupplierInv."Vendor Invoice No.");
                    if not PurchInvHeader.IsEmpty() then
                        MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
                          StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINV018Lbl), MICAFlowBufferSupplierInv."Vendor Invoice No."), EAPINV018Lbl);

                    if MICAFlowBufferSupplierInv."Total Amount" <= 0 then
                        MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
                          StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINV019Lbl), MICAFlowBufferSupplierInv."Total Amount Raw"), EAPINV019Lbl);
                end;
            IGCMLbl:
                begin
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::"Credit Memo");
                    PurchaseHeader.SetRange("Vendor Cr. Memo No.", MICAFlowBufferSupplierInv."Vendor Invoice No.");
                    if not PurchaseHeader.IsEmpty() then
                        MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
                          StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINV018Lbl), MICAFlowBufferSupplierInv."Vendor Invoice No."), EAPINV018Lbl);

                    if MICAFlowBufferSupplierInv."Total Amount" >= 0 then
                        MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
                          StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINV019Lbl), MICAFlowBufferSupplierInv."Total Amount Raw"), EAPINV019Lbl);
                end;
            else
                MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
                  StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINVXXXLbl),
                  StrSubstNo(IncorrectDocumentTypeErr, MICAFlowBufferSupplierInv.FieldCaption(DOCTYPE), MICAFlowBufferSupplierInv.DOCTYPE)), EAPINVXXXLbl);
        end;

        // Check if the sum of lines amounts is equal to 'MICA Total Inv. Amt.(excl.VAT)'
        if LinesAmount <> MICAFlowBufferSupplierInv."Total Amount" then
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
              StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINV019Lbl), MICAFlowBufferSupplierInv."Total Amount"), EAPINV019Lbl);

        if not Vendor.Get(MICAFlowBufferSupplierInv."Supplier PARTNERID") then
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
              StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINV021Lbl), MICAFlowBufferSupplierInv."Supplier PARTNERID"), EAPINV021Lbl);
        if not Vendor.Get(MICAFlowBufferSupplierInv."BillTo PARTNERID") then
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
              StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINV021Lbl), MICAFlowBufferSupplierInv."BillTo PARTNERID"), EAPINV021Lbl);

        if not CountryRegion.Get(MICAFlowBufferSupplierInv."BillTo COUNTRY") then
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
              StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINVXXXLbl), StrSubstNo(IncorrectValueLbl, MICAFlowBufferSupplierInv.FieldCaption("BillTo COUNTRY"), MICAFlowBufferSupplierInv."BillTo COUNTRY")), EAPINVXXXLbl);
        if not CountryRegion.Get(MICAFlowBufferSupplierInv."Supplier COUNTRY") then
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
              StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINVXXXLbl), StrSubstNo(IncorrectValueLbl, MICAFlowBufferSupplierInv.FieldCaption("Supplier COUNTRY"), MICAFlowBufferSupplierInv."Supplier COUNTRY")), EAPINVXXXLbl);

        if not Currency.Get(MICAFlowBufferSupplierInv.CURRENCY) then
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
              StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINV023Lbl), MICAFlowBufferSupplierInv.CURRENCY), EAPINV023Lbl);

        PaymentTerms.SetRange("MICA GIS Payment Term Code", MICAFlowBufferSupplierInv.TERMID);
        if PaymentTerms.IsEmpty() then
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
              StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINV025Lbl), MICAFlowBufferSupplierInv.TERMID), EAPINV025Lbl);

        if GenJnlCheckLine.DateNotAllowed(MICAFlowBufferSupplierInv."Document Date") then
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
              StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINV029Lbl), MICAFlowBufferSupplierInv."Document Date"), EAPINV029Lbl);

        if MICAFlowBufferSupplierInv.RELFACTCODE = '' then
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
              CopyStr(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINV035Lbl), 1, 250), EAPINV035Lbl);


        MICAFlowBufferSupplierInv.Modify();

        SendTechnicalACK(PurchaseHeader, MICAFlowBufferSupplierInv);
    end;

    local procedure CheckLine(MICAFlowEntry: Record "MICA Flow Entry"; var MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv."; MICAFlow: Record "MICA Flow"; var LinesAmount: Decimal)
    var
        ParamMICAFlowSetup: Record "MICA Flow Setup";
        MICAFlowInformation: Record "MICA Flow Information";
        IncorrectValue2Lbl: Label '%1=%2. %3=%4';
    Begin
        if MICAFlowBufferSupplierInv."Line No." <> '' then begin
            CheckInvLine(MICAFlowEntry, MICAFlowBufferSupplierInv, MICAFlow, LinesAmount);
            exit;
        end;

        if MICAFlowBufferSupplierInv."Freight Line No." <> '' then begin
            CheckChargeLine(MICAFlowEntry, MICAFlowBufferSupplierInv, MICAFlow, LinesAmount);
            exit;
        end;

        MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
          StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINVXXXLbl),
            StrSubstNo(IncorrectValue2Lbl,
             MICAFlowBufferSupplierInv.FieldCaption(MICAFlowBufferSupplierInv."Line No."), MICAFlowBufferSupplierInv."Line No.",
             MICAFlowBufferSupplierInv.FieldCaption("Freight Line No."), MICAFlowBufferSupplierInv."Freight Line No.")), EAPINVXXXLbl);
    end;

    local procedure CheckInvLine(MICAFlowEntry: Record "MICA Flow Entry"; var MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv."; MICAFlow: Record "MICA Flow"; var LinesAmount: Decimal)
    var
        ParamMICAFlowSetup: Record "MICA Flow Setup";
        MICAFlowInformation: Record "MICA Flow Information";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchRcptLineLbl: Label '%1%2', Comment = '%1%2', Locked = true;
    begin
        if MICAFlowBufferSupplierInv.DOCTYPE = IGINVFirmLbl then begin
            PurchRcptLine.SetFilter("MICA AL No.", StrSubstNo(PurchRcptLineLbl, CopyStr(MICAFlowBufferSupplierInv."Line DocumentID2", 1, 9), '*'));
            if PurchRcptLine.IsEmpty() then
                MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
                  StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINV031Lbl), MICAFlowBufferSupplierInv.FieldCaption("Line DocumentID2"), MICAFlowBufferSupplierInv."Line DocumentID2"), EAPINV031Lbl);

            PurchRcptLine.SetRange("MICA AL Line No.", MICAFlowBufferSupplierInv."Line Linenum2");
            if PurchRcptLine.IsEmpty() then
                MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
                  StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINV032Lbl), MICAFlowBufferSupplierInv.FieldCaption("Line Linenum2"), MICAFlowBufferSupplierInv."Line Linenum2"), EAPINV032Lbl);
        end;

        if not EvaluateRawDecToDec(MICAFlowBufferSupplierInv."Line OPERAMT", MICAFlowBufferSupplierInv."Line OPERAMT Raw") or (MICAFlowBufferSupplierInv."Line OPERAMT" = 0) then
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
              StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINV039Lbl), StrSubstNo(IncorrectValueLbl, MICAFlowBufferSupplierInv.FieldCaption("Line OPERAMT"), MICAFlowBufferSupplierInv."Line OPERAMT RAW")), EAPINV039Lbl);

        if not EvaluateRawDecToDec(MICAFlowBufferSupplierInv."Line Quantity", MICAFlowBufferSupplierInv."Line Quantity Raw") then
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
              StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINVXXXLbl), StrSubstNo(IncorrectValueLbl, MICAFlowBufferSupplierInv.FieldCaption("Line Quantity"), MICAFlowBufferSupplierInv."Line Quantity RAW")), EAPINVXXXLbl);

        if not EvaluateRawDecToDec(MICAFlowBufferSupplierInv."Line Neto Weight", MICAFlowBufferSupplierInv."Line MICH.NETMASS Raw") then
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
              StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINVXXXLbl), StrSubstNo(IncorrectValueLbl, MICAFlowBufferSupplierInv.FieldCaption("Line Neto Weight"), MICAFlowBufferSupplierInv."Line MICH.NETMASS RAW")), EAPINVXXXLbl);

        if not EvaluateRawDecToDec(MICAFlowBufferSupplierInv."Line Amount", MICAFlowBufferSupplierInv."Line Amount Raw") then
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
              StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINVXXXLbl), StrSubstNo(IncorrectValueLbl, MICAFlowBufferSupplierInv.FieldCaption("Line Amount"), MICAFlowBufferSupplierInv."Line Amount RAW")), EAPINVXXXLbl)
        else
            case MICAFlowBufferSupplierInv.DOCTYPE of
                IGINVFirmLbl,
                IGINVRebillLbl:
                    if MICAFlowBufferSupplierInv."Line Amount" < 0 then
                        MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
                          StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINV047Lbl), MICAFlowBufferSupplierInv."Line Amount"), EAPINV047Lbl);
                IGCMLbl:
                    if MICAFlowBufferSupplierInv."Line Amount" > 0 then
                        MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
                          StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINV047Lbl), MICAFlowBufferSupplierInv."Line Amount"), EAPINV047Lbl);
            end;


        if not EvaluateRawDecToDec(MICAFlowBufferSupplierInv."Tax Amount", MICAFlowBufferSupplierInv."Tax Amount Raw") then
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
              StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINVXXXLbl), StrSubstNo(IncorrectValueLbl, MICAFlowBufferSupplierInv.FieldCaption("Tax Amount"), MICAFlowBufferSupplierInv."Tax Amount RAW")), EAPINVXXXLbl);

        if not EvaluateRawDecToDec(MICAFlowBufferSupplierInv."Quantity Tax", MICAFlowBufferSupplierInv."Quantity Tax Raw") then
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
              StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINVXXXLbl), StrSubstNo(IncorrectValueLbl, MICAFlowBufferSupplierInv.FieldCaption("Quantity Tax"), MICAFlowBufferSupplierInv."Quantity Tax RAW")), EAPINVXXXLbl);

        LinesAmount += MICAFlowBufferSupplierInv."Line Amount";
        MICAFlowBufferSupplierInv.Modify();
    end;

    local procedure CheckChargeLine(MICAFlowEntry: Record "MICA Flow Entry"; var MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv."; MICAFlow: Record "MICA Flow"; var LinesAmount: Decimal)
    var
        ParamMICAFlowSetup: Record "MICA Flow Setup";
        MICAFlowInformation: Record "MICA Flow Information";
    begin
        if not EvaluateRawDecToDec(MICAFlowBufferSupplierInv."Line Charge Amount", MICAFlowBufferSupplierInv."Line Charge Amount Raw") or (MICAFlowBufferSupplierInv."Line Charge Amount" = 0) then
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
              StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINV049Lbl), MICAFlowBufferSupplierInv."Line Charge Amount RAW"), EAPINV049Lbl)
        else
            case MICAFlowBufferSupplierInv.DOCTYPE of
                IGINVFirmLbl,
                IGINVRebillLbl:
                    if MICAFlowBufferSupplierInv."Line Charge Amount" < 0 then
                        MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
                          StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINV047Lbl), MICAFlowBufferSupplierInv."Line Charge Amount"), EAPINV047Lbl);
                ReasonReBillLbl:
                    if MICAFlowBufferSupplierInv."Line Charge Amount" > 0 then
                        MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
                          StrSubstNo(ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, EAPINV047Lbl), MICAFlowBufferSupplierInv."Line Charge Amount"), EAPINV047Lbl);
            end;

        LinesAmount += MICAFlowBufferSupplierInv."Line Charge Amount";
        MICAFlowBufferSupplierInv.Modify();
    end;

    local procedure InsertPurchaseHeader(MICAFlowEntry: Record "MICA Flow Entry"; MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv."; var PurchaseHeader: Record "Purchase Header";
    var RebillPurchaseHeader: Record "Purchase Header"; var HeaderInserted: Boolean; var HeadersDef: array[3] of Boolean)
    var
        MICAFlowInformation: Record "MICA Flow Information";
        HeaderMICAUpdateSupplierInvoice: Codeunit "MICA Update Supplier Invoice";
    begin
        if HeaderInserted then
            exit;

        if HeaderMICAUpdateSupplierInvoice.Run(MICAFlowBufferSupplierInv) then begin
            HeaderInserted := true;
            HeaderMICAUpdateSupplierInvoice.GetHeadersDef(HeadersDef);
            HeaderMICAUpdateSupplierInvoice.GetPurchaseHeader(PurchaseHeader, MICAFlowEntry);
            HeaderMICAUpdateSupplierInvoice.GetPurchaseHeaderRebillInv(RebillPurchaseHeader);
        end else begin
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error, StrSubstNo(UpdateErrorLbl, format(PurchaseHeader.RecordId()), GetLastErrorText()), BSC_PROCESSINGLbl);
            if RebillPurchaseHeader."No." <> '' then
                MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error, StrSubstNo(UpdateErrorLbl, format(RebillPurchaseHeader.RecordId()), GetLastErrorText()), BSC_PROCESSINGLbl);
        end;
    end;

    local procedure InsertPurchaseLines(MICAFlowEntry: Record "MICA Flow Entry"; MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv.";
    var PurchaseHeader: Record "Purchase Header"; var RebillPurchaseHeader: Record "Purchase Header"; HeadersDef: array[3] of Boolean)
    var
        MICAFlowInformation: Record "MICA Flow Information";
        MICAUpdateSupplierInvLine: Codeunit "MICA Update Supplier Inv. Line";
    begin
        MICAUpdateSupplierInvLine.SetHeadersDef(HeadersDef);

        if HeadersDef[2] then
            MICAUpdateSupplierInvLine.SetPurchHeader(PurchaseHeader, MICAFlowEntry);

        if not HeadersDef[1] and HeadersDef[3] then
            MICAUpdateSupplierInvLine.SetPurchaseHeaderRebill(RebillPurchaseHeader);

        if not MICAUpdateSupplierInvLine.Run(MICAFlowBufferSupplierInv) then
            MICAFlowBufferSupplierInv.AddInformation(MICAFlowEntry, MICAFlowBufferSupplierInv."Entry No.", MICAFlowInformation."Info Type"::Error,
              StrSubstNo(UpdateErrorLbl, MICAFlowBufferSupplierInv."Line DocumentID3" + ' ' + MICAFlowBufferSupplierInv."Line Linenum3", GetLastErrorText()), BSC_PROCESSINGLbl);
    end;

    local procedure UpdateBuffSupplierInvCommonData(MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv.")
    var
        FoundMICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv.";
    begin
        FoundMICAFlowBufferSupplierInv.SetRange("Flow Code", MICAFlowBufferSupplierInv."Flow Code");
        FoundMICAFlowBufferSupplierInv.SetRange("Flow Entry No.", MICAFlowBufferSupplierInv."Flow Entry No.");
        if FoundMICAFlowBufferSupplierInv.FindSet() then
            repeat
                FoundMICAFlowBufferSupplierInv."Total Amount" := MICAFlowBufferSupplierInv."Total Amount";
                FoundMICAFlowBufferSupplierInv."Document Date" := MICAFlowBufferSupplierInv."Document Date";
                FoundMICAFlowBufferSupplierInv."MICH.ORIGINVDATE" := MICAFlowBufferSupplierInv."MICH.ORIGINVDATE";
                FoundMICAFlowBufferSupplierInv.Modify();
            until FoundMICAFlowBufferSupplierInv.Next() = 0;
    end;


    local procedure CheckFinancialReportingSetup(MICAFlowEntry: Record "MICA Flow Entry")
    var
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        MissingValuesErr: Label 'Value for %1 in %2 is not defined.';
    begin
        MICAFinancialReportingSetup.Get();

        if MICAFinancialReportingSetup."GIS AP Integrat. Charge (Item)" = '' then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error,
              StrSubstNo(MissingValuesErr, MICAFinancialReportingSetup.FieldCaption("GIS AP Integrat. Charge (Item)"), MICAFinancialReportingSetup.TableName()), '');

        if MICAFinancialReportingSetup."GIS AP Integrat. Freight Item" = '' then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error,
              StrSubstNo(MissingValuesErr, MICAFinancialReportingSetup.FieldCaption("GIS AP Integrat. Freight Item"), MICAFinancialReportingSetup.TableName()), '');
    end;


    local procedure SendTechnicalACK(PurchaseHeader: Record "Purchase Header"; var MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv.")
    var
        MICAFlow: Record "MICA Flow";
        MICAFlowSendSuppInvTechACK: Codeunit "MICA Flow Send SuppInv TechACK";
    begin
        MICAFlowSendSuppInvTechACK.SetParameters(PurchaseHeader, MICAFlowBufferSupplierInv);
        MICAFlowSendSuppInvTechACK.Run(MICAFlow);
    end;

    local procedure SendFunctionalACK(PurchaseHeader: Record "Purchase Header"; var MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv.")
    var
        MICAFlow: Record "MICA Flow";
        MICAFlowSendSuppInvFuncACK: Codeunit "MICA Flow Send SuppInv FuncACK";
    begin
        MICAFlowSendSuppInvFuncACK.SetParameters(PurchaseHeader, MICAFlowBufferSupplierInv);
        MICAFlowSendSuppInvFuncACK.Run(MICAFlow);
    end;

    local procedure EvaluateRawDateToDate(var OutValue: Date; RawDate: Text): Boolean // RawDate is in 'YYYYMMDD' format
    var
        XmlDate: Text;
    begin
        XmlDate := CopyStr(RawDate, 1, 4) + '-' +
                    CopyStr(RawDate, 5, 2) + '-' +
                    CopyStr(RawDate, 7, 2);
        Exit(Evaluate(OutValue, XmlDate, 9));
        // Converts to native format (Xml Date format 'YYYY-MM-DD', see https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/properties/devenv-format-property)
    end;

    local procedure EvaluateRawDecToDec(var OutValue: Decimal; RawDec: Text): Boolean
    var
        DebitCredit: Text[1];
    begin
        ////[D|C| ][Sign]decimals.decimals
        DebitCredit := RawDec[1];
        if DebitCredit IN ['D', 'C', ' '] then
            RawDec := CopyStr(RawDec, 2)
        else
            DebitCredit := ' ';
        Exit(Evaluate(OutValue, RawDec, 9));
        // Converts to Xml Decimal format (see https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/properties/devenv-format-property)
    end;

    local procedure CheckACKParameters(MICAFlow: Record "MICA Flow");
    begin
        CreateParam(MICAFlow.Code, TechnicalACKFlowLbl, 'Technical Acknowledgment flow code', 'GIS_AP_INV_TECH_ACK');
        CreateParam(MICAFlow.Code, FunctioinalACKFlowLbl, 'Functional Acknowledgement flow code', 'GIS_AP_INV_FCT_ACK');
        CreateParam(MICAFlow.Code, EAPINV018Lbl, 'Error code “EAPINV018”', 'Invoice No. %1 is Duplicate');
        CreateParam(MICAFlow.Code, EAPINV047Lbl, 'Error code “EAPINV047”', 'Invoice Line Amount %1 is not valid.');
        CreateParam(MICAFlow.Code, EAPINV019Lbl, 'Error code “EAPINV019”', 'Invoice Amount %1 is invalid.');
        CreateParam(MICAFlow.Code, EAPINV021Lbl, 'Error code “EAPINV021”', 'Vendor No. %1 is invalid.');
        CreateParam(MICAFlow.Code, EAPINV023Lbl, 'Error code “EAPINV023”', 'Invoice Currency Code %1 is invalid.');
        CreateParam(MICAFlow.Code, EAPINV025Lbl, 'Error code “EAPINV025”', 'The Payment Terms Name %1 is invalid.');
        CreateParam(MICAFlow.Code, EAPINV029Lbl, 'Error code “EAPINV029”', 'The GL Date %1 is not in an Open or Future accounting period.');
        CreateParam(MICAFlow.Code, EAPINV031Lbl, 'Error code “EAPINV031”', 'The Purchase Order Number %1 %2 is invalid.');
        CreateParam(MICAFlow.Code, EAPINV032Lbl, 'Error code “EAPINV032”', 'The Purchase Order Line Number %1 %2 is invalid.');
        CreateParam(MICAFlow.Code, EAPINV035Lbl, 'Error code “EAPINV035”', 'Relfact Code Missing.');
        CreateParam(MICAFlow.Code, EAPINV036Lbl, 'Error code “EAPINV036”', 'The AP Invoice Date is missing %1');
        CreateParam(MICAFlow.Code, EAPINV039Lbl, 'Error code “EAPINV039”', 'The Unit Price is missing on the Invoice %1 for PO Matched Invoices.');
        CreateParam(MICAFlow.Code, EAPINV049Lbl, 'Error code “EAPINV049”', 'Freight Information on Freight line is missing. %1');
        CreateParam(MICAFlow.Code, EAPINVXXXLbl, 'Error code “EAPINVXXX', '%1');


        MICAFlow.Get(Param_GISAPINVTECHACKLbl);
        CreateParam(MICAFlow.Code, LOGICALIDLbl, 'Logical ID', 'BSC_VN_PROD');
        CreateParam(MICAFlow.Code, COMPONENTLbl, 'Component', 'GIS_WMB_PROCESSINV_PURCHASE_PUB00_001');
        CreateParam(MICAFlow.Code, TASKLbl, 'Task', 'TECHNICAL');
        CreateParam(MICAFlow.Code, LANGUAGELbl, 'Language', 'US');
        CreateParam(MICAFlow.Code, DESCRIPTNLbl, 'Processus Description', 'Process Invoice for %1');
        CreateParam(MICAFlow.Code, FILENAMINGLbl, 'Name of the file', 'ACK_TECH%1.XML');

        MICAFlow.Get(ParamGISAPINVFCTACKLbl);
        CreateParam(MICAFlow.Code, LOGICALIDLbl, 'Logical ID', 'BSC_VN_PROD');
        CreateParam(MICAFlow.Code, COMPONENTLbl, 'Component', 'GIS_WMB_PROCESSINV_PURCHASE_PUB00_001');
        CreateParam(MICAFlow.Code, TASKLbl, 'Task', 'FUNCTIONAL');
        CreateParam(MICAFlow.Code, LANGUAGELbl, 'Language', 'US');
        CreateParam(MICAFlow.Code, DESCRIPTNLbl, 'Processus Description', 'Process Invoice for %1');
        CreateParam(MICAFlow.Code, FILENAMINGLbl, 'Name of the file', 'ACK_FCT%1.XML');
        CreateParam(MICAFlow.Code, BSC_PROCESSINGLbl, 'Error code “BSC_PROCESSING', '%1');
    end;

    local procedure CreateParam(Flow: Code[20]; ParamCode: Code[20]; Descr: Text[50]; TextVal: Text[250])
    var
        ParamMICAFlowSetup: Record "MICA Flow Setup";
    begin
        if not ParamMICAFlowSetup.Get(Flow, ParamCode) then begin
            ParamMICAFlowSetup.Init();
            ParamMICAFlowSetup.Flow := Flow;
            ParamMICAFlowSetup."Parameter Code" := ParamCode;
            ParamMICAFlowSetup.Description := Descr;
            ParamMICAFlowSetup.Type := ParamMICAFlowSetup.Type::Text;
            ParamMICAFlowSetup."Text Value" := TextVal;
            ParamMICAFlowSetup.Insert(true);
        end;
    end;
}