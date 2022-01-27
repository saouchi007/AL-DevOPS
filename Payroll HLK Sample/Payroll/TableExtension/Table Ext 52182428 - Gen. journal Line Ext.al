/// <summary>
/// TableExtension Gen. journal Line Ext (ID 52182428) extends Record Gen. Journal Line.
/// </summary>
tableextension 52182428 "Gen. journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(50006; "Description 2"; Text[200])
        {
            Caption = 'Description 2';
        }
        field(50007; "Employee code"; Code[20])
        {
        }
    }

    var
        myInt: Integer;
}