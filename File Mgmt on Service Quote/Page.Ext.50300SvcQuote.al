/// <summary>
/// PageExtension SDH Service Quote (ID 50100) extends Record Service Quote.
/// </summary>
pageextension 50300 ISA_ServiceQuote_Ext extends "Service Quote"
{

    layout
    {
        addfirst(FactBoxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(5900),
                              "No." = FIELD("No."),
                              "Document Type" = field("Document Type");
            }
        }
    }

    /*actions
    {
        addfirst(processing)
        {
            action(DocAttach)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;


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
    }*/
}
