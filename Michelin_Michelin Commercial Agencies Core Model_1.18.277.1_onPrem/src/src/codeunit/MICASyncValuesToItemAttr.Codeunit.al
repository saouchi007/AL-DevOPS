codeunit 81530 "MICA Sync Values To Item Attr"
{
    procedure SynchronizeToItem(ItemNo: Code[20]; TableType: Integer; Value: Code[20])
    var
        MICATableType: Record "MICA Table Type";
        MICATableValue: Record "MICA Table Value";
        ItemAttribute: Record "Item Attribute";
        ItemAttributeValue: Record "Item Attribute Value";
    begin
        if MICATableValue.Get(TableType, Value) then
            if MICATableType.Get(MICATableValue."Table Type") then
                if MICATableType."Synchronize to Attributes" then begin
                    ItemAttribute.SetRange(Name, MICATableType."Item Attribute Name");
                    if ItemAttribute.FindFirst() then begin
                        ItemAttributeValue.Init();
                        ItemAttributeValue.Validate("Attribute ID", ItemAttribute.ID);
                        ItemAttributeValue.Validate(Value, MICATableValue.Code + '-' + MICATableValue.Description);
                        if ItemAttributeValue.Insert(true) then;
                    end;
                end;
    end;
}