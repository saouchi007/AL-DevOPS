report 82521 "MICA Sales - Shipment Custom"
{
    // version NAVW114.01

    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rdl82521.MICASalesShipmentCustom.rdl';
    // Caption = 'Sales - Shipment'; // ENU
    Caption = 'Remisión de entrega';
    PreviewMode = PrintLayout;
    UsageCategory = None;

    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Shipment';
            column(No_SalesShptHeader; "No.")
            {
            }
            column(PageCaption; PageCaptionCapLbl)
            {
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = sorting(Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = sorting(Number)
                                        where(Number = const(1));
                    column(CompanyInfo2Picture; PicCompanyInformation.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; FoundCompanyInformation.Picture)
                    {
                    }
                    column(CompanyInfo3Picture; SetLogoCompanyInformation.Picture)
                    {
                    }
                    column(SalesShptCopyText; StrSubstNo(Text002Lbl, CopyText))
                    {
                    }
                    column(ShipToAddr1; ShipToAddr[1])
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(ShipToAddr2; ShipToAddr[2])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(ShipToAddr3; ShipToAddr[3])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(ShipToAddr4; ShipToAddr[4])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(ShipToAddr5; ShipToAddr[5])
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInformation."Phone No.")
                    {
                    }
                    column(ShipToAddr6; ShipToAddr[6])
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInformation."Home Page")
                    {
                    }
                    column(CompanyInfoEmail; CompanyInformation."E-Mail")
                    {
                    }
                    column(CompanyInfoFaxNo; CompanyInformation."Fax No.")
                    {
                    }
                    column(CompanyInfoVATRegtnNo; CompanyInformation."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoGiroNo; CompanyInformation."Giro No.")
                    {
                    }
                    column(CompanyInfoBankName; CompanyInformation."Bank Name")
                    {
                    }
                    column(CompanyInfoBankAccountNo; CompanyInformation."Bank Account No.")
                    {
                    }
                    column(SelltoCustNo_SalesShptHeader; "Sales Shipment Header"."Sell-to Customer No.")
                    {
                    }
                    column(DocDate_SalesShptHeader; ForMAT("Sales Shipment Header"."Document Date", 0, 4))
                    {
                    }
                    column(SalesPersonText; SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName; SalespersonPurchaser.Name)
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(YourRef_SalesShptHeader; "Sales Shipment Header"."Your Reference")
                    {
                    }
                    column(ShipToAddr7; ShipToAddr[7])
                    {
                    }
                    column(ShipToAddr8; ShipToAddr[8])
                    {
                    }
                    column(TransportInstruction; TransportInstructionDesc)
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(ShptDate_SalesShptHeader; Format("Sales Shipment Header"."Shipment Date", 0, 4))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(ItemTrackingAppendixCaption; ItemTrackingAppendixCaptionLbl)
                    {
                    }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    {
                    }
                    column(VATRegNoCaption; VATRegNoCaptionLbl)
                    {
                    }
                    column(GiroNoCaption; GiroNoCaptionLbl)
                    {
                    }
                    column(BankNameCaption; BankNameCaptionLbl)
                    {
                    }
                    column(BankAccNoCaption; BankAccNoCaptionLbl)
                    {
                    }
                    column(ShipmentNoCaption; ShipmentNoCaptionLbl)
                    {
                    }
                    column(ShipmentDateCaption; ShipmentDateCaptionLbl)
                    {
                    }
                    column(HomePageCaption; HomePageCaptionLbl)
                    {
                    }
                    column(EmailCaption; EmailCaptionLbl)
                    {
                    }
                    column(DocumentDateCaption; DocumentDateCaptionLbl)
                    {
                    }
                    column(SelltoCustNo_SalesShptHeaderCaption; "Sales Shipment Header".FieldCaption("Sell-to Customer No."))
                    {
                    }
                    column(OrderNoCaption_SalesShptHeader; OurDocumentNoCaptionLbl)
                    {
                    }
                    column(OrderNo_SalesShptHeader; "Sales Shipment Header"."Order No.")
                    {
                    }
                    column(ExternalDocumentNoCaption_SalesShptHeader; PurchaseOrderNoCaptionLbl)
                    {
                    }
                    column(ExternalDocumentNo_SalesShptHeader; "Sales Shipment Header"."External Document No.")
                    {
                    }
                    column(AcceptanceNote; WarehouseSetup."MICA Acceptance Note")
                    {
                    }
                    column(ShipToInformation_SalesShptLineCaption; ShipToLbl)
                    {
                    }
                    dataitem(DimensionLoop1; Integer)
                    {
                        DataItemLinkReference = "Sales Shipment Header";
                        DataItemTableView = sorting(Number)
                                            where(Number = filter(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(HeaderDimensionsCaption; HeaderDimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            DimText1Lbl: Label '%1 - %2', Comment = '%1%2', Locked = true;
                            DimText2Lbl: Label '%1; %2 - %3', Comment = '%1%2%3', Locked = true;
                        begin
                            if Number = 1 then begin
                                if not DimensionSetEntry.FindSet() then
                                    CurrReport.Break();
                            end else
                                if not Continue then
                                    CurrReport.Break();

                            CLEAR(DimText);
                            Continue := false;
                            repeat
                                OldDimText := CopyStr(DimText, 1, 75);
                                if DimText = '' then
                                    DimText := StrSubstNo(DimText1Lbl, DimensionSetEntry."Dimension Code", DimensionSetEntry."Dimension Value Code")
                                else
                                    DimText := CopyStr(StrSubstNo(DimText2Lbl, DimText, DimensionSetEntry."Dimension Code", DimensionSetEntry."Dimension Value Code"), 1, MaxStrLen(DimText));
                                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until DimensionSetEntry.Next() = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not MyShowInternalInfo then
                                CurrReport.Break();
                        end;
                    }
                    dataitem("Sales Shipment Line"; "Sales Shipment Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = "Sales Shipment Header";
                        DataItemTableView = sorting("Document No.", "Line No.") where(Quantity = FILTER(<> 0));
                        column(Description_SalesShptLine; Description)
                        {
                        }
                        column(ShowInternalInfo; MyShowInternalInfo)
                        {
                        }
                        column(ShowCorrectionLines; ShowCorrectionLines)
                        {
                        }
                        column(Type_SalesShptLine; ForMAT(Type, 0, 2))
                        {
                        }
                        column(AsmHeaderExists; AsmHeaderExists)
                        {
                        }
                        column(DocumentNo_SalesShptLine; "Document No.")
                        {
                        }
                        column(LinNo; LinNo)
                        {
                        }
                        column(Qty_SalesShptLine; Quantity)
                        {
                        }
                        column(UOM_SalesShptLine; "Unit of Measure")
                        {
                        }
                        column(No_SalesShptLine; "No.")
                        {
                        }
                        column(LineNo_SalesShptLine; "Line No.")
                        {
                        }
                        column(Description_SalesShptLineCaption; FieldCaption(Description))
                        {
                        }
                        column(Qty_SalesShptLineCaption; FieldCaption(Quantity))
                        {
                        }
                        column(UOM_SalesShptLineCaption; FieldCaption("Unit of Measure"))
                        {
                        }
                        column(No_SalesShptLineCaption; FieldCaption("No."))
                        {
                        }

                        column(MICA_Countermark; "MICA Countermark")
                        {

                        }
                        column(MICA_CountermarkFieldCaption; FieldCaption("MICA Countermark"))
                        {

                        }
                        dataitem(DimensionLoop2; Integer)
                        {
                            DataItemTableView = sorting(Number)
                                                where(Number = filter(1 ..));
                            column(DimText1; DimText)
                            {
                            }
                            column(LineDimensionsCaption; LineDimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            var
                                DimText1Lbl: Label '%1 - %2', Comment = '%1%2', Locked = true;
                                DimText2Lbl: Label '%1; %2 - %3', Comment = '%1%2%3', Locked = true;
                            begin
                                if Number = 1 then begin
                                    if not FoundDimensionSetEntry.FindSet() then
                                        CurrReport.Break();
                                end else
                                    if not Continue then
                                        CurrReport.Break();

                                CLEAR(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := CopyStr(DimText, 1, 75);
                                    if DimText = '' then
                                        DimText := StrSubstNo(DimText1Lbl, FoundDimensionSetEntry."Dimension Code", FoundDimensionSetEntry."Dimension Value Code")
                                    else
                                        DimText := CopyStr(StrSubstNo(DimText2Lbl, DimText, FoundDimensionSetEntry."Dimension Code", FoundDimensionSetEntry."Dimension Value Code"), 1, MaxStrLen(DimText));
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until FoundDimensionSetEntry.Next() = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not MyShowInternalInfo then
                                    CurrReport.Break();
                            end;
                        }
                        dataitem(DisplayAsmInfo; Integer)
                        {
                            DataItemTableView = sorting(Number);
                            column(PostedAsmLineItemNo; BlanksForIndent() + PostedAssemblyLine."No.")
                            {
                            }
                            column(PostedAsmLineDescription; BlanksForIndent() + PostedAssemblyLine.Description)
                            {
                            }
                            column(PostedAsmLineQuantity; PostedAssemblyLine.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(PostedAsmLineUOMCode; GetUnitOfMeasureDescr(PostedAssemblyLine."Unit of Measure Code"))
                            {
                            }

                            trigger OnAfterGetRecord()
                            var
                                ItemTranslation: Record "Item Translation";
                            begin
                                if Number = 1 then
                                    PostedAssemblyLine.FindSet()
                                else
                                    PostedAssemblyLine.Next();

                                if ItemTranslation.Get(PostedAssemblyLine."No.",
                                     PostedAssemblyLine."Variant Code",
                                     "Sales Shipment Header"."Language Code")
                                then
                                    PostedAssemblyLine.Description := ItemTranslation.Description;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not DisplayAssemblyInformation then
                                    CurrReport.Break();
                                if not AsmHeaderExists then
                                    CurrReport.Break();

                                PostedAssemblyLine.SetRange("Document No.", PostedAssemblyHeader."No.");
                                SetRange(Number, 1, PostedAssemblyLine.Count());
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            TransportInstruction: Record "MICA Transport Instructions";
                        begin
                            LinNo := "Line No.";
                            if not ShowCorrectionLines and Correction then
                                CurrReport.Skip();

                            FoundDimensionSetEntry.SetRange("Dimension Set ID", "Dimension Set ID");
                            if DisplayAssemblyInformation then
                                AsmHeaderExists := AsmToShipmentExists(PostedAssemblyHeader);

                            if "Cross-Reference No." <> '' then
                                Description := CopyStr("Cross-Reference No." + WarehouseSetup."MICA Cross Reference Separator" + Description, 1, MaxStrLen(Description));

                            if (TransportInstructionDesc = '') and ("MICA Transport Instruction" <> '') then
                                if TransportInstruction.Get("MICA Transport Instruction") then
                                    TransportInstructionDesc := TransportInstruction.Description;


                        end;

                        trigger OnPostDataItem()
                        begin
                            if MyShowLotSN then begin
                                ItemTrackingDocManagement.SetRetrieveAsmItemTracking(true);
                                TrackingSpecCount :=
                                  ItemTrackingDocManagement.RetrieveDocumentItemTracking(TempBufferTrackingSpecification,
                                    "Sales Shipment Header"."No.", Database::"Sales Shipment Header", 0);
                                ItemTrackingDocManagement.SetRetrieveAsmItemTracking(false);
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := Find('+');
                            while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) do
                                MoreLines := Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break();
                            SetRange("Line No.", 0, "Line No.");
                        end;
                    }
                    dataitem(Total; Integer)
                    {
                        DataItemTableView = sorting(Number)
                                            where(Number = const(1));
                    }
                    dataitem(Total2; Integer)
                    {
                        DataItemTableView = sorting(Number)
                                            where(Number = const(1));
                        column(BilltoCustNo_SalesShptHeader; "Sales Shipment Header"."Bill-to Customer No.")
                        {
                        }
                        column(CustAddr1; CustAddr[1])
                        {
                        }
                        column(CustAddr2; CustAddr[2])
                        {
                        }
                        column(CustAddr3; CustAddr[3])
                        {
                        }
                        column(CustAddr4; CustAddr[4])
                        {
                        }
                        column(CustAddr5; CustAddr[5])
                        {
                        }
                        column(CustAddr6; CustAddr[6])
                        {
                        }
                        column(CustAddr7; CustAddr[7])
                        {
                        }
                        column(CustAddr8; CustAddr[8])
                        {
                        }
                        column(BilltoAddressCaption; BilltoAddressCaptionLbl)
                        {
                        }
                        column(BilltoCustNo_SalesShptHeaderCaption; "Sales Shipment Header".FieldCaption("Bill-to Customer No."))
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if not ShowAlwaysShipToInformationVar then
                                if not ShowCustAddr then
                                    CurrReport.Break();
                        end;
                    }
                    dataitem(ItemTrackingLine; Integer)
                    {
                        DataItemTableView = sorting(Number);
                        column(TrackingSpecBufferNo; TempBufferTrackingSpecification."Item No.")
                        {
                        }
                        column(TrackingSpecBufferDesc; TempBufferTrackingSpecification.Description)
                        {
                        }
                        column(TrackingSpecBufferLotNo; TempBufferTrackingSpecification."Lot No.")
                        {
                        }
                        column(TrackingSpecBufferSerNo; TempBufferTrackingSpecification."Serial No.")
                        {
                        }
                        column(TrackingSpecBufferQty; TempBufferTrackingSpecification."Quantity (Base)")
                        {
                        }
                        column(ShowTotal; ShowTotal)
                        {
                        }
                        column(ShowGroup; ShowGroup)
                        {
                        }
                        column(QuantityCaption; QuantityCaptionLbl)
                        {
                        }
                        column(SerialNoCaption; SerialNoCaptionLbl)
                        {
                        }
                        column(LotNoCaption; LotNoCaptionLbl)
                        {
                        }
                        column(DescriptionCaption; DescriptionCaptionLbl)
                        {
                        }
                        column(NoCaption; NoCaptionLbl)
                        {
                        }
                        dataitem(TotalItemTracking; Integer)
                        {
                            DataItemTableView = sorting(Number)
                                                where(Number = const(1));
                            column(Quantity1; TotalQty)
                            {
                            }
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then
                                TempBufferTrackingSpecification.FindSet()
                            else
                                TempBufferTrackingSpecification.Next();

                            if not ShowCorrectionLines and TempBufferTrackingSpecification.Correction then
                                CurrReport.Skip();
                            if TempBufferTrackingSpecification.Correction then
                                TempBufferTrackingSpecification."Quantity (Base)" := -TempBufferTrackingSpecification."Quantity (Base)";

                            ShowTotal := false;
                            if ItemTrackingAppendix.IsStartNewGroup(TempBufferTrackingSpecification) then
                                ShowTotal := true;

                            ShowGroup := false;
                            if (TempBufferTrackingSpecification."Source Ref. No." <> OldRefNo) or
                               (TempBufferTrackingSpecification."Item No." <> OldNo)
                            then begin
                                OldRefNo := TempBufferTrackingSpecification."Source Ref. No.";
                                OldNo := TempBufferTrackingSpecification."Item No.";
                                TotalQty := 0;
                            end else
                                ShowGroup := true;
                            TotalQty += TempBufferTrackingSpecification."Quantity (Base)";
                        end;

                        trigger OnPreDataItem()
                        begin
                            if TrackingSpecCount = 0 then
                                CurrReport.Break();
                            CurrReport.NewPage();
                            SetRange(Number, 1, TrackingSpecCount);
                            TempBufferTrackingSpecification.SETCURRENTKEY("Source ID", "Source Type", "Source Subtype", "Source Batch Name",
                              "Source Prod. Order Line", "Source Ref. No.");
                        end;
                    }

                    trigger OnPreDataItem()
                    begin
                        // Item Tracking:
                        if MyShowLotSN then begin
                            TrackingSpecCount := 0;
                            OldRefNo := 0;
                            ShowGroup := false;
                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := FormatDocument.GetCOPYText();
                        OutputNo += 1;
                    end;
                    TotalQty := 0;           // Item Tracking
                end;

                trigger OnPostDataItem()
                begin
                    if not IsReportInPreviewMode() then
                        CODEUNIT.RUN(CODEUNIT::"Sales Shpt.-Printed", "Sales Shipment Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := 1 + ABS(MyNoOfCopies);
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Language Code" <> '' then
                    CurrReport.LANGUAGE := Language.GetLanguageID("Language Code")
                else
                    CurrReport.Language := Language.GetLanguageIdOrDefault("Language Code");

                FormatAddressFields("Sales Shipment Header");
                FormatDocumentFields("Sales Shipment Header");

                DimensionSetEntry.SetRange("Dimension Set ID", "Dimension Set ID");
            end;

            trigger OnPostDataItem()
            begin
                OnAfterPostDataItem("Sales Shipment Header");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies; MyNoOfCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies how many copies of the document to print.';
                    }
                    field(ShowInternalInfo; MyShowInternalInfo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Internal Information';
                        ToolTip = 'Specifies if the document shows internal information.';
                    }
                    field(LogInteraction; MyLogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies if you want to record the reports that you print as interactions.';
                    }
                    field("Show Correction Lines"; ShowCorrectionLines)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Correction Lines';
                        ToolTip = 'Specifies if the correction lines of an undoing of quantity posting will be shown on the report.';
                    }
                    field(ShowLotSN; MyShowLotSN)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Serial/Lot Number Appendix';
                        ToolTip = 'Specifies if you want to print an appendix to the sales shipment report showing the lot and serial numbers in the shipment.';
                    }
                    field(DisplayAsmInfo; DisplayAssemblyInformation)
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Show Assembly Components';
                        ToolTip = 'Specifies if you want the report to include information about components that were used in linked assembly orders that supplied the item(s) being sold.';
                    }
                    field(ShowAlwaysShipToInformation; ShowAlwaysShipToInformationVar)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Ship-to information';
                        ToolTip = 'Specifies if you always want to display Show-to information.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction();
            LogInteractionEnable := MyLogInteraction;
            ShowAlwaysShipToInformationVar := true;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        CompanyInformation.Get();
        SalesReceivablesSetup.Get();
        WarehouseSetup.Get();
        FormatDocument.SetLogoPosition(SalesReceivablesSetup."Logo Position on Documents", FoundCompanyInformation, PicCompanyInformation, SetLogoCompanyInformation);

        OnAfterInitReport();
    end;

    trigger OnPostReport()
    begin
        if MyLogInteraction and not IsReportInPreviewMode() then
            if "Sales Shipment Header".FindSet() then
                repeat
                    SegManagement.LogDocument(
                      5, "Sales Shipment Header"."No.", 0, 0, Database::Customer, "Sales Shipment Header"."Sell-to Customer No.",
                      "Sales Shipment Header"."Salesperson Code", "Sales Shipment Header"."Campaign No.",
                      "Sales Shipment Header"."Posting Description", '');
                until "Sales Shipment Header".Next() = 0;
    end;

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage() then
            InitLogInteraction();
        AsmHeaderExists := false;
    end;

    var
        WarehouseSetup: Record "Warehouse Setup";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        FoundCompanyInformation: Record "Company Information";
        PicCompanyInformation: Record "Company Information";
        SetLogoCompanyInformation: Record "Company Information";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        DimensionSetEntry: Record "Dimension Set Entry";
        FoundDimensionSetEntry: Record "Dimension Set Entry";
        TempBufferTrackingSpecification: Record "Tracking Specification" temporary;
        PostedAssemblyHeader: Record "Posted Assembly Header";
        PostedAssemblyLine: Record "Posted Assembly Line";
        ResponsibilityCenter: Record "Responsibility Center";
        ItemTrackingAppendix: Report "Item Tracking Appendix";
        Language: Codeunit Language;
        FormatAddress: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit "SegManagement";
        ItemTrackingDocManagement: Codeunit "Item Tracking Doc. Management";
        CustAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        SalesPersonText: Text[50];
        ReferenceText: Text[80];
        MoreLines: Boolean;
        MyNoOfCopies: Integer;
        OutputNo: Integer;
        NoOfLoops: Integer;
        TrackingSpecCount: Integer;
        OldRefNo: Integer;
        OldNo: Code[20];
        CopyText: Text[30];
        ShowCustAddr: Boolean;
        DimText: Text[120];
        OldDimText: Text[75];
        MyShowInternalInfo: Boolean;
        Continue: Boolean;
        MyLogInteraction: Boolean;
        ShowCorrectionLines: Boolean;
        MyShowLotSN: Boolean;
        ShowTotal: Boolean;
        ShowGroup: Boolean;
        TotalQty: Decimal;
        TransportInstructionDesc: Text[150];
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        AsmHeaderExists: Boolean;
        ShowAlwaysShipToInformationVar: Boolean;
        LinNo: Integer;
        ItemTrackingAppendixCaptionLbl: Label 'Item Tracking - Appendix';
        PhoneNoCaptionLbl: Label 'Phone No.';
        VATRegNoCaptionLbl: Label 'VAT Reg. No.';
        GiroNoCaptionLbl: Label 'Giro No.';
        BankNameCaptionLbl: Label 'Bank';
        BankAccNoCaptionLbl: Label 'Account No.';
        // ShipmentNoCaptionLbl: Label 'Shipment No.'; // ENU
        ShipmentNoCaptionLbl: label 'No. de envío';
        // ShipmentDateCaptionLbl: Label 'Shipment Date'; // ENU
        ShipmentDateCaptionLbl: Label 'Fecha de envío';
        HomePageCaptionLbl: Label 'Home Page';
        EmailCaptionLbl: Label 'Email';
        DocumentDateCaptionLbl: Label 'Document Date';
        HeaderDimensionsCaptionLbl: Label 'Header Dimensions';
        LineDimensionsCaptionLbl: Label 'Line Dimensions';
        BilltoAddressCaptionLbl: Label 'Bill-to Address';
        QuantityCaptionLbl: Label 'Quantity';
        SerialNoCaptionLbl: Label 'Serial No.';
        LotNoCaptionLbl: Label 'Lot No.';
        DescriptionCaptionLbl: Label 'Description';
        NoCaptionLbl: Label 'No.';
        PageCaptionCapLbl: Label 'Page %1 of %2';
        Text002Lbl: Label 'Remisión de entrega %1', Comment = '%1 = Document No.';
        // Text002Lbl: Label 'Sales - Shipment %1', Comment = '%1 = Document No.'; // ENU

        // ShipToLbl: Label 'Ship-To :'; // ENU
        ShipToLbl: Label 'Enviado a :';
        // OurDocumentNoCaptionLbl: label 'Our Document No.'; // ENU
        OurDocumentNoCaptionLbl: label 'No. de Pedido';
        // PurchaseOrderNoCaptionLbl: label 'Purchase Order No.'; // ENU
        PurchaseOrderNoCaptionLbl: label 'No. Orden de Compra';

    procedure InitLogInteraction()
    begin
        MyLogInteraction := SegManagement.FindInteractTmplCode(5) <> '';
    end;

    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean; NewShowCorrectionLines: Boolean; NewShowLotSN: Boolean; DisplayAsmInfo: Boolean)
    begin
        MyNoOfCopies := NewNoOfCopies;
        MyShowInternalInfo := NewShowInternalInfo;
        MyLogInteraction := NewLogInteraction;
        ShowCorrectionLines := NewShowCorrectionLines;
        MyShowLotSN := NewShowLotSN;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview() or MailManagement.IsHandlingGetEmailBody());
    end;

    local procedure FormatAddressFields(SalesShipmentHeader: Record "Sales Shipment Header")
    begin
        FormatAddress.GetCompanyAddr(SalesShipmentHeader."Responsibility Center", ResponsibilityCenter, CompanyInformation, CompanyAddr);
        FormatAddress.SalesShptShipTo(ShipToAddr, SalesShipmentHeader);
        ShowCustAddr := FormatAddress.SalesShptBillTo(CustAddr, ShipToAddr, SalesShipmentHeader);
    end;

    local procedure FormatDocumentFields(SalesShipmentHeader: Record "Sales Shipment Header")
    begin
        with SalesShipmentHeader do begin
            FormatDocument.SetSalesPerson(SalespersonPurchaser, "Salesperson Code", SalesPersonText);
            ReferenceText := FormatDocument.SetText("Your Reference" <> '', CopyStr(FieldCaption("Your Reference"), 1, 80));
        end;
    end;

    local procedure GetUnitOfMeasureDescr(UOMCode: Code[10]): Text[50]
    var
        UnitofMeasure: Record "Unit of Measure";
    begin
        if not UnitofMeasure.Get(UOMCode) then
            exit(UOMCode);
        exit(UnitofMeasure.Description);
    end;

    procedure BlanksForIndent(): Text[10]
    begin
        exit(PADSTR('', 2, ' '));
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterInitReport()
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterPostDataItem(var SalesShipmentHeader: Record "Sales Shipment Header")
    begin
    end;
}

