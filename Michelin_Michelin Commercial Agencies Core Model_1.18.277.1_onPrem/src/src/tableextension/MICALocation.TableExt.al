tableextension 80220 "MICA Location" extends Location
{
    fields
    {
        field(80000; "MICA Outb Whse Hand T Exp Ord"; DateFormula)
        {
            Caption = 'Outbound Whse. Handling Time Express Order';
            DataClassification = CustomerContent;
        }

        field(80010; "MICA Base Cal. Code Exp. Order"; Code[10])
        {
            Caption = 'Base Calendar Code Express Order';
            DataClassification = CustomerContent;
            TableRelation = "Base Calendar";
        }

        field(80020; "MICA Regular Cut Off"; time)
        {
            Caption = 'Regular Cut Off';
            DataClassification = CustomerContent;
        }

        field(80030; "MICA Express Cut Off"; time)
        {
            Caption = 'Express Cut Off';
            DataClassification = CustomerContent;
        }
        field(80040; "MICA Entry Type"; option)
        {
            caption = 'Entry Type';
            DataClassification = CustomerContent;
            OptionMembers = " ","P (Main)","C (Transit)";
        }
        field(81300; "MICA PIT Location Code"; Code[10])
        {
            Caption = 'PIT Location Code';
            DataClassification = CustomerContent;
        }
        field(81301; "MICA DRP IN Location Code"; Code[50])
        {
            Caption = 'DRP IN Location Code';
            DataClassification = CustomerContent;
        }
        field(81302; "MICA DRP OUT Location Code"; Code[50])
        {
            Caption = 'DRP OUT Location Code';
            DataClassification = CustomerContent;
        }
        field(81303; "MICA Blocked Inv. Location"; Boolean)
        {
            Caption = 'Blocked Inv. Location';
            DataClassification = CustomerContent;
        }
        field(81304; "MICA 3PL Location Code"; Code[20])
        {
            Caption = '3PL Location Code';
            DataClassification = CustomerContent;
        }
        field(81305; "MICA 3PL Integration"; Boolean)
        {
            Caption = '3PL Integration';
            DataClassification = CustomerContent;
        }
        field(81306; "MICA 3PL Location Name"; Code[50])
        {
            Caption = '3PL Location Name';
            DataClassification = CustomerContent;
        }
        field(81307; "MICA Exclude from DRP"; Boolean)
        {
            Caption = 'Exclude from DRP';
            DataClassification = CustomerContent;
        }
        field(81420; "MICA SRD Default Delay"; DateFormula)
        {
            Caption = 'SRD Default Delay';
            DataClassification = CustomerContent;
        }

        field(81380; "MICA Whse. Receipt Creat. Per."; DateFormula)
        {
            Caption = 'Whse. Receipt Creation Period';
            DataClassification = CustomerContent;
        }

        field(81590; "MICA Commitment Type"; Option)
        {
            Caption = 'Commitment Type';
            DataClassification = CustomerContent;
            OptionMembers = "On-Hand + GIT","On-Hand","Third Party";
            OptionCaption = 'On-Hand + GIT,On-Hand,Third Party';

            trigger OnValidate()
            begin
                if "MICA Commitment Type" = "MICA Commitment Type"::"Third Party" then
                    TestField("MICA 3rd Party Vendor No.");
            end;
        }

        field(81623; "MICA 3PL Anticipation Period"; DateFormula)
        {
            Caption = '3PL Anticipation Period';
            DataClassification = CustomerContent;
        }

        field(81823; "MICA 3PL E-Mail for Sales Docs"; Text[200])
        {
            Caption = '3PL E-Mail for Sales Documents';
            DataClassification = CustomerContent;
        }

        field(81824; "MICA 3PL Email Pstd. Shpt."; Boolean)
        {
            caption = '3PL Send posted shipment by email';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "MICA 3PL Email Pstd. Shpt." then
                    TestField("MICA 3PL E-Mail for Sales Docs");
            end;
        }
        field(81825; "MICA 3PL Email Pstd. Inv."; Boolean)
        {
            caption = '3PL Send posted invoice by email';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "MICA 3PL Email Pstd. Inv." then
                    TestField("MICA 3PL E-Mail for Sales Docs");
            end;
        }

        field(82220; "MICA eFDM On Hand Quantity"; Code[20])
        {
            Caption = 'eFDM On Hand Quantity';
            DataClassification = CustomerContent;
        }
        field(82221; "MICA eFDM Blocked Quantity"; Code[20])
        {
            Caption = 'eFDM Blocked Quantity';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "MICA eFDM Blocked Quantity" <> '' then
                    TestField("MICA eFDM On Hand Quantity", "MICA eFDM Blocked Quantity");
            end;
        }
        field(82340; "MICA SPD OnHand Qty. Code"; Code[20])
        {
            Caption = 'SPD OnHand Qty. Code';
            DataClassification = CustomerContent;
        }
        field(82341; "MICA SPD Blocked Qty. Code"; Code[20])
        {
            Caption = 'SPD Blocked Qty. Code';
            DataClassification = CustomerContent;
        }
        field(82541; "MICA Pick-Up Calendar"; Code[10])
        {
            Caption = 'Pick-Up Calendar';
            DataClassification = CustomerContent;
            TableRelation = "Base Calendar";
        }
        field(82542; "MICA Pick-Up Shipping Agent"; Code[10])
        {
            Caption = 'Pick-Up Shipping Agent';
            DataClassification = CustomerContent;
            TableRelation = "Shipping Agent";
        }
        field(82543; "MICA PickUp Ship Agent Service"; Code[10])
        {
            Caption = 'Pick-Up Shipping Agent Service';
            DataClassification = CustomerContent;
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("MICA Pick-Up Shipping Agent"));
        }
        field(82580; "MICA Allocation Detail"; Boolean)
        {
            Caption = 'Allocation Detail';
            DataClassification = CustomerContent;
        }
        field(82380; "MICA Inventory Organization"; Code[3])
        {
            DataClassification = CustomerContent;
            Caption = 'Inventory Organization';
        }
        field(82920; "MICA 3rd Party Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = '3rd Party Vendor No.';
            TableRelation = Vendor."No.";

            trigger OnValidate()
            var
                SalesHeader: Record "Sales Header";
                SalesLine: Record "Sales Line";
            begin
                SalesHeader.SetRange("Location Code", Code);
                SalesHeader.ModifyAll("MICA 3rd Party Vendor No.", Rec."MICA 3rd Party Vendor No.", false);
                SalesLine.SetRange("Location Code", Code);
                SalesLine.ModifyAll("MICA 3rd Party Vendor No.", Rec."MICA 3rd Party Vendor No.", false);

            end;
        }
    }
}