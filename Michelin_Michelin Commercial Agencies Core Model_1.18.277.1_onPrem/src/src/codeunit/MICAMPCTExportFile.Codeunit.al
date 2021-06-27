codeunit 81550 "MICA MP CT-Export File"
{
    // version MIC01.00.18

    // MIC:EDD029:1:0      21/02/2017 COSMO.CCO
    //   # New codeunit to manage Mass Payment File creation

    Permissions = TableData "Data Exch. Field" = rimd;
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    var
        BankAccount: Record "Bank Account";
        ExpUserFeedbackGenJnl: Codeunit "Exp. User Feedback Gen. Jnl.";
    begin
        Rec.LockTable();
        BankAccount.GET(Rec."Bal. Account No.");
        IF Export(Rec, BankAccount.GetPaymentExportXMLPortID()) THEN
            ExpUserFeedbackGenJnl.SetExportFlagOnGenJnlLine(Rec);
    end;

    var
        ExportToServerFile: Boolean;

    procedure Export(var GenJournalLine: Record "Gen. Journal Line"; XMLPortID: Integer): Boolean
    var
        CreditTransferRegister: Record "Credit Transfer Register";
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        OutStream: OutStream;
        UseCommonDialog: Boolean;
        FileName: Text;
        FileManagementLbl: Label '%1.TXT', Comment = '%1', Locked = true;
    //FinancialReportingSetup: Record 80010;
    //i: Integer;
    begin
        Clear(TempBlob);
        //TempBlob.Init();
        TempBlob.CreateOutStream(OutStream);
        XMLPORT.EXPORT(XMLPortID, OutStream, GenJournalLine);

        CreditTransferRegister.FindLast();
        UseCommonDialog := NOT ExportToServerFile;
        //FinancialReportingSetup.GET;
        //IF FinancialReportingSetup."Mass Payment File Mask" <> '' THEN BEGIN
        //i := STRPOS(FinancialReportingSetup."Mass Payment File Mask",'yyyyMMddHHmmss');
        //IF  i > 0 THEN
        //  FileName := COPYSTR(FinancialReportingSetup."Mass Payment File Mask",1,i - 1) + FORMAT(CURRENTDATETIME,0,'<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>')
        //              + COPYSTR(FinancialReportingSetup."Mass Payment File Mask",i + STRLEN('yyyyMMddHHmmss'))
        //ELSE
        //  FileName := FinancialReportingSetup."Mass Payment File Mask";

        //END ELSE BEGIN
        //  FileName := CreditTransferRegister.Identifier;
        //END;
        IF FileManagement.BLOBExport(TempBlob, STRSUBSTNO(FileManagementLbl, FileName), UseCommonDialog) <> '' THEN
            SetCreditTransferRegisterToFileCreated(CreditTransferRegister, TempBlob);

        EXIT(CreditTransferRegister.Status = CreditTransferRegister.Status::"File Created");
    end;

    local procedure SetCreditTransferRegisterToFileCreated(var CreditTransferRegister: Record "Credit Transfer Register"; var TempBlob: Codeunit "Temp Blob")
    var
        InStream: InStream;
        OutStream: OutStream;
    begin
        CreditTransferRegister.Status := CreditTransferRegister.Status::"File Created";

        CreditTransferRegister."Exported File".CreateOutStream(OutStream);
        TempBlob.CreateInStream(InStream);
        CopyStream(OutStream, InStream);
        //CreditTransferRegister."Exported File" := TempBlob.Blob;
        //CreditTransferRegister."Exported File Name" :=STRSUBSTNO('%1.DAT',FileName) ;
        CreditTransferRegister.Modify();
    end;

    procedure EnableExportToServerFile()
    begin
        ExportToServerFile := TRUE;
    end;
}

