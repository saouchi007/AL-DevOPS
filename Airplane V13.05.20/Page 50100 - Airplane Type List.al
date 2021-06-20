page 50100 "Airplane Type List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Airplane Type";
    Editable = true;
    SourceTableView = sorting(Popularity) order(descending);

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(ICAO; ICAO)
                {
                    ApplicationArea = All;

                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Popularity; Popularity)
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