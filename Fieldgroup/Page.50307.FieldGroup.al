/// <summary>
/// Page ISA_FieldGroup (ID 50307).
/// </summary>
page 50307 ISA_FieldGroup
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = ISA_FieldGroup;
    
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
            }
        }
        area(Factboxes)
        {
            
        }
    }
    
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                
                trigger OnAction();
                begin
                    
                end;
            }
        }
    }
}