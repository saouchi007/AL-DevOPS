codeunit 50100 BonusCalculation
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesInvLineInsert', '', true, true)]
    local procedure RunOnAfterSalesInvLineInsert(var SalesInvLine: Record "Sales Invoice Line")
    begin
        CalculateBonus(SalesInvLine);
    end;

    local procedure CalculateBonus(var SalesInvLine: Record "Sales Invoice Line")
    var
        BonusHeader: Record BonusHeaderTable;
    begin
        if SalesInvLine.Type <> SalesInvLine.Type::Item then begin
            exit;

            BonusHeader.SetRange("Customer No.", SalesInvLine."Bill-to Customer No.");
            BonusHeader.SetRange(Status, BonusHeader.Status::Released);
            BonusHeader.SetFilter("Starting Date", '..%1', SalesInvLine."Posting Date");
            BonusHeader.SetFilter("Ending Date", '1%..', SalesInvLine."Posting Date");

            if BonusHeader.IsEmpty() then
                exit;
            if BonusHeader.FindSet() then
                repeat
                    FindBonusForAllItems(BonusHeader, SalesInvLine);
                    FindBonusforOneItem(BonusHeader, SalesInvLine);
                until BonusHeader.Next() = 0;

        end;
    end;

    local procedure FindBonusForAllItems(var BonusHeader: Record BonusHeaderTable; SalesInvLine: Record "Sales Invoice Line")
    var
        BonusLine: Record BonusLineTable;
    begin
        BonusLine.SetRange("Document No.", BonusHeader."No.");
        BonusLine.SetRange(Type, BonusLine.Type::"All Items");



        if BonusLine.FindFirst() then
            InsertBonusEntry(BonusLine, SalesInvLine);
    end;

    local procedure FindBonusforOneItem(var BonusHeader: Record BonusHeaderTable; SalesInvLine: Record "Sales Invoice Line")
    var
        BonusLine: Record BonusLineTable;
    begin
        BonusLine.SetRange("Document No.", BonusHeader."No.");
        BonusLine.SetRange(Type, BonusLine.Type::Item);
        BonusLine.SetRange("Item No.", SalesInvLine."No.");

        if BonusLine.FindFirst() then begin
            InsertBonusEntry(BonusLine, SalesInvLine);
        end;

    end;

    local procedure InsertBonusEntry(var BonusLine: Record BonusLineTable; SalesInvLine: Record "Sales Invoice Line")
    var
        BonusEntry: Record BonusEntry;
        EntryNo: Integer;
    begin
        if BonusLine.FindLast() then
            EntryNo := BonusEntry."Entry No." + 1
        else
            EntryNo := 1;

        BonusEntry.Init();
        BonusEntry."Entry No." := EntryNo;
        BonusEntry."Bonus No." := SalesInvLine."Document No.";
        BonusEntry."Document No." := SalesInvLine."Document No.";
        BonusEntry."Item No." := SalesInvLine."No.";
        BonusEntry."Posting Date" := SalesInvLine."Posting Date";
        BonusEntry."Bonus amount" := SalesInvLine."Line Amount" * BonusLine."Bonus Perc." / 100;
        BonusEntry.Insert();
    end;


}