/// <summary>
/// Page ISA_CustomerList (ID 50303).
/// </summary>
page 50303 ISA_CustomerList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Customer;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

            }
        }
        area(Factboxes)
        {

        }
    }


    trigger OnOpenPage()
    begin
        ISA_IsolatedEvent();
    end;

    //[IntegrationEvent(false, false, true)]
    internal procedure ISA_IsolatedEvent()
    begin

    end;
}