/// <summary>
/// Page ISA_Best_Sellers (ID 50329).
/// </summary>
page 50329 ISA_Best_Sellers
{
    PageType = List;
    Caption = 'ISA Best Sellers';
    UsageCategory = None;
    SourceTable = ISA_Best_Sellers;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    DataCaptionFields = "List Name";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                
                field("Book Title"; Rec."Book Title")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Book Title field.';
                }
                field("Book Description"; Rec."Book Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Book Description field.';
                }
                field("Book Author"; Rec."Book Author")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Book Author field.';
                }
                field("Amazon URL"; Rec."Amazon URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amazon URL field.';
                }
            }
        }
        
    }
    
}