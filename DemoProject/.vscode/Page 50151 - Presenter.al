page 50151 "Presenter Table"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = PresenterShow;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(P_Code; P_Code)
                {
                    ApplicationArea = All;

                }
                field(P_Name; P_Name)
                {

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