codeunit 80160 "MICA AllowedDimension"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertGlobalGLEntry', '', false, false)]
    local procedure OnBeforeInsertGlobalGLEntry(var GlobalGLEntry: Record "G/L Entry")
    var

    begin
        CheckAllowedDimension(GlobalGLEntry);
    end;

    local procedure CheckAllowedDimension(var GLEntry: Record "G/L Entry")
    var
        MICAGLAccAllowedDim: Record "MICA G/L Acc. Allowed Dim.";
        DimensionSetEntry: Record "Dimension Set Entry";
        TxtAllowedDim_Err: Label 'A dimension used in %1 %2 has caused an error. Select a valid Dimension Value Code for the Dimension Code of %3 for %4';
    begin
        DimensionSetEntry.SetRange("Dimension Set ID", GLEntry."Dimension Set ID");
        if DimensionSetEntry.FindSet() then begin
            MICAGLAccAllowedDim.Reset();
            MICAGLAccAllowedDim.SetRange("MICA G/L Account No.", GLEntry."G/L Account No.");
            repeat
                MICAGLAccAllowedDim.Setrange("MICA Dimension Code", DimensionSetEntry."Dimension Code");
                if not MICAGLAccAllowedDim.IsEmpty() then begin
                    MICAGLAccAllowedDim.SetRange("MICA Dimension Value Code", DimensionSetEntry."Dimension Value Code");
                    IF MICAGLAccAllowedDim.IsEmpty() then
                        error(TxtAllowedDim_Err, GLEntry."Document Type", GLEntry."Document No.", DimensionSetEntry."Dimension Code", GLEntry."G/L Account No.");
                end;
            until DimensionSetEntry.next() = 0;
        end;
    end;
}