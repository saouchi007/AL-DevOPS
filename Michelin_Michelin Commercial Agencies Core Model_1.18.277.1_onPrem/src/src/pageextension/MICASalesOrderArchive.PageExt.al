pageextension 81821 "MICA Sales Order Archive" extends "Sales Order Archive"
{
    layout
    {
        addlast(General)
        {
            field("MICA Order Type"; Rec."MICA Order Type")
            {
                ApplicationArea = All;
            }
        }
        addlast(Content)
        {
            group("MICA Michelin")
            {
                field("MICA Shipment Post Option"; Rec."MICA Shipment Post Option")
                {
                    ApplicationArea = All;
                }
                field("MICA Created By"; Rec."MICA Created By")
                {
                    ApplicationArea = All;
                }
            }
        }

    }

    actions
    {
    }
}