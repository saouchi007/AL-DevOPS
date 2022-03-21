/// <summary>
/// Page ISA_AllFields (ID 50181).
/// </summary>
page 50181 ISA_AllFields
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'All Fields';
    SourceTable = Field;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(TableNo; Rec.TableNo)
                {
                    ApplicationArea = All;

                }
                field(TableName; Rec.TableName)
                {
                    ApplicationArea = All;

                }
                field(FieldName; Rec.FieldName)
                {
                    ApplicationArea = All;

                }
                field("Type Name"; Rec."Type Name")
                {
                    ApplicationArea = All;

                }
                field(Len; Rec.Len)
                {
                    ApplicationArea = All;

                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = All;

                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ApplicationArea = All;

                }
                field(RelationTableNo; Rec.RelationTableNo)
                {
                    ApplicationArea = All;

                }
                field(RelationFieldNo; Rec.RelationFieldNo)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}