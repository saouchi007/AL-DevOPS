#if OnPremise
dotnet
{
    assembly(DidiSoft.Pgp)
    {
        Type(DidiSoft.Pgp.PGPLib; PgpLib) { }
    }
}
#endif

codeunit 80865 "MICA Encryption Mgt"
{
    procedure EncryptBlob(var FromMICAFlowEntry: Record "MICA Flow Entry"; AsciiArmor: Boolean): Integer
    var
#if OnPremise
        MICAFlow: Record "MICA Flow";
        MICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowInformation: Record "MICA Flow Information";
        MyFile: File;
        PgpLib: DotNet PgpLib;
        InputStream: DotNet Stream;
        OutputStream: DotNet Stream;
        PublicKeyStream: DotNet Stream;
        InStream: InStream;
        KeyInStream: InStream;
        OutStream: OutStream;
        NewEntryNo: Integer;
        ProcessedEntriesCount: Integer;
        EntryCreatedLbl: Label 'Entry %1 created, encrypted from Entry %2.', Comment = '%1 = New Entry No., %2 = Entry to encrypt No';
        EncryptionDisabledLbl: Label 'Encryption disabled in flow %1', Comment = '%1 = Flow code';
        AlreadyEncryptedLbl: Label 'Entry is already encrypted.';
#endif
        NotAvailableOnPremiseErr: Label 'This codeunit can be executed OnPremise only.';
    begin
#if OnPremise

        PgpLib := PgpLib.PGPLib();

        if FromMICAFlowEntry.FindSet() then
            repeat
                if not FromMICAFlowEntry."Use Encryption" then begin
                    FromMICAFlowEntry.TestField("Send Status", FromMICAFlowEntry."Send Status"::Prepared);
                    Clear(MICAFlow);
                    MICAFlow.Get(FromMICAFlowEntry."Flow Code");

                    if MICAFlow."Use Encryption" then begin
                        Clear(MyFile);
                        MyFile.Open(MICAFlow."Public Key Filepath");
                        MyFile.CreateInStream(KeyInStream);

                        FromMICAFlowEntry.CalcFields(FromMICAFlowEntry.Blob);
                        FromMICAFlowEntry.Blob.CreateInStream(InStream);

                        NewEntryNo := MICAFlow.CreateFlowEntry();
                        MICAFlowEntry.Get(NewEntryNo);
                        MICAFlowEntry.Validate(Description, FromMICAFlowEntry.Description + '-Encrypted.pgp');
                        MICAFlowEntry.Validate("Use Encryption", true);
                        MICAFlowEntry.Validate("Source Entry No.", FromMICAFlowEntry."Entry No.");
                        MICAFlowEntry.CalcFields(Blob);
                        MICAFlowEntry."Copied from Entry No." := FromMICAFlowEntry."Entry No.";
                        MICAFlowEntry.Blob.CreateOutStream(OutStream);

                        FromMICAFlowEntry.Validate("Skip this Entry", true);
                        FromMICAFlowEntry.Validate("Use Encryption", true);
                        FromMICAFlowEntry.Modify(false);

                        InputStream := InStream;
                        PublicKeyStream := KeyInStream;
                        OutputStream := OutStream;

                        PgpLib.EncryptStream(InputStream, PublicKeyStream, OutputStream, AsciiArmor);

                        MICAFlowEntry.Validate(Blob);
                        MICAFlowEntry.Validate("Send Status", MICAFlowEntry."Send Status"::Prepared);
                        MICAFlowEntry.Modify(true);
                        MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(EntryCreatedLbl, NewEntryNo, FromMICAFlowEntry."Entry No."), '');
                        MyFile.Close();
                        ProcessedEntriesCount += 1;
                    end else
                        FromMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(EncryptionDisabledLbl, MICAFlow.Code), '');
                end else
                    FromMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, AlreadyEncryptedLbl, '');
            until FromMICAFlowEntry.Next() = 0;
        exit(ProcessedEntriesCount);
#else
        error(NotAvailableOnPremiseErr);
#endif        
    end;
}
