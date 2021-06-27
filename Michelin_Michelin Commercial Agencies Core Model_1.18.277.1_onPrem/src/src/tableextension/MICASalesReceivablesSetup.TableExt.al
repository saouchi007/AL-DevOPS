tableextension 80022 "MICA Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(80000; "MICA Internal Code Nos."; Code[20])
        {
            Caption = 'Internal Code Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }

        field(80001; "MICA CES Evaluation Period"; DateFormula)
        {
            Caption = 'CES Evaluation Period';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
        }

        field(80002; "MICA Interact Templ Req Analy"; Code[10])
        {
            Caption = 'Interaction Template for Req. Analysis';
            DataClassification = CustomerContent;
            Description = 'REQUEST';
            TableRelation = "Interaction Template".Code;
        }

        field(80003; "MICA Express Order Qty Max"; Decimal)
        {
            Caption = 'Express Order Qty Max';
            DataClassification = CustomerContent;
        }

        field(80010; "MICA SANA Next Trucks Period"; DateFormula)
        {
            Caption = 'SANA Next Trucks Period';
            DataClassification = CustomerContent;
        }

        field(80020; "MICA In-transit default delay"; DateFormula)
        {
            Caption = 'In-transit default delay';
            DataClassification = CustomerContent;
        }

        field(80030; "MICA Commitment Period"; DateFormula)
        {
            Caption = 'Commitment Period';
            DataClassification = CustomerContent;
        }
        field(80180; "MICA Disable Appl. Sales Disc."; Boolean)
        {
            Caption = 'Disable Applied Sales Discount';
            DataClassification = CustomerContent;
        }
        field(80182; "MICA Force Appl. Sales Disc."; Boolean)
        {
            Caption = 'Force Applied Sales Discount';
            DataClassification = CustomerContent;
        }
        field(80183; "MICA Force Val. During WebShop"; Boolean)
        {
            Caption = 'Force validation during Web Shop refresh';
            DataClassification = CustomerContent;
        }
        field(80240; "MICA Type of Cust. for Prices"; Option)
        {
            Caption = 'Type of Customer for Prices';
            OptionMembers = "Bill-to Customer (standard)","Sell-to Customer";
            OptionCaption = 'Bill-to Customer (standard),Sell-to Customer';
            DataClassification = CustomerContent;
        }
        field(80340; "MICA Approval Workflow"; Code[20])
        {
            Caption = 'Approval Workflow';
            DataClassification = CustomerContent;
            TableRelation = "Workflow".Code;
        }
        field(81610; "MICA Keep order when invoiced"; Boolean)
        {
            Caption = 'Keep order when invoiced';
            DataClassification = CustomerContent;
        }

        field(81820; "MICA Shipment Post Option"; Option)
        {
            Caption = 'Shipment Post Option';
            DataClassification = CustomerContent;
            OptionMembers = " ",Ship,"Ship and Invoice";
            OptionCaption = ' ,Ship,Ship and Invoice';
        }
        field(81821; "MICA Auto Whse.Ship Part Post"; Boolean)
        {
            Caption = 'Auto Whse.Shipment on Partial Post';
            DataClassification = CustomerContent;
        }
        field(82500; "MICA BIBNET. Release Order"; Boolean)
        {
            Caption = 'BIBNET. Release Order';
            DataClassification = CustomerContent;
        }
        field(82501; "MICA NotUse In Mem. Split Line"; Boolean)
        {
            Caption = 'Do Not Use In Memory for Split Line';
            DataClassification = CustomerContent;
        }
        field(80140; "MICA Use Std Reservation Mode"; Boolean)
        {
            Caption = 'Use Standard Reservation Mode';
            DataClassification = CustomerContent;
        }

        field(82740; "MICA Overdue Buffer"; DateFormula)
        {
            Caption = 'Overdue Buffer';
            DataClassification = CustomerContent;
        }
        field(82760; "MICA Rebate Recalc. Window"; DateFormula)
        {
            Caption = 'Rebate Excl. Recalc. Window';
            DataClassification = CustomerContent;
        }
        field(82761; "MICA Price Recalc. Window"; DateFormula)
        {
            Caption = 'Price Excl. Recalc. Window';
            DataClassification = CustomerContent;
        }
        field(82762; "MICA SO Price Rec. Excl. Wind."; DateFormula)
        {
            Caption = 'SO Price Rec. Excl. Wind.';
            DataClassification = CustomerContent;
        }
        field(82763; "MICA SO Reb. Rec. Excl. Wind."; DateFormula)
        {
            Caption = 'SO Reb. Rec. Excl. Wind.';
            DataClassification = CustomerContent;
        }
        field(82820; "MICA Default % of Prepayment"; Decimal)
        {
            Caption = 'Default % of Prepayment';
            DataClassification = CustomerContent;
        }
        field(83980; "MICA ASN Use Line No. Grouping"; Boolean)
        {
            Caption = 'ASN Use Line No. Grouping';
            DataClassification = CustomerContent;
        }
        field(81780; "MICA Optimize Archive Mgmt"; Boolean)
        {
            Caption = 'Optimize Archive Management';
            DataClassification = CustomerContent;
        }
        field(82920; "MICA 3rd Party Cancel Reason"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = '3rd Party Cancel Reason Code';
            TableRelation = "MICA Table Value".Code where("Table Type" = const(SalesLineCancelReasonCode), Blocked = const(false));
        }
        field(82921; "MICA 3rd Party Avail. Warn. %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = '3rd Party Avail. Warning %';
            MinValue = 10;
            MaxValue = 100;
        }
        field(82940; "MICA Combine Shipment Option"; Option)
        {
            Caption = 'Combine Shipment Option';
            OptionMembers = Create,CreateAndPost;
            OptionCaption = 'Create,Create & Post';
            DataClassification = CustomerContent;
        }
        field(82950; "MICA Combine Ship. By VAT Rate"; Boolean)
        {
            Caption = 'Combine Shipment By VAT Rate';
            DataClassification = CustomerContent;
        }
        field(83000; "MICA Reb. Pool Jnl. Serie No."; Code[20])
        {
            Caption = 'Rebate Pool Journal Serie No.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }
}