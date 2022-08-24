/// <summary>
/// Page ISA_FieldSelection (ID 50312).
/// </summary>
page 50312 ISA_FieldSelection
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = ISA_FieldSelection;
    Caption = 'Field Selection';

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field(TableNo; Rec.TableNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Table No field.';
                    TableRelation = Field.TableNo;

                    trigger OnValidate()
                    var
                        FieldRec: Record Field;
                    begin
                        FieldRec.SetRange(TableNo, Rec.TableNo);
                        if FieldRec.FindSet() then
                            Rec.TableName := FieldRec.TableName;
                    end;

                }
                field(TableName; Rec.TableName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Table Name field.';
                    Editable = false;
                }
                field(FieldNo; Rec.FieldNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Field No field.';

                    trigger OnLookup(var text: Text): Boolean
                    var
                        FieldRec: Record Field;
                        FieldSelection: Codeunit "Field Selection";
                    begin
                        FieldRec.SetRange(TableNo, Rec.TableNo);
                        if (FieldRec.FindSet()) then begin
                            FieldSelection.Open(FieldRec);
                            Rec.FieldNo := FieldRec."No.";
                            Rec.FieldName := FieldRec.FieldName;
                        end;
                    end;
                }
                field(FieldName; Rec.FieldName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Field Name field.';
                    Editable = false;
                }
            }
        }
    }


}