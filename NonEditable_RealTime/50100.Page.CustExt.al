pageextension 50100 CustExt extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field(Locked; Rec.Locked)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }
}