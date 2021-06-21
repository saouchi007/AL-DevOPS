tableextension 50101 MoveUpandDown extends "Sales Line"
{
    fields
    {
        field(50100; LinePosition; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line Position';
        }
    }

    trigger OnAfterInsert()
    begin
        LinePosition := FindLastPosition() + 1;
        Rec.Modify();
    end;

    procedure FindLastPosition(): Integer
    var
        salesLine: Record "Sales Line";
    begin
        salesLine.Reset();
        salesLine.SetRange("Document Type", "Document Type");
        salesLine.SetRange("Document No.", "Document No.");
        salesLine.SetCurrentKey(LinePosition);
        salesLine.Ascending(true);
        if salesLine.FindLast() then
            exit(salesLine.LinePosition)
        else
            exit(0);
    end;
}