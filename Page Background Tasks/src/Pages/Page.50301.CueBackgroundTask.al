/// <summary>
/// Page ISA_CueBackgroundTask (ID 50301).
/// </summary>
page 50301 ISA_CueBackgroundTask
{
    PageType = CardPart;
    RefreshOnActivate = true;
    Caption = 'Cue Background Task';

    layout
    {
        area(Content)
        {
            cuegroup(GroupName)
            {
                Caption = 'Page Background Task Group';
                field(BlockedCustomers; BlockedCustomers)
                {
                    ApplicationArea = All;
                    Caption = 'Blocked Cus  tomers';
                    trigger OnDrillDown()
                    var
                        Cust: Record Customer;
                        CustomerList: Page "Customer List";
                    begin
                        Cust.SetRange(Blocked, Cust.Blocked::All);
                        CustomerList.SetTableView(Cust);
                        CustomerList.Run();
                    end;
                }
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.EnqueueBackgroundTask(TaskID, Codeunit::ISA_BackgroundTask);
    end;

    trigger OnPageBackgroundTaskCompleted(TaskID: Integer; Result: Dictionary of [Text, Text])
    begin
        Evaluate(BlockedCustomers, Result.Get('TotalBlockedCustomers'))
    end;

    trigger OnPageBackgroundTaskError(TaskID: Integer; ErrorCode: Text; ErrorText: Text; ErrorCallStack: Text; var isHandled: Boolean)
    begin

    end;

    var
        BlockedCustomers: Integer;
        TaskID: Integer;
        Style: Text;
}