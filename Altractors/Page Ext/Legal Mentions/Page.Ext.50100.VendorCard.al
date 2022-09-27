/// <summary>
/// PageExtension ISA_VendorCard_Ext (ID 50228) extends Record MyTargetPage.
/// </summary>
pageextension 50100 ISA_VendorCard_Ext extends "Vendor Card"
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
                    ToolTip = 'Afin de renseigner le Registre du Commerce du fournisseur';
                    trigger OnValidate()
                    var
                        TradeRegisterNotification: Notification;
                        TradeRegisterNotificationLbl: Label 'Nouvelle notification : le registre de commerce actuel est surutilisé !';
                        Vendors: Record Vendor;
                        CurrentTradeRegister: Text;
                    begin

                        if Rec.ISA_TradeRegister <> '' then begin
                            Vendors.SetRange(ISA_TradeRegister, Rec.ISA_TradeRegister);
                            if Vendors.Count > 1 then begin
                                TradeRegisterNotification.Message(TradeRegisterNotificationLbl);
                                TradeRegisterNotification.Scope := NotificationScope::LocalScope;
                                TradeRegisterNotification.SetData(CurrentTradeRegister, Rec.ISA_TradeRegister);
                                TradeRegisterNotification.AddAction(ShowDetailsLbl, Codeunit::ISA_StampDutyProcessor, 'OpenVendorsListTradeRegister');
                                TradeRegisterNotification.Send();
                            end;
                        end;
                    end;
                }
                field(ISA_FiscalID; Rec.ISA_FiscalID)
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                    ToolTip = 'Afin de renseigner le Numéro d''Identification Fiscale du fournisseur';
                    trigger OnValidate()
                    var
                        FiscalIDNotification: Notification;
                        FiscalIDNotificationLbl: Label 'Nouvelle notification : l''identification fiscale actuelle est surutilisée !';
                        Vendors: Record Vendor;
                        CurrentFiscalID: Text;
                    begin

                        if Rec.ISA_FiscalID <> '' then begin
                            Vendors.SetRange(ISA_FiscalID, Rec.ISA_FiscalID);
                            if Vendors.Count > 1 then begin
                                FiscalIDNotification.Message(FiscalIDNotificationLbl);
                                FiscalIDNotification.Scope := NotificationScope::LocalScope;
                                FiscalIDNotification.SetData(CurrentFiscalID, Rec.ISA_FiscalID);
                                FiscalIDNotification.AddAction(ShowDetailsLbl, Codeunit::ISA_StampDutyProcessor, 'OpenVendorsListFiscalID');
                                FiscalIDNotification.Send();
                            end;
                        end;
                    end;
                }
                field(ISA_StatisticalID; Rec.ISA_StatisticalID)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Afin de renseigner le  Numéro d''Identification Statistique du fournisseur';
                    trigger OnValidate()
                    var
                        StatisticalIDNotification: Notification;
                        StatisticalIDNotificationLbl: Label 'Nouvelle notification : l''identification statistique actuelle est surutilisée !';
                        Vendors: Record Vendor;
                        CurrentStatisticalID: Text;
                    begin

                        if Rec.ISA_StatisticalID <> '' then begin
                            Vendors.SetRange(ISA_StatisticalID, Rec.ISA_StatisticalID);
                            if Vendors.Count > 1 then begin
                                StatisticalIDNotification.Message(StatisticalIDNotificationLbl);
                                StatisticalIDNotification.Scope := NotificationScope::LocalScope;
                                StatisticalIDNotification.SetData(CurrentStatisticalID, Rec.ISA_StatisticalID);
                                StatisticalIDNotification.AddAction(ShowDetailsLbl, Codeunit::ISA_StampDutyProcessor, 'OpenVendorsListStatisticalID');
                                StatisticalIDNotification.Send();
                            end;
                        end;
                    end;
                }
                field(ISA_ItemNumber; Rec.ISA_ItemNumber)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Afin de renseigner le Numéro d''Article du fournisseur';
                    trigger OnValidate()
                    var
                        ItemNumberNotification: Notification;
                        ItemNumberNotificationLbl: Label 'Nouvelle notification : le numéro d''article actuel est surutilisé !';
                        Vendors: Record Vendor;
                        CurrentItemNumber: Text;
                    begin

                        if Rec.ISA_ItemNumber <> '' then begin
                            Vendors.SetRange(ISA_ItemNumber, Rec.ISA_ItemNumber);
                            if Vendors.Count > 1 then begin
                                ItemNumberNotification.Message(ItemNumberNotificationLbl);
                                ItemNumberNotification.Scope := NotificationScope::LocalScope;
                                ItemNumberNotification.SetData(CurrentItemNumber, Rec.ISA_ItemNumber);
                                ItemNumberNotification.AddAction(ShowDetailsLbl, Codeunit::ISA_StampDutyProcessor, 'OpenVendorsListItemNumber');
                                ItemNumberNotification.Send();
                            end;
                        end;
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
        if Vendor.Count > 1 then
            Error(DuplicatEntryLbl, Rec.ISA_TradeRegister);
    end;

    var
        DuplicatEntryLbl: Label 'Value %1 is already used ! Press F5 to refesh';
        ShowDetailsLbl: Label 'Trouver des doublons!';
}