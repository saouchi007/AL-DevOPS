page 50305 ISA_CustomerList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Customer;
    Caption = 'ISA Customer List';

    trigger OnOpenPage()
    begin
        IsolatedEvents();
    end;

    [IntegrationEvent(false, false, true)]
    internal procedure IsolatedEvents()
    begin
        //the last boolean in IntegrationEvent is dedicated to isolated events, true to activate isolated events
        // in the even sub on codeunit 50304, a page is used and the procedure name as an anchor IsolatedEvents
        // when the latter is executed in this page OnOpenPage trigger , then CU would kick in with MyProcedure
    end;

    /// <summary>
    /// IsolatedEventsAlpha.
    /// </summary>
    [BusinessEvent(false, true)]
    procedure IsolatedEventsAlpha()
    begin

    end;
}