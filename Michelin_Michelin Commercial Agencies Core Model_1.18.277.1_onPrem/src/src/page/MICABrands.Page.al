page 80040 "MICA Brands"
{
    PageType = List;
    SourceTable = "MICA Table Value";
    Caption = 'Brands';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTableView = where ("Table Type" = const (ItemBrand));
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
                field("Item Brand Grouping Code"; Rec."Item Brand Grouping Code")
                {
                    ApplicationArea = All;
                }
                field("Item Brand Group. English Name"; Rec."Item Brand Group. English Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
