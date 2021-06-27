pageextension 81461 "MICA Posted Purchase Rcpt Line" extends "Posted Purchase Receipt Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("MICA ASN No."; Rec."MICA ASN No.")
            {
                ApplicationArea = All;
            }
            field("MICA ASN Line No."; Rec."MICA ASN Line No.")
            {
                ApplicationArea = All;
            }
            field("MICA Country of Origin"; Rec."MICA Country of Origin")
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
            field("MICA Ctry. ISO Code/O. Manuf."; Rec."MICA Ctry. ISO Code/O. Manuf.")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }
}