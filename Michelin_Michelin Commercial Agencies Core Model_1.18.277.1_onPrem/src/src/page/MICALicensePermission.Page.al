page 80877 "MICA License Permission"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "License Permission";
    Editable = false;
    caption = 'License Permission';

    layout
    {
        area(Content)
        {
            repeater(List)
            {
                field("Object Type"; Rec."Object Type") { ApplicationArea = All; }
                field("Object Number"; Rec."Object Number") { ApplicationArea = All; }
                field("Read Permission"; Rec."Read Permission") { ApplicationArea = All; }
                field("Modify Permission"; Rec."Modify Permission") { ApplicationArea = All; }
                field("Insert Permission"; Rec."Insert Permission") { ApplicationArea = All; }
                field("Execute Permission"; Rec."Execute Permission") { ApplicationArea = All; }
                field("Delete Permission"; Rec."Delete Permission") { ApplicationArea = All; }
                field("Limited Usage Permission"; Rec."Limited Usage Permission") { ApplicationArea = All; }

            }
        }
    }
#if OnPremise
    actions
    {
        area(Processing)
        {
            action(LicenseInformation)
            {
                Caption = 'License Information';
                ApplicationArea = All;
                RunObject = page "MICA License Information";
                Promoted = true;
                Image = ExportFile;
                PromotedOnly = true;
                PromotedCategory = Process;

            }
        }
    }
#endif
}