pageextension 81620 "MICA Whse. Shipment Lines" extends "Whse. Shipment Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("MICA Shipment Date in SO"; Rec."MICA Shipment Date in SO")
            {
                ApplicationArea = All;
            }
            field("MICA Planed Shipm. Date in SO"; Rec."MICA Planed Shipm. Date in SO")
            {
                ApplicationArea = All;
            }
            field("MICA Planned Deliv. Date in SO"; Rec."MICA Planned Deliv. Date in SO")
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
    }
}