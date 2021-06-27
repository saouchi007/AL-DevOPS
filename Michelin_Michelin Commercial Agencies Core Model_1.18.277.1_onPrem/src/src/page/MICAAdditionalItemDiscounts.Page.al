page 80181 "MICA Additional Item Discounts"
{
    // version OFFINVOICE

    ApplicationArea = Basic, Suite;
    Caption = 'Additional Item Discounts';
    DataCaptionFields = "Document No.", "Document Line No.", "Item No.";
    Editable = false;
    PageType = List;
    SourceTable = "MICA Additional Item Discount";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
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

