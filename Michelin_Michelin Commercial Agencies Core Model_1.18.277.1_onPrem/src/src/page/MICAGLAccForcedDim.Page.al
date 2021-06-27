page 80120 "MICA G/L Acc. Forced Dim."
{
    PageType = List;
    SourceTable = "MICA G/L Acc. Forced Dim.";
    Caption = 'G/L Account Forced Dimensions';
    DataCaptionFields = "MICA G/L Account No.";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("MIC G/L Account No."; Rec."MICA G/L Account No.")
                {
                    ApplicationArea = all;
                }
                field("MIC Dimension Code"; Rec."MICA Dimension Code")
                {
                    ApplicationArea = All;

                }
                field("MIC Dimension Value Code"; Rec."MICA Dimension Value Code")
                {
                    ApplicationArea = all;
                }

            }
        }
    }
}