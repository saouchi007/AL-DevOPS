codeunit 81824 "MICA Whse. Email After Post"
{
    Permissions = tabledata "Sales Invoice Header" = rm, tabledata "Sales Shipment Header" = rm;

    var
        Location: Record Location;
        ToSendSalesShipmentHeader: Record "Sales Shipment Header";
        ReportSelections: Record "Report Selections";
        CompanyInformation: Record "Company Information";
        SMTPMailSetup: Record "SMTP Mail Setup";
        SMTPMail: Codeunit "SMTP Mail";
        WhseShptHeaderNo: Code[20];
        ManualProcessToManageErrors: Boolean;
        CustomerName: Text;
        EmailSubject: text;
        EmailBody: Text;
        RecipientEmail: Text;

    trigger OnRun()
    begin
        SendSalesDocToWhseByEmail();
    end;

    local procedure SendSalesDocToWhseByEmail()
    var
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        ToUpdateSalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceNo: code[20];
        ErrorMessage: Text[250];
        RecipientNotSetOnLocationErr: Label '%1 is empty on %2 %3';
        SendManuallyWithForceMsg: Label 'Send manually / Force email sending.';
    begin
        if not CompanyInformation.Get() then
            exit;

        if not SMTPMailSetup.Get() then
            exit;

        PostedWhseShipmentLine.SetCurrentKey("Posted Source No.", "Posting Date");

        with ToSendSalesShipmentHeader do begin
            SetCurrentKey("MICA Stat./Send. S. Doc./Whse.");
            if ManualProcessToManageErrors then
                SetRange("MICA Stat./Send. S. Doc./Whse.", "MICA Stat./Send. S. Doc./Whse."::"In error")
            else
                SetRange("MICA Stat./Send. S. Doc./Whse.", "MICA Stat./Send. S. Doc./Whse."::"To send");
            if FindSet(false, false) then
                repeat
                    // Get Sales Invoice No. (if necessary)
                    if "MICA S.Doc. Type to Send/Whse." in ["MICA S.Doc. Type to Send/Whse."::"Invoice only", "MICA S.Doc. Type to Send/Whse."::"Shipment and Invoice"] then
                        SalesInvoiceNo := GetInvoiceNoFromSalesShpt("No.")
                    else
                        SalesInvoiceNo := '';
                    // Get Warehouse Shipment No.
                    WhseShptHeaderNo := '';
                    PostedWhseShipmentLine.SetRange("Posted Source No.", "No.");
                    PostedWhseShipmentLine.SetRange("Posting Date", "Posting Date");
                    if PostedWhseShipmentLine.FindFirst() then
                        WhseShptHeaderNo := PostedWhseShipmentLine."Whse. Shipment No.";
                    Location.Get(GetFirstLocationFromFromSalesShptLine("No."));
                    RecipientEmail := Location."MICA 3PL E-Mail for Sales Docs";
                    // Send email
                    if RecipientEmail = '' then
                        ErrorMessage := CopyStr(StrSubstNo(RecipientNotSetOnLocationErr, Location.FieldCaption("MICA 3PL E-Mail for Sales Docs"), Location.TableCaption(), Location.Code), 1, 250)
                    else
                        ErrorMessage := SendEmailTo3PL("MICA S.Doc. Type to Send/Whse.", "No.", SalesInvoiceNo, "Order No.");
                    // Set status on shipment header
                    ToUpdateSalesShipmentHeader.get("No.");
                    ToUpdateSalesShipmentHeader."MICA User Email to Whse. St." := CopyStr(UserId(), 1, 50);
                    ToUpdateSalesShipmentHeader."MICA DT Email to Whse. Status" := CurrentDateTime();
                    if ErrorMessage = '' then begin
                        ToUpdateSalesShipmentHeader."MICA Stat./Send. S. Doc./Whse." := ToUpdateSalesShipmentHeader."MICA Stat./Send. S. Doc./Whse."::Sent;
                        if ManualProcessToManageErrors then
                            ToUpdateSalesShipmentHeader."MICA Send. S. Doc./Whse. Text" := SendManuallyWithForceMsg
                        else
                            ToUpdateSalesShipmentHeader."MICA Send. S. Doc./Whse. Text" := Format(ToUpdateSalesShipmentHeader."MICA Stat./Send. S. Doc./Whse.");
                    end else begin
                        ToUpdateSalesShipmentHeader."MICA Stat./Send. S. Doc./Whse." := ToUpdateSalesShipmentHeader."MICA Stat./Send. S. Doc./Whse."::"In error";
                        ToUpdateSalesShipmentHeader."MICA Send. S. Doc./Whse. Text" := ErrorMessage;
                    end;
                    ToUpdateSalesShipmentHeader.Modify(false);
                until Next() = 0;
        end;
    end;

    local procedure GetFirstLocationFromFromSalesShptLine(FromSalesShptNo: Code[20]): Code[20]
    var
        SalesShipmentLine: Record "Sales Shipment Line";
    begin
        SalesShipmentLine.SetRange("Document No.", FromSalesShptNo);
        SalesShipmentLine.SetFilter("Location Code", '<>%1', '');
        if not SalesShipmentLine.FindFirst() then
            exit('')
        else
            exit(SalesShipmentLine."Location Code");
    end;

    local procedure GetInvoiceNoFromSalesShpt(FromSalesShptNo: Code[20]): code[20]
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
    begin
        ItemLedgerEntry.SetCurrentKey("Document No.");
        ItemLedgerEntry.SetRange("Document No.", FromSalesShptNo);
        ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
        ItemLedgerEntry.SetFilter("Invoiced Quantity", '<>0');
        if ItemLedgerEntry.FindFirst() then begin
            ValueEntry.SetCurrentKey("Item Ledger Entry No.", "Entry Type");
            ValueEntry.SetRange("Entry Type", ValueEntry."Entry Type"::"Direct Cost");
            ValueEntry.SetFilter("Invoiced Quantity", '<>0');
            ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
            ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
            if ValueEntry.FindFirst() then
                exit(ValueEntry."Document No.");
        end;
    end;

    procedure SetSendSalesDocToWhseByEmail(var FromSalesHeader: Record "Sales Header"; FromSalesShptHdrNo: Code[20])
    var
        ToSalesShipmentHeader: Record "Sales Shipment Header";
    begin
        if not (FromSalesHeader."Document Type" = FromSalesHeader."Document Type"::Order) then
            exit;
        if FromSalesShptHdrNo = '' then
            exit;
        if not ToSalesShipmentHeader.Get(FromSalesShptHdrNo) then
            exit;
        if not Location.Get(ToSalesShipmentHeader."Location Code") then
            exit;
        if Location."MICA 3PL E-Mail for Sales Docs" = '' then
            exit;
        if not Location."MICA 3PL Email Pstd. Shpt." and not Location."MICA 3PL Email Pstd. Inv." then
            exit;

        with ToSalesShipmentHeader do begin
            "MICA Stat./Send. S. Doc./Whse." := "MICA Stat./Send. S. Doc./Whse."::"To send";
            case true of
                Location."MICA 3PL Email Pstd. Shpt." and not Location."MICA 3PL Email Pstd. Inv.":
                    "MICA S.Doc. Type to Send/Whse." := "MICA S.Doc. Type to Send/Whse."::"Shipment only";
                Location."MICA 3PL Email Pstd. Inv." and not Location."MICA 3PL Email Pstd. Shpt.":
                    "MICA S.Doc. Type to Send/Whse." := "MICA S.Doc. Type to Send/Whse."::"Invoice only";
                Location."MICA 3PL Email Pstd. Inv." and Location."MICA 3PL Email Pstd. Shpt.":
                    "MICA S.Doc. Type to Send/Whse." := "MICA S.Doc. Type to Send/Whse."::"Shipment and Invoice";
            end;
            Modify(false);
        end;
    end;

    local procedure SendEmailTo3PL(DocToSend: Option; FromSalesShptNo: Code[20]; FromSalesInvNo: Code[20]; FromSalesOrderNo: code[20]): Text[250]
    var
        ShptTempBlob: Codeunit "Temp Blob";
        InvTempBlob: Codeunit "Temp Blob";
        MICAIntegrationMgmt: Codeunit "MICA Integration Mgmt";
        RecipientEmailList: List of [Text];
        InStream: InStream;
        IsMailCreated: Boolean;
        SendShptByMail: Boolean;
        SendInvByMail: Boolean;
        ShptFileName: Text;
        InvFileName: Text;
        CannotSplitMailsLbl: Label 'Passed emails are not valid';
        CannotCreateTheFileErr: Label 'PDF file(s) cannot be created for posted sales shipment no. %1';
        EmailSentErrLbl: label 'The email to warehouse %1 cannot be sent with the related document(s)';
    begin
        IsMailCreated := false;
        // DocToSend = "","Shipment only","Invoice only","Shipment and Invoice"
        if DocToSend in [1, 3] then // DocToSend = "Shipment only" OR "Shipment and Invoice"
            SendShptByMail := CreateShptHdrPdfFile(ShptTempBlob, ShptFileName, FromSalesShptNo);

        if (DocToSend in [2, 3]) and (FromSalesInvNo <> '') then // DocToSend = "Invoice only" OR "Shipment and Invoice"
            SendInvByMail := CreateInvHdrPdfFile(InvTempBlob, InvFileName, FromSalesInvNo);

        if not SendShptByMail and not SendInvByMail then
            exit(StrSubstNo(CannotCreateTheFileErr, FromSalesShptNo));

        BuildEmailSubjectAndBody(FromSalesInvNo, SendInvByMail, FromSalesOrderNo);

        if not MICAIntegrationMgmt.SplitEmailToRecipient(RecipientEmail, RecipientEmailList) then
            exit(CannotSplitMailsLbl);

        if SendShptByMail then begin
            if not IsMailCreated then begin
                if SMTPMailSetup."MICA Default From Email Addr." = '' then
                    SMTPMail.CreateMessage(CompanyInformation.Name, SMTPMailSetup."User ID", RecipientEmailList, EmailSubject, EmailBody, true)
                else
                    SMTPMail.CreateMessage(CompanyInformation.Name, SMTPMailSetup."MICA Default From Email Addr.", RecipientEmailList, EmailSubject, EmailBody, true);
                IsMailCreated := true;
            end;
            Clear(InStream);
            ShptTempBlob.CreateInStream(InStream);
            SMTPMail.AddAttachmentStream(InStream, ShptFileName);
        end;
        // Clear(RecipientEmailList);
        if SendInvByMail then begin
            if not IsMailCreated then begin
                if SMTPMailSetup."MICA Default From Email Addr." = '' then
                    SMTPMail.CreateMessage(CompanyInformation.Name, SMTPMailSetup."User ID", RecipientEmailList, EmailSubject, EmailBody, true)
                else
                    SMTPMail.CreateMessage(CompanyInformation.Name, SMTPMailSetup."MICA Default From Email Addr.", RecipientEmailList, EmailSubject, EmailBody, true);
                IsMailCreated := true;
            end;
            Clear(InStream);
            InvTempBlob.CreateInStream(InStream);
            SMTPMail.AddAttachmentStream(InStream, InvFileName);
        end;

        if TrySendMail(SMTPMail) then
            exit('')
        else
            if not GuiAllowed() then
                exit(CopyStr(GetLastErrorText(), 1, 250))
            else
                exit(StrSubstNo(EmailSentErrLbl, Location.Code));
    end;

    local procedure CreateShptHdrPdfFile(var ToShptTempBlob: Codeunit "Temp Blob"; var ToAttachmentFileName: Text; FromSalesShptNo: Code[20]): Boolean
    var
        FoundSalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        ShptRecordRef: RecordRef;
        ShptPdfFileNameLbl: label 'Shipment no. %1 - Order no. %2 (%3).pdf';
        OutStream: OutStream;
    begin

        if FromSalesShptNo = '' then
            exit(false);

        SalesShipmentLine.SetRange("Document No.", FromSalesShptNo);
        SalesShipmentLine.SetFilter("Location Code", '<>%1', '');
        if SalesShipmentLine.IsEmpty then
            exit(false);

        FoundSalesShipmentHeader.SetRange("No.", FromSalesShptNo);
        if not FoundSalesShipmentHeader.FindFirst() then
            exit(false);
        ShptRecordRef.GetTable(FoundSalesShipmentHeader);

        ReportSelections.FilterPrintUsage(ReportSelections.Usage::"S.Shipment".AsInteger());
        ReportSelections.SetRange("Use for Email Attachment", true);
        if ReportSelections.FindFirst() then begin
            ToAttachmentFileName := StrSubstNo(ShptPdfFileNameLbl, FromSalesShptNo, FoundSalesShipmentHeader."Order No.", FoundSalesShipmentHeader."Sell-to Customer Name");
            AddWhseShptNoInFileName(ToAttachmentFileName);
            Clear(ToShptTempBlob);
            ToShptTempBlob.CreateOutStream(OutStream, TextEncoding::UTF16);
            if Report.SaveAs(ReportSelections."Report ID", '', ReportFormat::Pdf, OutStream, ShptRecordRef) then
                exit(true)
            else
                exit(false);
        end;
    end;

    local procedure CreateInvHdrPdfFile(var ToInvTempBlob: Codeunit "Temp Blob"; var ToAttachmentFileName: Text; FromSalesInvNo: Code[20]): Boolean
    var
        FoundSalesInvoiceHeader: Record "Sales Invoice Header";
        InvRecordRef: RecordRef;
        InvPdfFileNameLbl: label 'Invoice no. %1 - Order no. %2 (%3).pdf';
        OutStream: OutStream;
    begin
        if FromSalesInvNo = '' then
            exit(false);

        FoundSalesInvoiceHeader.SetRange("No.", FromSalesInvNo);
        if not FoundSalesInvoiceHeader.FindFirst() then
            exit(false);
        InvRecordRef.GetTable(FoundSalesInvoiceHeader);

        ReportSelections.FilterPrintUsage(ReportSelections.Usage::"S.Invoice".AsInteger());
        ReportSelections.SetRange("Use for Email Attachment", true);
        if ReportSelections.FindFirst() then begin
            ToAttachmentFileName := StrSubstNo(InvPdfFileNameLbl, FromSalesInvNo, FoundSalesInvoiceHeader."Order No.", FoundSalesInvoiceHeader."Sell-to Customer Name");
            AddWhseShptNoInFileName(ToAttachmentFileName);
            Clear(ToInvTempBlob);
            ToInvTempBlob.CreateOutStream(OutStream, TextEncoding::UTF16);
            if Report.SaveAs(ReportSelections."Report ID", '', ReportFormat::Pdf, OutStream, InvRecordRef) then
                exit(true)
            else
                exit(false);
        end;
    end;

    local procedure BuildEmailSubjectAndBody(FromInvHeaderNo: code[20]; FromSendInvByMail: Boolean; FromSalesOrderNo: Code[20])
    var
        WhseShipmentTxt: Text;
        SalesOrderTxt: Text;
        SalesInvoiceTxt: Text;
        EmailSubjectLbl: label '%1 : %2 %3';
        WhseShipmentLbl: label 'Warehouse shipment no. %1 - ';
        SalesInvoiceLbl: label '- Invoice no. %1';
        SalesOrderLbl: label 'Order no. %1';
        Body1Lbl: label '<p>Hello,</p><p>Please find attached the document(s) related to the order no. %1.</p>';
        Body2Lbl: Label '<p>Kind regards,</p><p>%1.</p>';
        Body3Lbl: Label '<p><strong>PS: This message has been automatically sent by ERP system.</strong></p>';
    begin
        if WhseShptHeaderNo <> '' then
            WhseShipmentTxt := StrSubstNo(WhseShipmentLbl, WhseShptHeaderNo);

        if (FromInvHeaderNo <> '') and FromSendInvByMail then
            SalesInvoiceTxt := StrSubstNo(SalesInvoiceLbl, FromInvHeaderNo);

        SalesOrderTxt := StrSubstNo(SalesOrderLbl, FromSalesOrderNo);

        EmailSubject := strsubstno(EmailSubjectLbl, CompanyInformation.Name, WhseShipmentTxt, SalesOrderTxt);
        if SalesInvoiceTxt <> '' then
            EmailSubject += SalesInvoiceTxt;

        EmailSubject += ' - ' + CustomerName;

        EmailBody := StrSubstNo(Body1Lbl, FromSalesOrderNo);
        EmailBody += StrSubstNo(Body2Lbl, CompanyInformation.Name);
        EmailBody += Body3Lbl;
    end;

    local procedure AddWhseShptNoInFileName(var AttachmentPdfName: Text)
    var
        NewAttachmentNameLbl: label 'Warehouse shipment No. %1 - %2';
    begin
        if WhseShptHeaderNo <> '' then
            AttachmentPdfName := StrSubstNo(NewAttachmentNameLbl, WhseShptHeaderNo, AttachmentPdfName);
    end;

    [TryFunction]
    local procedure TrySendMail(LocSMTPMail: Codeunit "SMTP Mail")
    begin
        LocSMTPMail.Send();
    end;

    procedure SetSpecificFiltersOnSalesShptHdrToForceSending(var FromSalesShipmentHeader: Record "Sales Shipment Header")
    begin
        ManualProcessToManageErrors := true;
        // SalesShptHdrToSend.CopyFilters(FromSalesShptHdr);
        ToSendSalesShipmentHeader.Copy(FromSalesShipmentHeader);
    end;

    procedure CancelEmailSendingToWarehouse(var FromSalesShipmentHeader: Record "Sales Shipment Header")
    var
        ToSalesShipmentHeader: Record "Sales Shipment Header";
        NoOfRecords: Integer;
        NoOfRecordsUpdatedMsg: label 'Email sending canceled for %1 %2.';
        NothingToUpdateMsg: label 'No %1 to update with status %2';
    begin
        FromSalesShipmentHeader.SetRange("MICA Stat./Send. S. Doc./Whse.", FromSalesShipmentHeader."MICA Stat./Send. S. Doc./Whse."::"In error");
        with ToSalesShipmentHeader do begin
            Copy(FromSalesShipmentHeader);
            SetCurrentKey("MICA Stat./Send. S. Doc./Whse.");
            if FindFirst() then begin
                NoOfRecords := Count();
                repeat
                    "MICA Stat./Send. S. Doc./Whse." := "MICA Stat./Send. S. Doc./Whse."::Canceled;
                    "MICA Send. S. Doc./Whse. Text" := Format("MICA Stat./Send. S. Doc./Whse.");
                    "MICA User Email to Whse. St." := CopyStr(UserId(), 1, 50);
                    Modify(false);
                until Next() = 0;
                FromSalesShipmentHeader.SetRange("MICA Stat./Send. S. Doc./Whse.");
                Message(StrSubstNo(NoOfRecordsUpdatedMsg, NoOfRecords, FromSalesShipmentHeader.TableCaption()));
            end else
                Message(StrSubstNo(NothingToUpdateMsg, FromSalesShipmentHeader.TableCaption(), "MICA Stat./Send. S. Doc./Whse."::Canceled));
        end;
    end;
}