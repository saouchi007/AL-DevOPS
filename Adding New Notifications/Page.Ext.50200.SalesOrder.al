/// <summary>
/// PageExtension ISA_SalesOrders_Ext (ID 50200) extends Record Sales Order.
/// </summary>
pageextension 50200 ISA_SalesOrders_Ext extends "Sales Order"
{
    trigger OnOpenPage()
    var
        PostingDateNotification: Notification;
        PostingDateLbl: Label 'Posting date is different from the current date !';
        CheckWorkDate: Label 'Would you like to check work date ?';
        CreditBalanceNotification : Notification;
        CreditBalanceLbl : Label 'New Notification : The current balance exceeds the credit limit';
        ShowDetailsLbl : Label 'Show Details';
        Cust : Record Customer;
        CustNumber: Text;
    begin
        /* ------------- Notification only 
        if Rec."Posting Date" <> Today then begin
            PostingDateNotification.Message(PostingDateLbl);
            PostingDateNotification.Scope := NotificationScope::LocalScope;
            PostingDateNotification.Send();
        end;
        -----------------*/
        /*  Adding actions on a notification
        if Rec."Posting Date" <> Today then 
        begin
            PostingDateNotification.Message(PostingDateLbl);
            PostingDateNotification.Scope := NotificationScope::LocalScope;
            PostingDateNotification.AddAction(CheckWorkDate, Codeunit::ISA_NotificationActionHandler, 'OpenMySettings');
            PostingDateNotification.Send();
        end;
        ******************************************/
        //Sending data with a notification
        if Cust.Get(Rec."Sell-to Customer No.") then 
        begin
            Cust.CalcFields("Balance (LCY)");
            if Cust."Balance (LCY)" > Cust."Credit Limit (LCY)" then
            begin
                CreditBalanceNotification.Message(CreditBalanceLbl);
                CreditBalanceNotification.Scope := NotificationScope::LocalScope;
                CreditBalanceNotification.SetData(CustNumber, Cust."No.");
                CreditBalanceNotification.AddAction(ShowDetailsLbl, Codeunit::ISA_NotificationActionHandler,'OpenCustomerLedgerEntries');
                CreditBalanceNotification.Send();
            end;    
        end;
    end;
}