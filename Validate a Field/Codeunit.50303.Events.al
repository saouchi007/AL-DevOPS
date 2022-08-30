/// <summary>
/// Codeunit ISA_Events (ID 50303).
/// </summary>
codeunit 50303 ISA_Events
{

    [EventSubscriber(ObjectType::Page, Page::"Customer Card", 'OnBeforeValidateEvent', 'Phone No.', true, true)]
    local procedure ISA_Event(var Rec: Record Customer)
    begin
        Message('OnBeforeValidateEvent of the page');
        Rec."Phone No." := '666';
    end;
}