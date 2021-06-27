pageextension 82061 "MICA Vendor Bank Account List" extends "Vendor Bank Account List"
{
    layout
    {
        addafter(Name)
        {
            field("MICA Name 2"; Rec."Name 2")
            {
                ApplicationArea = All;
            }
        }
        addlast(Control1)
        {
            field("MICA Blocked"; Rec."MICA Blocked")
            {
                ApplicationArea = All;
            }
        }
    }
    
}