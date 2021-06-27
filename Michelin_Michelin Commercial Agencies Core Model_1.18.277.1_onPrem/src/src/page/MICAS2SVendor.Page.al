page 82862 "MICA S2S Vendor"
{
    PageType = API;
#if not OnPremise
    APIPublisher = 'MichelinCA';
    APIGroup = 'S2S';
#endif 
    DelayedInsert = true;
    APIVersion = 'v1.0';
    Caption = 's2sVendor', Locked = true;
    EntityName = 's2sVendor';
    EntitySetName = 's2sVendors';
    ODataKeyFields = SystemId;
    SourceTable = "Vendor";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ChangeTrackingAllowed = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    ApplicationArea = All;
                    Caption = 'id', Locked = true;
                    Editable = false;
                }
                field(companyCode; MICAFinancialReportingSetup."Company Code")
                {
                    ApplicationArea = All;
                    Caption = 'companyCode', Locked = true;
                }
                field(number; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'number', Locked = true;
                }
                field(displayName; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'displayName', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo(Name));
                    end;
                }
                field(address; PostalAddressJSON)
                {
                    ApplicationArea = All;
                    Caption = 'address', Locked = true;
                    ODataEDMType = 'POSTALADDRESS';
                    ToolTip = 'Specifies the address for the vendor.';

                    trigger OnValidate()
                    begin
                        PostalAddressSet := true;
                    end;
                }
                field(phoneNumber; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'phoneNumber', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Phone No."));
                    end;
                }
                field(email; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    Caption = 'email', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("E-Mail"));
                    end;
                }
                field(website; Rec."Home Page")
                {
                    ApplicationArea = All;
                    Caption = 'website', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Home Page"));
                    end;
                }
                field(taxRegistrationNumber; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                    Caption = 'taxRegistrationNumber', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("VAT Registration No."));
                    end;
                }
                field(currencyCode; CurrencyCodeTxt)
                {
                    ApplicationArea = All;
                    Caption = 'currencyCode', Locked = true;

                    trigger OnValidate()
                    begin
                        Rec."Currency Code" :=
                          GraphMgtGeneralTools.TranslateCurrencyCodeToNAVCurrencyCode(
                            LCYCurrencyCode, CopyStr(CurrencyCodeTxt, 1, MaxStrLen(LCYCurrencyCode)));

                        if Currency.Code <> '' then begin
                            if Currency.Code <> Rec."Currency Code" then
                                Error(CurrencyValuesDontMatchErr);
                            exit;
                        end;

                        if Rec."Currency Code" = '' then
                            Rec."Currency Id" := BlankGUID
                        else begin
                            if not Currency.Get(Rec."Currency Code") then
                                Error(CurrencyCodeDoesNotMatchACurrencyErr);

                            Rec."Currency Id" := Currency.SystemId;
                        end;

                        RegisterFieldSet(Rec.FieldNo("Currency Id"));
                        RegisterFieldSet(Rec.FieldNo("Currency Code"));
                    end;
                }
                field(taxLiable; Rec."Tax Liable")
                {
                    ApplicationArea = All;
                    Caption = 'taxLiable', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Tax Liable"));
                    end;
                }
                field(blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    Caption = 'blocked', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo(Blocked));
                    end;
                }
                field(balance; Rec."Balance (LCY)")
                {
                    ApplicationArea = All;
                    Caption = 'balance', Locked = true;
                }
                field(lastModifiedDateTime; Rec."Last Modified Date Time")
                {
                    ApplicationArea = All;
                    Caption = 'lastModifiedDateTime', Locked = true;
                }
                field(territoryCode; Rec."Territory Code")
                {
                    ApplicationArea = All;
                    Caption = 'territoryCode', Locked = true;
                }
                field(language; Rec."Language Code")
                {
                    ApplicationArea = All;
                    Caption = 'language', Locked = true;
                }
                field(shipmentMethodCode; Rec."Shipment Method Code")
                {
                    ApplicationArea = All;
                    Caption = 'shipmentMethodCode', Locked = true;
                }
                field(countryRegionCode; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'countryRegionCode', Locked = true;
                }
                field(paytoVendorNo; Rec."Pay-to Vendor No.")
                {
                    ApplicationArea = All;
                    Caption = 'paytoVendorNo', Locked = true;
                }
                field(pricesIncludingVAT; Rec."Prices Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'pricesIncludingVAT', Locked = true;
                }
                field(vatRegistrationNo; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                    Caption = 'vatRegistrationNo', Locked = true;
                }
                field(prepaymentPct; Rec."Prepayment %")
                {
                    ApplicationArea = All;
                    Caption = 'prepaymentPct', Locked = true;
                }
                field(leadTimeCalculation; Rec."Lead Time Calculation")
                {
                    ApplicationArea = All;
                    Caption = 'leadTimeCalculation', Locked = true;
                }
                field(gtcPricelistCode; Rec."MICA GTC Pricelist Code")
                {
                    ApplicationArea = All;
                    Caption = 'gtcPricelistCode', Locked = true;
                }
                field(partyOwnership; Rec."MICA Party Ownership")
                {
                    ApplicationArea = All;
                    Caption = 'partyOwnership', Locked = true;
                }
                field(offtakerCode; Rec."MICA Offtaker Code")
                {
                    ApplicationArea = All;
                    Caption = 'offtakerCode', Locked = true;
                }
                field(englishName; Rec."MICA English Name")
                {
                    ApplicationArea = All;
                    Caption = 'englishName', Locked = true;
                }
                field(locationCode; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Caption = 'locationCode', Locked = true;
                }
                field(contactFirstName; GContact."First Name")
                {
                    ApplicationArea = All;
                    Caption = 'contactFirstName', Locked = true;
                }
                field(contactLastName; GContact.Name)
                {
                    ApplicationArea = All;
                    Caption = 'contactLastName', Locked = true;
                }
                field(contactPhoneNo; GContact."Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'contactPhoneNo', Locked = true;
                }
                field(contactEmail; GContact."E-Mail")
                {
                    ApplicationArea = All;
                    Caption = 'contactEmail', Locked = true;
                }
                field(currencyDescription; Currency.Description)
                {
                    ApplicationArea = All;
                    Caption = 'currencyDescription', Locked = true;
                }
                field(paymentTermsCode; PaymentTerms.Code)
                {
                    ApplicationArea = All;
                    Caption = 'paymentTermsCode', Locked = true;
                }
                field(paymentTermsDescription; PaymentTerms.Description)
                {
                    ApplicationArea = All;
                    Caption = 'paymentTermsDescription', Locked = true;
                }
                field(paymentMethodCode; PaymentMethod.Code)
                {
                    ApplicationArea = All;
                    Caption = 'paymentMethodCode', Locked = true;
                }
                field(paymentMethodDescription; PaymentMethod.Description)
                {
                    ApplicationArea = All;
                    Caption = 'paymentMethodDescription', Locked = true;
                }
                field(languageName; Language.Name)
                {
                    ApplicationArea = All;
                    Caption = 'languageName', Locked = true;
                }
                field(orderRoutingType; '')
                {
                    ApplicationArea = All;
                    Caption = 'orderRoutingType', Locked = true;
                }
                field(dUNSNumber; '')
                {
                    ApplicationArea = All;
                    Caption = 'dUNSNumber', Locked = true;
                }
                field(aNNumber; '')
                {
                    ApplicationArea = All;
                    Caption = 'aNNumber', Locked = true;
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
        Clear(Rec.Contact);
        Clear(PaymentMethod);
        Clear(PaymentTerms);
        Clear(Currency);
        Clear(Language);
        if GContact.Get(Rec."Primary Contact No.") then;
        if PaymentMethod.Get(Rec."Payment Method Code") then;
        if PaymentTerms.Get(Rec."Payment Terms Code") then;
        if Currency.Get(Rec."Currency Code") then;
        if Language.Get(Rec."Language Code") then;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        Vendor: Record Vendor;
        LGraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
        RecRef: RecordRef;
    begin
        Vendor.SetRange("No.", Rec."No.");
        if not Vendor.IsEmpty then
            Rec.Insert();

        Rec.Insert(true);

        ProcessPostalAddress();
        RecRef.GetTable(Rec);
        LGraphMgtGeneralTools.ProcessNewRecordFromAPI(RecRef, TempFieldSet, CurrentDateTime);
        RecRef.SetTable(Rec);

        Rec.Modify(true);
        SetCalculatedFields();
        exit(false);
    end;

    trigger OnModifyRecord(): Boolean
    var
        Vendor: Record Vendor;
        LGraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
    begin
        if xRec.SystemId <> Rec.SystemId then
            LGraphMgtGeneralTools.ErrorIdImmutable();
        Vendor.SetRange(SystemId, Rec.SystemId);
        Vendor.FindFirst();

        ProcessPostalAddress();

        if Rec."No." = Vendor."No." then
            Rec.Modify(true)
        else begin
            Vendor.TransferFields(Rec, false);
            Vendor.Rename(Rec."No.");
            Rec.TransferFields(Vendor);
        end;

        SetCalculatedFields();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ClearCalculatedFields();
    end;

    var
        Currency: Record Currency;
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        TempFieldSet: Record "Field" temporary;
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        GContact: Record Contact;
        Language: Record Language;
        GraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
        LCYCurrencyCode: Code[10];
        CurrencyCodeTxt: Text;
        PostalAddressJSON: Text;
        IRS1099Code: Code[10];
        CurrencyValuesDontMatchErr: Label 'The currency values do not match to a specific Currency.', Locked = true;
        CurrencyCodeDoesNotMatchACurrencyErr: Label 'The "currencyCode" does not match to a Currency.', Locked = true;
        BlankGUID: Guid;
        PostalAddressSet: Boolean;

    local procedure SetCalculatedFields()
    var
        GraphMgtVendor: Codeunit "Graph Mgt - Vendor";
    begin
        PostalAddressJSON := GraphMgtVendor.PostalAddressToJSON(Rec);
        CurrencyCodeTxt := GraphMgtGeneralTools.TranslateNAVCurrencyCodeToCurrencyCode(LCYCurrencyCode, Rec."Currency Code");
    end;

    local procedure ClearCalculatedFields()
    begin
        Clear(Rec.SystemId);
        Clear(PostalAddressJSON);
        Clear(IRS1099Code);
        Clear(PostalAddressSet);
        TempFieldSet.DeleteAll();
    end;

    local procedure RegisterFieldSet(FieldNo: Integer)
    begin
        if TempFieldSet.Get(DATABASE::Vendor, FieldNo) then
            exit;

        TempFieldSet.Init();
        TempFieldSet.TableNo := DATABASE::Vendor;
        TempFieldSet.Validate("No.", FieldNo);
        TempFieldSet.Insert(true);
    end;

    local procedure ProcessPostalAddress()
    var
        GraphMgtVendor: Codeunit "Graph Mgt - Vendor";
    begin
        if not PostalAddressSet then
            exit;

        GraphMgtVendor.UpdatePostalAddress(PostalAddressJSON, Rec);

        if xRec.Address <> Rec.Address then
            RegisterFieldSet(Rec.FieldNo(Address));

        if xRec."Address 2" <> Rec."Address 2" then
            RegisterFieldSet(Rec.FieldNo("Address 2"));

        if xRec.City <> Rec.City then
            RegisterFieldSet(Rec.FieldNo(City));

        if xRec."Country/Region Code" <> Rec."Country/Region Code" then
            RegisterFieldSet(Rec.FieldNo("Country/Region Code"));

        if xRec."Post Code" <> Rec."Post Code" then
            RegisterFieldSet(Rec.FieldNo("Post Code"));

        if xRec.County <> Rec.County then
            RegisterFieldSet(Rec.FieldNo(County));
    end;

    trigger OnOpenPage()
    begin
        if not MICAFinancialReportingSetup.Get() then
            MICAFinancialReportingSetup.Init();
    end;
}

