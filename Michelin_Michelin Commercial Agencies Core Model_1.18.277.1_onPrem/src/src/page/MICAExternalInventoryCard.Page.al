page 82923 "MICA External Inventory Card"
{
    UsageCategory = None;
    Caption = 'External Inventory Card';
    PageType = Card;
    SourceTable = "Purchase Header";
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Vendor Order No."; Rec."Vendor Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("MICA 3rd Party"; Rec."MICA 3rd Party")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part(ExternalInventoryLines; "MICA Exter. Invent. Subfom")
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(ReleaseGroup)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(Release)
                {
                    ApplicationArea = Suite;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        CurrPage.Update();
                        ReleasePurchDoc.PerformManualRelease(Rec);
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Suite;
                    Caption = 'Re&open';
                    Enabled = Rec.Status <> Rec.Status::Open;
                    Image = ReOpen;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed';

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        ReleasePurchDoc.PerformManualReopen(Rec);
                    end;
                }
            }
        }
    }
    trigger OnNewRecord(BelowRec: Boolean)
    begin
        Rec.InitInsert();
        Rec.Insert(true);
        Rec.InitExternalInventory();
        Rec.Modify(true);
    end;
}
