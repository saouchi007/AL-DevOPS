page 82782 "MICA S2S Sales Orders"
{
    APIVersion = 'v1.0';
#if not OnPremise    
    APIPublisher = 'MichelinCA';
    APIGroup = 'S2S';
#endif        
    Caption = 's2sSalesOrders', Locked = true;
    DelayedInsert = true;
    EntityName = 's2sSalesOrder';
    EntitySetName = 's2sSalesOrders';
    ODataKeyFields = Id;
    PageType = API;
    SourceTable = "Sales Order Entity Buffer";
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
                    Editable = false;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo(Id));
                    end;
                }
                field(seriesNo; Rec."MICA Series No.")
                {
                    ApplicationArea = All;
                    Caption = 'seriesNo', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("MICA Series No."));
                    end;
                }

                field(number; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'number', Locked = true;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("No."));
                    end;
                }
                field(externalDocumentNumber; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'externalDocumentNumber', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("External Document No."))
                    end;
                }
                field(orderDate; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Caption = 'orderDate', Locked = true;

                    trigger OnValidate()
                    begin
                        DocumentDateVar := Rec."Document Date";
                        DocumentDateSet := true;

                        RegisterFieldSet(Rec.FieldNo("Document Date"));
                    end;
                }
                field(postingDate; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'postingDate', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FIELDNO("Posting Date"));
                    end;
                }
                field(customerId; Rec."Customer Id")
                {
                    ApplicationArea = All;
                    Caption = 'customerId', Locked = true;

                    trigger OnValidate()
                    var
                        O365SalesInvoiceMgmt: Codeunit "O365 Sales Invoice Mgmt";
                    begin
                        Customer.SetRange(SystemId, Rec."Customer Id");
                        if not Customer.FindFirst() then
                            Error(CouldNotFindCustomerErr);

                        O365SalesInvoiceMgmt.EnforceCustomerTemplateIntegrity(Customer);

                        Rec."Sell-to Customer No." := Customer."No.";
                        RegisterFieldSet(Rec.FieldNo("Customer Id"));
                        RegisterFieldSet(Rec.FieldNo("Sell-to Customer No."));
                    end;
                }
                field(contactId; Rec."Contact Graph Id")
                {
                    ApplicationArea = All;
                    Caption = 'contactId', Locked = true;

                    trigger OnValidate()
                    var
                        Contact: Record Contact;
                        Customer: Record Customer;
                        GraphIntContact: Codeunit "Graph Int. - Contact";
                    begin
                        RegisterFieldSet(Rec.FieldNo("Contact Graph Id"));

                        if Rec."Contact Graph Id" = '' then
                            Error(ContactIdHasToHaveValueErr);

                        if not GraphIntContact.FindOrCreateCustomerFromGraphContactSafe(Rec."Contact Graph Id", Customer, Contact) then
                            exit;

                        UpdateCustomerFromGraphContactId(Customer);

                        if Contact."Company No." = Customer."No." then begin
                            Rec.Validate("Sell-To Contact No.", Contact."No.");
                            Rec.Validate("Sell-to Contact", Contact.Name);

                            RegisterFieldSet(Rec.FieldNo("Sell-To Contact No."));
                            RegisterFieldSet(Rec.FieldNo("Sell-to Contact"));
                        end;
                    end;
                }
                field(customerNumber; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'customerNumber', Locked = true;

                    trigger OnValidate()
                    var
                        O365SalesInvoiceMgmt: Codeunit "O365 Sales Invoice Mgmt";
                    begin
                        if Customer."No." <> '' then begin
                            if Customer."No." <> Rec."Sell-to Customer No." then
                                Error(CustomerValuesDontMatchErr);
                            exit;
                        end;

                        if not Customer.Get(Rec."Sell-to Customer No.") then
                            Error(CouldNotFindCustomerErr);

                        O365SalesInvoiceMgmt.EnforceCustomerTemplateIntegrity(Customer);

                        Rec."Customer Id" := Customer.Id;
                        RegisterFieldSet(Rec.FieldNo("Customer Id"));
                        RegisterFieldSet(Rec.FieldNo("Sell-to Customer No."));
                    end;
                }
                field(customerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Caption = 'customerName', Locked = true;
                    Editable = false;
                }
                field(billToName; Rec."Bill-to Name")
                {
                    ApplicationArea = All;
                    Caption = 'billToName', Locked = true;
                    Editable = false;
                }
                field(billToCustomerId; Rec."Bill-to Customer Id")
                {
                    ApplicationArea = All;
                    Caption = 'billToCustomerId', Locked = true;

                    trigger OnValidate()
                    var
                        O365SalesInvoiceMgmt: Codeunit "O365 Sales Invoice Mgmt";
                    begin
                        IF NOT BillToCustomer.GetBySystemId(Rec."Bill-to Customer Id") THEN
                            ERROR(CouldNotFindBillToCustomerErr);

                        O365SalesInvoiceMgmt.EnforceCustomerTemplateIntegrity(BillToCustomer);

                        Rec."Bill-to Customer No." := BillToCustomer."No.";
                        RegisterFieldSet(Rec.FIELDNO("Bill-to Customer Id"));
                        RegisterFieldSet(Rec.FIELDNO("Bill-to Customer No."));
                    end;
                }
                field(billToCustomerNumber; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'billToCustomerNumber', Locked = true;

                    trigger OnValidate()
                    var
                        O365SalesInvoiceMgmt: Codeunit "O365 Sales Invoice Mgmt";
                    begin
                        IF BillToCustomer."No." <> '' THEN BEGIN
                            IF BillToCustomer."No." <> Rec."Bill-to Customer No." THEN
                                ERROR(BillToCustomerValuesDontMatchErr);
                            EXIT;
                        END;

                        IF NOT BillToCustomer.GET(Rec."Bill-to Customer No.") THEN
                            ERROR(CouldNotFindBillToCustomerErr);

                        O365SalesInvoiceMgmt.EnforceCustomerTemplateIntegrity(BillToCustomer);

                        Rec."Bill-to Customer Id" := BillToCustomer.SystemId;
                        RegisterFieldSet(Rec.FIELDNO("Bill-to Customer Id"));
                        RegisterFieldSet(Rec.FIELDNO("Bill-to Customer No."));
                    end;
                }
                field(shipToAddressId; Rec."MICA Ship-To-Address Id")
                {
                    ApplicationArea = All;
                    Caption = 'shipToAddressId', Locked = true;

                    trigger OnValidate()
                    var
                        ShiptoAddress: Record "Ship-to Address";
                    begin
                        ShiptoAddress.SetRange(SystemId, Rec."MICA Ship-To-Address Id");
                        if not ShiptoAddress.FindFirst() then
                            Error(CurrencyIdDoesNotMatchACurrencyErr);

                        Rec."Ship-to Code" := ShiptoAddress.Code;
                        Rec."Ship-to Name" := ShiptoAddress.Name;

                        RegisterFieldSet(Rec.FieldNo("MICA Ship-To-Address Id"));
                        RegisterFieldSet(Rec.FieldNo("Ship-to Code"));
                        RegisterFieldSet(Rec.FieldNo("Ship-to Name"));
                    end;

                }
                field(shipToName; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                    Caption = 'shipToName', Locked = true;

                    trigger OnValidate()
                    begin
                        if xRec."Ship-to Name" <> Rec."Ship-to Name" then begin
                            Rec."Ship-to Code" := '';
                            RegisterFieldSet(Rec.FIELDNO("Ship-to Code"));
                            RegisterFieldSet(Rec.FIELDNO("Ship-to Name"));
                        end;
                    end;
                }
                field(shipToContact; Rec."Ship-to Contact")
                {
                    ApplicationArea = All;
                    Caption = 'shipToContact', Locked = true;

                    trigger OnValidate()
                    begin
                        if xRec."Ship-to Contact" <> Rec."Ship-to Contact" then begin
                            Rec."Ship-to Code" := '';
                            RegisterFieldSet(Rec.FIELDNO("Ship-to Code"));
                            RegisterFieldSet(Rec.FIELDNO("Ship-to Contact"));
                        end;
                    end;
                }
                field(sellingPostalAddress; SellingPostalAddressJSONText)
                {
                    ApplicationArea = All;
                    Caption = 'sellingPostalAddress', Locked = true;
                    ODataEDMType = 'POSTALADDRESS';
                    ToolTip = 'Specifies the selling address of the Sales Invoice.';

                    trigger OnValidate()
                    begin
                    end;
                }
                field(billingPostalAddress; BillingPostalAddressJSONText)
                {
                    ApplicationArea = All;
                    Caption = 'billingPostalAddress', Locked = true;
                    ODataEDMType = 'POSTALADDRESS';
                    ToolTip = 'Specifies the billing address of the Sales Invoice.';

                    trigger OnValidate()
                    begin
                        BillingPostalAddressSet := true;
                    end;
                }
                field(shippingPostalAddress; ShippingPostalAddressJSONText)
                {
                    ApplicationArea = All;
                    Caption = 'shippingPostalAddress', Locked = true;
                    ODataEDMType = 'POSTALADDRESS';
                    ToolTip = 'Specifies the shipping address of the Sales Invoice.';

                    trigger OnValidate()
                    begin
                    end;
                }
                field(currencyId; Rec."Currency Id")
                {
                    ApplicationArea = All;
                    Caption = 'CurrencyId', Locked = true;

                    trigger OnValidate()
                    begin
                        if Rec."Currency Id" = BlankGUID then
                            Rec."Currency Code" := ''
                        else begin
                            Currency.SetRange(Id, Rec."Currency Id");
                            if not Currency.FindFirst() then
                                Error(CurrencyIdDoesNotMatchACurrencyErr);

                            Rec."Currency Code" := Currency.Code;
                        end;

                        RegisterFieldSet(Rec.FieldNo("Currency Id"));
                        RegisterFieldSet(Rec.FieldNo("Currency Code"));
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

                            Rec."Currency Id" := Currency.Id;
                        end;

                        RegisterFieldSet(Rec.FieldNo("Currency Id"));
                        RegisterFieldSet(Rec.FieldNo("Currency Code"));
                    end;
                }
                field(pricesIncludeTax; Rec."Prices Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'pricesIncludeTax', Locked = true;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Prices Including VAT"));
                    end;
                }
                field(paymentTermsId; Rec."Payment Terms Id")
                {
                    ApplicationArea = All;
                    Caption = 'PaymentTermsId', Locked = true;

                    trigger OnValidate()
                    begin
                        if Rec."Payment Terms Id" = BlankGUID then
                            Rec."Payment Terms Code" := ''
                        else begin
                            PaymentTerms.SetRange(Id, Rec."Payment Terms Id");
                            if not PaymentTerms.FindFirst() then
                                Error(PaymentTermsIdDoesNotMatchAPaymentTermsErr);

                            Rec."Payment Terms Code" := PaymentTerms.Code;
                        end;

                        RegisterFieldSet(Rec.FieldNo("Payment Terms Id"));
                        RegisterFieldSet(Rec.FieldNo("Payment Terms Code"));
                    end;
                }
                field(shipmentMethodId; Rec."Shipment Method Id")
                {
                    ApplicationArea = All;
                    Caption = 'ShipmentMethodId', Locked = true;

                    trigger OnValidate()
                    begin
                        if Rec."Shipment Method Id" = BlankGUID then
                            Rec."Shipment Method Code" := ''
                        else begin
                            ShipmentMethod.SetRange(Id, Rec."Shipment Method Id");
                            if not ShipmentMethod.FindFirst() then
                                Error(ShipmentMethodIdDoesNotMatchAShipmentMethodErr);

                            Rec."Shipment Method Code" := ShipmentMethod.Code;
                        end;

                        RegisterFieldSet(Rec.FieldNo("Shipment Method Id"));
                        RegisterFieldSet(Rec.FieldNo("Shipment Method Code"));
                    end;
                }
                field(salesperson; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    Caption = 'salesperson', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Salesperson Code"));
                    end;
                }
                field(partialShipping; PartialShipping)
                {
                    ApplicationArea = All;
                    Caption = 'partialShipping', Locked = true;

                    trigger OnValidate()
                    begin
                        ProcessPartialShipping();
                    end;
                }
                field(requestedDeliveryDate; Rec."Requested Delivery Date")
                {
                    ApplicationArea = All;
                    Caption = 'requestedDeliveryDate', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Requested Delivery Date"));
                    end;
                }
                part(salesOrderLines2; "Sales Order Line Entity")
                {
                    ApplicationArea = All;
                    Caption = 'Lines', Locked = true;
                    EntityName = 'salesOrderLine2';
                    EntitySetName = 'salesOrderLines2';
                    SubPageLink = "Document Id" = FIELD(Id);
                }
                part(salesOrderLines; "MICA S2S Sales Order Lines")
                {
                    ApplicationArea = All;
                    Caption = 'Lines', Locked = true;
                    EntityName = 's2sSalesOrderLine';
                    EntitySetName = 's2sSalesOrderLines';
                    SubPageLink = "Document Id" = FIELD(Id);
                }
                field(discountAmount; Rec."Invoice Discount Amount")
                {
                    ApplicationArea = All;
                    Caption = 'discountAmount', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Invoice Discount Amount"));
                        InvoiceDiscountAmount := Rec."Invoice Discount Amount";
                        DiscountAmountSet := true;
                    end;
                }
                field(discountAppliedBeforeTax; Rec."Discount Applied Before Tax")
                {
                    ApplicationArea = All;
                    Caption = 'discountAppliedBeforeTax', Locked = true;
                    Editable = false;
                }
                field(totalAmountExcludingTax; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'totalAmountExcludingTax', Locked = true;
                    Editable = false;
                }
                field(totalTaxAmount; Rec."Total Tax Amount")
                {
                    ApplicationArea = All;
                    Caption = 'totalTaxAmount', Locked = true;
                    Editable = false;
                    ToolTip = 'Specifies the total tax amount for the sales invoice.';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Total Tax Amount"));
                    end;
                }
                field(totalAmountIncludingTax; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'totalAmountIncludingTax', Locked = true;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Amount Including VAT"));
                    end;
                }
                field(fullyShipped; Rec."Completely Shipped")
                {
                    ApplicationArea = All;
                    Caption = 'fullyShipped', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Completely Shipped"));
                    end;
                }
                field(status; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'status', Locked = true;
                    Editable = false;
                    ToolTip = 'Specifies the status of the Sales Invoice (cancelled, paid, on hold, created).';
                }
                field(lastModifiedDateTime; Rec."Last Modified Date Time")
                {
                    ApplicationArea = All;
                    Caption = 'lastModifiedDateTime', Locked = true;
                    Editable = false;
                }
                field(phoneNumber; Rec."Sell-to Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'PhoneNumber', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Sell-to Phone No."));
                    end;
                }
                field(email; Rec."Sell-to E-Mail")
                {
                    ApplicationArea = All;
                    Caption = 'Email', Locked = true;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Sell-to E-Mail"));
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
        if HasWritePermission then
            GraphMgtSalesOrderBuffer.RedistributeInvoiceDiscounts(Rec);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        GraphMgtSalesOrderBuffer.PropagateOnDelete(Rec);

        exit(false);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CheckCustomerSpecified();
        ProcessBillingPostalAddress();

        GraphMgtSalesOrderBuffer.PropagateOnInsert(Rec, TempFieldBuffer);
        SetDates();

        UpdateDiscount();

        SetCalculatedFields();

        exit(false);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if xRec.Id <> Rec.Id then
            Error(CannotChangeIDErr);

        ProcessBillingPostalAddress();

        GraphMgtSalesOrderBuffer.PropagateOnModify(Rec, TempFieldBuffer);
        UpdateDiscount();

        SetCalculatedFields();

        exit(false);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ClearCalculatedFields();
    end;

    trigger OnOpenPage()
    begin
        CheckPermissions();
    end;

    var
        TempFieldBuffer: Record "Field Buffer" temporary;
        BillToCustomer: Record "Customer";
        Customer: Record Customer;
        Currency: Record Currency;
        PaymentTerms: Record "Payment Terms";
        ShipmentMethod: Record "Shipment Method";
        GraphMgtSalesOrderBuffer: Codeunit "Graph Mgt - Sales Order Buffer";
        GraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
        LCYCurrencyCode: Code[10];
        CurrencyCodeTxt: Text;
        SellingPostalAddressJSONText: Text;
        BillingPostalAddressJSONText: Text;
        BillingPostalAddressSet: Boolean;
        ShippingPostalAddressJSONText: Text;
        CustomerNotProvidedErr: Label 'A customerNumber or a customerId must be provided.', Locked = true;
        CustomerValuesDontMatchErr: Label 'The customer values do not match to a specific Customer.', Locked = true;
        CouldNotFindCustomerErr: Label 'The customer cannot be found.', Locked = true;
        CannotChangeIDErr: Label 'The id cannot be changed.', Locked = true;
        PartialShipping: Boolean;
        ContactIdHasToHaveValueErr: Label 'Contact Id must have a value set.', Locked = true;
        BillToCustomerValuesDontMatchErr: Label 'The bill-to customer values do not match to a specific Customer.', Locked = true;
        CouldNotFindBillToCustomerErr: Label 'The bill-to customer cannot be found.', Locked = true;
        SalesOrderPermissionsErr: Label 'You do not have permissions to read Sales Orders.';
        CurrencyValuesDontMatchErr: Label 'The currency values do not match to a specific Currency.', Locked = true;
        CurrencyIdDoesNotMatchACurrencyErr: Label 'The "currencyId" does not match to a Currency.', Locked = true;
        CurrencyCodeDoesNotMatchACurrencyErr: Label 'The "currencyCode" does not match to a Currency.', Locked = true;
        PaymentTermsIdDoesNotMatchAPaymentTermsErr: Label 'The "paymentTermsId" does not match to a Payment Terms.', Locked = true;
        ShipmentMethodIdDoesNotMatchAShipmentMethodErr: Label 'The "shipmentMethodId" does not match to a Shipment Method.', Locked = true;
        CannotFindOrderErr: Label 'The order cannot be found.', Locked = true;
        DiscountAmountSet: Boolean;
        InvoiceDiscountAmount: Decimal;
        BlankGUID: Guid;
        DocumentDateSet: Boolean;
        DocumentDateVar: Date;
        HasWritePermission: Boolean;

    local procedure SetCalculatedFields()
    var
        GraphMgtSalesOrder: Codeunit "Graph Mgt - Sales Order";
    begin
        SellingPostalAddressJSONText := GraphMgtSalesOrder.SellToCustomerAddressToJSON(Rec);
        BillingPostalAddressJSONText := GraphMgtSalesOrder.BillToCustomerAddressToJSON(Rec);
        CurrencyCodeTxt := GraphMgtGeneralTools.TranslateNAVCurrencyCodeToCurrencyCode(LCYCurrencyCode, Rec."Currency Code");
        PartialShipping := (Rec."Shipping Advice" = Rec."Shipping Advice"::Partial);
    end;

    local procedure ClearCalculatedFields()
    begin
        CLEAR(SellingPostalAddressJSONText);
        Clear(BillingPostalAddressJSONText);
        Clear(DiscountAmountSet);
        Clear(InvoiceDiscountAmount);

        PartialShipping := false;
        TempFieldBuffer.DeleteAll();
    end;

    local procedure RegisterFieldSet(FieldNo: Integer)
    var
        LastOrderNo: Integer;
    begin
        LastOrderNo := 1;
        if TempFieldBuffer.FindLast() then
            LastOrderNo := TempFieldBuffer.Order + 1;

        Clear(TempFieldBuffer);
        TempFieldBuffer.Order := LastOrderNo;
        TempFieldBuffer."Table ID" := DATABASE::"Sales Invoice Entity Aggregate";
        TempFieldBuffer."Field ID" := FieldNo;
        TempFieldBuffer.Insert();
    end;

    local procedure CheckCustomerSpecified()
    begin
        if (Rec."Sell-to Customer No." = '') and
           (Rec."Customer Id" = BlankGUID)
        then
            Error(CustomerNotProvidedErr);
    end;

    local procedure ProcessBillingPostalAddress()
    var
        GraphMgtSalesOrder: Codeunit "Graph Mgt - Sales Order";
    begin
        if not BillingPostalAddressSet then
            exit;

        GraphMgtSalesOrder.ProcessComplexTypes(Rec, BillingPostalAddressJSONText);

        if xRec."Sell-to Address" <> Rec."Sell-to Address" then
            RegisterFieldSet(Rec.FieldNo("Sell-to Address"));

        if xRec."Sell-to Address 2" <> Rec."Sell-to Address 2" then
            RegisterFieldSet(Rec.FieldNo("Sell-to Address 2"));

        if xRec."Sell-to City" <> Rec."Sell-to City" then
            RegisterFieldSet(Rec.FieldNo("Sell-to City"));

        if xRec."Sell-to Country/Region Code" <> Rec."Sell-to Country/Region Code" then
            RegisterFieldSet(Rec.FieldNo("Sell-to Country/Region Code"));

        if xRec."Sell-to Post Code" <> Rec."Sell-to Post Code" then
            RegisterFieldSet(Rec.FieldNo("Sell-to Post Code"));

        if xRec."Sell-to County" <> Rec."Sell-to County" then
            RegisterFieldSet(Rec.FieldNo("Sell-to County"));
    end;

    local procedure ProcessPartialShipping()
    begin
        if PartialShipping then
            Rec."Shipping Advice" := Rec."Shipping Advice"::Partial
        else
            Rec."Shipping Advice" := Rec."Shipping Advice"::Complete;

        RegisterFieldSet(Rec.FieldNo("Shipping Advice"));
    end;

    local procedure UpdateCustomerFromGraphContactId(var Customer: Record Customer)
    var
        O365SalesInvoiceMgmt: Codeunit "O365 Sales Invoice Mgmt";
        UpdateCustomer: Boolean;
    begin
        UpdateCustomer := Rec."Sell-to Customer No." = '';
        if not UpdateCustomer then begin
            TempFieldBuffer.Reset();
            TempFieldBuffer.SetRange("Field ID", Rec.FieldNo("Customer Id"));
            UpdateCustomer := not TempFieldBuffer.FindFirst();
            TempFieldBuffer.Reset();
        end;

        if UpdateCustomer then begin
            Rec.Validate("Customer Id", Customer.Id);
            Rec.Validate("Sell-to Customer No.", Customer."No.");
            RegisterFieldSet(Rec.FieldNo("Customer Id"));
            RegisterFieldSet(Rec.FieldNo("Sell-to Customer No."));
        end;

        O365SalesInvoiceMgmt.EnforceCustomerTemplateIntegrity(Customer);
    end;

    local procedure CheckPermissions()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        if not SalesHeader.ReadPermission then
            Error(SalesOrderPermissionsErr);

        HasWritePermission := SalesHeader.WritePermission;
    end;

    local procedure UpdateDiscount()
    var
        SalesHeader: Record "Sales Header";
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
    begin
        if not DiscountAmountSet then begin
            GraphMgtSalesOrderBuffer.RedistributeInvoiceDiscounts(Rec);
            exit;
        end;

        SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."No.");
        SalesCalcDiscountByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, SalesHeader);
    end;

    local procedure SetDates()
    var
        LocalGraphMgtSalesOrderBuffer: Codeunit "Graph Mgt - Sales Order Buffer";
    begin
        if not DocumentDateSet then
            exit;

        TempFieldBuffer.Reset();
        TempFieldBuffer.DeleteAll();

        if DocumentDateSet then begin
            Rec."Document Date" := DocumentDateVar;
            RegisterFieldSet(Rec.FieldNo("Document Date"));
        end;

        LocalGraphMgtSalesOrderBuffer.PropagateOnModify(Rec, TempFieldBuffer);
        Rec.Find();
    end;

    local procedure GetOrder(var SalesHeader: Record "Sales Header")
    begin
        IF NOT SalesHeader.GetBySystemId(Rec.Id) THEN
            ERROR(CannotFindOrderErr);
    end;

    [ServiceEnabled]
    [Scope('OnPrem')]
    procedure CommitAllForInquiry(var actionContext: WebServiceActionContext)
    var
    begin
        CommitAll(actionContext, true);
    end;

    [ServiceEnabled]
    [Scope('OnPrem')]
    procedure CommitAllForOrder(var actionContext: WebServiceActionContext)
    var
    begin
        CommitAll(actionContext, false);
    end;

    local procedure CommitAll(var actionContext: WebServiceActionContext; FromAPI: Boolean)
    var
        SalesHeader: Record "Sales Header";
        MICAAPISalesLine: Record "MICA API Sales Line";
    begin
        GetOrder(SalesHeader);
        if FromAPI then begin
            MICAAPISalesLine.SetRange("Document Type", SalesHeader."Document Type");
            MICAAPISalesLine.SetRange("Document No.", SalesHeader."No.");
            MICAAPISalesLine.DeleteAll(false);
        end;
        SalesHeader.CommitAll(FromAPI);

        actionContext.SetObjectType(ObjectType::Page);
        actionContext.SetObjectId(Page::"MICA S2S Sales Orders");
        actionContext.AddEntityKey(Rec.FIELDNO("No."), Rec."No.");

        // Set the result code to inform the caller that an item was created.
        actionContext.SetResultCode(WebServiceActionResultCode::Updated);
    end;
}