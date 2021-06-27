pageextension 80782 "MICA Document Sending Profile" extends "Document Sending Profile" //MyTargetPageId
{
    layout
    {
        addlast(General)
        {
            field("MICA Daily Sent"; Rec."MICA Daily Sent")
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
    }
}