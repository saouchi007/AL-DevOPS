/// <summary>
/// Page ISA_Best_Sellers_Theme (ID 50328).
/// </summary>
page 50328 ISA_NYT_Best_Sellers_Theme
{
    PageType = List;
    ApplicationArea = All;
    Caption = 'ISA NYT Best Sellers Theme';
    UsageCategory = Lists;
    SourceTable = ISA_NYT_Best_Sellers_Theme;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field(ListName; Rec.ListName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the List Name field.';
                }
                field("Newest Published Date"; Rec."Newest Published Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Newest Published Date field.';
                }
                field(OldestPublishedDate; Rec.OldestPublishedDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Oldest Published Date field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SyncLatestData)
            {
                ApplicationArea = All;
                Caption = 'Sync Latest Data';
                ToolTip = 'Sync latest available data';
                Image = LaunchWeb;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                var
                    NYT_API_Mgmt: Codeunit ISA_NYT_API_Mgmt;
                begin
                    NYT_API_Mgmt.ISA_SyncBookAPIData();
                    CurrPage.Update(false);
                end;
            }

            action(OpenBestSellersList)
            {
                ApplicationArea = All;
                Caption = 'ISA Best Sellers List';
                ToolTip = 'Opens "Best Sellers List Page"';
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    NYT_Best_Sellers: Record ISA_Best_Sellers;
                    NYT_Best_Sellers_Page: Page ISA_Best_Sellers;
                begin
                    NYT_Best_Sellers.SetRange("List Name", Rec.ListName);
                    NYT_Best_Sellers_Page.SetTableView(NYT_Best_Sellers);
                    NYT_Best_Sellers_Page.RunModal();
                end;
            }
        }
    }
}