tableextension 80140 "MICA Sales Line" extends "Sales Line" //MyTargetTableId
{
    fields
    {
        field(80000; "MICA Exceptional Disc. %"; Decimal)
        {
            Caption = 'Exceptional Disc. %';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
            MinValue = 0;
            MaxValue = 100;
            trigger OnValidate()
            var
                SalesHeader: Record "Sales Header";
                RebatesMgt: Codeunit "MICA New Rebates Line Mgt";
                Discount: Decimal;
            begin
                if "MICA Exceptional Disc. %" <> xRec."MICA Exceptional Disc. %" then begin
                    if SalesHeader.get("Document Type", "Document No.") then;
                    RebatesMgt.CalcExceptionalRebates(Rec, SalesHeader);
                    Discount := RebatesMgt.CalcLineDiscount(Rec);
#if OnPremise                                        
                    "Line Discount %" := Discount;
                    ValidateLineDiscountPercent(true);
#else
                    Validate("Line Discount %", Discount);
#endif
                end;
            end;
        }
        field(80001; "MICA Pay. Terms Line Disc. %"; Decimal)
        {
            Caption = 'Payment Terms Line Disc. %';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
            MinValue = 0;
            MaxValue = 100;
        }
        field(80002; "MICA Splitted Line"; Boolean)
        {
            Caption = 'Commit run';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80060; "MICA Catalog Item No."; Code[20])
        {
            Caption = 'Catalog Item No.';
            DataClassification = CustomerContent;
        }

        field(80340; "MICA Source Line Commit Date"; DateTime)
        {
            Caption = 'Source Line Commit Date';
            DataClassification = CustomerContent;
            Editable = false;
        }

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

        field(80421; "MICA Split Source line No."; Integer)
        {
            Caption = 'Split Source Line No.';
            DataClassification = CustomerContent;
        }

        field(80422; "MICA Split Src Exp Ord Qty (b)"; Decimal)
        {
            Caption = 'Split Source Express Order Qty (base)';
            DataClassification = CustomerContent;
        }
        field(80423; "MICA Delete From Split Line"; Boolean)
        {
            Caption = 'Delete From Split Line';
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
        field(81490; "MICA Delivery Date Modified"; Date)
        {
            Caption = 'Delivery Date Modified';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81640; "MICA Sales Agreement No."; Code[20])
        {
            Caption = 'Sales Agreement No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                MICASalesAgreement: record "MICA Sales Agreement";
                SalesAgreementErr_Msg: label 'You cannot select sales agreement %1 for an item which has item category code %2. Document Type: %3; Document No: %4';
                ErrorText: Text;
            begin
                if MICASalesAgreement.Get("MICA Sales Agreement No.") and ((MICASalesAgreement."Item Category Code" = "Item Category Code") or (MICASalesAgreement."Item Category Code" = '')) then begin
                    "MICA Priority Code" := MICASalesAgreement."Priority Code";
                    VALIDATE("MICA Payment Terms Code", MICASalesAgreement."Payment Terms Code");
                    validate("MICA Payment Method Code", MICASalesAgreement."Payment Method Code");
                    VALIDATE("MICA Pay. Terms Line Disc. %", MICASalesAgreement."Payment Terms Discount %");
                end else begin
                    ErrorText := StrSubstNo(SalesAgreementErr_Msg, MICASalesAgreement."No.", "Item Category Code", Format("Document Type"), "Document No.");
                    error(ErrorText);
                end;
            end;

            trigger OnLookup()
            var
                MICASalesAgreement: record "MICA Sales Agreement";
                SalesDocHeader: Record "Sales Header";
            begin
                SalesDocHeader.Get("Document Type", "Document No.");
                SalesDocHeader.TestField("Order Date");
                MICASalesAgreement.SetRange("Customer No.", "Sell-to Customer No.");
                MICASalesAgreement.SetFilter("Item Category Code", '%1|%2', '', "Item Category Code");
                MICASalesAgreement.SetFilter("Start Date", '<= %1', SalesDocHeader."Order Date");
                MICASalesAgreement.SetFilter("End Date", '>=%1', SalesDocHeader."Order Date");
                if Page.RunModal(0, MICASalesAgreement) = Action::LookupOK then begin
                    Validate("MICA Sales Agreement No.", MICASalesAgreement."No.");
                    Modify(true);
                end;
            end;
        }
        field(81641; "MICA Priority Code"; Code[10])
        {
            Caption = 'Priority Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Priority";
            Editable = false;
        }
        field(81642; "MICA Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81643; "MICA Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method';
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnLookup()
            var
                MICASalesAgreement: record "MICA Sales Agreement";
            begin
                calcfields("Posting Date");
                MICASalesAgreement.SetRange("Customer No.", "Sell-to Customer No.");
                MICASalesAgreement.SetFilter("Start Date", '<= %1', "Posting Date");
                MICASalesAgreement.SetFilter("End Date", '>=%1', "Posting Date");
                if Page.RunModal(0, MICASalesAgreement) = Action::LookupOK then
                    Validate("MICA Payment Method Code", "MICA Payment Method Code");
            end;
        }
        field(81645; "MICA Due Date"; Date)
        {
            Caption = 'Due Date';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(81646; "MICA Inv. Split No."; Integer)
        {
            Caption = 'Inv. Split No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81780; "MICA Status"; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            OptionMembers = Open,"Reserve OnHand","Reserve InTransit","Waiting Allocation","Send to Execution",Closed;
            OptionCaption = 'Open,Reserve OnHand,Reserve InTransit,Waiting Allocation,Send to Execution,Closed';
            Editable = false;
            trigger OnValidate()
            var
                SanaContext: Codeunit "SC - Execution Context";
            begin
                if Rec.IsTemporary() then
                    exit;
                if ("MICA Status" <> xRec."MICA Status") and (SanaContext.GetCurrentOperationName() <> 'CalculateBasket') then
                    "MICA Last Date Update Status" := CurrentDateTime();
            end;
        }
        field(81781; "MICA Release Status Count"; Integer)
        {
            Caption = 'Release Status Count';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81785; "MICA Cancel. Reason"; Code[20])
        {
            Caption = 'Cancel. Reason';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(SalesLineCancelReasonCode), Blocked = const(false));
            trigger OnValidate()
            begin
                "MICA Cancelled" := "MICA Cancel. Reason" <> '';
            end;
        }
        field(81790; "MICA Cancelled"; Boolean)
        {
            Caption = 'Cancelled';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81800; "MICA Product Type Code"; Code[2])
        {
            Caption = 'Product Type Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81820; "MICA Delete Without Realloc."; Boolean)
        {
            Caption = 'Delete Without Reallocation';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(81822; "MICA Inv. Discrepancy"; Boolean)
        {
            Caption = 'Inv. Discrepancy';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ResetInvDiscrepancyMsg: Label 'Sales Order Line won’t be considered Discrepancy when 3PL Shipping Confirmation is Posted. Do you want to continue?';
            begin
                if (Rec.Type = Rec.Type::Item) and xRec."MICA Inv. Discrepancy" and not "MICA Inv. Discrepancy" then
                    if not Confirm(ResetInvDiscrepancyMsg, false) then
                        Error('');
            end;
        }
        field(81980; "MICA Prev. Planned Del. Date"; Date)
        {
            Caption = 'Previous Planned Delivery Date';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(82180; "MICA Requested Receipt Date"; date)
        {
            Caption = 'Requested Receipt Date';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(82181; "MICA Promised Receipt Date"; date)
        {
            Caption = 'Promised Receipt Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(82380; "MICA Last Date Update Status"; DateTime)
        {
            Caption = 'Last Date Update Status';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81860; "MICA Except. Rebate Reason"; code[20])
        {
            Caption = 'Except. Rebate Reason';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(SalesLineExceptRebateReason), Blocked = const(false));
            trigger OnValidate()
            var
                SalesHeader: Record "Sales Header";
                RebatesMgt: Codeunit "MICA New Rebates Line Mgt";
            begin
                if "MICA Except. Rebate Reason" <> xRec."MICA Except. Rebate Reason" then begin
                    if SalesHeader.get("Document Type", "Document No.") then;
                    RebatesMgt.CalcExceptionalRebates(Rec, SalesHeader);
                end;
            end;
        }
        field(81870; "MICA Skip Rebates Calculation"; Boolean)
        {
            Caption = 'Skip Rebates Calculation';
            DataClassification = CustomerContent;

        }

        field(82700; "MICA Exempt from 3PL Ant. Chk."; Boolean)
        {
            Caption = 'Exempt from 3PL Anticipation Check';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."MICA Exempt from 3PL Ant. Chk." where("Document Type" = field("Document Type"), "No." = field("Document No.")));
            Editable = false;
        }
        field(82760; "MICA Is Selected"; Boolean)
        {
            Caption = 'Is Selected';
            DataClassification = CustomerContent;
        }

        modify("Requested Delivery Date")
        {
            trigger OnAfterValidate()
            begin
                if "Requested Delivery Date" = 0D then
                    exit;
                "MICA Requested Receipt Date" := "Shipment Date";
            End;
        }

        modify("Promised Delivery Date")
        {
            trigger OnAfterValidate()
            begin
                if "Promised Delivery Date" = 0D then
                    exit;
                "MICA Promised Receipt Date" := "Shipment Date";
            End;
        }

        field(80140; "MICA Transport Instruction"; Code[20])
        {
            Caption = 'Transport Instruction';
            DataClassification = CustomerContent;
            TableRelation = "MICA Transport Instructions".Code;
        }
        field(80150; "MICA Copy Posted Doc. No."; Boolean)
        {
            Caption = 'Copy Posted Doc. No.';
            DataClassification = CustomerContent;
        }
        field(82920; "MICA CAI"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'CAI';
            Editable = false;
        }
        field(82921; "MICA Last Commitment DateTime"; DateTime)
        {
            Caption = 'Last Commitment DateTime';
            FieldClass = FlowField;
            CalcFormula = max("MICA 3rd Party Comm. Qty. Det."."Commitment DateTime" where("Sales Order No." = field("Document No."), "Sales Order Line No." = field("Line No.")));
        }
        field(82922; "MICA 3rd Party Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor;
            Editable = false;
        }
        field(83000; "MICA Rebate Pool Line"; Boolean)
        {
            Caption = 'Rebate Pool Line';
            DataClassification = CustomerContent;
        }
        field(83001; "MICA Rebate Pool Entry No."; Integer)
        {
            Caption = 'Rebate Pool Entry No.';
            DataClassification = CustomerContent;
            TableRelation = "MICA Rebate Pool Entry" where("Entry No." = field("MICA Rebate Pool Entry No."), Open = const(true));
        }
    }

    keys
    {
        key(Key1; "MICA Source Line Commit Date")
        {

        }
    }

    procedure OrderIsExpressOrder(): Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        if SalesHeader.Get("Document Type", "Document No.") then
            exit(SalesHeader."MICA Order Type" = SalesHeader."MICA Order Type"::"Express Order");
        exit(false);
    end;

    procedure OrderIs3rdParty(): Boolean
    var
        Location: Record "Location";
    begin
        if not Location.Get(Rec."Location Code") then
            exit(false);
        if Location."MICA Commitment Type" = Location."MICA Commitment Type"::"Third Party" then
            exit(true);
    end;

    procedure IsCustomerTransportOrder(): Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        if SalesHeader.Get("Document Type", "Document No.") then
            exit(SalesHeader."MICA Customer Transport");
    end;

    procedure SetSkipCheckCommercPeriod(pSkipCheckCommercPeriod: Boolean)
    begin
        SkipCheckCommercPeriod := pSkipCheckCommercPeriod;
    end;

    procedure GetSkipCheckCommercPeriod(): Boolean
    begin
        exit(SkipCheckCommercPeriod);
    end;

    var
        SkipCheckCommercPeriod: Boolean;
}