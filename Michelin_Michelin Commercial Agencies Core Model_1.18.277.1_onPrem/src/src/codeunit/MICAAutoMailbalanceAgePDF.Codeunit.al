codeunit 80840 "MICA Auto Mail balance Age PDF"
{

    trigger OnRun()
    var
        Customer: Record Customer;
        WorkCustomer: Record Customer;
    begin
        Customer.SetFilter("Balance (LCY)", '<>%1', 0);
        Customer.SetRange("MICA Dont send balance aged", false);
        if Customer.FindSet() then
            repeat
                WorkCustomer.Get(Customer."No.");
                WorkCustomer.SetRange("No.", Customer."No.");
                if EmailBalanceAgedAsPDF(WorkCustomer) then;
            until Customer.Next() = 0;
    end;

    [TryFunction]
    procedure EmailBalanceAgedAsPDF(var Customer: Record "Customer");
    var
        CompanyInformation: Record "Company Information";
        Contact: Record Contact;
        AttachmentTempBlob: Codeunit "Temp Blob";
        EmailSubject: Text;
        AttachmentName: Text;
        ToAddress: Text;
        OutStream: OutStream;
        InStream: InStream;
    begin
        if Customer."E-Mail" = '' then begin
            if Contact.Get(Customer."Primary Contact No.") then
                ToAddress := Contact."E-Mail";
        end else
            ToAddress := Customer."E-Mail";
        CompanyInformation.Get();
        EmailSubject := StrSubstNo(TxtEmailBalanceAgedSubjectTxt, CustomerDetailedAgingTxt, WorkDate());
        AttachmentName := StrSubstNo(TxtAttachmentNameBalanceAgedTxt, Customer."No.");
        DoEmailBalanceAgeWithPDF(Customer, EmailSubject, AttachmentName, ToAddress, AttachmentTempBlob);
        Customer.Validate("MICA Last Balance Aged Sent", WorkDate());
        AttachmentTempBlob.CreateInStream(InStream);
        Customer."MICA Last Balance Aged Blob".CreateOutStream(OutStream);
        CopyStream(OutStream, InStream);
        //Cust.Validate("MICA Last Balance Aged Blob", TempBlobAttachment.Blob);
        Customer.Modify();
        Commit();
    end;

    local procedure DoEmailBalanceAgeWithPDF(Customer: Record Customer; EmailSubject: Text; AttachmentName: Text; ToAddress: Text; var AttachmentTempBlob: Codeunit "Temp Blob")
    var
        CompanyInformation: Record "Company Information";
        SMTPMailSetup: Record "SMTP Mail Setup";
        SMTPMail: Codeunit "SMTP Mail";
        VarInStream: InStream;
        ToAddressList: List of [Text];
    begin
        CompanyInformation.Get();
        SMTPMailSetup.Get();

        ToAddressList.Add(ToAddress);
        if SMTPMailSetup."MICA Default From Email Addr." = '' then
            SMTPMail.CreateMessage(CompanyInformation.Name, SMTPMailSetup."User ID", ToAddressList, EmailSubject, MessageContentTxt, true)
        else
            SMTPMail.CreateMessage(CompanyInformation.Name, SMTPMailSetup."MICA Default From Email Addr.", ToAddressList, EmailSubject, MessageContentTxt, true);

        SaveDocumentAsPDFToStream(Customer, AttachmentTempBlob);
        AttachmentTempBlob.CreateInStream(VarInStream);
        SMTPMail.AddAttachmentStream(VarInStream, AttachmentName);

        SMTPMail.Send();
    end;

    local procedure SaveDocumentAsPDFToStream(DocumentVariantCustomer: Record Customer; var TempBlob: Codeunit "Temp Blob"): Boolean;
    var
        Customer: Record Customer;
        CustomerDetailedAging: Report "Customer Detailed Aging";
        VarOutStream: OutStream;
    begin
        TempBlob.CreateOutStream(VarOutStream);
        CustomerDetailedAging.InitializeRequest(WorkDate(), true);
        Customer.SetRange("No.", DocumentVariantCustomer."No.");
        CustomerDetailedAging.SetTableView(Customer);
        if CustomerDetailedAging.SaveAs('', ReportFormat::Pdf, VarOutStream) then
            exit(true)
        else
            Error(TxtCouldNotSaveReportErr, Report::"Customer Detailed Aging");
    end;

    var
        TxtEmailBalanceAgedSubjectTxt: Label '%1 - %2';
        TxtAttachmentNameBalanceAgedTxt: Label 'Customer Detailed Aging - %1.pdf';
        TxtCouldNotSaveReportErr: Label 'Could not save report, Report Id %1.';
        CustomerDetailedAgingTxt: Label 'Customer Detailed Aging at';
        MessageContentTxt: Label 'Please find attached the Customer Detailed Aging';
}