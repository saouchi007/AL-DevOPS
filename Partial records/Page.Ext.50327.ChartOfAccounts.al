/// <summary>
/// PageExtension ISA_ChartAccounts_Ext (ID 50327) extends Record MyTargetPage.
/// </summary>
pageextension 50327 ISA_ChartAccounts_Ext extends "Chart of Accounts"
{

    trigger OnOpenPage()
    begin
        //ISA_DefaultRecordSelection();
        ISA_PartialRecord();
    end;

    local procedure ISA_DefaultRecordSelection()
    var
        ILE: Record "Item Ledger Entry";
        ILEDict: Dictionary of [Integer, Text];
        StartDate: DateTime;
    begin
        StartDate := CurrentDateTime;

        if ILE.FindSet() then
            repeat
                ILEDict.Add(ILE."Entry No.", ILE.Description);
            until ILE.Next() = 0;

        Message('Working time : %1 \Total count is %2', CurrentDateTime - StartDate, ILE.Count);
    end;

    local procedure ISA_PartialRecord()
    var
        ILE: Record "Item Ledger Entry";
        ILEDict: Dictionary of [Integer, Text];
        StartDate: DateTime;
    begin
        StartDate := CurrentDateTime;

        ILE.SetLoadFields(ILE."Entry No.", ILE.Description);

        if ILE.FindSet() then
            repeat
                ILEDict.Add(ILE."Entry No.", ILE.Description);
            until ILE.Next() = 0;

        Message('Working time : %1 \Total count is %2', CurrentDateTime - StartDate, ILE.Count);
    end;
}