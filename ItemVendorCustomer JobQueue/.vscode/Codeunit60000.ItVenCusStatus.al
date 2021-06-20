codeunit 60000 "Demo ItVenCust"
{

    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        //Case Rec."Parameter String" of
        //'ITEM':

        //'VENDOR': 

        //'CUSTOMER':     
    end;

    local procedure RunForItem()
    var
        Item: Record Item;
        DemoItem: Record "Demo Item";
        Found: Boolean;
    begin
        Item.Reset();
        Item.SetRange(Blocked, false);
        if Item.FindFirst() then
            repeat
                DemoItem.SetRange("Item No.", Item."No.");
                if not DemoItem.FindFirst() then begin
                    DemoItem.Init();
                    DemoItem."Item No." := Item."No.";
                    DemoItem.Insert();
                    Found := true;
                end;
            until (Item.Next() = 0) OR (Found = true);
    end;

    local procedure RunForCustomer()
    var
        Customer: Record Customer;
        DemoCustomer: Record "Demo Customer";
        Found: Boolean;
    begin
        Customer.Reset();
        Customer.SetRange(Blocked, Customer.Blocked::" ");
        if Customer.FindFirst() then
            repeat
                DemoCustomer.SetRange("Customer  No.", Customer."No.");
                if not DemoCustomer.FindFirst() then begin
                    DemoCustomer.Init();
                    DemoCustomer."Customer  No." := Customer."No.";
                    DemoCustomer.Insert(true);
                    Found := true;
                end;
            until (Customer.Next = 0) OR (Found = true);
    end;

    local procedure RunForVendor()
    var
        Vendor: Record Vendor;
        DemoVendor: Record "Demo Vendor";
        Found: Boolean;
    begin
        Vendor.Reset();
        Vendor.SetRange(Blocked, Vendor.Blocked::" ");
        if Vendor.FindFirst() then
            repeat
                DemoVendor.SetRange("Vendor No.", Vendor."No.");
                if not DemoVendor.FindFirst() then begin
                    DemoVendor.Init();
                    DemoVendor."Vendor No." := Vendor."No.";
                    DemoVendor.Insert(true);
                    Found := true;
                end;
            until (Vendor.Next = 0) OR (Found = true);
    end;



}