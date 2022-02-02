/// <summary>
/// Codeunit PorductVideoHandler (ID 50137).
/// </summary>
codeunit 50137 PorductVideoHandler
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::Video, 'OnRegisterVideo', '', false, false)]
    local procedure OnRegisterVideo(var Sender: Codeunit Video)
    var
        NewProductVideoLinks: Record NewVideoProdLink;
    begin
        NewProductVideoLinks.Reset();
        if NewProductVideoLinks.FindSet() then
            repeat
                Sender.Register(NewProductVideoLinks.AppID, NewProductVideoLinks.Title, NewProductVideoLinks.VideoURL, NewProductVideoLinks.Category);
            until NewProductVideoLinks.Next() = 0;
    end;
}