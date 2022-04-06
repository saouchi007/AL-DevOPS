/// <summary>
/// PageExtension ISA_InventorySetup (ID 50201) extends Record Inventory Setup.
/// </summary>
pageextension 50201 ISA_InventorySetup extends "Inventory Setup"
{
    layout
    {
        addafter(Numbering)
        {
            group(ItemAttributes)
            {
                Caption = 'Item Attributes';
                field(ISA_Attr1; Rec.ISA_Attr1)
                {
                    ApplicationArea = All;
                }
                field(ISA_Attr2; Rec.ISA_Attr2)
                {
                    ApplicationArea = All;
                }
                field(ISA_Attr3; Rec.ISA_Attr3)
                {
                    ApplicationArea = All;
                }
                field(ISA_Attr4; Rec.ISA_Attr4)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}