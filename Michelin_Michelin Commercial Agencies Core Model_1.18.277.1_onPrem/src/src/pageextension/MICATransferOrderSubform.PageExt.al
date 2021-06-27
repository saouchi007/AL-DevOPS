pageextension 81462 "MICA Transfer Order Subform" extends "Transfer Order Subform"
{
    layout
    {
        modify("Receipt Date")
        {
            Caption = 'Availability date';
        }

        addlast(Control1)
        {
            field("MICA ASN No."; Rec."MICA ASN No.")
            {
                ApplicationArea = All;
                Editable = (Rec.Status = Rec.Status::Open);
            }
            field("MICA ASN Line No."; Rec."MICA ASN Line No.")
            {
                ApplicationArea = All;
                Editable = (Rec.Status = Rec.Status::Open);
            }
            field("MICA AL No."; Rec."MICA AL No.")
            {
                ApplicationArea = All;
            }
            field("MICA AL Line No."; Rec."MICA AL Line No.")
            {
                ApplicationArea = All;
            }
            field("MICA Purchase Order No."; Rec."MICA Purchase Order No.")
            {
                ApplicationArea = All;
                Editable = (Rec.Status = Rec.Status::Open);
            }
            field("MICA Purchase Order Line No."; Rec."MICA Purchase Order Line No.")
            {
                ApplicationArea = All;
                Editable = (Rec.Status = Rec.Status::Open);
            }
            field("MICA Container ID"; Rec."MICA Container ID")
            {
                ApplicationArea = All;
                Editable = (Rec.Status = Rec.Status::Open);
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
                Editable = (Rec.Status = Rec.Status::Open);
            }
            field("MICA Port of Arrival"; Rec."MICA Port of Arrival")
            {
                ApplicationArea = All;
                Editable = (Rec.Status = Rec.Status::Open);
            }
            field("MICA Carrier Doc. No."; Rec."MICA Carrier Doc. No.")
            {
                ApplicationArea = All;
                Editable = (Rec.Status = Rec.Status::Open);
            }
            field("MICA Country of Origin"; Rec."MICA Country of Origin")
            {
                ApplicationArea = All;
                Editable = (Rec.Status = Rec.Status::Open);
            }
            field("MICA DC14"; Rec."MICA DC14")
            {
                ApplicationArea = All;
            }
            field("MICA Ctry. ISO Code/O. Manuf."; Rec."MICA Ctry. ISO Code/O. Manuf.")
            {
                ApplicationArea = all;
                Editable = (Rec.Status = Rec.Status::Open);
            }
        }
    }

    actions
    {
    }
}