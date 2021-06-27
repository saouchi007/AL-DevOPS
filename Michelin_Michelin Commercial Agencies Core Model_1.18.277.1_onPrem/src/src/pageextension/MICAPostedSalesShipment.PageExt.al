pageextension 81062 "MICA Posted Sales Shipment" extends "Posted Sales Shipment"
{
    layout
    {
        addlast(General)
        {
            field("MICA Truck Driver Info"; Rec."MICA Truck Driver Info")
            {
                ApplicationArea = All;
            }
            field("MICA Truck License Plate"; Rec."MICA Truck License Plate")
            {
                ApplicationArea = All;
            }
            group("MICA Send Sales Document to Warehouse")
            {
                Caption = 'SEND DOCUMENT TO WAREHOUSE';
                field("MICA Stat./Send. S. Doc./Whse."; Rec."MICA Stat./Send. S. Doc./Whse.")
                {
                    ApplicationArea = All;
                }
                field("MICA Send. S. Doc./Whse. Text"; Rec."MICA Send. S. Doc./Whse. Text")
                {
                    ApplicationArea = All;
                    trigger OnAssistEdit()
                    begin
                        Rec.ShowSendEmailWhseErrorMessage();
                    end;
                }
                field("MICA S.Doc. Type to Send/Whse."; Rec."MICA S.Doc. Type to Send/Whse.")
                {
                    ApplicationArea = All;
                }
                field("MICA DT Email to Whse. Status"; Rec."MICA DT Email to Whse. Status")
                {
                    ApplicationArea = All;
                }
                field("MICA User Email to Whse. St."; Rec."MICA User Email to Whse. St.")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}