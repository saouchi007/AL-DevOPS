codeunit 82821 "MICA Flow Update Cust. PTY"
{
    TableNo = "MICA Flow Buffer Cust. PTY";

    trigger OnRun()
    begin
        ProcessData(Rec);
    end;

    local procedure ProcessData(MICAFlowBufferCustPTY: Record "MICA Flow Buffer Cust. PTY")
    var
        Customer: Record Customer;
        MICAFlowRecord: Record "MICA Flow Record";
        MICAFlowEntry: Record "MICA Flow Entry";
    begin
        GeneralLedgerSetup.Get();
        SalesReceivablesSetup.Get();

        CreateOrUpdateNewCustomer(Customer, MICAFlowBufferCustPTY);
        MICAFlowRecord.UpdateReceiveRecord(MICAFlowBufferCustPTY."Flow Entry No.", Customer.RecordId(), MICAFlowEntry."Receive Status"::Processed);
    end;

    local procedure CreateOrUpdateNewCustomer(var NewCustomer: Record Customer; MICAFlowBufferCustPTY: Record "MICA Flow Buffer Cust. PTY")
    begin
        if not CustomerExist(NewCustomer, MICAFlowBufferCustPTY."MICA MDM Bill-to Site Use ID") then
            InsertOrModifyCustomer(NewCustomer, MICAFlowBufferCustPTY, true)
        else
            InsertOrModifyCustomer(NewCustomer, MICAFlowBufferCustPTY, false);
    end;

    local procedure CustomerExist(var NewCustomer: Record Customer; NewBillToSiteUseID: Code[20]): Boolean
    begin
        NewCustomer.Reset();
        NewCustomer.SetRange("MICA MDM Bill-to Site Use ID", NewBillToSiteUseID);
        exit(NewCustomer.FindFirst());
    end;

    local procedure InsertOrModifyCustomer(var NewCustomer: Record Customer; MICAFlowBufferCustPTY: Record "MICA Flow Buffer Cust. PTY"; InsertOrModify: Boolean)
    begin
        if InsertOrModify then begin
            NewCustomer.Init();
            NewCustomer.Insert(true);
            ModifyCustomerData(NewCustomer, MICAFlowBufferCustPTY, InsertOrModify);
        end else
            ModifyCustomerData(NewCustomer, MICAFlowBufferCustPTY, InsertOrModify);
    end;

    local procedure ModifyCustomerData(var NewCustomer: Record Customer; MICAFlowBufferCustPTY: Record "MICA Flow Buffer Cust. PTY"; IsNewCustomer: Boolean)
    begin
        if MICAFlowBufferCustPTY.Name <> '' then
            NewCustomer.Validate(Name, MICAFlowBufferCustPTY.Name);
        if MICAFlowBufferCustPTY.Address <> '' then
            NewCustomer.Validate(Address, MICAFlowBufferCustPTY.Address);
        if MICAFlowBufferCustPTY."Address 2" <> '' then
            NewCustomer.Validate("Address 2", MICAFlowBufferCustPTY."Address 2");
        if MICAFlowBufferCustPTY.City <> '' then
            NewCustomer.Validate(City, MICAFlowBufferCustPTY.City);
        if MICAFlowBufferCustPTY."Currency Code" <> '' then
            SetCurrencyCode(NewCustomer, MICAFlowBufferCustPTY);

        if MICAFlowBufferCustPTY."Language Code" <> '' then
            NewCustomer.Validate("Language Code", MICAFlowBufferCustPTY."Language Code");
        if MICAFlowBufferCustPTY."Country/Region Code" <> '' then
            NewCustomer.Validate("Country/Region Code", MICAFlowBufferCustPTY."Country/Region Code");
        if MICAFlowBufferCustPTY."Bill-to Customer No." <> '' then
            NewCustomer."Bill-to Customer No." := MICAFlowBufferCustPTY."Bill-to Customer No.";
        if MICAFlowBufferCustPTY."VAT Registration No." <> '' then
            NewCustomer."VAT Registration No." := MICAFlowBufferCustPTY."VAT Registration No.";
        if MICAFlowBufferCustPTY."Post Code" <> '' then
            NewCustomer.Validate("Post Code", MICAFlowBufferCustPTY."Post Code");
        if MICAFlowBufferCustPTY.County <> '' then
            NewCustomer.Validate(County, MICAFlowBufferCustPTY.County);

        if IsNewCustomer then begin
            SetContactData(NewCustomer);
            SetNewCustomerData(NewCustomer);
        end else
            SetBlockedStatus(NewCustomer, MICAFlowBufferCustPTY);

        if MICAFlowBufferCustPTY."MICA Type Raw" <> '' then
            NewCustomer.Validate("MICA Type", MICAFlowBufferCustPTY."MICA Type");
        if MICAFlowBufferCustPTY."MICA Status Raw" <> '' then begin
            if not IsNewCustomer and (MICAFlowBufferCustPTY."MICA Status" = MICAFlowBufferCustPTY."MICA Status"::Inactive) then
                UpdateAllShipToAsInactive(NewCustomer."No.");
            NewCustomer.Validate("MICA Status", MICAFlowBufferCustPTY."MICA Status");
        end;

        if MICAFlowBufferCustPTY."MICA Market Code" <> '' then
            NewCustomer.Validate("MICA Market Code", MICAFlowBufferCustPTY."MICA Market Code");
        if MICAFlowBufferCustPTY."MICA English Name" <> '' then
            NewCustomer.Validate("MICA English Name", MICAFlowBufferCustPTY."MICA English Name");
        if MICAFlowBufferCustPTY."MICA Party Ownership Raw" <> '' then
            NewCustomer.Validate("MICA Party Ownership", MICAFlowBufferCustPTY."MICA Party Ownership");
        if MICAFlowBufferCustPTY."MICA Channel" <> '' then
            NewCustomer.Validate("MICA Channel", MICAFlowBufferCustPTY."MICA Channel");
        if MICAFlowBufferCustPTY."MICA Business Orientation" <> '' then
            NewCustomer.Validate("MICA Business Orientation", MICAFlowBufferCustPTY."MICA Business Orientation");
        if MICAFlowBufferCustPTY."MICA Partnership" <> '' then
            NewCustomer.Validate("MICA Partnership", MICAFlowBufferCustPTY."MICA Partnership");
        if MICAFlowBufferCustPTY."MICA MDM ID LE" <> '' then
            NewCustomer.Validate("MICA MDM ID LE", MICAFlowBufferCustPTY."MICA MDM ID LE");
        if MICAFlowBufferCustPTY."MICA TimeZone Raw" <> '' then
            NewCustomer.Validate("MICA Time Zone", MICAFlowBufferCustPTY."MICA TimeZone");
        if MICAFlowBufferCustPTY."MICA MDM Bill-to Site Use ID" <> '' then
            NewCustomer.Validate("MICA MDM Bill-to Site Use ID", MICAFlowBufferCustPTY."MICA MDM Bill-to Site Use ID");
        if MICAFlowBufferCustPTY."MICA MDM ID BT" <> '' then
            NewCustomer.Validate("MICA MDM ID BT", MICAFlowBufferCustPTY."MICA MDM ID BT");
        if MICAFlowBufferCustPTY."MICA Customer Type Raw" <> '' then
            NewCustomer.Validate("MICA Segmentation Code", MICAFlowBufferCustPTY."MICA Segmentation Code");
        if MICAFlowBufferCustPTY."MICA RPL Status" <> '' then
            NewCustomer.Validate("MICA RPL Status", MICAFlowBufferCustPTY."MICA RPL Status");
        NewCustomer.Modify(true);
    end;

    local procedure SetCurrencyCode(var Customer: Record Customer; MICAFlowBufferCustPTY: Record "MICA Flow Buffer Cust. PTY")
    begin
        if MICAFlowBufferCustPTY."Currency Code" <> GeneralLedgerSetup."LCY Code" then
            Customer.Validate("Currency Code", MICAFlowBufferCustPTY."Currency Code")
        else
            Customer.Validate("Currency Code", '');
    end;

    local procedure SetNewCustomerData(var Customer: Record Customer)
    begin
        Customer.Validate("Credit Limit (LCY)", 1);
        Customer.Validate("MICA % Of Prepayment", SalesReceivablesSetup."MICA Default % of Prepayment");
        Customer.Validate(Blocked, Customer.Blocked::All)
    end;

    local procedure SetBlockedStatus(var Customer: Record Customer; MICAFlowBufferCustPTY: Record "MICA Flow Buffer Cust. PTY")
    var
        MICAValueTable: Record "MICA Table Value";
    begin
        if MICAValueTable.Get(MICAValueTable."Table Type"::RestrictedSite, MICAFlowBufferCustPTY."MICA RPL Status") then
            if MICAValueTable."Block Value" then
                Customer.Validate(Blocked, Customer.Blocked::All)
            else
                Customer.Validate(Blocked, Customer.Blocked::" ");

    end;

    local procedure SetContactData(var Customer: Record Customer)
    var
        ContactBusinessRelation: Record "Contact Business Relation";
        Contact: Record Contact;
    begin
        Contact.FilterGroup(2);
        if ContactBusinessRelation.FindByRelation(ContactBusinessRelation."Link to Table"::Customer, Customer."No.") then
            Contact.SetRange("Company No.", ContactBusinessRelation."Contact No.");

        if Contact.FindFirst() then begin
            Customer.Validate("Contact Type", Contact.Type);
            Customer.Validate("Primary Contact No.", Contact."No.");
            Customer.Validate(Contact, Contact."No.");
        end;
    end;

    local procedure UpdateAllShipToAsInactive(CustomerNo: Code[20])
    var
        ShiptoAddress: Record "Ship-to Address";
    begin
        ShiptoAddress.SetCurrentKey("Customer No.", "Code");
        ShiptoAddress.SetRange("Customer No.", CustomerNo);
        ShiptoAddress.SetRange("MICA Status", ShiptoAddress."MICA Status"::Active);
        if ShiptoAddress.IsEmpty() then
            exit;
        ShiptoAddress.ModifyAll("MICA Status", ShiptoAddress."MICA Status"::Inactive);
    end;


    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
}