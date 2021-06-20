tableextension 50100 CustomerExt extends Customer
{
    fields
    {
        field(50100; "Bonuses"; Integer)
        {
            Caption = 'Bonuses';
            FieldClass = FlowField;
            CalcFormula = count(BonusHeaderTable where("Customer No." = field("No.")));
            Editable = false;
        }
    }
    var
        BonusExist: Label 'You cannot delete customer N° %1 because there is at least one bonus assigned';

    trigger OnBeforeDelete()
    var
        BonusHeader: Record BonusHeaderTable;
    begin

        BonusHeader.SetRange("Customer No.", "No.");
        if not BonusHeader.IsEmpty then
            Error(BonusExist, "No.");

    end;

}