/// <summary>
/// PageExtension ISA_ServiceQuote_Ext (ID 50222) extends Record Service Quote.
/// </summary>
pageextension 50222 ISA_ServiceQuote_Ext extends "Service Quote"
{
    actions
    {
        addfirst(processing)
        {
            action(DocAttach)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attachments;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Add a file as an attachment';

                trigger OnAction()
                var
                    DocAttachDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocAttachDetails.OpenForRecRef(RecRef);
                    DocAttachDetails.RunModal();
                end;
            }
        }
    }

    /*
        actions
        {
            addfirst(processing)
            {
                action(Import)
                {
                    Caption = 'Import Zip File';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Import;
                    ToolTip = 'Import Attachments from Zip';

                    trigger OnAction()
                    var
                        ImportCU: Codeunit ISA_Import;
                    begin
                        //ImportCU.ImportAttachmentsFromZip(Rec);
                    end;
                }
            }
        }
        */
}