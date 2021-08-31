pageextension 50104 CustCardExt extends "Customer Card"
{
    layout
    {
        addafter("Document Sending Profile")
        {
            field("Earliest Contact Date/Time"; Rec."Earliest Contact Date/Time")
            {
                ApplicationArea = all;
            }
        }

    }

}