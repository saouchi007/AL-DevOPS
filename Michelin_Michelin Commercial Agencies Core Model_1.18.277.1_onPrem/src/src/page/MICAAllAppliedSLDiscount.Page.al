page 80187 "MICA All Applied SL Discount"
{
    Caption = 'Applied Sales Line Discount';
    // version OFFINVOICE
    ApplicationArea = All;
    Editable = false;
    PageType = List;
    SourceTable = "MICA Posted Applied SL Disc.";
    UsageCategory = Lists;
    SourceTableTemporary = true;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Rebates Type"; Rec."Rebates Type")
                {
                    ApplicationArea = All;
                }

                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ApplicationArea = All;
                }

                field("Sales Type"; Rec."Sales Type")
                {
                    ApplicationArea = All;
                }
                field("Sales Code"; Rec."Sales Code")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Product Line"; Rec."Product Line")
                {
                    ApplicationArea = All;
                }
                field(Brand; Rec.Brand)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Sales Discount %"; Rec."Sales Discount %")
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec."MICA Status")
                {
                    ApplicationArea = All;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                    ApplicationArea = All;
                }
                field("Posted Document Line No."; Rec."Posted Document Line No.")
                {
                    ApplicationArea = All;
                }
                field("MICA Source Document No."; Rec."MICA Source Document No.")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    trigger OnInit()
    var
        MICANewAppliedSLDiscount: Record "MICA New Applied SL Discount";
        MICAPostedAppliedSLDisc: Record "MICA Posted Applied SL Disc.";
        EntryNo: Integer;
    begin
        if MICANewAppliedSLDiscount.FindSet() then
            repeat
                Rec.Init();
                Rec.TransferFields(MICANewAppliedSLDiscount);
                MICANewAppliedSLDiscount.CalcFields(Status);
                Rec."MICA Status" := MICANewAppliedSLDiscount.Status;
                EntryNo += 1;
                Rec."Entry No." := EntryNo;
                Rec.Insert();
            until MICANewAppliedSLDiscount.Next() = 0;
        if MICAPostedAppliedSLDisc.FindSet() then
            repeat
                Rec.Init();
                Rec.TransferFields(MICAPostedAppliedSLDisc);
                EntryNo += 1;
                Rec."Entry No." := EntryNo;
                Rec.Insert();
            until MICAPostedAppliedSLDisc.Next() = 0;
    end;


}