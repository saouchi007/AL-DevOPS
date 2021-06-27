page 80876 "MICA Sample Sub Line List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "MICA Sample Sub Line";
    Caption = 'Sample Sub Line List';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Logical Id"; Rec."Logical Id")
                {
                    ApplicationArea = All;
                }
                field("Location Id"; Rec."Location Id")
                {
                    ApplicationArea = All;
                }
                field("Item Id"; Rec."Item Id")
                {
                    ApplicationArea = All;
                }
                field("Attribute Id"; Rec."Attribute Id")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}