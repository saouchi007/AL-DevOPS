pageextension 80922 "MICA Pstd. Pmt. Recon. Subform" extends "Pstd. Pmt. Recon. Subform"
{
    layout
    {
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