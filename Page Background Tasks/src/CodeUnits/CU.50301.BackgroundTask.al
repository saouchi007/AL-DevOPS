/// <summary>
/// Codeunit ISA_BackgroundTask (ID 50301).
/// </summary>
codeunit 50301 ISA_BackgroundTask
{
    trigger OnRun()
    var
        Customers: Record Customer;
        myDictionary: Dictionary of [Text, Text];
    begin
        Customers.SetRange(Blocked, Customers.Blocked::All);
        myDictionary.Add('TotalBlockedCustomers', Format(Customers.Count));
        Sleep(10000);
        Page.SetBackgroundTaskResult(myDictionary);
    end;

}