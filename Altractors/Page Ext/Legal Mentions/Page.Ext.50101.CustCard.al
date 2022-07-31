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
                    ToolTip = 'Afin de renseigner le Registre du Commerce du client';
                    trigger OnValidate()
                    var
                        CustomerRec: Record Customer;
                        TradeRegisterNotification: Notification;
                        TradeRegisterNotificationLabel: Label 'This trade register is already used by another customer';
                    begin
                        CustomerRec.SetFilter(ISA_TradeRegister, Rec.ISA_TradeRegister);
                        if CustomerRec.Count > 0 then begin
                            TradeRegisterNotification.Message(TradeRegisterNotificationLabel);
                            TradeRegisterNotification.Scope := NotificationScope::LocalScope;
                            TradeRegisterNotification.Send();
                            //Error(DuplicatEntryLbl, Rec.ISA_TradeRegister);
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
                        CustomerRec: Record Customer;
                    begin
                        CustomerRec.SetFilter(ISA_FiscalID, Rec.ISA_FiscalID);
                        if CustomerRec.Count > 0 then
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
                        CustomerRec: Record Customer;
                    begin
                        CustomerRec.SetFilter(ISA_StatisticalID, Rec.ISA_StatisticalID);
                        if CustomerRec.Count > 0 then
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
                        CustomerRec: Record Customer;
                    begin
                        CustomerRec.SetFilter(ISA_ItemNumber, Rec.ISA_ItemNumber);
                        if CustomerRec.Count > 0 then
                            Error(DuplicatEntryLbl, Rec.ISA_ItemNumber);
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

}