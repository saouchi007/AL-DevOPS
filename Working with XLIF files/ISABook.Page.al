/// <summary>
/// Page ISA_BookList (ID 50310).
/// </summary>
page 50310 ISA_BookList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = ISA_Book;
    Caption = 'Book List';
    CardPageId = ISA_BookCard;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Author; Rec.Author)
                {
                    ToolTip = 'Specifies the value of the Author field.';
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field.';
                }
                field(Hardcover; Rec.Hardcover)
                {
                    ToolTip = 'Specifies the value of the Hardcover field.';
                }
                field(PageCount; Rec.PageCount)
                {
                    ToolTip = 'Specifies the value of the Page Count field.';
                }
            }
        }

    }

   }