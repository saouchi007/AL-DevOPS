page 82600 "MICA Flow Result"
{
    Caption = 'Flow Integration';
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "MICA Flow Result";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group("Send Flow")
            {
                Visible = (Rec."MICA Send Last Flow Entry No." <> 0);

                field("MICA Send Last Flow Entry No."; Rec."MICA Send Last Flow Entry No.")
                {
                    ApplicationArea = All;
                }

                field("Send Last DateTime"; Rec."MICA Send Last DateTime")
                {
                    ApplicationArea = All;
                }
                field("Send Last Flow Status"; Rec."MICA Send Last Flow Status")
                {
                    ApplicationArea = All;
                }
                field("MICA Send Last Info Count"; Rec."MICA Send Last Info Count")
                {
                    ApplicationArea = All;
                }

                field("MICA Send Last Warning Count"; Rec."MICA Send Last Warning Count")
                {
                    ApplicationArea = All;
                }

                field("MICA Send Last Error Count"; Rec."MICA Send Last Error Count")
                {
                    ApplicationArea = All;
                }


            }
            group("Receive Flow")
            {
                Visible = (Rec."MICA Rcv. Last Flow Entry No." <> 0);
                field("MICA Receive Last Flow Entry No."; Rec."MICA Rcv. Last Flow Entry No.")
                {
                    ApplicationArea = All;

                }
                field("Receive Last DateTime"; Rec."MICA Receive Last DateTime")
                {
                    ApplicationArea = All;
                }
                field("Receive Last Flow Status"; Rec."MICA Receive Last Flow Status")
                {
                    ApplicationArea = All;
                }


                field("MICA Receive Last Info Count"; Rec."MICA Receive Last Info Count")
                {
                    ApplicationArea = All;
                }

                field("MICA Receive Last Warning Count"; Rec."MICA Rcv. Last Warning Count")
                {
                    ApplicationArea = All;
                }

                field("MICA Receive Last Error Count"; Rec."MICA Receive Last Error Count")
                {
                    ApplicationArea = All;
                }


            }
        }
    }

    procedure Initialize(SendLastFlowEntryNo: Integer; ReceiveLastFlowEntryNo: Integer; MICARecordID: RecordId)
    begin
        Rec."Entry No." += 1;
        Rec."MICA Send Last Flow Entry No." := SendLastFlowEntryNo;
        Rec."MICA Rcv. Last Flow Entry No." := ReceiveLastFlowEntryNo;
        Rec."MICA Record ID" := MICARecordID;
        if Not Rec.insert() then;

    end;


}