page 81760 "MICA Market Code"
{
    PageType = List;
    SourceTable = "MICA Table Value";
    SourceTableView = where ("Table Type" = const (MarketCode));
    Caption = 'Market Codes';
    ApplicationArea = All;
    UsageCategory = Lists;


    layout
    {
        area(Content)
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
                field("Market Code Business Line"; Rec."Market Code Business Line")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}