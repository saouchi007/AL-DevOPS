/// <summary>
/// PageExtension ISA_ItemList (ID 50202) extends Record Item List.
/// </summary>
pageextension 50202 ISA_ItemList extends "Item List"
{
    layout
    {
        addafter("Unit Price")
        {
            field(ShortItemAttr1; ShortItemAttr1)
            {
                ApplicationArea = All;
                CaptionClass = '1,5,,' + Caption1;
                Visible = Visible1;
            }
            field(ShortItemAttr2; ShortItemAttr2)
            {
                ApplicationArea = All;
                CaptionClass = '1,5,,' + Caption2;
                Visible = Visible2;
            }
            field(ShortItemAttr3; ShortItemAttr3)
            {
                ApplicationArea = All;
                CaptionClass = '1,5,,' + Caption3;
                Visible = Visible3;
            }
            field(ShortItemAttr4; ShortItemAttr4)
            {
                ApplicationArea = All;
                CaptionClass = '1,5,,' + Caption4;
                Visible = Visible4;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetCaptionData();
        SetItemAttibuteValue();

    end;

    local procedure SetCaptionData()
    var
        ItemAttribute: Record "Item Attribute";
        InventorySetup: Record "Inventory Setup";
    begin
        Clear(Caption1);
        Clear(Caption2);
        Clear(Caption3);
        Clear(Caption4);
        Clear(Visible1);
        Clear(Visible1);
        Clear(Visible3);
        Clear(Visible4);
        if InventorySetup.Get() then begin
            if ItemAttribute.Get(InventorySetup.ISA_Attr1) then begin
                Caption1 := ItemAttribute.GetTranslatedName(GlobalLanguage);
                Visible1 := true;
            end else begin
                Visible1 := false;
            end;

            ItemAttribute.Reset();
            if ItemAttribute.Get(InventorySetup.ISA_Attr2) then begin
                Caption2 := ItemAttribute.GetTranslatedName(GlobalLanguage);
                Visible2 := true;
            end else begin
                Visible2 := false;
            end;

            ItemAttribute.Reset();
            if ItemAttribute.Get(InventorySetup.ISA_Attr3) then begin
                Caption3 := ItemAttribute.GetTranslatedName(GlobalLanguage);
                Visible3 := true;
            end else begin
                Visible3 := false;
            end;

            ItemAttribute.Reset();
            if ItemAttribute.Get(InventorySetup.ISA_Attr4) then begin
                Caption4 := ItemAttribute.GetTranslatedName(GlobalLanguage);
                Visible4 := true;
            end else begin
                Visible4 := false;
            end;
        end;
    end;

    local procedure SetItemAttibuteValue()
    var
        ItemAttributeValueMap: Record "Item Attribute Value Mapping";
        ItemAttributeValue: Record "Item Attribute Value";
        InventorySetup: Record "Inventory Setup";
    begin
        if InventorySetup.Get() then begin
            if ItemAttributeValueMap.Get(Database::Item, Rec."No.", InventorySetup.ISA_Attr1) then
                if ItemAttributeValue.Get(ItemAttributeValueMap."Item Attribute ID", ItemAttributeValueMap."Item Attribute Value ID") then
                    ShortItemAttr1 := ItemAttributeValue.GetTranslatedName(GlobalLanguage);

            ItemAttributeValueMap.Reset();
            ItemAttributeValue.Reset();
            if ItemAttributeValueMap.Get(Database::Item, Rec."No.", InventorySetup.ISA_Attr2) then
                if ItemAttributeValue.Get(ItemAttributeValueMap."Item Attribute ID", ItemAttributeValueMap."Item Attribute Value ID") then
                    ShortItemAttr2 := ItemAttributeValue.GetTranslatedName(GlobalLanguage);

            ItemAttributeValueMap.Reset();
            ItemAttributeValue.Reset();
            if ItemAttributeValueMap.Get(Database::Item, Rec."No.", InventorySetup.ISA_Attr3) then
                if ItemAttributeValue.Get(ItemAttributeValueMap."Item Attribute ID", ItemAttributeValueMap."Item Attribute Value ID") then
                    ShortItemAttr3 := ItemAttributeValue.GetTranslatedName(GlobalLanguage);

            ItemAttributeValueMap.Reset();
            ItemAttributeValue.Reset();
            if ItemAttributeValueMap.Get(Database::Item, Rec."No.", InventorySetup.ISA_Attr4) then
                if ItemAttributeValue.Get(ItemAttributeValueMap."Item Attribute ID", ItemAttributeValueMap."Item Attribute Value ID") then
                    ShortItemAttr4 := ItemAttributeValue.GetTranslatedName(GlobalLanguage);
        end;
    end;

    var
        ShortItemAttr1: Text[250];
        ShortItemAttr2: Text[250];
        ShortItemAttr3: Text[250];
        ShortItemAttr4: Text[250];

        Caption1, Caption2, Caption3, Caption4 : Text[50];
        Visible1, Visible2, Visible3, Visible4 : Boolean;
}