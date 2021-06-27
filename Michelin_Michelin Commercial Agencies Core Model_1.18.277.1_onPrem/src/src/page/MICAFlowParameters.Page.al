page 80872 "MICA Flow Parameters"
{
    PageType = List;
    SourceTable = "MICA Flow Setup";
    Caption = 'Interface Flow Parameters';
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Flow; Rec."Flow")
                {
                    ApplicationArea = All;
                }
                field("Parameter Code"; Rec."Parameter Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec."Description")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec."Type")
                {
                    ApplicationArea = All;
                }
                field("Decimal Value"; Rec."Decimal Value")
                {
                    ApplicationArea = All;
                    Enabled = Rec.Type = 0;
                }
                field("Integer Value"; Rec."Integer Value")
                {
                    ApplicationArea = All;
                    Enabled = Rec.Type = 1;
                }
                field("Text Value"; Rec."Text Value")
                {
                    ApplicationArea = All;
                    Enabled = Rec.Type = 2;
                }
                field("Date Value"; Rec."Date Value")
                {
                    ApplicationArea = All;
                    Enabled = Rec.Type = 3;
                }
                field("Date Formula Value"; Rec."Date Formula Value")
                {
                    ApplicationArea = All;
                    Enabled = Rec.Type = 4;
                }
            }
        }
    }

}
