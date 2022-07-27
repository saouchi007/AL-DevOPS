/// <summary>
/// PageExtension Id.
/// </summary>
pageextension 50121 ISA_FA_Comments extends "Fixed Asset Card"
{
    trigger OnOpenPage()
    var
        FA_Comments: Record "Comment Line";
        CommentFetched: Text;
    begin
        FA_Comments.SetFilter("Table Name", 'Fixed Asset');
        FA_Comments.SetRange("No.", 'FA000010');

        if FA_Comments.FindSet then begin
            repeat begin
                CommentFetched += '- ' + FA_Comments.Comment + '\';
            end until FA_Comments.Next = 0;
        end;
        Message(CommentFetched);
    end;
}