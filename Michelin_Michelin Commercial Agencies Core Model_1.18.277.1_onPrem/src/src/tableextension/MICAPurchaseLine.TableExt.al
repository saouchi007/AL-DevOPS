tableextension 81141 "MICA Purchase Line" extends "Purchase Line"
{
    fields
    {
        field(81140; "MICA Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            DataClassification = CustomerContent;
            Editable = false;
        }

        //Flow Export
        field(80860; "MICA Flow Entry No."; Integer)
        {
            Caption = 'Flow Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MICA Flow Entry";
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80861; "MICA Flow Record Entry No."; Integer)
        {
            Caption = 'Flow Record Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MICA Flow Record";
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80862; "MICA Send Last Flow Status"; Option)
        {
            Caption = 'Send Last Flow Status';
            DataClassification = CustomerContent;
            Editable = false;
            OptionMembers = "",Prepared,Sent;
            OptionCaption = ',Prepared,Sent';
        }
        field(80863; "MICA Send Last Flow Entry No."; Integer)
        {
            Caption = 'Send Last Flow Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MICA Flow Entry";
        }
        field(80864; "MICA Send Last DateTime"; DateTime)
        {
            Caption = 'Send Last DateTime';
            FieldClass = FlowField;
            CalcFormula = lookup("MICA Flow Entry"."Sent Date Time" where("Entry No." = field("MICA Send Last Flow Entry No.")));
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80866; "MICA Send Last Info Count"; Integer)
        {
            Caption = 'Send Last Info Count';
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Information), "Flow Entry No." = field("MICA Send Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80867; "MICA Send Last Warning Count"; Integer)
        {
            Caption = 'Send Last Warning Count';
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Warning), "Flow Entry No." = field("MICA Send Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80868; "MICA Send Last Error Count"; Integer)
        {
            Caption = 'Send Last Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Error), "Flow Entry No." = field("MICA Send Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80869; "MICA Send Ack. Received"; Boolean)
        {
            Caption = 'Send Ack. Received';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(80870; "MICA Rcv. Last Flow Entry No."; Integer)
        {
            Caption = 'Receive Last Flow Entry No.';
            Editable = false;
            TableRelation = "MICA Flow Entry";
            DataClassification = CustomerContent;
        }

        field(80872; "MICA Receive Last Flow Status"; Option)
        {
            Caption = 'Receive Last Flow Status';
            Editable = false;
            OptionMembers = "",Created,Received,Loaded,Processed,PostProcessed;
            OptionCaption = ',Created,Received,Loaded,Processed,PostProcessed';
            FieldClass = FlowField;
            CalcFormula = lookup("MICA Flow Entry"."Receive Status" where("Entry No." = field("MICA Rcv. Last Flow Entry No.")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80874; "MICA Receive Last DateTime"; DateTime)
        {
            Caption = 'Receive Last DateTime';
            FieldClass = FlowField;
            CalcFormula = lookup("MICA Flow Entry"."Received Date Time" where("Entry No." = field("MICA Rcv. Last Flow Entry No.")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80876; "MICA Receive Last Info Count"; Integer)
        {
            Caption = 'Receive Last Info Count';
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Information), "Flow Entry No." = field("MICA Rcv. Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80877; "MICA Rcv. Last Warning Count"; Integer)
        {
            Caption = 'Receive Last Warning Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Warning), "Flow Entry No." = field("MICA Rcv. Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80878; "MICA Receive Last Error Count"; Integer)
        {
            Caption = 'Receive Last Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Error), "Flow Entry No." = field("MICA Rcv. Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80879; "MICA Record ID"; RecordId)
        {
            Caption = 'Record ID';
            DataClassification = CustomerContent;
        }
        //Flow end
        field(81309; "MICA AL No."; Code[35])
        {
            Caption = 'AL No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(81310; "MICA AL Line No."; Text[30])
        {
            Caption = 'AL Line No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(81311; "MICA SRD"; Date)
        {
            Caption = 'SRD';
            DataClassification = CustomerContent;
        }
        field(81312; "MICA Location-To Code"; Code[10])
        {
            Caption = 'Location-To Code';
            DataClassification = CustomerContent;
            TableRelation = Location where("Use As In-Transit" = filter(false));
        }

        field(81460; "MICA ASN No."; Code[35])
        {
            Caption = 'ASN No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81470; "MICA ASN Line No."; Integer)
        {
            Caption = 'ASN Line No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81471; "MICA Country of Origin"; Code[10])
        {
            Caption = 'Country of Origin';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
        }
        field(82030; "MICA Freight Line No."; Text[10])
        {
            Caption = 'Freight Line No.';
            Description = 'Freight Line No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81980; "MICA Container ID"; Code[50])
        {
            Caption = 'Container ID';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81981; "MICA ETA"; Date)
        {
            Caption = 'ETA';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81982; "MICA Seal No."; Code[20])
        {
            Caption = 'Seal No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81983; "MICA Port of Arrival"; Code[20])
        {
            Caption = 'Port of Arrival';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81984; "MICA Carrier Doc. No."; Code[20])
        {
            Caption = 'Carrier Doc. No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81985; "MICA Ctry. ISO Code/O. Manuf."; code[10])
        {
            caption = 'Country ISO code of origin manufacturing';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
        }
        field(82360; "MICA DC14"; code[20])
        {
            Caption = 'DC14';
            DataClassification = CustomerContent;
        }
        field(82361; "MICA Ship From Vendor"; Code[20])
        {
            Caption = 'Ship From Vendor';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(82020; "MICA GIS Document Line No."; Integer)
        {
            Caption = 'GIS Document Line No.';
            Description = 'GIS Document Line No.';
            DataClassification = CustomerContent;
            Editable = false;
            BlankNumbers = BlankZero;
        }

        field(82021; "MICA GIS Freight Doc. Line No."; Integer)
        {
            Caption = 'GIS Freight Doc. Line No.';
            Description = 'GIS Freight Doc. Line No.';
            DataClassification = CustomerContent;
            Editable = false;
            BlankNumbers = BlankZero;
        }
        field(82022; "MICA GIS Dest. Country Code"; Code[10])
        {
            Caption = 'GIS Destination Country Code';
            Description = 'GIS Destination Country Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82023; "MICA GIS Country of Origin"; Code[10])
        {
            Caption = 'GIS Country of Origin';
            Description = 'GIS Country of Origin';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82024; "MICA GIS Region of Origin"; Code[10])
        {
            Caption = 'GIS Region of Origin';
            Description = 'GIS Region of Origin';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82025; "MICA GIS Delivery Terms"; Code[10])
        {
            Caption = 'GIS Delivery Terms';
            Description = 'GIS Delivery Terms';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82026; "MICA GIS Commodity Code"; Text[30])
        {
            Caption = 'GIS Commodity Code';
            Description = 'GIS Commodity Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82027; "MICA GIS Net Mass"; Decimal)
        {
            Caption = 'GIS Net Mass';
            Description = 'GIS Net Mass';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82028; "MICA GIS Supplementary Units"; Text[30])
        {
            Caption = 'GIS Supplementary Units';
            Description = 'GIS Supplementary Units';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82029; "MICA GIS Mode of Transport"; Text[30])
        {
            Caption = 'GIS Mode of Transport';
            Description = 'GIS Mode of Transport';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(82031; "MICA GIS Loading Port"; Code[20])
        {
            Caption = 'GIS Loading Port';
            Description = 'GIS Loading Port';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(82032; "MICA GIS Statistic Procedure"; Text[30])
        {
            Caption = 'GIS Statistic Procedure';
            Description = 'GIS Statistic Procedure';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82033; "MICA GIS Statistical Value"; Text[30])
        {
            Caption = 'GIS Statistical Value';
            Description = 'GIS Statistical Value';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82034; "MICA GIS Country of Manuf."; Code[20])
        {
            Caption = 'GIS Country of Manufacture';
            Description = 'GIS Country of Manufacture';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82035; "MICA GIS Container No."; Code[50])
        {
            Caption = 'GIS Container No.';
            Description = 'GIS Container No.';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(82036; "MICA GIS Contrib. PO Shpt No."; Code[30])
        {
            Caption = 'GIS Contributor PO Shipment No.';
            Description = 'GIS Contributor PO Shipment No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82365; "MICA Initial Shipment Date"; Date)
        {
            Caption = 'Initial Shipment Date';
            DataClassification = CustomerContent;
        }
        field(82920; "MICA CAI"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'CAI';
            trigger OnValidate()
            var
                Item: Record Item;
                IncorrectCAIErr: Label 'Incorrect CAI';
                CAI: Code[20];
            begin
                CAI := Rec."MICA CAI";
                Item.SetRange("No. 2", "MICA CAI");
                Item.SetRange(Blocked, false);
                if not Item.FindFirst() then
                    Error(IncorrectCAIErr);
                Rec.Validate("No.", Item."No.");
                Rec."MICA CAI" := CAI;
            end;
        }
        field(82921; "MICA Commited Quantity"; Decimal)
        {
            Caption = 'Commited Quantity';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("MICA 3rd Party Comm. Qty. Det."."Commited Qty." where("Blanket Purch. Order Doc. No." = field("Document No."), "Item No." = field("No."), "Original Line" = field("MICA Original Line No.")));
        }
        field(82922; "MICA Last Commitment DateTime"; DateTime)
        {
            Caption = 'Last Commitment DateTime';
            FieldClass = FlowField;
            CalcFormula = max("MICA 3rd Party Comm. Qty. Det."."Commitment DateTime" where("Blanket Purch. Order Doc. No." = field("Document No."), "Blanket Purch. Order Line No." = field("Line No.")));
        }
        field(82923; "MICA 3rd Party"; Boolean)
        {
            Caption = '3rd Party';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header"."MICA 3rd Party" where("Document Type" = field("Document Type"), "No." = field("Document No.")));
            Editable = false;
        }
        field(82924; "MICA Original Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82925; "MICA Posted Quantity"; Decimal)
        {
            Caption = 'Posted Quantity';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("MICA Arch. 3rd Party Com. Qty."."Commited Qty." where("Blanket Purch. Order Doc. No." = field("Document No."), "Item No." = field("No."), "Original Line" = field("MICA Original Line No.")));
        }
    }
    keys
    {
        key(SK1; "MICA ASN No.", "MICA ASN Line No.")
        {

        }
    }
    trigger OnInsert()
    begin
        "MICA Last Date Modified" := TODAY();
    end;

    trigger OnModify()
    begin
        "MICA Last Date Modified" := TODAY();
    end;

    trigger OnRename()
    begin
        "MICA Last Date Modified" := TODAY();
    end;

    procedure TransfertCAI(var PurchaseLine: Record "Purchase Line")
    var
        FindPurchaseLine: Record "Purchase Line";
        InsertPurchaseLine: Record "Purchase Line";
        Item: Record Item;
        ThereIsAnInsert: Boolean;
        LineNo: Integer;
        OriginalLine: Integer;
    begin
        lineNo := 0;
        OriginalLine := 0;
        if PurchaseLine.Type = PurchaseLine.Type::Item then begin
            Item.SetRange("No. 2", PurchaseLine."MICA CAI");
            Item.SetRange(Blocked, false);
            if Item.FindSet() then begin
                FindPurchaseLine.SetRange("Document Type", PurchaseLine."Document Type");
                FindPurchaseLine.SetRange("Document No.", PurchaseLine."Document No.");
                FindPurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                FindPurchaseLine.SetRange("MICA Original Line No.", PurchaseLine."MICA Original Line No.");
                if FindPurchaseLine.FindLast() then
                    lineNo := FindPurchaseLine."Line No.";
                repeat
                    FindPurchaseLine.SetRange("No.", Item."No.");
                    if not FindPurchaseLine.FindFirst() then begin
                        InsertPurchaseLine.Init();
                        lineNo += 10000;
                        InsertPurchaseLine.TransferFields(PurchaseLine);
                        InsertPurchaseLine."No." := Item."No.";
                        InsertPurchaseLine.Validate("Line No.", lineNo);
                        InsertPurchaseLine.validate("MICA Original Line No.", OriginalLine);
                        InsertPurchaseLine.Insert(true);
                        ThereIsAnInsert := true;
                    end else begin
                        InsertPurchaseLine.TransferFields(FindPurchaseLine);
                        InsertPurchaseLine.Validate("Quantity (Base)", PurchaseLine."Quantity (Base)");
                        if InsertPurchaseLine."MICA Original Line No." = 0 then
                            InsertPurchaseLine.Validate("MICA Original Line No.", InsertPurchaseLine."Line No.");
                        OriginalLine := InsertPurchaseLine."MICA Original Line No.";
                        InsertPurchaseLine.Modify(false);
                    end;
                until (Item.Next() = 0) or ThereIsAnInsert;
            end;
        end;
    end;

    procedure GetAvailableQuantity() AvailableQuantity: Decimal
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.SetRange("Document Type", Rec."Document Type");
        PurchaseLine.SetRange("Document No.", Rec."Document No.");
        PurchaseLine.SetRange(Type, Rec.Type);
        PurchaseLine.SetRange("MICA CAI", Rec."MICA CAI");
        PurchaseLine.SetRange("MICA Original Line No.", "MICA Original Line No.");
        if PurchaseLine.FindSet() then
            repeat
                PurchaseLine.CalcFields("MICA Commited Quantity");
                AvailableQuantity -= PurchaseLine."MICA Commited Quantity";
                PurchaseLine.CalcFields("MICA Posted Quantity");
                AvailableQuantity -= PurchaseLine."MICA Posted Quantity";
            until PurchaseLine.Next() = 0;
        AvailableQuantity += Rec."Quantity (Base)";
    end;

    procedure MicaGetLineAmountExclVAT(): Decimal
    var
        PurchaseHeader: Record "Purchase Header";
        Currency: Record Currency;
    begin
        if "Document No." = '' then
            exit(0);
        if not PurchaseHeader.get("Document Type", "Document No.") then
            exit;
        if PurchaseHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else begin
            PurchaseHeader.TestField("Currency Factor");
            Currency.Get(PurchaseHeader."Currency Code");
            Currency.TestField("Amount Rounding Precision");
        end;

        if not PurchaseHeader."Prices Including VAT" then
            exit("Line Amount");

        exit(Round("Line Amount" / (1 + "VAT %" / 100), Currency."Amount Rounding Precision"));
    end;

    procedure MicaGetLineAmountInclVAT(): Decimal
    var
        PurchaseHeader: Record "Purchase Header";
        Currency: Record Currency;

    begin
        if "Document No." = '' then
            exit(0);
        if not PurchaseHeader.get("Document Type", "Document No.") then
            exit;

        if PurchaseHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else begin
            PurchaseHeader.TestField("Currency Factor");
            Currency.Get(PurchaseHeader."Currency Code");
            Currency.TestField("Amount Rounding Precision");
        end;

        if PurchaseHeader."Prices Including VAT" then
            exit("Line Amount");

        exit(Round("Line Amount" * (1 + "VAT %" / 100), Currency."Amount Rounding Precision"));
    end;
}