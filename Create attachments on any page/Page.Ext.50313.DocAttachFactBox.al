pageextension 50313 ISA_DocAttachmentFactbox_Ext extends "Document Attachment Factbox"
{
    Caption = 'Documents Attached';
    layout
    {
        modify(Documents)
        {
            trigger OnDrillDown()
            var
                Location: Record Location;
                RecRef: RecordRef;
                DocAttachDetails: Page "Document Attachment Details";
            begin
                case Rec."Table ID" of
                    Database::Location:
                        begin
                            RecRef.Open(Database::Location);
                            if Location.Get(Rec."No.") then
                                RecRef.GetTable(Location);
                        end;
                end;
                DocAttachDetails.OpenForRecRef(RecRef);
                DocAttachDetails.RunModal();
            end;
        }
    }
}