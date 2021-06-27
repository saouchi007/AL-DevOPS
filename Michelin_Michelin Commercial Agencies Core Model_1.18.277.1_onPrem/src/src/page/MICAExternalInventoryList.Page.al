page 82925 "MICA External Inventory List"
{
    UsageCategory = Lists;
    ApplicationArea = All;
    Caption = 'External Inventory List';
    PageType = List;
    SourceTable = "Purchase Header";
    SourceTableView = where("Document Type" = const("Blanket Order"), "MICA 3rd Party" = const(true));
    CardPageId = "MICA External Inventory Card";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Order No."; Rec."Vendor Order No.")
                {
                    ApplicationArea = All;
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
                }
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

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."MICA 3rd Party Vendor No." <> '' then
                Rec.SetRange("Buy-from Vendor No.", UserSetup."MICA 3rd Party Vendor No.");
        Rec.SetRange("Document Type", Rec."Document Type"::"Blanket Order");
        Rec.SetRange("MICA 3rd Party", true);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        UserSetup: Record "User Setup";
    begin
        Rec.InitExternalInventory();
    end;
}
