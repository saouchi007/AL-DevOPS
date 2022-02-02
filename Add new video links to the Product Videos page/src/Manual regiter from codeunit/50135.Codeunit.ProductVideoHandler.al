/// <summary>
/// Codeunit ProductVideoHandler (ID 50135).
/// </summary>
codeunit 50135 ProductVideoHandler
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::Video, 'OnRegisterVideo', '', false, false)]
    local procedure OnRegisterVideo(var Sender: Codeunit Video);
    begin
        Sender.Register('{e0012966-f86e-4add-8c23-cc6f8cae720c}', 'New Product Video', 'https://www.youtube.com/embed/TPZhMtoAACw', Enum::"Video Category"::Warehouse);
    end;
}

