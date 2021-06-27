tableextension 80400 "MICA Sales Shipment Line" extends "Sales Shipment Line"
{
    fields
    {
        field(80400; "MICA Countermark"; Text[250])
        {
            Caption = 'Countermark';
            DataClassification = CustomerContent;
        }
        field(80420; "MICA Webshop Comment"; Text[250])
        {
            Caption = 'Webshop Comment';
            DataClassification = CustomerContent;
            ObsoleteState = Pending;
            ObsoleteReason = 'MICA Countermark is used for Webshop comment';
        }

        field(81822; "MICA Inv. Discrepancy"; Boolean)
        {
            Caption = 'Inv. Discrepancy';
            DataClassification = CustomerContent;
        }
        field(80960; "MICA 3PL Whse Shpt. Comment"; Text[50])
        {
            Caption = '3PL Warehouse Shipment Comment';
            DataClassification = CustomerContent;
            Description = 'Comment for 3PL system';
        }
        field(81194; "MICA 3PL Country Of Origin"; Code[2])
        {
            Caption = '3PL Country Of Origin';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81195; "MICA 3PL DOT Value"; Code[10])
        {
            Caption = '3PL DOT Value';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(80140; "MICA Transport Instruction"; Code[20])
        {
            Caption = 'Transport Instruction';
            DataClassification = CustomerContent;
            TableRelation = "MICA Transport Instructions".Code;
        }
    }


    procedure IsLinkedToSalesInvLine(): Boolean
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetCurrentKey("Document Type", "Shipment No.", "Shipment Line No.");
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Invoice);
        SalesLine.SetRange("Shipment No.", "Document No.");
        SalesLine.SetRange("Shipment Line No.", "Line No.");
        exit(not SalesLine.IsEmpty);
    end;

}