codeunit 81558 "MICA Process Mass Payment AR"
{
    TableNo = "Gen. Journal Line";

    var
        PaymentMethod: Record "Payment Method";
        MICAFinancialReportingSetup: record "MICA Financial Reporting Setup";
        MICAFlow: record "MICA Flow";
        MICAFlowEntry: record "MICA Flow Entry";
        MICAFlowInformation: Record "MICA Flow Information";
        XmlMICAARMPpain00100103: XmlPort "MICA AR MP pain.001.001.03";
        DftPaymentType: Text[20];
        GiroPaymentType: Text[20];
        IntPaymentType: Text[20];
        MassPmtfileName: Text;
        XMLFileName: Text;

    trigger OnRun()
    var
        FromPmtGenJournalLine: record "Gen. Journal Line";
        TempPmtGenJournalLine: record "Gen. Journal Line" temporary;
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        NoOfRecords: Integer;
        StartMsg: Label 'Start preparing data for Mass Payment';
        PaymentJnlTxt: label 'Payment journal %1.';
        FlowEntryMsg: label '%1 no. %2 created with file %3.';
        ExportFailErr: Label 'Export Failed: %1';
        EndMsg: Label 'Data Prepapration has been completed.';
        NoOfLinesExportedMsg: label '%1 line(s) exported for %2 %3.';
    begin
        MICAFinancialReportingSetup.get();
        MICAFlow.Get(MICAFinancialReportingSetup."Mass Payment Flow code");

        CheckFlowParam();

        FromPmtGenJournalLine.CopyFilters(Rec);
        FromPmtGenJournalLine.SetRange("Exported to Payment File", false);
        if FromPmtGenJournalLine.IsEmpty() then
            exit;

        CheckBankAccountSetup(FromPmtGenJournalLine);

        CheckVendorSetup(FromPmtGenJournalLine);

        if PaymentMethod.FindSet() then
            repeat
                FromPmtGenJournalLine.SetRange("Payment Method Code", PaymentMethod.Code);
                if not FromPmtGenJournalLine.IsEmpty() then begin
                    NoOfRecords := FromPmtGenJournalLine.Count();
                    SetTmpPmtJnlLine(TempPmtGenJournalLine, FromPmtGenJournalLine);
                    if MICAFlowEntry.Get(MICAFlow.CreateFlowEntry()) then begin
                        MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StartMsg, StrSubstNo(PaymentJnlTxt, FromPmtGenJournalLine.GetFilter("Journal Batch Name")));
                        XMLFileName := GetFileName(TempPmtGenJournalLine);
                        MICAFlowEntry.Validate(Description, CopyStr(XMLFileName, 1, MaxStrLen(MICAFlowEntry.Description)));
                        Clear(OutStream);
                        Clear(TempBlob);
                        TempBlob.CreateOutStream(OutStream);
                        Clear(XmlMICAARMPpain00100103);
                        XmlMICAARMPpain00100103.SetDestination(OutStream);
                        XmlMICAARMPpain00100103.SetTableView(FromPmtGenJournalLine);
                        if XmlMICAARMPpain00100103.Export() then begin
                            SetPaymentExportedToFile(FromPmtGenJournalLine);
                            MICAFlowEntry.PrepareToSend(TempBlob);
                            Message(StrSubstNo(FlowEntryMsg, MICAFlowEntry.TableCaption(), MICAFlowEntry."Entry No.", MICAFlowEntry.Description));
                        end else
                            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(ExportFailErr, GetLastErrorText()), GetLastErrorCode());
                        MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, EndMsg, StrSubstNo(NoOfLinesExportedMsg, NoOfRecords, PaymentMethod.TableCaption(), PaymentMethod.Code)));
                        MICAFlowInformation.Update('', '');
                    end;
                end;
            until PaymentMethod.Next() = 0;
    end;

    local procedure SetPaymentExportedToFile(var FromPaymentJnlLine: record "Gen. Journal Line")
    var
        WithHoldingTaxPaymentJnlLine: record "Gen. Journal Line";
    begin
        if FromPaymentJnlLine.FindFirst() then begin
            WithHoldingTaxPaymentJnlLine.SetRange("Journal Template Name", FromPaymentJnlLine."Journal Template Name");
            WithHoldingTaxPaymentJnlLine.SetRange("Journal Batch Name", FromPaymentJnlLine."Journal Batch Name");
            WithHoldingTaxPaymentJnlLine.SetRange("Account Type", WithHoldingTaxPaymentJnlLine."Account Type"::"G/L Account");
            repeat
                FromPaymentJnlLine.Validate("Exported to Payment File", True);
                FromPaymentJnlLine.Modify(True);
                WithHoldingTaxPaymentJnlLine.SetRange("Document No.", FromPaymentJnlLine."Document No.");
                WithHoldingTaxPaymentJnlLine.ModifyAll("Exported to Payment File", true, true);
            until FromPaymentJnlLine.Next() = 0;
        end;
    end;

    local procedure CheckFlowParam()
    var
        MICAFlowSetup: record "MICA Flow Setup";
        FlowParamMissingErr: Label 'For %1 %2, %3 ''%4'' is missing.';
        ErrorText: Text;
    begin
        DftPaymentType := CopyStr(MICAFlowSetup.GetFlowTextParam(MICAFlow.Code, 'DFTPMTTYPE'), 1, 20);
        if DftPaymentType = '' then begin
            ErrorText := StrSubstNo(FlowParamMissingErr, MICAFlow.TableName(), MICAFlow.Code, MICAFlowSetup.TableName(), 'DFTPMTTYPE');
            Error(ErrorText);
        end;
        GiroPaymentType := CopyStr(MICAFlowSetup.GetFlowTextParam(MICAFlow.Code, 'GIROPMTTYPE'), 1, 20);
        if GiroPaymentType = '' then begin
            ErrorText := StrSubstNo(FlowParamMissingErr, MICAFlow.TableName(), MICAFlow.Code, MICAFlowSetup.TableName(), 'GIROPMTTYPE');
            Error(ErrorText);
        end;
        IntPaymentType := CopyStr(MICAFlowSetup.GetFlowTextParam(MICAFlow.Code, 'INTERPMTTYPE'), 1, 20);
        if IntPaymentType = '' then begin
            ErrorText := StrSubstNo(FlowParamMissingErr, MICAFlow.TableName(), MICAFlow.Code, MICAFlowSetup.TableName(), 'INTERPMTTYPE');
            Error(ErrorText);
        end;
        MassPmtfileName := MICAFlowSetup.GetFlowTextParam(MICAFlow.Code, 'FILENAME');
        if MassPmtfileName = '' then begin
            ErrorText := StrSubstNo(FlowParamMissingErr, MICAFlow.TableName(), MICAFlow.Code, MICAFlowSetup.TableName(), 'FILENAME');
            Error(ErrorText);
        end;
    end;

    local procedure SetTmpPmtJnlLine(var TmpPmtGenJournalLine: Record "Gen. Journal Line" temporary; var FromPmtGenJournalLine: Record "Gen. Journal Line")
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        LineNo: Integer;
    begin
        TmpPmtGenJournalLine.DeleteAll();
        IF FromPmtGenJournalLine.FindSet() then
            repeat
                TmpPmtGenJournalLine.Init();
                LineNo += 10000;
                TmpPmtGenJournalLine."Line No." := LineNo;
                TmpPmtGenJournalLine."Payment Method Code" := FromPmtGenJournalLine."Payment Method Code";
                TmpPmtGenJournalLine."Account Type" := FromPmtGenJournalLine."Account Type";
                TmpPmtGenJournalLine."Account No." := FromPmtGenJournalLine."Account No.";
                TmpPmtGenJournalLine."Amount (LCY)" := FromPmtGenJournalLine."Amount (LCY)";
                case FromPmtGenJournalLine."Account Type" of
                    FromPmtGenJournalLine."Account Type"::Customer:
                        begin
                            Customer.get(FromPmtGenJournalLine."Account No.");
                            TmpPmtGenJournalLine."Tax Liable" := (Customer."Currency Code" <> ''); // For international payments
                        end;
                    FromPmtGenJournalLine."Account Type"::Vendor:
                        begin
                            Vendor.get(FromPmtGenJournalLine."Account No.");
                            TmpPmtGenJournalLine."Tax Liable" := (Vendor."Currency Code" <> ''); // For international payments
                        end;
                end;
                TmpPmtGenJournalLine.Insert();
            until FromPmtGenJournalLine.Next() = 0;
    end;

    local procedure GetFileName(FromPmtGenJournalLine: Record "Gen. Journal Line"): Text[250];
    var
        CompanyInformation: Record "Company Information";
        FoundPaymentMethod: Record "Payment Method";
        MessageNameFlow: Text[20];
        DateTimeText: Text[20];
        ErrorText: Text[250];
        MsgNameFlowLbl: Label 'DOM-%1', Comment = '%1', Locked = true;
    begin
        CompanyInformation.Get();
        FoundPaymentMethod.get(FromPmtGenJournalLine."Payment Method Code");
        DateTimeText := Format(CurrentDateTime(), 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>');
        if FromPmtGenJournalLine."Tax Liable" then begin
            MessageNameFlow := 'INTL-X';
            ErrorText := StrSubstNo(MassPmtfileName, IntPaymentType, MessageNameFlow, DateTimeText, CompanyInformation."Country/Region Code", MICAFinancialReportingSetup."Company Code");
            exit(ErrorText);
        end else
            case true of
                FromPmtGenJournalLine."Payment Method Code" = MICAFinancialReportingSetup."Dynamic Pay. Mtd. Code Value 1": // GIRO
                    begin
                        MessageNameFlow := CopyStr(StrSubstNo(MsgNameFlowLbl, FoundPaymentMethod."MICA Pmt. Method Filename"), 1, 20);
                        ErrorText := StrSubstNo(MassPmtfileName, GiroPaymentType, MessageNameFlow, DateTimeText, CompanyInformation."Country/Region Code", MICAFinancialReportingSetup."Company Code");
                        exit(ErrorText);
                    end;
                FromPmtGenJournalLine."Payment Method Code" = MICAFinancialReportingSetup."Dynamic Pay. Mtd. Code Value 2": // DFT
                    begin
                        MessageNameFlow := CopyStr(StrSubstNo(MsgNameFlowLbl, FoundPaymentMethod."MICA Pmt. Method Filename"), 1, 20);
                        ErrorText := StrSubstNo(MassPmtfileName, DftPaymentType, MessageNameFlow, DateTimeText, CompanyInformation."Country/Region Code", MICAFinancialReportingSetup."Company Code");
                        exit(ErrorText);
                    end;
            end;
    end;

    local procedure CheckBankAccountSetup(var FromPmtGenJournalLine: record "Gen. Journal Line")
    var
        VendorBankAccount: Record "Vendor Bank Account";
        Employee: Record Employee;
        ToPmtGenJournalLine: record "Gen. Journal Line";
        BankAccTypeNotSetErr: Label '%1 not set for bank acount no. %2 of the vendor no. %3.';
        ErrorText: Text;
    begin
        ToPmtGenJournalLine.CopyFilters(FromPmtGenJournalLine);
        if ToPmtGenJournalLine.FindSet() then
            repeat
                case ToPmtGenJournalLine."Account Type" of
                    ToPmtGenJournalLine."Account Type"::Vendor:
                        begin
                            VendorBankAccount.get(ToPmtGenJournalLine."Account No.", ToPmtGenJournalLine."Recipient Bank Account");
                            if VendorBankAccount."MICA Bank Account Type" = '' then begin
                                ErrorText := StrSubstNo(BankAccTypeNotSetErr, VendorBankAccount.FieldCaption("MICA Bank Account Type"), VendorBankAccount.Code, VendorBankAccount."Vendor No.");
                                Error(ErrorText);
                            end;
                        end;
                    ToPmtGenJournalLine."Account Type"::Employee:
                        begin
                            Employee.get(ToPmtGenJournalLine."Account No.");
                            Employee.TestField("MICA Bank Account Type");
                        end;
                end;
            until ToPmtGenJournalLine.Next() = 0;
    end;

    local procedure CheckVendorSetup(var FromPmtGenJournalLine: record "Gen. Journal Line")
    var
        Vendor: Record "Vendor";
        ToPmtGenJournalLine: record "Gen. Journal Line";
    begin
        ToPmtGenJournalLine.CopyFilters(FromPmtGenJournalLine);
        if ToPmtGenJournalLine.FindSet() then
            repeat
                if ToPmtGenJournalLine."Account Type" = ToPmtGenJournalLine."Account Type"::Vendor then begin
                    Vendor.get(ToPmtGenJournalLine."Account No.");
                    Vendor.TestField("VAT Registration No.");
                end;
            until ToPmtGenJournalLine.Next() = 0;
    end;
}