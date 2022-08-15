/// <summary>
/// Page ISA_CustomerCue (ID 50303).
/// </summary>
page 50303 ISA_CustomerCue
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Tasks;
    RefreshOnActivate = true;
    Caption = 'Customer Cue';
    SourceTable = ISA_CustomerCue;

    layout
    {
        area(Content)
        {
            cuegroup(GroupName)
            {
                Caption = 'Blocked Customers';
                field(BlockedCustomers; BlockedCustomersVar)
                {
                    Caption = 'By Variable';
                    ApplicationArea = All;
                    StyleExpr = Style;

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
                field(BlockedCustomersFlowField; Rec.BlockedCustomers)
                {
                    Caption = 'By FlowField';
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;

    trigger OnAfterGetCurrRecord()
    var
        Cust: Record Customer;
    begin
        Cust.SetRange(Blocked, Cust.Blocked::All);
        BlockedCustomersVar := Cust.Count;

        if BlockedCustomersVar > 2 then
            Style := 'Unfavorable';
    end;

    var
        myInt: Integer;
        BlockedCustomersVar: Integer;
        Style: Text;
}