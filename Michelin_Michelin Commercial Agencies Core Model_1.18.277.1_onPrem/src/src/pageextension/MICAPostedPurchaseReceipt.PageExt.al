pageextension 81460 "MICA Posted Purchase Receipt" extends "Posted Purchase Receipt"
{
    layout
    {
        addlast(General)
        {
            group("MICA Michelin")
            {
                Caption = 'Michelin';

                field("MICA ASN No."; Rec."MICA ASN No.")
                {
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
            }

        }
    }
    actions
    {
        addlast("&Receipt")
        {
            action("MICA Create ASN Transfer Order")
            {
                Caption = 'Create ASN Transfer Order';
                ApplicationArea = All;
                Image = TransferOrder;
                Promoted = true;

                trigger OnAction()
                var
                    ASN: Codeunit "MICA ASN Integration";
                begin
                    ASN.CreateTransferOrder(Rec, 0); //Create
                    ASN.CreateTransferOrder(Rec, 1); //Ship
                end;
            }

            action("MICA Create and Post Transfer Order")
            {
                Caption = 'Create and Post Transfer Order';
                ApplicationArea = All;
                Image = TransferOrder;
                Promoted = true;

                trigger OnAction()
                var
                    PostProcessPurchOrd: Codeunit "MICA Flow PostProcessPurchOrd";
                begin
                    PostProcessPurchOrd.CreateAndPostTransferOrder(Rec);
                end;
            }
        }
    }
}