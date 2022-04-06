page 50191 ISA_BooksTemporary
{
    ApplicationArea = All;
    Caption = 'ISA_BooksTemporary';
    PageType = List;
    SourceTable = ISA_BookTemporary;
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No. "; Rec."No. ")
                {
                    ToolTip = 'Specifies the value of the No . field.';
                    ApplicationArea = All;
                }
                field(PageCount; Rec.PageCount)
                {
                    ToolTip = 'Specifies the value of the Page Count field.';
                    ApplicationArea = All;
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
