/// <summary>
/// Codeunit ISA_StampDutyProcessor (ID 50230).
/// </summary>
codeunit 50106 ISA_StampDutyProcessor
{
    //Permissions = tabledata "Sales Header" = RIMD;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostGLAndCustomer', '', false, false)]
    local procedure CreateandPostStampDuty(var SalesHeader: Record "Sales Header"; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[35]; var SrcCode: Code[10]; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
        PostingDutyEntries(SalesHeader, GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, GenJnlPostLine);
    end;
    /*
        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterInsertInvoiceHeader', '', false, false)]
        local procedure TransferStampDuty(var SalesHeader: Record "Sales Header"; var SalesInvHeader: Record "Sales Invoice Header")
        begin
            InsertInvoiceHeaderWithDuty(SalesHeader, SalesInvHeader);
        end;
    */
    local procedure PostingDutyEntries(SalesHeader: Record "Sales Header"; DocNo: Code[20]; ExtDocNo: Code[35]; SourceCode: Code[10]; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        //PostCustomerEntry in post sales
        GenJnlLine: Record "Gen. Journal Line";
        SalesAndRec: Record "Sales & Receivables Setup";
        SalesLine: Record "Sales Line";
    begin
        SalesAndRec.Get();
        if SalesHeader."Payment Method Code" = 'COD' then begin

            with GenJnlLine do begin
                InitNewLine(
                  SalesHeader."Posting Date", SalesHeader."Document Date", SalesHeader."Posting Description",
                  SalesHeader."Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 2 Code",
                  SalesHeader."Dimension Set ID", SalesHeader."Reason Code");

                CopyDocumentFields("Gen. Journal Document Type"::" ", DocNo, ExtDocNo, SourceCode, '');
                "Account Type" := "Account Type"::Customer;
                "Account No." := SalesHeader."Bill-to Customer No.";
                CopyFromSalesHeader(SalesHeader);
                Amount := SalesHeader.ISA_StampDuty; //-5000; //SalesLine.ISA_StampDuty;
                Description := SalesHeader."Bill-to Name" + ' - ' + SalesHeader."No." + ' - Droit de timbre';
                GenJnlPostLine.RunWithCheck(GenJnlLine);

                InitNewLine(
             SalesHeader."Posting Date", SalesHeader."Document Date", SalesHeader."Posting Description",
             SalesHeader."Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 2 Code",
             SalesHeader."Dimension Set ID", SalesHeader."Reason Code");

                CopyDocumentFields("Gen. Journal Document Type"::" ", DocNo, ExtDocNo, SourceCode, '');
                "Account Type" := "Account Type"::"G/L Account";
                "Account No." := SalesAndRec.ISA_StampDuty_GLA; //; '6110';
                CopyFromSalesHeader(SalesHeader);
                Amount := SalesHeader.ISA_StampDuty * -1; //5000; //SalesLine.ISA_StampDuty;
                Description := SalesHeader."Bill-to Name" + ' - ' + SalesHeader."No." + ' - Droit de timbre';
                GenJnlPostLine.RunWithCheck(GenJnlLine);
            end;

        end;
    end;

    local procedure InsertInvoiceHeaderWithDuty(var SalesHeaderDT: Record "Sales Header"; var SalesInvHeader: Record "Sales Invoice Header")
    // InsertInvoiceHeader in post sales
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        with SalesHeaderDT do begin
            SalesInvHeader.Init();
            CalcFields("Work Description");
            SalesInvHeader."No." := "Posting No.";

            if "Document Type" = "Document Type"::Order then begin
                SalesInvHeader."Pre-Assigned No. Series" := '';
                SalesInvHeader."Order No. Series" := "No. Series";
                SalesInvHeader."Order No." := "No.";
                //SalesInvHeader.ISA_StampDuty := 666; //SalesHeaderDT.ISA_StampDuty;
            end else begin
                if "Posting No." = '' then
                    SalesInvHeader."No." := "No.";
                SalesInvHeader."Pre-Assigned No. Series" := "No. Series";
                SalesInvHeader."Pre-Assigned No." := "No.";
            end;

            SalesInvHeader.TransferFields(SalesHeaderDT);
        end;
    end;
}