codeunit 82060 "MICA Mass Payments Vietnam"
{
    trigger OnRun()
    begin

    end;

    procedure GetTempGenJournalLine(var TempGenJournalLine: Record "Gen. Journal Line"; var GenJournalLine: Record "Gen. Journal Line")
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        i: Integer;
    begin
        i += 1;
        if TempGenJournalLine.IsTemporary() then
            TempGenJournalLine.DeleteAll();
        IF GenJournalLine.FindSet() then
            repeat

                TempGenJournalLine.Init();
                TempGenJournalLine."Line No." := i;
                TempGenJournalLine."Payment Method Code" := GenJournalLine."Payment Method Code";
                TempGenJournalLine."Account Type" := GenJournalLine."Account Type";
                TempGenJournalLine."Account No." := GenJournalLine."Account No.";
                TempGenJournalLine."Amount (LCY)" := GenJournalLine."Amount (LCY)";
                case GenJournalLine."Account Type" of
                    GenJournalLine."Account Type"::Customer:
                        begin
                            Customer.get(GenJournalLine."Account No.");
                            TempGenJournalLine."Tax Liable" := (Customer."Currency Code" <> ''); // For international payments
                        end;
                    GenJournalLine."Account Type"::Vendor:
                        begin
                            Vendor.get(GenJournalLine."Account No.");
                            TempGenJournalLine."Tax Liable" := (Vendor."Currency Code" <> ''); // For international payments
                        end;
                end;
                TempGenJournalLine.Insert();
                i += 1;
            until GenJournalLine.Next() = 0;
    end;

    procedure GetFileName(GenJournalLine: Record "Gen. Journal Line"; var FileName: Text[250])
    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        CompanyInformation: Record "Company Information";
        Environment: Char;
        DateTimeText: Text[20];
        PaymentType: Text[5];
        MessageNameFlow: Text[20];
    begin
        Clear(FileName);
        CompanyInformation.Get();
        MICAFinancialReportingSetup.Get();
        DateTimeText := Format(CurrentDateTime(), 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>');
        Environment := 'I';
        if GenJournalLine."Tax Liable" then begin // Supplier is international
            MessageNameFlow := 'XMLV3-SUP-INTL-X';
            PaymentType := '00604';
        end else
            CASE TRUE of
                GenJournalLine."Payment Method Code" = MICAFinancialReportingSetup."Dynamic Pay. Mtd. Code Value 1": // GIRO
                    begin
                        MessageNameFlow := 'XMLV3-SUP-DOM-GIRO';
                        PaymentType := '00603';
                    end;
                GenJournalLine."Payment Method Code" = MICAFinancialReportingSetup."Dynamic Pay. Mtd. Code Value 2": // DFT
                    begin
                        MessageNameFlow := 'XMLV3-SUP-DOM-DFT';
                        PaymentType := '00602';
                    end;
            end;
        FileName := 'GMS' + PaymentType + '_' + MessageNameFlow + '_' + DateTimeText + '_' + Environment + '_';
        FileName += CompanyInformation."Country/Region Code" + '_' + MICAFinancialReportingSetup."Company Code" + '_BSC.xml';
    end;
}