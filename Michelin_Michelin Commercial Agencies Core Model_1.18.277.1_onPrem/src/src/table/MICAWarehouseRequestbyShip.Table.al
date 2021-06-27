table 81620 "MICA Warehouse Request by Ship"
{
    //3PL-009: Whse. Shipment BSC to 3PL
    // Based on standard table "Warehouse Request"

    Caption = 'Warehouse Request by Shipment Date';
    LookupPageID = 5793;

    fields
    {
        field(1; "Source Type"; Integer)
        {
            Caption = 'Source Type';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(2; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            Editable = false;
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
            DataClassification = CustomerContent;
        }
        field(3; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            Editable = false;
            DataClassification = CustomerContent;
            TableRelation = IF ("Source Document" = CONST("Sales Order")) "Sales Header"."No." WHERE("Document Type" = CONST(Order), "No." = FIELD("Source No.")) ELSE
            IF ("Source Document" = CONST("Sales Return Order")) "Sales Header"."No." WHERE("Document Type" = CONST("Return Order"), "No." = FIELD("Source No.")) ELSE
            IF ("Source Document" = CONST("Purchase Order")) "Purchase Header"."No." WHERE("Document Type" = CONST(Order), "No." = FIELD("Source No.")) ELSE
            IF ("Source Document" = CONST("Purchase Return Order")) "Purchase Header"."No." WHERE("Document Type" = CONST("Return Order"), "No." = FIELD("Source No.")) ELSE
            IF ("Source Type" = CONST(5741)) "Transfer Header"."No." WHERE("No." = FIELD("Source No.")) ELSE
            IF ("Source Type" = FILTER(5406 | 5407)) "Production Order"."No." WHERE(Status = CONST(Released), "No." = FIELD("Source No.")) ELSE
            IF ("Source Type" = FILTER(901)) "Assembly Header"."No." WHERE("Document Type" = CONST(Order), "No." = FIELD("Source No."));
        }
        field(4; "Source Document"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Source Document';
            Editable = false;
            OptionCaption = ',Sales Order,,,Sales Return Order,Purchase Order,,,Purchase Return Order,Inbound Transfer,Outbound Transfer,Prod. Consumption,Prod. Output,Service Order,,,,,,,Assembly Consumption,Assembly Order';
            OptionMembers = ,"Sales Order",,,"Sales Return Order","Purchase Order",,,"Purchase Return Order","Inbound Transfer","Outbound Transfer","Prod. Consumption","Prod. Output","Service Order",,,,,,,"Assembly Consumption","Assembly Order";
        }
        field(5; "Document Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Document Status';
            Editable = false;
            OptionCaption = 'Open,Released';
            OptionMembers = Open,Released;
        }
        field(6; "Location Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Location Code';
            Editable = false;
            TableRelation = Location;
        }
        field(7; "Shipment Method Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Shipment Method Code';
            Editable = false;
            TableRelation = "Shipment Method";
        }
        field(8; "Shipping Agent Code"; Code[10])
        {
            DataClassification = CustomerContent;
            AccessByPermission = TableData 5790 = R;
            Caption = 'Shipping Agent Code';
            Editable = false;
            TableRelation = "Shipping Agent";
        }
        field(10; "Shipping Advice"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Shipping Advice';
            Editable = false;
            OptionCaption = 'Partial,Complete';
            OptionMembers = Partial,Complete;
        }
        field(11; "Destination Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Destination Type';
            OptionCaption = ' ,Customer,Vendor,Location,Item,Family,Sales Order';
            OptionMembers = " ",Customer,Vendor,Location,Item,Family,"Sales Order";
        }
        field(12; "Destination No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Destination No.';
            TableRelation = IF ("Destination Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Destination Type" = CONST(Customer)) Customer
            ELSE
            IF ("Destination Type" = CONST(Location)) Location
            ELSE
            IF ("Destination Type" = CONST(Item)) Item
            ELSE
            IF ("Destination Type" = CONST(Family)) Family
            ELSE
            IF ("Destination Type" = CONST("Sales Order")) "Sales Header"."No." WHERE("Document Type" = CONST(Order));
        }
        field(13; "External Document No."; Code[35])
        {
            DataClassification = CustomerContent;
            Caption = 'External Document No.';
        }
        field(14; "Expected Receipt Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Expected Receipt Date';
        }
        field(15; "Shipment Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Shipment Date';
        }
        field(19; Type; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Type';
            Editable = false;
            OptionCaption = 'Inbound,Outbound';
            OptionMembers = Inbound,Outbound;
        }
        field(20; "Put-away / Pick No."; Code[20])
        {
            CalcFormula = Lookup ("Warehouse Activity Line"."No." WHERE("Source Type" = FIELD("Source Type"),
                                                                      "Source Subtype" = FIELD("Source Subtype"),
                                                                      "Source No." = FIELD("Source No."),
                                                                      "Location Code" = FIELD("Location Code")));
            Caption = 'Put-away / Pick No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(41; "Completely Handled"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Completely Handled';
        }
    }

    keys
    {
        key(Key1; Type, "Location Code", "Source Type", "Source Subtype", "Source No.", "Shipment Date")
        {
        }
        key(Key2; "Source Type", "Source Subtype", "Source No.")
        {
            MaintainSQLIndex = false;
        }
        key(Key3; "Source Type", "Source No.")
        {
            MaintainSQLIndex = false;
        }
        key(Key4; "Source Document", "Source No.")
        {
            MaintainSQLIndex = false;
        }
        key(Key5; Type, "Location Code", "Completely Handled", "Document Status", "Expected Receipt Date", "Shipment Date", "Source Document", "Source No.")
        {
        }
        key(Key6; "Document Status", "Source No.", "Source Subtype", "Source Type", Type, "Completely Handled", "Location Code")
        {
        }
        key(Key7; "Source No.", "Source Subtype", "Source Type", Type)
        {
        }
    }

    fieldgroups
    {
    }

    procedure DeleteRequest(SourceType: Integer; SourceSubtype: Integer; SourceNo: Code[20])
    begin
        SetSourceFilter(SourceType, SourceSubtype, SourceNo);
        IF NOT ISEMPTY() THEN
            DELETEALL();
    end;

    procedure SetSourceFilter(SourceType: Integer; SourceSubtype: Integer; SourceNo: Code[20])
    begin
        SETRANGE("Source Type", SourceType);
        SETRANGE("Source Subtype", SourceSubtype);
        SETRANGE("Source No.", SourceNo);
    end;
}
