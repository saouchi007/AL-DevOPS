/// <summary>
/// PageExtension ISA_SalesOrder (ID 50200) extends Record Sales Order.
/// </summary>
pageextension 50200 ISA_SalesOrder extends "Customer Card"
{
    layout
    {
        modify("Responsibility Center")
        {
            trigger OnAfterValidate()
            var
                ResponsabilityCenterNotification: Notification;
                ResponsabilityCenterNotificationLbl: Label 'New Notification : Current responsability center is over used !';
                ShowDetailsLbl: Label 'Show Details';
                Cust: Record Customer;
                OpenCustLedgerEntries: Text;
                CurrentRespCenter: Text;
            begin

                if Rec."Responsibility Center" <> '' then begin
                    Cust.SetRange("Responsibility Center", Rec."Responsibility Center");
                    if Cust.Count > 0 then begin
                        ResponsabilityCenterNotification.Message(ResponsabilityCenterNotificationLbl);
                        ResponsabilityCenterNotification.Scope := NotificationScope::LocalScope;
                        ResponsabilityCenterNotification.SetData(CurrentRespCenter, Rec."Responsibility Center");
                        ResponsabilityCenterNotification.AddAction(ShowDetailsLbl, Codeunit::ISA_NotificationHandler, 'OpenCustomersList');
                        ResponsabilityCenterNotification.Send();
                    end;
                end;
            end;
        }
    }
}