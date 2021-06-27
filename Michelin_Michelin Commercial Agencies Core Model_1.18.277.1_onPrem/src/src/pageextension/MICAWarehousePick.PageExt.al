pageextension 80966 "MICA Warehouse Pick" extends "Warehouse Pick"
{

    actions
    {
        addafter(RegisterPick)
        {
            action("MICA &PrintTruckLoading")
            {
                ApplicationArea = Warehouse;
                Caption = '&Print Truck Loading';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = '';

                trigger OnAction()
                var
                    WhseActivHeader: Record "Warehouse Activity Header";
                    TruckLoadingList: Report "MICA Truck Loading List";
                begin
                    WhseActivHeader.SetRange(Type, WhseActivHeader.Type::Pick);
                    WhseActivHeader.SetRange("No.", Rec."No.");
                    TruckLoadingList.SetTableView(WhseActivHeader);
                    TruckLoadingList.Run();
                end;
            }
        }
    }
}