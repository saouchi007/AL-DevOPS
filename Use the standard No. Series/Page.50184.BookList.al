/// <summary>
/// Page ISA_BookList (ID 50184).
/// </summary>
page 50184 ISA_BookList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = ISA_Book;
    Caption = 'Book List';
    ModifyAllowed = false;
    CardPageId = 50185;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No.";Rec."No.")
                {
                    ApplicationArea = All;
                    
                }
                field(Title;Rec.Title)
                {
                    ApplicationArea = All;
                    
                }
                field(Author;Rec.Author)
                {
                    ApplicationArea = All;
                    
                }
                field(PageCount;Rec.PageCount)
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