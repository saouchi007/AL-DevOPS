codeunit 82000 "MICA ARSTOCK message to DOO"
{
    //EDD-ITG-008: GIT – ARSTOCK message communication to DOO
    TableNo = "Transfer Receipt Header";

    var
        SentMsg: Label 'ARSTOCK message has been sent to DOO.';
        ConfirmMsg: Label 'Would you like to send ARSTOCK message to DOO ?';

    trigger OnRun()
    begin
        if not Confirm(ConfirmMsg, false) then
            exit;
        SendARSTOCKMessage(Rec);
        message(SentMsg);
    end;

    [EventSubscriber(ObjectType::Codeunit, 5705, 'OnAfterTransferOrderPostReceipt', '', false, false)]
    LOCAL procedure C5705OnAfterTransferOrderPostReceipt(VAR TransferHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean; VAR TransferReceiptHeader: Record "Transfer Receipt Header")
    begin
        if TransferReceiptHeader."MICA ASN No." <> '' then
            SendARSTOCKMessage(TransferReceiptHeader);
    end;

    procedure SendARSTOCKMessage(TransferReceiptHeader: Record "Transfer Receipt Header")
    begin
        with TransferReceiptHeader do begin
            TestField("MICA ASN No.");
            TestField("MICA ARSTOCK Integrated", false);

            //Send ARSTOCK message

            "MICA ARSTOCK Integrated" := true;
            Modify();
        end;
    end;

}