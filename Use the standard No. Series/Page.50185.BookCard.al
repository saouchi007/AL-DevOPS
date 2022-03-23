/// <summary>
/// Page ISA_BookCard (ID 50185).
/// </summary>
page 50185 ISA_BookCard
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ISA_Book;
    Caption = 'Book Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = All;

                }
            }
            group(Details)
            {
                Caption = 'Details';
                field(Author; Rec.Author)
                {
                    ApplicationArea = All;
                }
                field(PageCount; Rec.PageCount)
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}