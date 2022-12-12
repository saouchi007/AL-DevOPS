/// <summary>
/// Codeunit ISA_toolBox (ID 50304).
/// </summary>
codeunit 50304 ISA_Isolated
{
    [EventSubscriber(ObjectType::Page, Page::ISA_CustomerList, 'IsolatedEvents', '', false, false)]
    local procedure MyProcedure()
    begin
        Error('This is an isolated event test !');
    end;
}