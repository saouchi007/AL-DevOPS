/// <summary>
/// PageExtension ISA_DocAttachmentFactbox_Ext (ID 50313) extends Record Document Attachment Factbox.
/// </summary>
pageextension 50313 ISA_DocAttachmentFactbox_Ext extends "Document Attachment Factbox"
{
    Caption = 'Documents Attached';
    layout
    {
        modify(Documents)
        {
            trigger OnDrillDown()
            var
                ServiceHeader: Record "Service Header";
                RecRef: RecordRef;
                DocAttachDetails: Page "Document Attachment Details";
            begin
                case Rec."Table ID" of
                    Database::"Service Header":
                        begin
                            RecRef.Open(Database::"Service Header");
                            if ServiceHeader.Get(Rec."Document Type") then
                                RecRef.GetTable(ServiceHeader);
                        end;
                end;
                DocAttachDetails.OpenForRecRef(RecRef);
                DocAttachDetails.RunModal();
            end;
        }
    }
}