pageextension 80081 "MICA GLEntriesNo2" extends "General Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("MICA No. 2"; Rec."MICA No. 2")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("MICA Currency Code"; Rec."MICA Currency Code")
            {
                ApplicationArea = All;
                Editable = false;
            }

            field("MICA Amount (FCY)"; Rec."MICA Amount (FCY)")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("MICA Source Type"; Rec."Source Type")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("MICA Source No."; Rec."Source No.")
            {
                ApplicationArea = All;
                Editable = false;

            }
            field("MICA Rebate Code"; Rec."MICA Rebate Code")
            {
                ApplicationArea = All;
            }

            field("MICA Additional Information 1"; Rec."MICA Additional Information 1")
            {
                ApplicationArea = All;
            }
            field("MICA Additional Information 2"; Rec."MICA Additional Information 2")
            {
                ApplicationArea = All;
            }
            field("MICA Additional Information 3"; Rec."MICA Additional Information 3")
            {
                ApplicationArea = All;
            }
            field("MICA Additional Information 4"; Rec."MICA Additional Information 4")
            {
                ApplicationArea = All;
            }
            field("MICA Amt. FCY To Be Erased"; Rec."MICA Amt. FCY To Be Erased")
            {
                ApplicationArea = All;
                Visible = VisibilityAmtFCYFields;
            }
            field("MICA Amt. FCY DateTime Mod."; Rec."MICA Amt. FCY DateTime Mod.")
            {
                ApplicationArea = All;
                Visible = VisibilityAmtFCYFields;
            }
            field("MICA Amt. FCY User Modified"; Rec."MICA Amt. FCY User Modified")
            {
                ApplicationArea = All;
                Visible = VisibilityAmtFCYFields;
            }
        }
    }
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId());
        VisibilityAmtFCYFields := UserSetup."MICA Allow Amt.FCY Era.Process";
    end;

    var
        VisibilityAmtFCYFields: Boolean;
}