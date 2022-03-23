/// <summary>
/// PageExtension ISA_ItemCard (ID 50188) extends Record Item Card.
/// </summary>
pageextension 50188 ISA_ItemCard extends "Item Card"
{
    layout
    {
        addafter("Purchasing Code")
        {
            field(VideoURL; Rec.VideoURL)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a video url';
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            action(PlayVideo)
            {
                Caption = 'Play Video';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Picture;
                ApplicationArea = All;

                trigger OnAction()
                var
                    Video: Codeunit Video;
                begin
                    Video.Play(Rec.VideoURL);
                end;
            }
        }
    }

}