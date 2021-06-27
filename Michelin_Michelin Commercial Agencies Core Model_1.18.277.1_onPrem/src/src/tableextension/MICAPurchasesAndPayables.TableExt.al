tableextension 80740 "MICA PurchasesAndPayables" extends "Purchases & Payables Setup"
{
    // version NAVW113.02,SPLN1.00

    // SPLN1.00 ALI 2019-02-22 Added new fields, to be printed on PO
    fields
    {
        field(80000; "MICA PO Notes Text 1"; Text[250])
        {
            Caption = 'PO Notes Text 1';
            DataClassification = CustomerContent;
            Description = 'SPLN1.00';
        }
        field(80001; "MICA PO Notes Text 2"; Text[250])
        {
            Caption = 'PO Notes Text 2';
            DataClassification = CustomerContent;
            Description = 'SPLN1.00';
        }
        field(80002; "MICA PO Footer Text Left"; Text[250])
        {
            Caption = 'PO Footer Text - Left';
            DataClassification = CustomerContent;
            Description = 'SPLN1.00';
        }
        field(80003; "MICA PO Footer Text Right"; Text[250])
        {
            Caption = 'PO Footer Text - Right';
            DataClassification = CustomerContent;
            Description = 'SPLN1.00';
        }
        field(81300; "MICA Intercompany Dimension"; Code[20])
        {
            Caption = 'Intercompany Dimension';
            DataClassification = CustomerContent;
            TableRelation = Dimension;
        }
        field(81460; "MICA ASN Flow Code"; Code[20])
        {
            Caption = 'ASN Flow Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow".Code;
        }
        field(81260; "MICA AL to PO Flow Code"; Code[20])
        {
            Caption = 'AL to PO Flow Code';
            TableRelation = "MICA Flow".Code;
            DataClassification = CustomerContent;
        }
        field(81261; "MICA Update SRD Flow Code"; Code[20])
        {
            Caption = 'Update SRD Flow Code';
            TableRelation = "MICA Flow".Code;
            DataClassification = CustomerContent;
        }
        field(81550; "MICA Detail Invoices Mass Pay."; Boolean)
        {
            Caption = 'Detail Of Invoices In Mass Payment';
            DataClassification = CustomerContent;
        }
        field(81551; "MICA Mass Payment No."; Code[20])
        {
            Caption = 'Mass Payment No.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(81552; "MICA Add. Info. in Mass Pmt."; Boolean)
        {
            Caption = 'Additional Information’s in Mass Payment';
            DataClassification = CustomerContent;
        }
        field(81610; "MICA Keep order when invoiced"; Boolean)
        {
            Caption = 'Keep order when invoiced';
            DataClassification = CustomerContent;
        }

        field(82021; "MICA GIS Sup. Inv. Flow Code"; Code[20])
        {
            Caption = 'GIS Supplier Invoice Integration Flow Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow";
        }
    }

    /*[Scope('Personalization')]
    procedure GetRecordOnce()
    begin
        if RecordHasBeenRead then
            exit;
        Get();
        RecordHasBeenRead := true;
    end;

    var
        RecordHasBeenRead: Boolean;*/
}

