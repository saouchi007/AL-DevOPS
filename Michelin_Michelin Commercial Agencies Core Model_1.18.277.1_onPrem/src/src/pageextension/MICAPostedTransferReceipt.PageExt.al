pageextension 81466 "MICA Posted Transfer Receipt" extends "Posted Transfer Receipt"
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
                field("MICA ASN Date"; Rec."MICA ASN Date")
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

                field("MICA ARSTOCK Integrated"; Rec."MICA ARSTOCK Integrated")
                {
                    ApplicationArea = All;
                }
                field("MICA Maritime Air Number"; Rec."MICA Maritime Air Number")
                {
                    ApplicationArea = All;
                }
                field("MICA Maritime Air Company Name"; Rec."MICA Maritime Air Company Name")
                {
                    ApplicationArea = All;
                }
                field("MICA Action From Page"; Rec."MICA Action From Page")
                {
                    ApplicationArea = All;
                }
            }

            field("MICA Vendor Order No."; Rec."MICA Vendor Order No.")
            {
                ApplicationArea = All;
            }

        }

    }

    actions
    {
        addlast(Processing)
        {
            action("MICA ARSTOCK message")
            {
                Caption = 'ARSTOCK message';
                ApplicationArea = All;
                Image = SendElectronicDocument;
                RunObject = codeunit "MICA ARSTOCK message to DOO";
            }
        }
    }
}