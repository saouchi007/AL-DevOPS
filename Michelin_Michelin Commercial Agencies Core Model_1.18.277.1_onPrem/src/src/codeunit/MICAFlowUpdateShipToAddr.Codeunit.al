codeunit 82841 "MICA Flow Update ShipTo Addr."
{
    TableNo = "MICA Flow Buffer StA PTY";

    trigger OnRun()
    begin
        ProcessData(Rec);
    end;

    local procedure ProcessData(MICAFlowBufferStAPTY: Record "MICA Flow Buffer StA PTY")
    var
        MICAFlowRecord: Record "MICA Flow Record";
        MICAFlowEntry: Record "MICA Flow Entry";
        ShiptoAddress: Record "Ship-to Address";
    begin
        CreateOrUpdateNewShipToAddress(ShiptoAddress, MICAFlowBufferStAPTY);
        MICAFlowRecord.UpdateReceiveRecord(MICAFlowBufferStAPTY."Flow Entry No.", ShiptoAddress.RecordId(), MICAFlowEntry."Receive Status"::Processed);
    end;

    local procedure CreateOrUpdateNewShipToAddress(var ShiptoAddress: Record "Ship-to Address"; MICAFlowBufferStAPTY: Record "MICA Flow Buffer StA PTY")
    var
        Customer: Record Customer;
    begin
        if not CheckIfShipToExist(ShiptoAddress, MICAFlowBufferStAPTY."MICA MDM Ship-to Use ID") then begin
            if CheckIfCustomerExist(Customer, MICAFlowBufferStAPTY) then
                InsertOrModifyShipToAddress(ShiptoAddress, Customer."No.", MICAFlowBufferStAPTY, true);
        end else
            InsertOrModifyShipToAddress(ShiptoAddress, Customer."No.", MICAFlowBufferStAPTY, false);
    end;

    local procedure CheckIfCustomerExist(var NewCustomer: Record Customer; NewMICAFlowBufferStAPTY: Record "MICA Flow Buffer StA PTY"): Boolean
    begin
        NewCustomer.Reset();
        NewCustomer.SetRange("MICA MDM Bill-to Site Use ID", NewMICAFlowBufferStAPTY."Customer No.");
        exit(NewCustomer.FindFirst());
    end;

    local procedure CheckIfShipToExist(var ShiptoAddress: Record "Ship-to Address"; ShipToUseSiteID: Code[20]): Boolean
    begin
        ShiptoAddress.SetCurrentKey("MICA MDM Ship-to Use ID");
        ShiptoAddress.SetRange("MICA MDM Ship-to Use ID", ShipToUseSiteID);
        exit(ShiptoAddress.FindFirst());
    end;

    local procedure InsertOrModifyShipToAddress(var ShiptoAddress: Record "Ship-to Address"; CustomerNo: Code[20]; MICAFlowBufferStAPTY: Record "MICA Flow Buffer StA PTY"; InsertOrModify: Boolean)
    begin
        if InsertOrModify then begin
            ShiptoAddress.Init();
            ShiptoAddress.Validate("Customer No.", CustomerNo);
            ShiptoAddress.Validate(Code, GetNextSeriesNo(MICAFlowBufferStAPTY."Ship-to Addr. Nos."));
            ShiptoAddress.Insert(true);

            ModifyShipToAddrValues(ShiptoAddress, MICAFlowBufferStAPTY);
            CheckIfCustomerHasDefaultShipTo(CustomerNo, ShiptoAddress.Code);
        end else
            ModifyShipToAddrValues(ShiptoAddress, MICAFlowBufferStAPTY);
    end;

    local procedure GetNextSeriesNo(ShipToAddrNos: Code[20]): Code[10]
    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        LastShipToAddrCode: Code[20];
        DummyCode: Code[10];
    begin
        LastShipToAddrCode := NoSeriesManagement.GetNextNo(ShipToAddrNos, Today(), true);
        DummyCode := CopyStr(CopyStr(LastShipToAddrCode, 1, MaxStrLen(LastShipToAddrCode)), 1, MaxStrLen(DummyCode));
        exit(DummyCode);
    end;

    local procedure ModifyShipToAddrValues(var ShiptoAddress: Record "Ship-to Address"; MICAFlowBufferStAPTY: Record "MICA Flow Buffer StA PTY")
    begin
        if MICAFlowBufferStAPTY.Name <> '' then
            ShiptoAddress.Validate(Name, MICAFlowBufferStAPTY.Name);
        if MICAFlowBufferStAPTY.Address <> '' then
            ShiptoAddress.Validate(Address, MICAFlowBufferStAPTY.Address);
        if MICAFlowBufferStAPTY."Address 2" <> '' then
            ShiptoAddress.Validate("Address 2", MICAFlowBufferStAPTY."Address 2");
        if MICAFlowBufferStAPTY.City <> '' then
            ShiptoAddress.Validate(City, MICAFlowBufferStAPTY.City);
        if MICAFlowBufferStAPTY."Country/Region Code" <> '' then
            ShiptoAddress.Validate("Country/Region Code", MICAFlowBufferStAPTY."Country/Region Code");
        if MICAFlowBufferStAPTY."Post Code" <> '' then
            ShiptoAddress.Validate("Post Code", MICAFlowBufferStAPTY."Post Code");
        if MICAFlowBufferStAPTY."MICA Time Zone Raw" <> '' then
            ShiptoAddress.Validate("MICA Time Zone", MICAFlowBufferStAPTY."MICA Time Zone");
        if MICAFlowBufferStAPTY."MICA MDM ID" <> '' then
            ShiptoAddress.Validate("MICA MDM ID", MICAFlowBufferStAPTY."MICA MDM ID");
        if MICAFlowBufferStAPTY."MICA Status Raw" <> '' then
            ShiptoAddress.Validate("MICA Status", MICAFlowBufferStAPTY."MICA Status");
        if MICAFlowBufferStAPTY."MICA RPL Status" <> '' then
            ShiptoAddress.Validate("MICA RPL Status", MICAFlowBufferStAPTY."MICA RPL Status");
        if MICAFlowBufferStAPTY."MICA MDM Ship-to Use ID" <> '' then
            ShiptoAddress.Validate("MICA MDM Ship-to Use ID", MICAFlowBufferStAPTY."MICA MDM Ship-to Use ID");
        ShiptoAddress.Modify(true);
    end;

    local procedure CheckIfCustomerHasDefaultShipTo(CustomerNo: Code[20]; ShipToCode: Code[10])
    var
        Customer: Record Customer;
    begin
        if not Customer.Get(CustomerNo) then
            Customer.Init();

        if Customer."Ship-to Code" <> '' then
            exit;

        Customer."Ship-to Code" := ShipToCode;
        Customer.Modify();
    end;
}