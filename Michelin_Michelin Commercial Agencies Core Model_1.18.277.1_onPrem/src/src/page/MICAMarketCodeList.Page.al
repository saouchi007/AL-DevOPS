page 80023 "MICA Market Code List"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "MICA Table Value";
    Caption = 'Market Code List';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }

                field("Market Code Business Line"; Rec."Market Code Business Line")
                {
                    ApplicationArea = All;
                }


            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {

        }
    }
}