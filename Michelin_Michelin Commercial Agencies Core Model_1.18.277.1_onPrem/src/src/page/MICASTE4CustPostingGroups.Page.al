page 81025 "MICA STE4 Cust. Posting Groups"
{
    Caption = 'STE4 Customer Posting Groups';
    PageType = List;
    UsageCategory = None;
    SourceTable = "Customer Posting Group";
    SourceTableTemporary = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec.Code)
                {
                    Caption = 'Code';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                }
                field("Receivables Account"; Rec."Receivables Account")
                {
                    Caption = 'Receivables Account';
                    ApplicationArea = All;
                }
                field("Service Charge Acc."; Rec."Service Charge Acc.")
                {
                    Caption = 'Service Charge Acc.';
                    ApplicationArea = All;
                }
                field("Interest Account"; Rec."Interest Account")
                {
                    Caption = 'Interest Account';
                    ApplicationArea = All;
                }
                field("Additional Fee Account"; Rec."Additional Fee Account")
                {
                    Caption = 'Additional Fee Account';
                    ApplicationArea = All;
                }
                field("Debit Rounding Account"; Rec."Debit Rounding Account")
                {
                    Caption = 'Additional Fee Account';
                    ApplicationArea = All;
                }
                field("Credit Rounding Account"; Rec."Credit Rounding Account")
                {
                    Caption = 'Credit Rounding Account';
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        CustomerPostingGroup: Record "Customer Posting Group";
    begin
        if CustomerPostingGroup.FindSet() then
            repeat
                Rec.TransferFields(CustomerPostingGroup);
                Rec.Insert();
            until CustomerPostingGroup.Next() = 0;
    end;

    procedure GetSelectionFilter(): Text
    var
        TempCustomerPostingGroup: Record "Customer Posting Group" temporary;
        CustomerPostingGroupFilter: Text;
    begin
        TempCustomerPostingGroup.Copy(Rec, true);
        CurrPage.SetSelectionFilter(TempCustomerPostingGroup);
        if TempCustomerPostingGroup.FindSet() then
            repeat
                if CustomerPostingGroupFilter = '' then
                    CustomerPostingGroupFilter := TempCustomerPostingGroup.Code
                else
                    CustomerPostingGroupFilter += '|' + TempCustomerPostingGroup.Code
            until TempCustomerPostingGroup.Next() = 0;
        exit(CustomerPostingGroupFilter);
    end;
}