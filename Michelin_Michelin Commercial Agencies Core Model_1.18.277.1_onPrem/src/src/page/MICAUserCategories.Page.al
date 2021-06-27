page 81180 "MICA User Categories"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "MICA User Category";
    Caption = 'User Categories';

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Code"; Rec."Code")
                {
                    Caption = 'Code';
                    ApplicationArea = All;

                }
                field(Description; Rec."Description")
                {
                    Caption = 'Description';
                    ApplicationArea = All;

                }
            }
        }

    }

}