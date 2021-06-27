page 80160 "MICA G/L Acc. Allowed Dim."
{
    PageType = List;
    SourceTable = "MICA G/L Acc. Allowed Dim.";
    Caption = 'G/L Account Allowed Dimensions';
    DataCaptionFields = "MICA G/L Account No.";
    DelayedInsert = true;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("MICA Dimension Code"; Rec."MICA Dimension Code")
                {
                    ApplicationArea = All;

                }
                field("MICA Dimension Value Code"; Rec."MICA Dimension Value Code")
                {
                    ApplicationArea = all;
                }
                field("MICA G/L Account No."; Rec."MICA G/L Account No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
            }
        }
    }
}