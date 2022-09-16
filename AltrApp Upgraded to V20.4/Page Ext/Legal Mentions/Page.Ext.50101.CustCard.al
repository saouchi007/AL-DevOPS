/// <summary>
/// PageExtension ISA_CustomerCard_Ext (ID 50229) extends Record Customer Card.
/// </summary>
pageextension 50101 ISA_CustomerCard_Ext extends "Customer Card"
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
                    ToolTip = 'Afin de renseigner le Registre de Commerce du client';
                    trigger OnValidate()
                    var
                        TradeRegisterNotification: Notification;
                        TradeRegisterNotificationLbl: Label 'Nouvelle notification : le registre de commerce actuel est surutilisé !';
                        Customers: Record Customer;
                        CurrentTradeRegister: Text;
                    begin

                        if Rec.ISA_TradeRegister <> '' then begin
                            Customers.SetRange(ISA_TradeRegister, Rec.ISA_TradeRegister);
                            if Customers.Count > 0 then begin
                                TradeRegisterNotification.Message(TradeRegisterNotificationLbl);
                                TradeRegisterNotification.Scope := NotificationScope::LocalScope;
                                TradeRegisterNotification.SetData(CurrentTradeRegister, Rec.ISA_TradeRegister);
                                TradeRegisterNotification.AddAction(ShowDetailsLbl, Codeunit::ISA_StampDutyProcessor, 'OpenCustomersListTradeRegister');
                                TradeRegisterNotification.Send();
                            end;
                        end;
                    end;
                }
                field(ISA_FiscalID; Rec.ISA_FiscalID)
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                    ToolTip = 'Afin de renseigner le Numéro d''Identification Fiscale du client';
                    trigger OnValidate()
                    var
                        FiscalIDNotification: Notification;
                        FiscalIDNotificationLbl: Label 'Nouvelle notification : l''identification fiscale actuelle est surutilisée !';
                        Customers: Record Customer;
                        CurrentFiscalID: Text;
                    begin

                        if Rec.ISA_FiscalID <> '' then begin
                            Customers.SetRange(ISA_FiscalID, Rec.ISA_FiscalID);
                            if Customers.Count > 0 then begin
                                FiscalIDNotification.Message(FiscalIDNotificationLbl);
                                FiscalIDNotification.Scope := NotificationScope::LocalScope;
                                FiscalIDNotification.SetData(CurrentFiscalID, Rec.ISA_FiscalID);
                                FiscalIDNotification.AddAction(ShowDetailsLbl, Codeunit::ISA_StampDutyProcessor, 'OpenCustomersListFiscalID');
                                FiscalIDNotification.Send();
                            end;
                        end;
                    end;
                }
                field(ISA_StatisticalID; Rec.ISA_StatisticalID)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Afin de renseigner le  Numéro d''Identification Statistique du client';
                    trigger OnValidate()
                    var
                        StatisticalIDNotification: Notification;
                        StatisticalIDNotificationLbl: Label 'Nouvelle notification : l''identification statistique actuelle est surutilisée !';
                        Customers: Record Customer;
                        CurrentStatisticalID: Text;
                    begin

                        if Rec.ISA_StatisticalID <> '' then begin
                            Customers.SetRange(ISA_StatisticalID, Rec.ISA_StatisticalID);
                            if Customers.Count > 0 then begin
                                StatisticalIDNotification.Message(StatisticalIDNotificationLbl);
                                StatisticalIDNotification.Scope := NotificationScope::LocalScope;
                                StatisticalIDNotification.SetData(CurrentStatisticalID, Rec.ISA_StatisticalID);
                                StatisticalIDNotification.AddAction(ShowDetailsLbl, Codeunit::ISA_StampDutyProcessor, 'OpenCustomersListStatisticalID');
                                StatisticalIDNotification.Send();
                            end;
                        end;
                    end;
                }
                field(ISA_ItemNumber; Rec.ISA_ItemNumber)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Afin de renseigner le Numéro d''Article du client';
                    trigger OnValidate()
                    var
                        ItemNumberNotification: Notification;
                        ItemNumberNotificationLbl: Label 'Nouvelle notification : le numéro d''article actuel est surutilisé !';
                        Customers: Record Customer;
                        CurrentItemNumber: Text;
                    begin

                        if Rec.ISA_ItemNumber <> '' then begin
                            Customers.SetRange(ISA_ItemNumber, Rec.ISA_ItemNumber);
                            if Customers.Count > 0 then begin
                                ItemNumberNotification.Message(ItemNumberNotificationLbl);
                                ItemNumberNotification.Scope := NotificationScope::LocalScope;
                                ItemNumberNotification.SetData(CurrentItemNumber, Rec.ISA_ItemNumber);
                                ItemNumberNotification.AddAction(ShowDetailsLbl, Codeunit::ISA_StampDutyProcessor, 'OpenCustomersListItemNumber');
                                ItemNumberNotification.Send();
                            end;
                        end;
                    end;
                }

            }
        }
    }
    local procedure CheckDuplicate(var CustRec: Record Vendor)
    begin
        //Message('%1', rec.ISA_TradeRegister);
        CustRec.SetFilter(ISA_TradeRegister, Rec.ISA_TradeRegister);
        //Message('%1', Vendor.Count);
        if CustRec.Count > 0 then
            Error(DuplicatEntryLbl, Rec.ISA_TradeRegister);
    end;

    var
        DuplicatEntryLbl: Label 'Value %1 is already used ! Press F5 to refesh';
        ShowDetailsLbl: Label 'Trouver des doublons!';

}