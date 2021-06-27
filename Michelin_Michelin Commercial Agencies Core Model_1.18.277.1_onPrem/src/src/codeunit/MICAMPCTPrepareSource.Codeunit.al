codeunit 81552 "MICA MP CT-Prepare Source"
{
    // version MIC01.00.18

    // MIC:EDD029:1:0      21/02/2017 COSMO.CCO
    //   # New codeunit to manage Mass Payment File creation

    TableNo = "Gen. Journal Line";

    trigger OnRun()
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.COPYFILTERS(Rec);
        CopyJnlLines(GenJournalLine, Rec);
    end;

    local procedure CopyJnlLines(var FromGenJournalLine: Record "Gen. Journal Line"; var TempGenJournalLine: Record "Gen. Journal Line" temporary)
    var
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        IF FromGenJournalLine.FindSet() THEN BEGIN
            GenJournalBatch.GET(FromGenJournalLine."Journal Template Name", FromGenJournalLine."Journal Batch Name");

            REPEAT
                TempGenJournalLine := FromGenJournalLine;
                TempGenJournalLine.Insert();
            UNTIL FromGenJournalLine.Next() = 0
        END ELSE
            CreateTempJnlLines(FromGenJournalLine, TempGenJournalLine);
    end;

    local procedure CreateTempJnlLines(var FromGenJournalLine: Record "Gen. Journal Line"; var TempGenJournalLine: Record "Gen. Journal Line" temporary)
    begin
        // To fill TempGenJnlLine from the source identified by filters set on FromGenJnlLine
        TempGenJournalLine := FromGenJournalLine;
    end;
}

