page 80186 "MICA Add. Item Discounts Fact"
{
    // version OFFINVOICE

    Caption = 'Additional Item Discounts';
    Editable = false;
    PageType = ListPart;
    SourceTable = "MICA Additional Item Discount";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Add. Item Discount Group Code"; Rec."Add. Item Discount Group Code")
                {
                    ApplicationArea = All;
                }
                field("Discount %"; Rec."Discount %")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}

