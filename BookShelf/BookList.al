page 50101 BookList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Book;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;

                }
                field(Title; "Title")
                {
                    ApplicationArea = All;
                }
                field(Author; "Author")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}