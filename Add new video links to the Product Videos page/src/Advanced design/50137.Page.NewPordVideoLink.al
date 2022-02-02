/// <summary>
/// Page NewProdVideoLink (ID 50137).
/// </summary>
page 50137 NewProdVideoLink
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = NewVideoProdLink;
    Caption = 'New Product Video Link';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field.';
                    ApplicationArea = All;
                }
                field(VideoURL; Rec.VideoURL)
                {
                    ToolTip = 'Specifies the value of the Video URL field.';
                    ApplicationArea = All;
                }
                field(Category; Rec.Category)
                {
                    ToolTip = 'Specifies the value of the Category field.';
                    ApplicationArea = All;
                }
                field(AppID; Rec.AppID)
                {
                    ToolTip = 'Specifies the value of the App ID field.';
                    ApplicationArea = All;
                }
                field(ExtensionName; Rec.ExtensionName)
                {
                    ToolTip = 'Specifies the value of the Extension Name field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}