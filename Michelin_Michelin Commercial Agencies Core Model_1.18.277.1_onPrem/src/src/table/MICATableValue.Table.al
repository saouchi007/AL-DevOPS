table 81531 "MICA Table Value"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "MICA Table Values";
    LookupPageId = "MICA Table Values";
    fields
    {
        field(1; "Table Type"; Option)
        {
            Caption = 'Table Type';
            DataClassification = CustomerContent;
            OptionMembers = " ",ItemBrand,ItemSegment,ItemLPFamily,ItemLPRCategory,ItemLPRSubFamily,ItemProductNature,ItemUsageCategory,ItemPrevisionIndicator,ItemSpeedIndex1,ItemTireType,ItemStarRating,ItemGradingType,ItemItemMasterTypeCode,ItemProductSegment,ItemAspectQuality,ItemUserItemType,ItemAdministrativeStatus,ItemAirtightness,ItemPatternCode,PaymentMethodPaymentType,MarketCode,CustChannel,CustBusinessOrientation,CustPartnership,CustDeliverability,CustMDMID,SalesLineCancelReasonCode,CustCreditClassification,RestrictedSite,SalesLineExceptRebateReason,ReasonCreditNote,SalesLineStatus,ItemClass,CustSegment;
            OptionCaption = ' ,ItemBrand,ItemSegment,ItemLPFamily,ItemLPRCategory,ItemLPRSubFamily,ItemProductNature,ItemUsageCategory,ItemPrevisionIndicator,ItemSpeedIndex1,ItemTireType,ItemStarRating,ItemGradingType,ItemItemMasterTypeCode,ItemProductSegment,ItemAspectQuality,ItemUserItemType,ItemAdministrativeStatus,ItemAirtightness,ItemPatternCode,PaymentMethodPaymentType,MarketCode,CustChannel,CustBusinessOrientation,CustPartnership,CustDeliverability,CustMDMID,SalesLineCancelReasonCode,CustCreditClassification,RestrictedSite,SalesLineExceptRebateReason,ReasonCreditNote,SalesLineStatus,ItemClass,CustSegment';
        }
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
            trigger OnValidate()
            begin
                OnValidateCodeDescription();
            end;
        }
        field(20; Description; Text[200])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                OnValidateCodeDescription();
            end;
        }
        field(30; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(40; "Item Brand Grouping Code"; Code[20])
        {
            Caption = 'Brand Grouping Code';
            DataClassification = CustomerContent;
        }
        field(50; "Item Brand Group. English Name"; Code[20])
        {
            Caption = 'Brand Grouping English Name';
            DataClassification = CustomerContent;
        }
        field(60; "Market Code Business Line"; Option)
        {
            Caption = 'Business Line';
            DataClassification = CustomerContent;
            OptionMembers = "LB-OE","LB-RT";
            OptionCaption = 'LB-OE,LB-RT';
        }
        field(70; "CT2 Referential Code"; Code[3])
        {
            DataClassification = CustomerContent;
            Caption = 'CT2 Referential Code';
        }
        field(80; "Allow Recalc."; Boolean)
        {
            Caption = 'Allow Recalculation';
            DataClassification = CustomerContent;
        }
        field(100; "Block Value"; Boolean)
        {
            Caption = 'Block Value';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Table Type", Code)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        OnInsertOrOnModify();
    end;

    trigger OnModify()
    begin
        if "Table Type" = "Table Type"::" " then
            Error(TypeCannotBeEmptyErr);
        OnInsertOrOnModify();
    end;

    trigger OnDelete()
    var
        MICATableType: Record "MICA Table Type";
        ItemAttribute: Record "Item Attribute";
        ItemAttributeValue: Record "Item Attribute Value";
    begin
        if MICATableType.Get("Table Type") then
            if MICATableType."Synchronize to Attributes" then begin
                ItemAttribute.SetRange(Name, MICATableType."Item Attribute Name");
                if ItemAttribute.FindFirst() then begin
                    ItemAttributeValue.SetRange("Attribute ID", ItemAttribute.ID);
                    ItemAttributeValue.SetRange(Value, Code + '-' + Description);
                    ItemAttributeValue.DeleteAll(true);
                end;
            end;
    end;

    trigger OnRename()
    begin
        Error(CanNotRenameErr);
    end;

    procedure OnInsertOrOnModify()
    var
        MICATableType: Record "MICA Table Type";
        ItemAttribute: Record "Item Attribute";
        ItemAttributeValue: Record "Item Attribute Value";
    begin
        if MICATableType.Get("Table Type") then
            if MICATableType."Synchronize to Attributes" then begin
                ItemAttribute.SetRange(Name, MICATableType."Item Attribute Name");
                if ItemAttribute.FindFirst() then begin
                    ItemAttributeValue.SetRange("Attribute ID", ItemAttribute.ID);
                    if ItemAttributeValue.FindSet() then begin
                        ItemAttributeValue.Validate(Value, Code + '-' + Description);
                        ItemAttributeValue.Modify(true);
                    end else begin
                        ItemAttributeValue.Init();
                        ItemAttributeValue.Validate("Attribute ID", ItemAttribute.ID);
                        ItemAttributeValue.Validate(Value, Code + '-' + Description);
                        ItemAttributeValue.Insert(true);
                    end;
                end
            end;
    end;

    local procedure OnValidateCodeDescription()
    var
        MICATableType: Record "MICA Table Type";
    begin
        if MICATableType.Get("Table Type") then
            if StrLen(Code) > MICATableType."Max. Length for Code" then
                Error(CodeLengthOverErr, MICATableType."Max. Length for Code") else
                if StrLen(Description) > MICATableType."Max. Length for Description" then
                    Error(DescriptionLengthOverErr, MICATableType."Max. Length for Description");
    end;

    var
        CodeLengthOverErr: Label 'Code length is over %1';
        DescriptionLengthOverErr: Label 'Description length is over %1';
        CanNotRenameErr: Label 'You cannot rename a Table Type';
        TypeCannotBeEmptyErr: Label 'Type cannot be empty';
}