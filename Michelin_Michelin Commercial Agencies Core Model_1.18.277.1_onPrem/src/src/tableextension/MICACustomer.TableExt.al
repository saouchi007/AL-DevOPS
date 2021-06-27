tableextension 80020 "MICA Customer" extends Customer //MyTargetTableId
{

    fields
    {
        field(80000; "MICA Type"; Option)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            OptionMembers = Direct,Indirect;
        }

        field(80010; "MICA Status"; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            OptionMembers = Active,Inactive;

            trigger OnValidate()
            var
                ShiptoAddr: Record "Ship-to Address";
            begin
                if ("MICA Status" = "MICA Status"::Inactive) and (xRec."MICA Status" = "MICA Status"::Active) then begin
                    if ShowConfirmDialog(GuiAllowed()) then begin
                        TestField("Balance (LCY)", 0);
                        CalcFields("No. of Quotes", "No. of Blanket Orders", "No. of Orders", "No. of Invoices", "No. of Return Orders", "No. of Credit Memos");
                        TestField("No. of Quotes", 0);
                        TestField("No. of Blanket Orders", 0);
                        TestField("No. of Orders", 0);
                        TestField("No. of Invoices", 0);
                        TestField("No. of Return Orders", 0);
                        TestField("No. of Credit Memos", 0);
                        ShiptoAddr.SetRange("Customer No.", "No.");
                        ShiptoAddr.SetRange("MICA Status", ShiptoAddr."MICA Status"::Active);
                        if ShiptoAddr.FindFirst() then
                            ShiptoAddr.TestField("MICA Status", ShiptoAddr."MICA Status"::Inactive);
                        Blocked := Blocked::All;
                    end else
                        "MICA Status" := xRec."MICA Status";

                end else
                    if ("MICA Status" = "MICA Status"::Active) and (xRec."MICA Status" = "MICA Status"::Inactive) then begin
                        TestField("MICA Status", "MICA Status"::Inactive);
                        ShiptoAddr.SetRange("Customer No.", "No.");
                        ShiptoAddr.SetRange("MICA Status", ShiptoAddr."MICA Status"::Inactive);
                        if ShiptoAddr.FindFirst() then
                            ShiptoAddr.TestField("MICA Status", ShiptoAddr."MICA Status"::Active);
                    end;

            end;
        }

        field(80020; "MICA Market Code"; Code[2])
        {
            Caption = 'Market Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(MarketCode), Blocked = const(false));
        }

        field(80030; "MICA English Name"; Text[100])
        {
            Caption = 'English Name';
            DataClassification = CustomerContent;
        }

        field(80040; "MICA Party Ownership"; Option)
        {
            Caption = 'Party Ownership';
            DataClassification = CustomerContent;
            OptionMembers = "Non Group",Group,"Group Network",Internal;
        }

        field(80050; "MICA Express Order"; Boolean)
        {
            Caption = 'Express Order';
            DataClassification = CustomerContent;
        }

        field(80060; "MICA Credit Classification"; Code[20])
        {
            Caption = 'Credit Classification';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(CustCreditClassification), Blocked = const(false));
        }

        field(80070; "MICA Chanel"; Code[10])
        {
            Caption = 'Chanel';
            DataClassification = CustomerContent;
            //TableRelation = "MICA Chanel".No;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80071; "MICA Channel"; Code[10])
        {
            Caption = 'Channel';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(CustChannel), Blocked = const(false));
        }

        field(80080; "MICA Distribution"; Code[10])
        {
            Caption = 'Distribution';
            DataClassification = CustomerContent;
            //TableRelation = "MICA Distribution".No;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80081; "MICA Business Orientation"; Code[10])
        {
            Caption = 'Business Orientation';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(CustBusinessOrientation), Blocked = const(false));
        }

        field(80090; "MICA Partnership"; Code[10])
        {
            Caption = 'Partnership';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(CustPartnership), Blocked = const(false));
        }

        field(80100; "MICA Base Cal. Code Exp. Order"; Code[10])
        {
            Caption = 'Base Calendar Code Express Order';
            DataClassification = CustomerContent;
            TableRelation = "Base Calendar";
        }

        field(80110; "MICA Shipping Agent Exp. Order"; Code[10])
        {
            Caption = 'Shipping Agent Express Order';
            DataClassification = CustomerContent;
            TableRelation = "Shipping Agent";
        }

        field(80120; "MICA Ship Agent Serv Exp Order"; Code[10])
        {
            Caption = 'Shipping Agent Service Express Order';
            DataClassification = CustomerContent;
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("MICA Shipping Agent Exp. Order"));
        }

        field(80130; "MICA Deliverability Code"; Code[10])
        {
            Caption = 'Deliverability code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(CustDeliverability), Blocked = const(false));
        }

        field(80140; "MICA MDM ID LE"; Code[40])
        {
            Caption = 'MDM ID LE';
            DataClassification = CustomerContent;
            //TableRelation = "MICA Table Value".Code where ("Table Type" = const (CustMDMID), Blocked = const (false));
        }

        field(80145; "MICA MDM Bill-to Site Use ID"; Code[20])
        {
            caption = 'MDM Bill-to Site Use ID';
            DataClassification = CustomerContent;
        }

        field(80150; "MICA Time Zone"; Integer)
        {
            Caption = 'Time Zone';
            DataClassification = CustomerContent;
            TableRelation = "Time Zone"."No.";
            trigger OnValidate()
            var
                TimeZone: Record "Time Zone";
            begin
                if TimeZone.Get("MICA Time Zone") then
                    Validate("MICA Time Zone Name", TimeZone."Display Name");
            end;
        }
        field(80160; "MICA Time Zone Name"; Text[250])
        {
            Caption = 'Time Zone Name';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(80170; "MICA MDM ID BT"; Code[40])
        {
            Caption = 'MDM ID BT';
            DataClassification = CustomerContent;
            //TableRelation = "MICA Table Value".Code where ("Table Type" = const (CustMDMID), Blocked = const (false));
        }

        field(80300; "MICA % Of Prepayment"; Decimal)
        {
            caption = '% Of Prepayment';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;
            InitValue = 100;
            DecimalPlaces = 0 : 2;
        }
        field(80310; "MICA Dont send balance aged"; Boolean)
        {
            Caption = 'Don''t send balance aged';
            DataClassification = CustomerContent;
        }
        field(80320; "MICA Last Balance Aged Sent"; Date)
        {
            Caption = 'Last Balance Aged Sent';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80330; "MICA Last Balance Aged Blob"; Blob)
        {
            Caption = 'Last Balance Aged Blob';
            DataClassification = CustomerContent;
        }
        field(80760; "MICA Accr. Customer Grp."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Deferred Rebates Customer Group';
            TableRelation = "MICA Accrual Customer Group";
        }
        field(80761; "MICA Accr. Cust. Posting Grp."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Def. Reb. Customer Posting Group';
            //TableRelation = "MICA Accr. Cust. Posting Group";
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80762; "MICA RPL Status"; Code[20])
        {
            Caption = 'Restricted Site';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(RestrictedSite), Blocked = const(false));
            trigger OnValidate()
            var
                MICAValueTable: Record "MICA Table Value";
            begin
                if MICAValueTable.Get(MICAValueTable."Table Type"::RestrictedSite, "MICA RPL Status") then
                    if MICAValueTable."Block Value" then
                        Validate(Blocked, Blocked::All)
                    else
                        Validate(Blocked, Blocked::" ");
            end;
        }
        field(80763; "MICA RPL Status Description"; Text[200])
        {
            Caption = 'Restricted Site Description';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("MICA Table Value".Description where("Table Type" = const(RestrictedSite), Code = field("MICA RPL Status")));
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
        field(80879; "MICA Record ID"; RecordId)
        {
            Caption = 'Record ID';
            DataClassification = CustomerContent;
        }
        field(80880; "MICA Send Last Flow Entry No."; Integer)
        {
            Caption = 'Send Last Flow Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MICA Flow Entry";
        }
        field(80881; "MICA Send Last Flow Status"; Option)
        {
            Caption = 'Send Last Flow Status';
            DataClassification = CustomerContent;
            Editable = false;
            OptionMembers = "",Prepared,Sent;
            OptionCaption = ',Prepared,Sent';
        }

        field(81820; "MICA Shipment Post Option"; Option)
        {
            Caption = 'Shipment Post Option';
            DataClassification = CustomerContent;
            OptionMembers = " ",Ship,"Ship and Invoice";
            OptionCaption = ' ,Ship,Ship and Invoice';
        }
        field(81860; "MICA Print Sell-to Address"; Boolean)
        {
            Caption = 'Print Sell-to Address';
            DataClassification = CustomerContent;
        }

        field(82160; "MICA Factoring"; Boolean)
        {
            Caption = 'Factoring';
            DataClassification = CustomerContent;
        }

        field(82740; "MICA Balance Due (Buffer)"; Decimal)
        {
            Caption = 'Balance Due (Buffer)';
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Cust. Ledg. Entry".Amount where
                ("Customer No." = field("No."),
                "MICA Initial Due Date (Buffer)" = field(upperlimit("Date Filter")),
                "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                "Currency Code" = field("Currency Filter")));
            Editable = false;
            AutoFormatExpression = "Currency Code";

        }
        field(82780; "MICA S2S External Ref."; Code[35])
        {
            caption = 'S2S External Ref.';
            DataClassification = CustomerContent;
        }
        field(82781; "MICA S2S Exact Qty."; Boolean)
        {
            caption = 'S2S Exact Qty.';
            DataClassification = CustomerContent;
        }
        field(82782; "MICA Fin. Report Primary Key"; Code[20]) //Use internaly for query join only
        {
            caption = 'Fin. Report Prim. Key';
            DataClassification = CustomerContent;
        }
        field(82820; "MICA Segmentation"; Option)
        {
            Caption = 'Segmentation';
            OptionMembers = DEALER,AVIATION,LEASER,OEM,PROF_END_USER;
            OptionCaption = 'DEALER,AVIATION,LEASER,OEM,PROF_END_USER';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Replaced by "MICA Segmentation Code" field';
        }
        field(82825; "MICA Segmentation Code"; Code[20])
        {
            Caption = 'Segmentation';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(CustSegment), Blocked = const(false));
        }
        field(83000; "MICA Rebate Pool"; Boolean)
        {
            Caption = 'Rebate Pool';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CheckIfRebatePoolEntriesExist();
            end;
        }
        field(83001; "MICA Rebate Pool Rem. Amount"; Decimal)
        {
            Caption = 'Rebate Pool Remaining Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("MICA Rebate Pool Dtld. Entry".Amount where("Customer No." = field("No.")));
        }
    }
    keys
    {
        Key(Key1; "MICA Party Ownership")
        {
        }
        key(Key2; "MICA Rebate Pool")
        {
        }
    }
    var
        Text80000Qst: Label 'Do you really want to inactivate this Customer?';
    //IncorrectTimeZoneNameErr: Label 'Incorrect Time Zone Name';

    procedure OpenCustomerLedgerEntriesDueBuffer()
    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        DetailedCustLedgEntry.SetRange("Customer No.", "No.");
        CopyFilter("Global Dimension 1 Filter", DetailedCustLedgEntry."Initial Entry Global Dim. 1");
        CopyFilter("Global Dimension 2 Filter", DetailedCustLedgEntry."Initial Entry Global Dim. 2");
        if GetFilter("Date Filter") <> '' then begin
            CopyFilter("Date Filter", DetailedCustLedgEntry."MICA Initial Due Date (Buffer)");
            DetailedCustLedgEntry.SetFilter("Posting Date", '<=%1', GetRangeMax("Date Filter"));
        end;
        CopyFilter("Currency Filter", DetailedCustLedgEntry."Currency Code");
        CustLedgerEntry.DrillDownOnEntriesDueBuffer(DetailedCustLedgEntry);
    end;

    local procedure CheckIfRebatePoolEntriesExist()
    var
        MICARebatePoolEntry: Record "MICA Rebate Pool Entry";
        CustomerHasRebatePoolEntriesLbl: Label 'You cannot disable this field. Customer %1 has Rebate Pool entries.', Comment = '%1 = No.';
    begin
        if not xRec."MICA Rebate Pool" then
            exit;

        MICARebatePoolEntry.SetRange("Customer No.", Rec."No.");
        if not MICARebatePoolEntry.IsEmpty() then
            Error(CustomerHasRebatePoolEntriesLbl, Rec."No.");
    end;

    local procedure ShowConfirmDialog(IsGuiAllowed: Boolean): Boolean
    begin
        if not IsGuiAllowed then
            exit(true);

        exit((Confirm(Text80000Qst)));
    end;
}