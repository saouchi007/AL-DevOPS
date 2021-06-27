table 81530 "MICA Table Type"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "MICA Table Types";
    LookupPageId = "MICA Table Types";
    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            OptionMembers = " ",ItemBrand,ItemSegment,ItemLPFamily,ItemLPRCategory,ItemLPRSubFamily,ItemProductNature,ItemUsageCategory,ItemPrevisionIndicator,ItemSpeedIndex1,ItemTireType,ItemStarRating,ItemGradingType,ItemItemMasterTypeCode,ItemProductSegment,ItemAspectQuality,ItemUserItemType,ItemAdministrativeStatus,ItemAirtightness,ItemPatternCode,PaymentMethodPaymentType,MarketCode,CustChannel,CustBusinessOrientation,CustPartnership,CustDeliverability,CustMDMID,SalesLineCancelReasonCode,CustCreditClassification,ItemClass,CustSegment;
            OptionCaption = ' ,ItemBrand,ItemSegment,ItemLPFamily,ItemLPRCategory,ItemLPRSubFamily,ItemProductNature,ItemUsageCategory,ItemPrevisionIndicator,ItemSpeedIndex1,ItemTireType,ItemStarRating,ItemGradingType,ItemItemMasterTypeCode,ItemProductSegment,ItemAspectQuality,ItemUserItemType,ItemAdministrativeStatus,ItemAirtightness,ItemPatternCode,PaymentMethodPaymentType,MarketCode,CustChannel,CustBusinessOrientation,CustPartnership,CustDeliverability,CustMDMID,SalesLineCancelReasonCode,CustCreditClassification,ItemClass,CustSegment';
        }
        field(10; "Max. Length for Code"; Integer)
        {
            Caption = 'Max. Length for Code';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 20;
        }
        field(20; "Max. Length for Description"; Integer)
        {
            Caption = 'Max. Length for Description';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 200;
        }
        field(30; "Synchronize to Attributes"; Boolean)
        {
            Caption = 'Synchronize to Attributes';
            DataClassification = CustomerContent;
        }
        field(40; "Item Attribute Name"; Text[250])
        {
            Caption = 'Item Attribute Name';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                ItemAttribute: Record "Item Attribute";
            begin
                ItemAttribute.SetRange(Name, xRec."Item Attribute Name");
                if ItemAttribute.FindFirst() then begin
                    ItemAttribute.Validate(Name, "Item Attribute Name");
                    ItemAttribute.Modify(true);
                end else begin
                    ItemAttribute.Init();
                    ItemAttribute.Validate(Type, ItemAttribute.Type::Text);
                    ItemAttribute.Validate(Name, "Item Attribute Name");
                end
            end;
        }
        field(50; "Value Count"; Integer)
        {
            Caption = 'Value Count';
            FieldClass = FlowField;
            CalcFormula = count("MICA Table Value" where("Table Type" = field(Type)));
        }
        field(60; "List Page Id"; Integer)
        {
            Caption = 'List Page Id';
            DataClassification = CustomerContent;
            TableRelation = "Page Metadata".ID;
        }
        field(70; "List Page Name"; Text[250])
        {
            Caption = 'List Page Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Page Metadata".Name where(ID = field("List Page Id")));
        }
    }
    keys
    {
        key(PK; "Type")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if Type = Type::" " then
            Error(TypeCannotBeEmptyErr);
    end;

    trigger OnRename()
    begin
        Error(CanNotRenameErr);
    end;

    trigger OnDelete()
    var
        MICATableValue: Record "MICA Table Value";
    begin
        MICATableValue.SetRange("Table Type", Type);
        MICATableValue.DeleteAll(true);
    end;

    procedure DrillDownValues()
    var
        MICATableValue: Record "MICA Table Value";
        MICATableValues: Page "MICA Table Values";
    begin
        if "List Page Id" = 0 then begin
            MICATableValue.SetRange("Table Type", Type);
            MICATableValues.SetTableView(MICATableValue);
            MICATableValues.RunModal();
        end else
            Page.RunModal("List Page Id");
    end;

    var
        CanNotRenameErr: Label 'You cannot rename a Table Type';
        TypeCannotBeEmptyErr: Label 'Type cannot be empty';
}