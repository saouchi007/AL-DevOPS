pageextension 50100 GL_Entries_Source_Name_Ext extends "General Ledger Entries"
{
    layout
    {
        addafter("Source Code")
        {
            field("Source Name"; SourceName)
            {
                Caption = 'Source Name';
                ApplicationArea = All;
            }
        }
    }
    var
        SourceName: Text[50];

    trigger OnAfterGetRecord()
    var
        Cust: Record Customer;
        Vend: Record Vendor;
        FA: Record "Fixed Asset";
        BankAccount: Record "Bank Account";
        Employee: Record Employee;
    begin
        SourceName := '';
        case Rec."Source Type" of
            Rec."Source Type"::Customer:
                if Cust.Get(Rec."Source No.") then
                    SourceName := Cust.Name;
            Rec."Source Type"::"Fixed Asset":
                if FA.Get(Rec."Source No.") then
                    SourceName := FA.Description;
            Rec."Source Type"::Vendor:
                if Vend.Get(Rec."Source No.") then
                    SourceName := Vend.Name;
            Rec."Source Type"::"Bank Account":
                if BankAccount.Get(Rec."Source No.") then
                    SourceName := BankAccount.Name;
            Rec."Source Type"::Employee:
                if Employee.Get(Rec."Source No.") then
                    SourceName := Employee.FullName();
        end;

    end;

}
