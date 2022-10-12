/// <summary>
/// Codeunit ISA_ToolBox (ID 50301).
/// </summary>
codeunit 50302 ISA_ToolBox_AttachDoc
{
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure DocAttachFactboxCustom(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        ServiceHeader: Record "Service Header";
    begin
        Case DocumentAttachment."Table ID" of
            DATABASE::"Service Header":
                begin
                    RecRef.Open(DATABASE::"Service Header");
                    if ServiceHeader.Get(DocumentAttachment."Document Type", DocumentAttachment."No.") then
                        RecRef.GetTable(ServiceHeader);
                end;
        end;
    end;



    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure AttachServiceQuote(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
    begin
        case RecRef.Number of
            Database::"Service Header":
                begin
                    FieldRef := RecRef.Field(1);
                    DocType := FieldRef.Value;
                    DocumentAttachment.Validate("Document Type", DocType);
                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
    end;
}