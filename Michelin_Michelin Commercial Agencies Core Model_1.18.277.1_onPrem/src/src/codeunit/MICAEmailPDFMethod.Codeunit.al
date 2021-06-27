codeunit 80781 "MICA Email PDF Method"
{
    procedure EmailInvoiceAsPDF(var SalesInvoiceHeader: Record "Sales Invoice Header"): Boolean
    var
        CompanyInformation: Record "Company Information";
        Customer: Record Customer;
        DocumentSendingProfile: Record "Document Sending Profile";
        Contact: Record Contact;
        ReportSelections: Record "Report Selections";
        EmailSubject: Text;
        AttachmentName: Text;
        ToAddress: Text;
    begin
        Customer.Get(SalesInvoiceHeader."Bill-to Customer No.");
        if DocumentSendingProfile.Get(Customer."Document Sending Profile") then
            if not DocumentSendingProfile."MICA Daily Sent" then
                exit(false);
        if Customer."E-Mail" = '' then begin
            if Contact.Get(Customer."Primary Contact No.") then
                ToAddress := Contact."E-Mail";
        end else
            ToAddress := Customer."E-Mail";
        CompanyInformation.Get();
        EmailSubject := StrSubstNo(TxtEmailSubjectInvoiceTxt, CompanyInformation.Name, SalesInvoiceHeader."No.");
        AttachmentName := StrSubstNo(TxtAttachmentNameInvoiceTxt, SalesInvoiceHeader."No.");
        exit(DoEmailWithPDF(SalesInvoiceHeader, EmailSubject, AttachmentName, ToAddress, SalesInvoiceHeader."Sell-to Customer No.", ReportSelections.Usage::"S.Invoice".AsInteger()));
    end;

    procedure EmailSalesCreditMemosAsPDF(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"): Boolean
    var
        CompanyInformation: Record "Company Information";
        Customer: Record Customer;
        DocumentSendingProfile: Record "Document Sending Profile";
        Contact: Record Contact;
        ReportSelections: Record "Report Selections";
        EmailSubject: Text;
        AttachmentName: Text;
        ToAddress: Text;
    begin
        Customer.Get(SalesCrMemoHeader."Bill-to Customer No.");
        if DocumentSendingProfile.Get(Customer."Document Sending Profile") then
            if not DocumentSendingProfile."MICA Daily Sent" then
                exit(false);
        if Customer."E-Mail" = '' then begin
            if Contact.Get(Customer."Primary Contact No.") then
                ToAddress := Contact."E-Mail";
        end else
            ToAddress := Customer."E-Mail";
        CompanyInformation.Get();
        EmailSubject := StrSubstNo(TxtEmailSubjectSalesCreditMemoTxt, CompanyInformation.Name, SalesCrMemoHeader."No.");
        AttachmentName := StrSubstNo(TxtAttachmentNameSalesCreditMemoTxt, SalesCrMemoHeader."No.");
        exit(DoEmailWithPDF(SalesCrMemoHeader, EmailSubject, AttachmentName, ToAddress, SalesCrMemoHeader."Sell-to Customer No.", ReportSelections.Usage::"S.Cr.Memo".AsInteger()));
    end;

    local procedure DoEmailWithPDF(RecordVariant: Variant; EmailSubject: Text; AttachmentName: Text; ToAddress: Text; CustNo: Code[20]; Usage: Integer): Boolean;
    var
        CompanyInformation: Record "Company Information";
        SMTPMailSetup: Record "SMTP Mail Setup";
        HtmlTempBlob: Codeunit "Temp Blob";
        AttachmentTempBlob: Codeunit "Temp Blob";
        SMTPMail: Codeunit "SMTP Mail";
        VarInStream: InStream;
        ToAddressList: List of [Text];
    begin
        CompanyInformation.Get();
        SMTPMailSetup.Get();

        if GetEmailBodyCustomText(CustNo, HtmlTempBlob, RecordVariant, Usage) then begin

            ToAddressList.Add(ToAddress);
            if SMTPMailSetup."MICA Default From Email Addr." = '' then
                SMTPMail.CreateMessage(CompanyInformation.Name, SMTPMailSetup."User ID", ToAddressList, EmailSubject, GetBlobValue(HtmlTempBlob), true)
            else
                SMTPMail.CreateMessage(CompanyInformation.Name, SMTPMailSetup."MICA Default From Email Addr.", ToAddressList, EmailSubject, GetBlobValue(HtmlTempBlob), true);

            SaveDocumentAsPDFToStream(RecordVariant, AttachmentTempBlob, Usage);
            AttachmentTempBlob.CreateInStream(VarInStream);
            SMTPMail.AddAttachmentStream(VarInStream, AttachmentName);

            exit(TrySendMail(SMTPMail));
        end else
            exit(false);
    end;

    [TryFunction]
    local procedure TrySendMail(SMTPMail: Codeunit "SMTP Mail")
    begin
        SMTPMail.Send();
    end;

    local procedure SaveDocumentAsPDFToStream(DocumentVariant: Variant; var TempBlob: Codeunit "Temp Blob"; Usage: Integer): Boolean;
    var
        DataTypeManagement: Codeunit "Data Type Management";
        DocumentRecordRef: RecordRef;
        ReportID: Integer;
        VarOutStream: OutStream;
    begin
        ReportID := GetDocumentReportID(DocumentVariant, Usage);
        DataTypeManagement.GetRecordRef(DocumentVariant, DocumentRecordRef);

        TempBlob.CreateOutStream(VarOutStream);

        if Report.SaveAs(ReportID, '', ReportFormat::Pdf, VarOutStream, DocumentRecordRef) then
            //if Report.SaveAs(ReportID, '', ReportFormat::Pdf, VarOutStream, DocumentRef) then
            exit(true)
        else
            exit(false);
        //Error(TxtCouldNotSaveReportErr, ReportID);
    end;

    local procedure GetDocumentReportID(DocumentVariant: Variant; Usage: Integer): Integer;
    var
        ReportSelections: Record "Report Selections";
        DataTypeManagement: Codeunit "Data Type Management";
        DocumentRecordRef: RecordRef;
    begin
        DataTypeManagement.GetRecordRef(DocumentVariant, DocumentRecordRef);
        ReportSelections.SetRange(Usage, Usage);
        if ReportSelections.FindFirst() then
            exit(ReportSelections."Report ID");

    end;

    local procedure GetEmailBodyCustomText(CustNo: Code[20]; var TempBlob: Codeunit "Temp Blob"; DocumentVariant: Variant; Usage: Integer): Boolean
    var
        ReportSelections: Record "Report Selections";
        TempReportSelections: Record "Report Selections" temporary;
        CustomReportLayout: Record "Custom Report Layout";
        ReportLayoutSelection: Record "Report Layout Selection";
        DataTypeManagement: Codeunit "Data Type Management";
        DocumentRecordRef: RecordRef;
        VarOutStream: OutStream;
    begin
        DataTypeManagement.GetRecordRef(DocumentVariant, DocumentRecordRef);
        if not ReportSelections.FindEmailBodyUsage(Usage, CustNo, TempReportSelections) then
            exit(false);
        DataTypeManagement.GetRecordRef(DocumentVariant, DocumentRecordRef);
        if CustomReportLayout.Get(TempReportSelections."Email Body Layout Code") then begin
            TempBlob.CreateOutStream(VarOutStream);
            ReportLayoutSelection.SetTempLayoutSelected(TempReportSelections."Email Body Layout Code");
            if Report.SaveAs(CustomReportLayout."Report ID", '', ReportFormat::Html, VarOutStream, DocumentRecordRef) then begin
                ReportLayoutSelection.SetTempLayoutSelected('');
                exit(true);
            end
            else
                exit(false);
            //RptLayoutSelctn.SetTempLayoutSelected('');
        end;
    end;

    local procedure GetBlobValue(TempBlob: Codeunit "Temp Blob"): Text
    var
        Result: Text;
        CR: Text[1];
        InStream: InStream;
    begin
        IF NOT TempBlob.HasValue() THEN
            EXIT('');

        CR[1] := 10;
        TempBlob.CreateInStream(InStream, TextEncoding::Windows);
        InStream.Read(Result);
        EXIT(Result);
    end;

    var
        TxtEmailSubjectInvoiceTxt: Label '%1 - Invoice - %2';
        TxtAttachmentNameInvoiceTxt: Label 'Invoice - %1.pdf';
        TxtEmailSubjectSalesCreditMemoTxt: Label '%1 - Credit Memo - %2';
        TxtAttachmentNameSalesCreditMemoTxt: Label 'Credit Memo - %1.pdf';
    //TxtCouldNotSaveReportErr: Label 'Could not save report, Report Id %1.';
}