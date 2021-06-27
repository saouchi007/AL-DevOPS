tableextension 80041 "MICA Dimention Value" extends "Dimension Value" //MyTargetTableId
{
    fields
    {
        field(80000; "MICA Michelin Code"; Code[10])
        {
            Caption = 'Michelin Code';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                DimValue: Record "Dimension Value";
            begin
                DimValue.SetRange("Dimension Code", "Dimension Code");
                DimValue.SetRange("MICA Michelin Code", "MICA Michelin Code");
                DimValue.SetFilter(Code, '<>%1', Code);
                if not DimValue.IsEmpty() then
                    Error(LbMichelinCodeExistErr);
            end;
        }
        field(81760; "MICA LB Michelin Code"; Code[3])
        {
            Caption = 'LB Michelin Code';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
            /*trigger OnValidate()
            var
                DimValue: Record "Dimension Value";
            begin
                DimValue.SetRange("Dimension Code", "Dimension Code");
                DimValue.SetRange("MICA LB Michelin Code", "MICA LB Michelin Code");
                DimValue.SetFilter(Code, '<>%1', Code);
                if not DimValue.IsEmpty() then
                    Error(LbMichelinCodeExistErr);
            end;*/
        }

    }
    var
        LbMichelinCodeExistErr: Label 'This LB Michelin Code already exist.';

}