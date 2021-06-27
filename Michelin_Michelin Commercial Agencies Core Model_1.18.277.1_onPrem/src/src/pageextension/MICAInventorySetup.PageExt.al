pageextension 81320 "MICA Inventory Setup" extends "Inventory Setup"
{
    layout
    {
        addlast(Content)
        {
            group("MICA DRP Integration")
            {
                Caption = 'DRP Integration';
                field("MICA DRP stock flow code"; Rec."MICA DRP stock flow code")
                {
                    ApplicationArea = all;
                }

                field("MICA DRP conf. order flow code"; Rec."MICA DRP conf. order flow code")
                {
                    ApplicationArea = all;
                }

                field("MICA DRP ord. ship. flow code"; Rec."MICA DRP ord. ship. flow code")
                {
                    ApplicationArea = all;
                }
                field("MICA DRP InTransit Flow Code"; Rec."MICA DRP InTransit Flow Code")
                {
                    ApplicationArea = All;
                }
            }

            group("MICA Michelin")
            {
                Caption = 'Michelin';

                field("MICA Purchase Location Code"; Rec."MICA Purchase Location Code")
                {
                    ApplicationArea = all;
                }
                field("MICA Keep Value in Item Card"; Rec."MICA Keep Value in Item Card")
                {
                    ApplicationArea = All;
                }
                field("MICA Item Weight Default UoM"; Rec."MICA Item Weight Default UoM")
                {
                    ApplicationArea = All;
                }
                field("MICA Item to PS9 Weight Factor"; Rec."MICA Item to PS9 Weight Factor")
                {
                    ApplicationArea = All;
                }
                field("MICA Item Wght Decimal Places"; Rec."MICA Item Wght Decimal Places")
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