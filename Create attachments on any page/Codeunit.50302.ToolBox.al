/// <summary>
/// Codeunit ISA_ToolBox (ID 50301).
/// </summary>
codeunit 50302 ISA_ToolBox_AttachDoc
{
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Enum "Sales Document Type";
    begin
        case RecRef.Number of
            Database::"Service Header":
                begin
                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);

                    FieldRef := RecRef.Field(1);
                    DocType := FieldRef.Value;
                    DocumentAttachment.Validate("Document Type", DocType);
                end;
        end;
    end;



    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Enum "Sales Document Type";
    begin
        case RecRef.Number of
            Database::"Service Header":
                begin
                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);

                    FieldRef := RecRef.Field(1);
                    DocType := FieldRef.Value;
                    DocumentAttachment.Validate("Document Type", DocType);
                end;

        end;
    end;
}