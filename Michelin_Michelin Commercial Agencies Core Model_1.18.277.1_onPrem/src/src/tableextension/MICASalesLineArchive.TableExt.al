tableextension 80403 "MICA Sales Line Archive" extends "Sales Line Archive"
{
    fields
    {

        ////// BEGIN
        field(80000; "MICA Exceptional Disc. %"; Decimal)
        {
            Caption = 'Exceptional Disc. %';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
        }
        field(80001; "MICA Pay. Terms Line Disc. %"; Decimal)
        {
            Caption = 'Payment Terms Line Disc. %';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
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
        field(81490; "MICA Delivery Date Modified"; Date)
        {
            Caption = 'Delivery Date Modified';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81781; "MICA Release Status Count"; Integer)
        {
            Caption = 'Release Status Count';
            DataClassification = CustomerContent;
            Editable = false;
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
        ////// END

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
        field(81640; "MICA Sales Agreement No."; Code[20])
        {
            Caption = 'Sales Agreement No.';
            DataClassification = CustomerContent;
            Editable = false;
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
        }
        field(81785; "MICA Cancel. Reason"; Code[20])
        {
            Caption = 'Cancel. Reason';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(SalesLineCancelReasonCode), Blocked = const(false));
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
        }
        field(81822; "MICA Inv. Discrepancy"; Boolean)
        {
            Caption = 'Inv. Discrepancy';
            DataClassification = CustomerContent;
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
        }

        field(80140; "MICA Transport Instruction"; Code[20])
        {
            Caption = 'Transport Instruction';
            DataClassification = CustomerContent;
            TableRelation = "MICA Transport Instructions".Code;
        }
    }

}