page 50311 ISA_BookCard
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

                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field.';
                }
            }
            group(Details)
            {

                field(Author; Rec.Author)
                {
                    ToolTip = 'Specifies the value of the Author field.';
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
    trigger OnOpenPage()
    var
        Module: ModuleInfo;
        OpenMsgLbl: Label 'Dev translation for %1', Comment = '%1 is the extension name', Locked = false, MaxLength = 999;
    begin
        NavApp.GetCurrentModuleInfo(Module);
        Message(OpenMsgLbl, Module.Name);
    end;
}