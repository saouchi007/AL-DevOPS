/// <summary>
/// TableExtension Cause of Absence Ext (ID 52182432) extends Record Cause of Absence.
/// </summary>
tableextension 52182432 "Cause of Absence Ext" extends "Cause of Absence"
{
    fields
    {
        field(50000; "Item Code"; Text[20])
        {
            CaptionML = ENU = 'Item Code',
                        FRA = 'Code rubrique';
            Description = 'HALRHPAIE';
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));

            trigger OnValidate();
            begin
                IF "Item Code" = '' THEN
                    EXIT;
                CauseAbsence.RESET;
                CauseAbsence.SETRANGE("Item Code", "Item Code");
                CauseAbsence.SETFILTER("Unit of Measure Code", '<>%1', "Unit of Measure Code");
                IF CauseAbsence.FINDSET THEN
                    ERROR(Text01, Code);
            end;
        }
        field(50001; Authorised; Boolean)
        {
            CaptionML = ENU = 'Authorised',
                        FRA = 'Autorisée';
        }
        field(50002; "To Be Deducted"; Boolean)
        {
            CaptionML = ENU = 'To Be Deducted',
                        FRA = 'A retenir';
        }
    }

    var
        CauseAbsence: Record 5206;
        Text01: Label 'Rubrique de paie %1 déjà paramétrée pour une autre unité de mesure !';
}