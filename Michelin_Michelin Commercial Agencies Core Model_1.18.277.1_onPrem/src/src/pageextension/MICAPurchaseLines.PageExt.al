pageextension 81140 "MICA Purchase Lines" extends "Purchase Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("MICA Send Last Flow Entry No."; Rec."MICA Send Last Flow Entry No.")
            {
                Visible = false;
                Editable = false;
                ApplicationArea = All;
            }
            field("MICA Send Last Flow Status"; Rec."MICA Send Last Flow Status")
            {
                Visible = false;
                Editable = false;
                ApplicationArea = All;
            }

            field("MICA Rcv. Last Flow Entry No."; Rec."MICA Rcv. Last Flow Entry No.")
            {
                Visible = false;
                Editable = false;
                ApplicationArea = All;
            }


            field("MICA Record ID"; Rec."MICA Record ID")
            {
                Visible = false;
                ApplicationArea = All;
            }

            field("MICA ASN No."; Rec."MICA ASN No.")
            {
                Visible = false;
                ApplicationArea = All;
            }

            field("MICA ASN Line No."; Rec."MICA ASN Line No.")
            {
                Visible = false;
                ApplicationArea = All;
            }

            field("MICA Country of Origin"; Rec."MICA Country of Origin")
            {
                Visible = false;
                ApplicationArea = All;
            }

            field("MICA Container ID"; Rec."MICA Container ID")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("MICA ETA"; Rec."MICA ETA")
            {
                Visible = false;
                ApplicationArea = All;
            }

            field("MICA SRD"; Rec."MICA SRD")
            {
                Visible = false;
                ApplicationArea = All;
            }

            field("MICA Seal No."; Rec."MICA Seal No.")
            {
                Visible = false;
                ApplicationArea = All;
            }

            field("MICA Port of Arrival"; Rec."MICA Port of Arrival")
            {
                Visible = false;
                ApplicationArea = All;
            }

            field("MICA Carrier Doc. No."; Rec."MICA Carrier Doc. No.")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("MICA Ctry. ISO Code/O. Manuf."; Rec."MICA Ctry. ISO Code/O. Manuf.")
            {
                ApplicationArea = all;
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
    {
    }
    trigger OnAfterGetRecord()
    begin
        CurrPage.FlowResult.Page.Initialize(Rec."MICA Send Last Flow Entry No.", Rec."MICA Rcv. Last Flow Entry No.", Rec."MICA Record ID");
    end;
}