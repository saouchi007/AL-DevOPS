pageextension 81122 "MICA Warehouse Receipt" extends "Warehouse Receipt"
{
    layout
    {
        addlast(General)
        {
            field("MICA Return Order With Collect"; Rec."MICA Return Order With Collect")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("MICA Container ID"; Rec."MICA Container ID")
            {
                ApplicationArea = All;
            }
            field("MICA Maritime Air Company Name"; Rec."MICA Maritime Air Company Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("MICA Maritime Air Number"; Rec."MICA Maritime Air Number")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("MICA ETA"; Rec."MICA ETA")
            {
                ApplicationArea = All;
            }
            field("MICA SRD"; Rec."MICA SRD")
            {
                ApplicationArea = All;
            }
            field("MICA Seal No."; Rec."MICA Seal No.")
            {
                ApplicationArea = All;
            }
            field("MICA Port of Arrival"; Rec."MICA Port of Arrival")
            {
                ApplicationArea = All;
            }
            field("MICA Carrier Doc. No."; Rec."MICA Carrier Doc. No.")
            {
                ApplicationArea = All;
            }
            field("MICA 3PL Update Status"; Rec."MICA 3PL Update Status")
            {
                ApplicationArea = All;
            }
            field("MICA Retrieve-From Addr. Code"; Rec."MICA Retrieve-From Addr. Code")
            {
                ApplicationArea = All;
            }
            field("MICA Retrieve-From Address"; Rec."MICA Retrieve-From Address")
            {
                ApplicationArea = All;
            }
        }
        addlast(Content)
        {
            group("MICA Michelin")
            {
                Caption = 'Michelin';
                field("MICA Send Last Flow Entry No."; Rec."MICA Send Last Flow Entry No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }


                field("MICA Send Ack. Received"; Rec."MICA Send Ack. Received")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("MICA Rcv. Last Flow Entry No."; Rec."MICA Rcv. Last Flow Entry No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }

                field("MICA Record ID"; Rec."MICA Record ID")
                {
                    ApplicationArea = All;
                }
            }

        }

        addlast(FactBoxes)
        {
            part(FlowIntegration; "MICA FlowInt-Whs. Receipt Line")
            {
                Provider = WhseReceiptLines;
                ApplicationArea = All;
                SubPageLink = "No." = field("No."), "Line No." = field("Line No.");
            }
            part(FlowResult; "MICA Flow Result")
            {
                Caption = 'Flow Integration (Header)';
                ApplicationArea = All;
                SubPageLink = "MICA Send Last Flow Entry No." = FIELD("MICA Send Last Flow Entry No."), "MICA Rcv. Last Flow Entry No." = FIELD("MICA Rcv. Last Flow Entry No.");
            }
        }

        addafter("Document Status")
        {
            field("MICA Status"; Rec."MICA Status")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast("F&unctions")
        {
            action("MICA Release")
            {
                Caption = 'Release';
                ApplicationArea = all;
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    ReleaseWhseReceipt: Codeunit "MICA Whse.-Receipt Release";
                begin
                    CurrPage.Update(true);
                    if Rec."MICA Status" = Rec."MICA Status"::Open then
                        ReleaseWhseReceipt.Release(Rec);
                    CurrPage.Update(false);
                end;
            }

            action("MICA Reopen")
            {
                Caption = 'Reopen';
                ApplicationArea = all;
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    ReleaseWhseReceipt: Codeunit "MICA Whse.-Receipt Release";
                begin
                    CurrPage.Update(true);
                    if Rec."MICA Status" = Rec."MICA Status"::Released then
                        ReleaseWhseReceipt.Reopen(Rec);
                    CurrPage.Update(true);
                end;
            }

        }
        modify("Post and &Print")
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField("MICA Status", rec."MICA Status"::Released);
                CheckIfIntegratedTo3PL();
            end;
        }
        modify("Post and Print P&ut-away")
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField("MICA Status", rec."MICA Status"::Released);
                CheckIfIntegratedTo3PL();
            end;
        }

        modify("Post Receipt")
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField("MICA Status", rec."MICA Status"::Released);
                CheckIfIntegratedTo3PL();
            end;
        }
    }

    trigger OnModifyRecord(): Boolean
    begin
        Rec.TestField("MICA Status", rec."MICA Status"::Open);
    end;

    trigger OnAfterGetRecord()
    begin
        CurrPage.FlowResult.Page.Initialize(Rec."MICA Send Last Flow Entry No.", Rec."MICA Rcv. Last Flow Entry No.", Rec."MICA Record ID");
    end;

    local procedure CheckIfIntegratedTo3PL()
    var
        Location: Record Location;
        GIT3PIntegrationLbl: Label 'GIT Receipt sent to 3PL. Document should be posted by 3PL integration. Do you really want to continue?';
    begin
        if Location.Get(Rec."Location Code") then
            if Location."MICA 3PL Integration" then
                if not Dialog.Confirm(GIT3PIntegrationLbl, false) then
                    Error('');
    end;


}

