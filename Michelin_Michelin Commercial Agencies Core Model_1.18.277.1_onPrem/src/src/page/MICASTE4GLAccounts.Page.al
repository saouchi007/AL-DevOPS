page 81023 "MICA STE4 GL Accounts"
{
    Caption = 'STE4 GL Accounts';
    PageType = List;
    UsageCategory = None;
    SourceTable = "Account Use Buffer";
    SourceTableTemporary = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Account No."; Rec."Account No.")
                {
                    Caption = 'Account No. 2';
                    ApplicationArea = All;
                }

            }
        }
    }
    trigger OnOpenPage()
    var
        MICAUniqueGlAccountsNo2: Query "MICA Unique Gl Accounts No2";
    begin
        MICAUniqueGlAccountsNo2.Open();
        while MICAUniqueGlAccountsNo2.Read() do begin
            Rec."Account No." := MICAUniqueGlAccountsNo2.No_2;
            Rec.Insert();
        end;
        MICAUniqueGlAccountsNo2.Close();

    end;

    procedure GetSelectionFilter(): Text
    var
        TempAccountUseBuffer: Record "Account Use Buffer" temporary;
        No2Filter: Text;
    begin
        TempAccountUseBuffer.Copy(Rec, true);
        CurrPage.SetSelectionFilter(TempAccountUseBuffer);
        if TempAccountUseBuffer.FindSet() then
            repeat
                if No2Filter = '' then
                    No2Filter := TempAccountUseBuffer."Account No."
                else
                    No2Filter += '|' + TempAccountUseBuffer."Account No."
            until TempAccountUseBuffer.Next() = 0;
        exit(No2Filter);
    end;
}