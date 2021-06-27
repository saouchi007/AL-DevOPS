page 81641 "MICA Sales Agreement List"
{

    PageType = List;
    SourceTable = "MICA Sales Agreement";
    SourceTableView = sorting("Customer No.", "Item Category Code", Default, DefaultLP);
    Caption = 'Sales Agreements';
    ApplicationArea = All;
    UsageCategory = Lists;
    DeleteAllowed = false;
    DelayedInsert = true;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Editable = CustomerEditable;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = All;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = All;
                }
                field("Priority Code"; Rec."Priority Code")
                {
                    ApplicationArea = All;
                }
                field(Default; Rec.Default)
                {
                    ApplicationArea = All;
                }
                field(DefaultLP; Rec.DefaultLP)
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field("Payment Terms Discount %"; Rec."Payment Terms Discount %")
                {
                    ApplicationArea = All;
                }
            }
        }

    }
    trigger OnInit()
    begin
        CustomerEditable := true;
    end;

    trigger OnOpenPage()
    begin
        MICAFinancialReportingSetup.GET();
        MICAFinancialReportingSetup.TestField("Sales Agreement Nos.");
        if CustomerNo <> '' then begin
            SetCustomerFilter();
            CustomerEditable := false;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if CustomerNo <> '' then
            Rec.Validate("Customer No.", CustomerNo);
    end;

    var
        CustomerNo: Code[20];
        CustomerEditable: Boolean;

    procedure SetCustomer(NewCusomerNo: Code[20])
    begin
        CustomerNo := NewCusomerNo;
    end;

    local procedure SetCustomerFilter()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Customer No.", CustomerNo);
        Rec.FilterGroup(0);
    end;

    var
        MICAFinancialReportingSetup: record "MICA Financial Reporting Setup";
}
