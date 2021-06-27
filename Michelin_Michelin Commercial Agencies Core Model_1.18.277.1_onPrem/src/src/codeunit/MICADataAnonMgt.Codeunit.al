codeunit 82960 "MICA Data Anon. Mgt"
{
    var
        Contact: Record Contact;
        Customer: Record Customer;
        CustomerBankAccount: Record "Customer Bank Account";
        Employee: Record Employee;
        Vendor: Record Vendor;
        VendorBankAccount: Record "Vendor Bank Account";
        BankAccount: Record "Bank Account";
        Location: Record Location;
        MICAFlow: Record "MICA Flow";
        MICAFlowEndpoint: Record "MICA Flow EndPoint";
        JobQueueEntry: Record "Job Queue Entry";

    trigger OnRun()
    begin
        if Contact.FindSet(true, false) then
            repeat
                Clear(Contact."Phone No.");
                Clear(Contact."Mobile Phone No.");
                Clear(Contact."E-Mail");
                Clear(Contact."E-Mail 2");
                Clear(Contact."Fax No.");
                Clear(Contact."Home Page");
                Clear(Contact."Post Code");
                Clear(Contact.City);
                Contact.Validate(Address, 'Address');
                Contact.Validate("Address 2", 'Address 2');
                Contact.Validate(Name, 'Contact');
                Contact.Modify(false);
            until Contact.Next() = 0;

        if Customer.FindSet(true, false) then
            repeat
                Clear(Customer."Primary Contact No.");
                Clear(Customer."Phone No.");
                Clear(Customer."E-Mail");
                Clear(Customer."Fax No.");
                Customer.Validate(Address, 'Address');
                Customer.Validate("Address 2", 'Address 2');
                Customer.Validate(Contact, 'Contact');
                Customer.Modify(false);
            until Customer.Next() = 0;

        if CustomerBankAccount.FindSet(true, false) then
            repeat
                Clear(CustomerBankAccount."Bank Branch No.");
                Clear(CustomerBankAccount."Bank Account No.");
                Clear(CustomerBankAccount."Transit No.");
                Clear(CustomerBankAccount."Fax No.");
                Clear(CustomerBankAccount."E-Mail");
                Clear(CustomerBankAccount."SWIFT Code");
                Clear(CustomerBankAccount.IBAN);
                Clear(CustomerBankAccount."Bank Clearing Code");
                Clear(CustomerBankAccount."Bank Clearing Standard");
                CustomerBankAccount.Modify(false);
            until CustomerBankAccount.Next() = 0;

        if Employee.FindSet(true, false) then
            repeat
                Clear(Employee."Mobile Phone No.");
                Clear(Employee."Phone No.");
                Clear(Employee."E-Mail");
                Clear(Employee."Employee Posting Group");
                Clear(Employee."Application Method");
                Clear(Employee."Bank Branch No.");
                Clear(Employee."Bank Account No.");
                Clear(Employee.IBAN);
                Clear(Employee."SWIFT Code");
                Clear(Employee."MICA NCC");
                Clear(Employee."MICA Ctry Credit Agent No.");
                Clear(Employee."MICA Bank Beneficiary Name");
                Clear(Employee."MICA Bank Account Type");
                Clear(Employee."MICA Employee VAT Reg. No.");
                Clear(Employee."MICA Payment Method Code");
                Employee.Validate(Address, 'Address');
                Employee.Validate("Address 2", 'Address 2');
                Employee.Modify(false);
            until Employee.Next() = 0;

        if Vendor.FindSet(true, false) then
            repeat
                Clear(Vendor.Contact);
                Clear(Vendor."Phone No.");
                Clear(Vendor."E-Mail");
                Clear(Vendor."Fax No.");
                Vendor.Validate(Address, 'Address');
                Vendor.Validate("Address 2", 'Address 2');
                Vendor.Modify(false);
            until Vendor.Next() = 0;

        if VendorBankAccount.FindSet(true, false) then
            repeat
                Clear(VendorBankAccount."Bank Branch No.");
                Clear(VendorBankAccount."Bank Account No.");
                Clear(VendorBankAccount."Fax No.");
                Clear(VendorBankAccount."E-Mail");
                Clear(VendorBankAccount."SWIFT Code");
                Clear(VendorBankAccount.IBAN);
                Clear(VendorBankAccount."MICA Bank Account Type");
                Clear(VendorBankAccount."Bank Clearing Standard");
                Clear(VendorBankAccount."Bank Clearing Code");
                VendorBankAccount.Modify(false);
            until VendorBankAccount.Next() = 0;

        if BankAccount.FindSet(true, false) then
            repeat
                Clear(BankAccount."Bank Branch No.");
                Clear(BankAccount."Bank Account No.");
                Clear(BankAccount."Phone No.");
                Clear(BankAccount."Fax No.");
                Clear(BankAccount."E-Mail");
                Clear(BankAccount."Transit No.");
                Clear(BankAccount."Bank Acc. Posting Group");
                Clear(BankAccount."SWIFT Code");
                Clear(BankAccount.IBAN);
                Clear(BankAccount."Bank Statement Import Format");
                Clear(BankAccount."Payment Export Format");
                BankAccount.Validate(Address, 'Address');
                BankAccount.Validate("Address 2", 'Address 2');
                BankAccount.Modify(false);
            until BankAccount.Next() = 0;

        if Location.FindSet(true, false) then
            repeat
                Clear(Location."MICA 3PL E-Mail for Sales Docs");
                Location.Validate(Address, 'Address');
                Location.Validate("Address 2", 'Address2');
                Location.Validate("MICA 3PL Email Pstd. Inv.", false);
                Location.Validate("MICA 3PL Email Pstd. Shpt.", false);
                Location.Modify(false);
            until Location.Next() = 0;

        if MICAFlow.FindSet(true, false) then
            repeat
                Clear(MICAFlow."EndPoint Type");
                Clear(MICAFlow."EndPoint Code");
                Clear(MICAFlow."Blob Container");
                Clear(MICAFlow."Blob Prefix");
                Clear(MICAFlow."MQ Sub URL");
                MICAFlow.Validate(Status, MICAFlow.Status::Open);
                MICAFlow.Modify(false);
            until MICAFlow.Next() = 0;

        if MICAFlowEndpoint.FindSet(true, false) then
            repeat
                Clear(MICAFlowEndpoint."Blob Storage");
                Clear(MICAFlowEndpoint."Blob SSAS Signature");
                Clear(MICAFlowEndpoint."MQ URL");
                Clear(MICAFlowEndpoint."MQ Login");
                Clear(MICAFlowEndpoint."MQ Password");
                MICAFlowEndpoint.Modify(false);
            until MICAFlowEndpoint.Next() = 0;

        if JobQueueEntry.FindSet(true, false) then
            repeat
                JobQueueEntry.SetStatus(JobQueueEntry.Status::"On Hold");
            until JobQueueEntry.Next() = 0;
    end;
}