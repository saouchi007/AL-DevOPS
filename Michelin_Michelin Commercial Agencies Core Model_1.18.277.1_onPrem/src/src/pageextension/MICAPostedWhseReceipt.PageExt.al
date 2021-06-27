pageextension 81124 "MICA Posted Whse. Receipt" extends "Posted Whse. Receipt"
{
    layout
    {
        addlast(General)
        {
            group("MICA Michelin")
            {
                Caption = 'Michelin';

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
                    ApplicationArea = All;
                }
                field("MICA Maritime Air Number"; Rec."MICA Maritime Air Number")
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
            }
        }

        addlast(Content)
        {
            group("MICA Flow Integration")
            {
                Caption = 'Flow Integration';

                field("MICA Send Last Flow Entry No."; Rec."MICA Send Last Flow Entry No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("MICA Send Last Flow Status"; Rec."MICA Send Last Flow Status")
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
            part(FlowResult; "MICA Flow Result")
            {
                ApplicationArea = All;
                SubPageLink = "MICA Send Last Flow Entry No." = FIELD("MICA Send Last Flow Entry No."), "MICA Rcv. Last Flow Entry No." = FIELD("MICA Rcv. Last Flow Entry No.");
            }
        }

    }
    actions
    {   //DOO-005 test>>
        // addafter("F&unctions")
        // {
        //     action("MICA Init Receipt")
        //     {
        //         Image = "8ball";
        //         trigger OnAction()
        //         var
        //             Header: Record "Posted Whse. Receipt Header";
        //             Line: Record "Posted Whse. Receipt Line";
        //         begin
        //             Header.Get(Rec."No.");
        //             Header."MICA Send Ack. Received" := false;
        //             Header.Modify();

        //             Line.SetRange("No.", Header."No.");
        //             Line.FindSet();
        //             Line."MICA ASN No." := 'ASN01';
        //             Line."MICA ASN Line No." := Line."Line No." + 1;
        //             Line."MICA Container ID" := 'Container 01';
        //             Line."MICA AL No." := 'AL 01';
        //             Line."MICA AL Line No." := Format(Line."Line No.", 0, 9);
        //             Line.Modify();
        //             while Line.Next() <> 0 do begin
        //                 Line."MICA ASN No." := 'ASN02';
        //                 Line."MICA ASN Line No." := Line."Line No." + 1;
        //                 Line."MICA Container ID" := 'Container 02';
        //                 Line."MICA AL No." := 'AL 02';
        //                 Line."MICA AL Line No." := Format(Line."Line No.", 0, 9);
        //                 Line.Modify();
        //             end;
        //         end;
        //     }
        // }
        //DOO-005 test<<
    }

    trigger OnAfterGetRecord()
    begin
        CurrPage.FlowResult.Page.Initialize(Rec."MICA Send Last Flow Entry No.", Rec."MICA Rcv. Last Flow Entry No.", Rec."MICA Record ID");
    end;

}