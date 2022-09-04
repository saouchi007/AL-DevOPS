/// <summary>
/// Codeunit ISA_DocumentAttachments (ID 50303).
/// </summary>
codeunit 50304 ISA_DocumentAttachments
{
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        ServiceHeader : Record "Service Header";
    begin
        case DocumentAttachment."Table ID" of
            DATABASE::"Service Header":
                begin
                    RecRef.Open(DATABASE::"Service Header");
                    if ServiceHeader.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(ServiceHeader);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        ServiceHeaderNo : Code[20];
        DocType: Enum "Sales Document Type";
    begin
        case RecRef.Number of
            DATABASE::"Service Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);

                     FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("Document Type", DocType::Quote);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"Payment Terms":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
    end;
}