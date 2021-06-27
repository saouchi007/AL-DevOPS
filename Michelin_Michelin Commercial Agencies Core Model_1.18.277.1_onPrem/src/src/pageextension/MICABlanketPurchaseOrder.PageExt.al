pageextension 82920 "MICA Blanket Purchase Order" extends "Blanket Purchase Order"
{
    layout
    {
        addlast(Content)
        {
            group("MICA Michelin")
            {
                field("MICA 3rd Party"; Rec."MICA 3rd Party")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
