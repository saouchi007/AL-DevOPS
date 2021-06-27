report 82980 "MICA Move Location Full Stock"
{
    Caption = 'Move Location Full Stock';
    ProcessingOnly = true;
    UsageCategory = None;
    UseRequestPage = true;

    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableView = sorting("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date") order(ascending);

            trigger OnPreDataItem()
            begin
                SetRange(Open, true);
                SetRange("Location Code", FromLocation);

                CountTotalRecords := 0;
                ProgressWindow.Open(ProgressEntriesLbl);
            end;

            trigger OnAfterGetRecord()
            begin
                InsertILEIntoJournal(ItemLedgerEntry);
                CountTotalRecords += 1;

                ProgressWindow.Update(1, CountTotalRecords);
            end;

            trigger OnPostDataItem()
            var
                TotalRecordsAddedLbl: Label '%1 %2(ies) added to the journal.';
            begin
                ProgressWindow.Close();
                Message(TotalRecordsAddedLbl, CountTotalRecords, ItemLedgerEntry.TableCaption());
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(FromLocationParam; FromLocation)
                    {
                        Caption = 'From Location:';
                        ApplicationArea = All;
                        TableRelation = Location where("Use As In-Transit" = const(false));
                        ToolTip = 'Select from which location you want to transfer stock.';
                    }
                    field(ToLocationParam; ToLocation)
                    {
                        Caption = 'To Location:';
                        ApplicationArea = All;
                        TableRelation = Location where("Use As In-Transit" = const(false));
                        ToolTip = 'Select for which location you want to transfer stock.';
                    }
                    field(ReasonCodeParam; ReasonCode)
                    {
                        Caption = 'Reason Code:';
                        ApplicationArea = All;
                        TableRelation = "Reason Code";
                        ToolTip = 'Select reason why you want to update inventory.';
                    }
                    field(DocumentNoParam; DocumentNo)
                    {
                        Caption = 'Document No:';
                        ApplicationArea = All;
                        ToolTip = 'Select document number to populate in Item Reclassification Journal.';

                        trigger OnValidate()
                        var
                            DocumentNoMustBePopulatedErr: Label 'The field %1 in Item Journal Batch %2 is populated. The field Document No. must be empty.', Comment = '%1 = No. Series, %2 = Item Journal Batch Name.';
                        begin
                            if DocumentNo <> '' then
                                if ItemJournalBatch."No. Series" <> '' then
                                    Error(DocumentNoMustBePopulatedErr, ItemJournalBatch.FieldCaption("No. Series"), ItemJournalBatch.Name);
                        end;
                    }
                }
            }
        }
        trigger OnOpenPage()
        begin
            if ItemJournalBatch.Get(CurrentItemJournalLine."Journal Template Name", CurrentItemJournalLine."Journal Batch Name") then;
        end;

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            if CloseAction = CloseAction::OK then
                CheckRequestPageFields();
        end;
    }

    local procedure InsertILEIntoJournal(ItemLedgerEntry: Record "Item Ledger Entry")
    var
        ItemJournalLine: Record "Item Journal Line";
        OldItemJournalLine: Record "Item Journal Line";
        NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        ItemJournalLine.Init();
        ItemJournalLine."Journal Template Name" := CurrentItemJournalLine."Journal Template Name";
        ItemJournalLine."Journal Batch Name" := CurrentItemJournalLine."Journal Batch Name";
        ItemJournalLine."Line No." := GetLastLineNo(CurrentItemJournalLine);
        ItemJournalLine.SetUpNewLine(OldItemJournalLine);
        ItemJournalLine.Validate("Posting Date", ItemLedgerEntry."Posting Date");
        if DocumentNo = '' then
            ItemJournalLine."Document No." := NoSeriesManagement.GetNextNo(ItemJournalBatch."No. Series", Today(), false)
        else
            ItemJournalLine."Document No." := DocumentNo;
        ItemJournalLine.Validate("Item No.", ItemLedgerEntry."Item No.");
        ItemJournalLine.Validate(Quantity, ItemLedgerEntry."Remaining Quantity");
        ItemJournalLine.Validate("Location Code", FromLocation);
        ItemJournalLine.Validate("Entry Type", ItemJournalLine."Entry Type"::Transfer);
        ItemJournalLine.Validate("New Location Code", ToLocation);
        ItemJournalLine.Validate("Reason Code", ReasonCode);
        ItemJournalLine.Validate("Applies-to Entry", ItemLedgerEntry."Entry No.");
        ItemJournalLine.Insert(true);
    end;

    local procedure CheckRequestPageFields()
    var
        FromLocationMustBePopulatedErr: Label 'The field From Location must be populated.';
        ToLocationMustBePopulatedErr: Label 'The field To Location must be populated.';
        ReasonCodeMustBePopulatedErr: Label 'The field Reason Code must be populated.';
        DocumentNoMustBePopulatedErr: Label 'The field %1 in Item Journal Batch %2 is empty. The field Document No. must be populated.', Comment = '%1 = No. Series, %2 = Item Journal Batch Name.';
    begin
        if FromLocation = '' then
            Error(FromLocationMustBePopulatedErr);

        if ToLocation = '' then
            Error(ToLocationMustBePopulatedErr);

        if ReasonCode = '' then
            Error(ReasonCodeMustBePopulatedErr);

        if DocumentNo = '' then
            if ItemJournalBatch."No. Series" = '' then
                Error(DocumentNoMustBePopulatedErr, ItemJournalBatch.FieldCaption("No. Series"), ItemJournalBatch.Name);
    end;

    procedure SetItemReclassJournal(NewCurrentItemJournalLine: Record "Item Journal Line")
    begin
        CurrentItemJournalLine := NewCurrentItemJournalLine;
    end;

    local procedure GetLastLineNo(NewCurrentItemJournalLine: Record "Item Journal Line"): Integer
    var
        ItemJournalLineNo: Record "Item Journal Line";
    begin
        ItemJournalLineNo.SetRange("Journal Template Name", NewCurrentItemJournalLine."Journal Template Name");
        ItemJournalLineNo.SetRange("Journal Batch Name", NewCurrentItemJournalLine."Journal Batch Name");
        if ItemJournalLineNo.FindLast() then
            exit(ItemJournalLineNo."Line No." + 10000)
        else
            exit(10000);
    end;

    var
        CurrentItemJournalLine: Record "Item Journal Line";
        ItemJournalBatch: Record "Item Journal Batch";
        FromLocation: Code[20];
        ToLocation: Code[20];
        ReasonCode: Code[20];
        DocumentNo: Code[20];
        CountTotalRecords: Integer;
        ProgressWindow: Dialog;
        ProgressEntriesLbl: Label 'Processing entries     #1###############';
}