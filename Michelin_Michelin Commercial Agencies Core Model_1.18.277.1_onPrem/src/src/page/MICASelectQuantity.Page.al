page 80141 "MICA Select Quantity"
{
    PageType = Card;
    Caption = 'Select Quantity';
    UsageCategory = None;
    layout
    {
        area(content)
        {
            field(Quantity; QuantityValue)
            {
                Caption = 'Quantity';
                ApplicationArea = All;
            }
            field(KeepCommitment; KeepCommitmentValue)
            {
                Caption = 'Keep Commitment';
                ApplicationArea = All;
            }
            field(ReallocateQuantity; ReallocateQuantityValue)
            {
                Caption = 'Reallocate Quantity';
                ApplicationArea = All;
                Editable = not KeepCommitmentValue;
            }

        }
    }

    trigger OnOpenPage()
    begin
        KeepCommitmentValue := true;
        ReallocateQuantityValue := true;
    end;

    procedure GetQuantity(): Decimal
    begin
        EXIT(QuantityValue);
    end;

    procedure GetKeepCommitment(): Boolean
    begin
        EXIT(KeepCommitmentValue);
    end;

    procedure GetReallocateQuantity(): Boolean
    begin
        EXIT(ReallocateQuantityValue and not KeepCommitmentValue);
    end;

    var
        QuantityValue: Decimal;
        KeepCommitmentValue: Boolean;
        ReallocateQuantityValue: Boolean;
}
