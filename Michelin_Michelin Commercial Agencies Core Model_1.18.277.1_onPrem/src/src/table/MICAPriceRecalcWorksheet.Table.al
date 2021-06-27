table 82760 "MICA Price Recalc. Worksheet"
{
    Caption = 'Price Recalculation Worksheet';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            DataClassification = CustomerContent;
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order), "No." = field("Order No."));

            trigger OnValidate()
            begin
                ValidateSalesOrderData("Order No.");
            end;
        }
        field(2; "Order Date"; Date)
        {
            Caption = 'Order Date';
            DataClassification = CustomerContent;
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                ValidateDataFromCustomer("Customer No.");
            end;
        }
        field(4; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
            FieldClass = FlowField;
        }
        field(5; "Customer Price Group"; Code[10])
        {
            Caption = 'Cust. Price Group';
            TableRelation = "Customer Price Group";
            DataClassification = CustomerContent;
        }
        field(6; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(7; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
            DataClassification = CustomerContent;
        }
        field(8; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                Description := GetItemDescription("Item No.");
            end;
        }
        field(9; Description; Text[100])
        {
            Caption = 'Description';
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            FieldClass = FlowField;
        }
        field(10; "Location Code"; Code[20])
        {
            Caption = 'Location';
            TableRelation = Location;
            DataClassification = CustomerContent;
        }
        field(11; "MICA Status"; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Reserve On-Hand,Reserve In-Transit,Waiting Allocation,Send to Execution,Closed';
            OptionMembers = Open,"Reserve On-Hand","Reserve In-Transit","Waiting Allocation","Send to Execution",Closed;
            DataClassification = CustomerContent;
        }
        field(12; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(13; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
            Editable = false;
            MinValue = 0;
        }
        field(14; "New Unit Price"; Decimal)
        {
            Caption = 'New Unit Price';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
            MinValue = 0;
        }
    }

    keys
    {
        key(PK; "Order No.", "Line No.")
        {
            Clustered = true;
        }
    }
    local procedure ValidateSalesOrderData(NewSalesOrderNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
    begin
        if Rec."Order No." <> xRec."Order No." then begin
            "Order Date" := 0D;
            Validate("Customer No.", '');
        end;

        if not SalesHeader.Get(SalesHeader."Document Type"::Order, NewSalesOrderNo) then
            SalesHeader.Init();

        "Order Date" := SalesHeader."Order Date";
        Validate("Customer No.", SalesHeader."Sell-to Customer No.");
    end;

    local procedure ValidateDataFromCustomer(NewCustomerNo: Code[20])
    var
        Customer: Record Customer;
    begin
        if not Customer.Get(NewCustomerNo) then
            Customer.Init();
        "Customer Name" := Customer.Name;
        "Customer Price Group" := Customer."Customer Price Group";
    end;

    local procedure GetItemDescription(NewItemNo: Code[20]): Text[100]
    var
        Item: Record Item;
    begin
        if not Item.Get(NewItemNo) then
            Item.Init();
        exit(Item.Description);
    end;

}