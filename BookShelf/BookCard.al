page 50200 BookCard
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Book;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Title; "Title")
                {
                    ApplicationArea = All;
                }
            }
            group(Details)
            {
                Caption = 'Details';
                field(Author; "Author")
                {
                    ApplicationArea = All;
                }
                field(Hardcover; "Hardcover")
                {
                    ApplicationArea = All;
                }
                field("Page Count"; "Page Count")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}