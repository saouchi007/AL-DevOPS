table 81641 "MICA Sales Agreement"
{
    DataClassification = CustomerContent;
    Caption = 'Sales Agreement';
    LookupPageId = "MICA Sales Agreement List";
    DrillDownPageId = "MICA Sales Agreement List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                FinancialReportingSetup: Record "MICA Financial Reporting Setup";
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    FinancialReportingSetup.GET();
                    NoSeriesManagement.TestManual(FinancialReportingSetup."Sales Agreement Nos.");
                END;
            end;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
            NotBlank = true;

            trigger OnValidate()
            var
                SalesAgreement: record "MICA Sales Agreement";
            begin
                TestField(Default, false);
                TestField(DefaultLP, false);
                FindDefaultSalesAgreement(SalesAgreement, Rec, false);
                if SalesAgreement.IsEmpty() then
                    VALIDATE(Default, true);

                if "Item Category Code" <> '' then begin
                    FindDefaultSalesAgreement(SalesAgreement, Rec, true);
                    if SalesAgreement.IsEmpty() then
                        VALIDATE(DefaultLP, true);
                end;
            end;
        }
        field(3; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Category";

            trigger OnValidate()
            var
                SalesAgreement: record "MICA Sales Agreement";
            begin
                TestField(Default, false);
                TestField(DefaultLP, false);
                FindDefaultSalesAgreement(SalesAgreement, Rec, true);
                if SalesAgreement.IsEmpty() then
                    VALIDATE(DefaultLP, true);
            end;
        }
        field(4; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            DataClassification = CustomerContent;
            TableRelation = "Payment Method";

            trigger OnValidate()
            begin
                If Default then
                    UpdateCustomer();
            end;
        }
        field(5; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            DataClassification = CustomerContent;
            TableRelation = "Payment Terms";

            trigger OnValidate()
            begin
                If Default then
                    UpdateCustomer();
            end;
        }
        field(6; "Priority Code"; Code[10])
        {
            Caption = 'Priority Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Priority";
        }
        field(7; Default; Boolean)
        {
            Caption = 'Default';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                SalesAgreement: Record "MICA Sales Agreement";
                DefaultLineErr_Msg: label 'You cannot disable a Default line. You must set up another Default line before disabling the current line.';
            begin
                if Default then begin
                    FindDefaultSalesAgreement(SalesAgreement, Rec, false);
                    if not SalesAgreement.IsEmpty() THEN
                        CheckCollapsingDefaultSalesAgreement(SalesAgreement, Rec);

                    UpdateCustomer();
                end else begin
                    FindDefaultSalesAgreement(SalesAgreement, Rec, false);
                    if SalesAgreement.IsEmpty() THEN
                        error(DefaultLineErr_Msg);
                end;
            end;
        }
        field(8; DefaultLP; Boolean)
        {
            Caption = 'Default LP';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                SalesAgreement: Record "MICA Sales Agreement";
                DefaultLineErr_Msg: label 'You cannot disable a Default LP line. You must set up another Default LP line before disabling the current line.';
            begin
                if DefaultLP then begin
                    TestField("Item Category Code");
                    FindDefaultSalesAgreement(SalesAgreement, Rec, true);
                    if not SalesAgreement.IsEmpty() THEN
                        CheckCollapsingDefaultSalesAgreement(SalesAgreement, Rec);
                end else begin
                    FindDefaultSalesAgreement(SalesAgreement, Rec, true);
                    if SalesAgreement.IsEmpty() THEN
                        error(DefaultLineErr_Msg);
                end;
            end;
        }
        field(9; "Start Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }

        field(10; "End Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                EndDatErr_Msg: Label 'Starting Date cannot be after ending date.';
            begin
                IF "Start Date" > "End Date" then
                    ERROR(EndDatErr_Msg);
            end;
        }
        field(11; "Payment Terms Discount %"; Decimal)
        {
            Caption = 'Payment Terms Discount %';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 0 : 2;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        Key(Key1; "Customer No.", "Item Category Code", Default, DefaultLP)
        {

        }
    }

    trigger OnInsert()
    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
    begin
        IF "No." = '' THEN BEGIN
            MICAFinancialReportingSetup.GET();
            MICAFinancialReportingSetup.TESTFIELD("Sales Agreement Nos.");
            NoSeriesManagement.InitSeries(MICAFinancialReportingSetup."Sales Agreement Nos.", '', 0D, "No.", MICAFinancialReportingSetup."Sales Agreement Nos.");
        END;
        TestField("Payment Method Code");
        TestField("Payment Terms Code");
        TestField("Start Date");
        TestField("End Date");
        if Default then
            Validate(Default);
        if DefaultLP then
            Validate(DefaultLP);
    end;

    trigger OnModify()
    begin
        TestField("Payment Method Code");
        TestField("Payment Terms Code");
        TestField("Start Date");
        TestField("End Date");
    end;

    Local procedure FindDefaultSalesAgreement(var MICASalesAgreement: Record "MICA Sales Agreement"; RecMICASalesAgreement: record "MICA Sales Agreement"; LPTest: Boolean)
    begin
        MICASalesAgreement.SetCurrentKey("Customer No.", "Item Category Code", Default, DefaultLP);
        MICASalesAgreement.setrange("Customer No.", RecMICASalesAgreement."Customer No.");
        MICASalesAgreement.SETRANGE("Item Category Code", RecMICASalesAgreement."Item Category Code");
        If not LPTest then
            MICASalesAgreement.SetRange(Default, true)
        else
            MICASalesAgreement.SetRange(DefaultLP, true);
        MICASalesAgreement.SetFilter("No.", '<>%1', RecMICASalesAgreement."No.");
    end;

    local procedure CheckCollapsingDefaultSalesAgreement(var SalesAgreement: Record "MICA Sales Agreement"; var NewDfltSalesAgreement: Record "MICA Sales Agreement")
    var
        DefaultSalesAgreement: Record "MICA Sales Agreement";
        CollapsingPeriod: Boolean;
        CollapsingError_Lbl: Label 'The period of the sales agreement %1 is collapsing with the period of sales agreement %2';
    begin
        DefaultSalesAgreement.CopyFilters(SalesAgreement);
        if DefaultSalesAgreement.FindSet() then
            repeat
                CollapsingPeriod := (DefaultSalesAgreement."Start Date" in [NewDfltSalesAgreement."Start Date" .. NewDfltSalesAgreement."End Date"]) or
                   (DefaultSalesAgreement."End Date" in [NewDfltSalesAgreement."Start Date" .. NewDfltSalesAgreement."End Date"]) or
                    (NewDfltSalesAgreement."Start Date" in [DefaultSalesAgreement."Start Date" .. DefaultSalesAgreement."End Date"]) or
                    (NewDfltSalesAgreement."End Date" in [DefaultSalesAgreement."Start Date" .. DefaultSalesAgreement."End Date"]);
                if CollapsingPeriod then
                    Error(CollapsingError_Lbl, NewDfltSalesAgreement."No.", DefaultSalesAgreement."No.");
            until DefaultSalesAgreement.Next() = 0;

    end;

    local procedure UpdateCustomer()
    var
        ModifyCustomer: record customer;
    begin
        if ModifyCustomer.get(Rec."Customer No.") then begin
            ModifyCustomer."Payment Method Code" := "Payment Method Code";
            ModifyCustomer."Payment Terms Code" := "Payment Terms Code";
            ModifyCustomer.Modify();
        end;
    end;

    var
        NoSeriesManagement: Codeunit NoSeriesManagement;

}