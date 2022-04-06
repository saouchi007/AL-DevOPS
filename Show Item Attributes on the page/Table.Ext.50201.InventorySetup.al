/// <summary>
/// TableExtension ISA_InventorySetup_Exy (ID 50201) extends Record MyTargetTable.
/// </summary>
tableextension 50201 ISA_InventorySetup_Exy extends "Inventory Setup"
{
    fields
    {
        field(50201; ISA_Attr1; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Item Attribute 1';
            TableRelation = "Item Attribute";
        }
        field(50202; ISA_Attr2; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Item Attribute 2';
            TableRelation = "Item Attribute";
        }
        field(50203; ISA_Attr3; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Item Attribute 3';
            TableRelation = "Item Attribute";
        }
        field(50204; ISA_Attr4; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Item Attribute 4';
            TableRelation = "Item Attribute";
        }
    }

    var
        myInt: Integer;
}