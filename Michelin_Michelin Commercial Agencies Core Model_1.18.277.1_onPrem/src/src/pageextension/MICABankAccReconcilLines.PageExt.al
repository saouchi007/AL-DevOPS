pageextension 80921 "MICA Bank Acc. Reconcil. Lines" extends "Bank Acc. Reconciliation Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("MICA Rcv. Last Flow Entry No."; Rec."MICA Rcv. Last Flow Entry No.")
            {
                ApplicationArea = All;
            }
            field("MICA Receive Last Flow Status"; Rec."MICA Receive Last Flow Status")
            {
                ApplicationArea = All;
            }

        }
        addafter(Description)
        {
            field("MICA Description 2"; Rec."MICA Description 2")
            {
                ApplicationArea = all;
                trigger OnAssistEdit()
                begin
                    Message(StrSubstNo(TxtDescMsg, Rec.FieldCaption("MICA Description 2"), Rec."MICA Description 2"));
                end;
            }
        }
        modify(Description)
        {
            trigger OnAssistEdit()
            begin
                Message(StrSubstNo(TxtDescMsg, Rec.FieldCaption(Description), Rec.Description));
            end;
        }

    }

    var
        TxtDescMsg: Label '%1\\%2';
}