/// <summary>
/// PageExtension ISA_CustomerCard_Ext (ID 50229) extends Record Customer Card.
/// </summary>
pageextension 50229 ISA_CustomerCard_Ext extends "Customer Card"
{
    layout
    {
        addafter("Address & Contact")
        {
            group(LegalMentions)
            {
                CaptionML = ENU = 'Legal Mentions', FRA = 'Mentions Légales';
                field(ISA_TradeRegister; Rec.ISA_TradeRegister)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Afin de renseigner le Registre du Commerce du client';
                    trigger OnValidate()
                    var
                        VendorRec: Record Customer;
                    begin
                        VendorRec.SetFilter(ISA_TradeRegister, Rec.ISA_TradeRegister);
                        if VendorRec.Count > 0 then
                            Error(DuplicatEntryLbl, Rec.ISA_TradeRegister);
                    end;
                }
                field(ISA_FiscalID; Rec.ISA_FiscalID)
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                    ToolTip = 'Afin de renseigner le Numéro d''Identification Fiscale du client';
                    trigger OnValidate()
                    var
                        VendorRec: Record Customer;
                    begin
                        VendorRec.SetFilter(ISA_FiscalID, Rec.ISA_FiscalID);
                        if VendorRec.Count > 0 then
                            Error(DuplicatEntryLbl, Rec.ISA_FiscalID);
                    end;
                }
                field(ISA_StatisticalID; Rec.ISA_StatisticalID)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Afin de renseigner le  Numéro d''Identification Statistique du client';
                    trigger OnValidate()
                    var
                        VendorRec: Record Customer;
                    begin
                        VendorRec.SetFilter(ISA_StatisticalID, Rec.ISA_StatisticalID);
                        if VendorRec.Count > 0 then
                            Error(DuplicatEntryLbl, Rec.ISA_StatisticalID);
                    end;
                }
                field(ISA_ItemNumber; Rec.ISA_ItemNumber)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Afin de renseigner le Numéro d''Article du client';
                    trigger OnValidate()
                    var
                        VendorRec: Record Customer;
                    begin
                        VendorRec.SetFilter(ISA_ItemNumber, Rec.ISA_ItemNumber);
                        if VendorRec.Count > 0 then
                            Error(DuplicatEntryLbl, Rec.ISA_ItemNumber);
                    end;
                }

            }
        }
    }
    local procedure CheckDuplicate(var Vendor: Record Vendor)
    begin
        //Message('%1', rec.ISA_TradeRegister);
        Vendor.SetFilter(ISA_TradeRegister, Rec.ISA_TradeRegister);
        //Message('%1', Vendor.Count);
        if Vendor.Count > 0 then
            Error(DuplicatEntryLbl, Rec.ISA_TradeRegister);
    end;

    var
        DuplicatEntryLbl: Label 'Value %1 is already used ! Press F5 to refesh';

}