page 81021 "MICA STE4 Key Allocation"
{
    Caption = 'Key Allocation';
    PageType = List;
    Editable = false;
    SourceTable = "MICA STE4 Key Allocation";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Date Of Calculation"; Rec."Date Of Calculation")
                {
                    ApplicationArea = All;
                }
                field("LB Code"; Rec."LB Code")
                {
                    ApplicationArea = All;
                }
                field("% Allocation"; Rec."% Allocation")
                {
                    ApplicationArea = All;
                }
                field("LB Amount"; Rec."LB Amount")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange(UserId, Database.UserId());
        Rec.FilterGroup(0);
    end;
}