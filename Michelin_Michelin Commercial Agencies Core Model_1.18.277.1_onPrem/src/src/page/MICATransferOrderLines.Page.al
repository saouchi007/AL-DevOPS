page 82100 "MICA Transfer Order Lines"
{
    PageType = List;
    Caption = 'Transfer Orders In Transit';
    ApplicationArea = all;
    UsageCategory = Lists;
    SourceTable = "Transfer Line";
    SourceTableTemporary = true;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("MICA ASN No."; Rec."MICA ASN No.")
                {
                    ApplicationArea = All;

                }
                field("MICA ASN Line No."; Rec."MICA ASN Line No.")
                {
                    ApplicationArea = All;
                }
                field("MICA AL No."; Rec."MICA AL No.")
                {
                    ApplicationArea = All;
                }
                field("MICA Purchase Order No."; Rec."MICA Purchase Order No.")
                {
                    ApplicationArea = All;
                }
                field("MICA Container ID"; Rec."MICA Container ID")
                {
                    ApplicationArea = All;
                }
                field("MICA ETA"; Rec."MICA ETA")
                {
                    ApplicationArea = All;
                }
                field("MICA SRD"; Rec."MICA SRD")
                {
                    ApplicationArea = All;
                }
                field("MICA Initial ETA"; Rec."MICA Initial ETA")
                {
                    ApplicationArea = All;
                }
                field("MICA Initial SRD"; Rec."MICA Initial SRD")
                {
                    ApplicationArea = All;
                }
                field("MICA Port of Arrival"; Rec."MICA Port of Arrival")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Reserved Quantity Inbnd."; Rec."Reserved Quantity Inbnd.")
                {
                    ApplicationArea = All;
                }
                field("Reserved Quantity Outbnd."; Rec."Reserved Quantity Outbnd.")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("MICA Whse. Receipt No."; Rec."MICA Whse. Receipt No.")
                {
                    ApplicationArea = All;
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    ApplicationArea = All;
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ApplicationArea = All;
                }
                field("MICA DC14"; Rec."MICA DC14")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Create Whse. Receipt")
            {
                Caption = 'Create Whse. Receipt';
                ApplicationArea = All;
                Image = NewWarehouseReceipt;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Location: Record Location;
                    ReceiptDocTo3PL: Codeunit "MICA Receipt Doc. To 3PL";
                begin
                    Location.SetRange("Require Receive", true);
                    if Location.FindSet() then
                        repeat
                            ReceiptDocTo3PL.ProcessTransferOrder(Location);
                        until Location.Next() = 0;
                    InitData();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        InitData();
    end;

    local procedure InitData()
    var
        MICATransferInTransitMgt: Codeunit "MICA Transfer In Transit Mgt.";
    begin
        MICATransferInTransitMgt.FillTempTransferLine(Rec);
        Rec.Reset();
    end;


}