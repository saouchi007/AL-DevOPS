page 50161 FieldsList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Field;
    Caption = 'Fields List';
    Editable = false;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(FieldsList)
            {
                field(TableNo; Rec.TableNo)
                {
                    ApplicationArea = All;

                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(TableName; Rec.TableName)
                {
                    ApplicationArea = All;
                }
                field(FieldName; Rec.FieldName)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
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
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = All;
                }
                field("Type Name"; Rec."Type Name")
                {
                    ApplicationArea = All;
                }
                field("Field Caption"; Rec."Field Caption")
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