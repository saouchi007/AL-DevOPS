tableextension 80021 "MICA Ship-To Adress" extends "Ship-to Address" //MyTargetTableId
{
    fields
    {
        field(80000; "MICA Status"; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            OptionMembers = Active,Inactive;
        }

        field(80010; "MICA Last Modification Date"; Date)
        {
            Caption = 'Last Modification Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80011; "MICA Last Mod. Date Time"; DateTime)
        {
            Caption = 'Last Modification Date Time';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(80020; "MICA Base Calendar Code"; Code[10])
        {
            Caption = 'Base Calendar Code';
            DataClassification = CustomerContent;
            TableRelation = "Base Calendar";
        }

        field(80030; "MICA Express Order"; Boolean)
        {
            Caption = 'Express Order';
            DataClassification = CustomerContent;
        }

        field(80040; "MICA Internal Code"; Code[20])
        {
            Caption = 'Internal Code';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(80050; "MICA Base Cal. Code Exp. Order"; Code[10])
        {
            Caption = 'Base Calendar Code Express Order';
            DataClassification = CustomerContent;
            TableRelation = "Base Calendar";
        }

        field(80060; "MICA Ship. Agent Exp. Order"; Code[10])
        {
            Caption = 'Shipping Agent Express Order';
            DataClassification = CustomerContent;
            TableRelation = "Shipping Agent";
        }
        field(80070; "MICA Ship Agent Serv Exp Order"; Code[10])
        {
            Caption = 'Shipping Agent Service Express Order';
            DataClassification = CustomerContent;
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("MICA Ship. Agent Exp. Order"));
        }
        field(80080; "MICA MDM ID"; Code[40])
        {
            Caption = 'MDM ID';
            DataClassification = CustomerContent;
            //TableRelation = "MICA Table Value".Code where ("Table Type" = const (CustMDMID), Blocked = const (false));
        }
        field(80090; "MICA MDM Ship-to Use ID"; Code[20])
        {
            caption = 'MDM Ship-to Site Use ID';
            DataClassification = CustomerContent;
        }
        field(80760; "MICA RPL Status"; Code[20])
        {
            Caption = 'Restricted Site';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(RestrictedSite), Blocked = const(false));
        }
        field(80761; "MICA RPL Status Description"; Text[200])
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

        field(82780; "MICA S2S External Ref."; Code[35])
        {
            caption = 'S2S External Ref.';
            DataClassification = CustomerContent;
        }
        field(82840; "MICA Time Zone"; Integer)
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
        field(82841; "MICA Time Zone Name"; Text[250])
        {
            Caption = 'Time Zone Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
    keys
    {
        key(Key1; "MICA MDM Ship-to Use ID")
        {

        }
    }
}