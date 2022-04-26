/// <summary>
/// PageExtension ISA_VendorCard_Ext (ID 50228) extends Record MyTargetPage.
/// </summary>
pageextension 50228 ISA_VendorCard_Ext extends "Vendor Card"
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
                    trigger OnValidate()
                    var
                        VendorRec: Record Vendor;
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
                    trigger OnValidate()
                    var
                        VendorRec: Record Vendor;
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
                    trigger OnValidate()
                    var
                        VendorRec: Record Vendor;
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
                    trigger OnValidate()
                    var
                        VendorRec: Record Vendor;
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