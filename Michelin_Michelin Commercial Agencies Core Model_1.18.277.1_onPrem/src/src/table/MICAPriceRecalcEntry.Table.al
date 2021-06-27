table 82762 "MICA Price Recalc. Entry"
{
    Caption = 'Price Recalculation Entry';
    DataClassification = CustomerContent;
    DrillDownPageId = "MICA Price Recalc. Entries";
    LookupPageId = "MICA Price Recalc. Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            DataClassification = CustomerContent;
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order), "No." = field("Order No."));
        }
        field(3; "Order Date"; Date)
        {
            Caption = 'Order Date';
            DataClassification = CustomerContent;
        }
        field(4; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
            DataClassification = CustomerContent;
        }
        field(5; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
            FieldClass = FlowField;
        }
        field(6; "Customer Price Group"; Code[10])
        {
            Caption = 'Cust. Price Group';
            TableRelation = "Customer Price Group";
            DataClassification = CustomerContent;
        }
        field(7; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(8; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
            DataClassification = CustomerContent;
        }
        field(9; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            FieldClass = FlowField;
        }
        field(11; "Location Code"; Code[20])
        {
            Caption = 'Location';
            TableRelation = Location;
            DataClassification = CustomerContent;
        }
        field(12; "MICA Status"; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Reserve On-Hand,Reserve In-Transit,Waiting Allocation,Send to Execution,Closed';
            OptionMembers = Open,"Reserve On-Hand","Reserve In-Transit","Waiting Allocation","Send to Execution",Closed;
            DataClassification = CustomerContent;
        }
        field(13; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(14; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(15; "New Unit Price"; Decimal)
        {
            Caption = 'New Unit Price';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(16; "Recalculation Date"; Date)
        {
            Caption = 'Recalculation Date';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}